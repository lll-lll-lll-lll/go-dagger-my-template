package main

import (
    "dagger.io/dagger"
    "universe.dagger.io/docker"
    "universe.dagger.io/go"
    "universe.dagger.io/docker/cli"
    "universe.dagger.io/netlify"

)

#GoBuildDocker: docker.#Dockerfile & {
    dockerfile: {
        path: "./Dockerfile"
    }
}

dagger.#Plan & {
    client: { 
        env: {
            // シークレットとして読み込む
            NETLIFY_TOKEN: dagger.#Secret
        }
        filesystem: {
            "./": read: contents: dagger.#FS
        }
        network: "unix:///var/run/docker.sock": connect: dagger.#Socket
    }

    actions: {
        params: image: {
            tag:      "latest"
            localTag: "daggerimage"
        }

        // ローカルの./Dockerfileからimageをビルド
        build: {
            godocker: #GoBuildDocker & {
                source: client.filesystem."./".read.contents
            }
        }

        // goのtestを実行する
        test: go.#Test & {
            source:  client.filesystem."./".read.contents
            package: "./..."
        }

        // ローカルにimageを作成する.  (注意：一回実行するとコンテナが再度作成されてしまう。直す必要ある)
        load: cli.#Load & {
            image: build.godocker.output
            host:  client.network."unix:///var/run/docker.sock".connect
            tag:   params.image.localTag
        }
        

        // コンテナを作成
        createContainer: {
            run: cli.#Run & {
                host:   client.network."unix:///var/run/docker.sock".connect
                command: {
                    name: "sh"
                    flags: "-c": #"""
                        docker run --restart=always --name daggercontainer -p 127.0.0.1:80:8080 -d daggerimage 
                        """#
                }
            }
        }

        // コンテナを起動
        startup: {
            run: cli.#Run & {
                host:   client.network."unix:///var/run/docker.sock".connect
                command: {
                    name: "sh"
                    flags: "-c": #"""
                        docker start daggercontainer
                        """#
                }
            }
        }

        // コンテナをstop
        stopContainer: {
            run: cli.#Run & {
                host:   client.network."unix:///var/run/docker.sock".connect
                command: {
                    name: "sh"
                    flags: "-c": #"""
                        docker stop daggercontainer
                        """#
                }
            }
        }

        // 作成したローカルのimageを削除する
        clean: cli.#Run & {
            host:   client.network."unix:///var/run/docker.sock".connect
            always: true
            env: IMAGE_NAME: params.image.localTag
            command: {
                name: "sh"
                flags: "-c": #"""
                    docker rmi --force "$IMAGE_NAME"
                    """#
            }
        }

        // 開発環境用のnetlifyにデプロイ
        deploy: netlify.#Deploy & {
			contents: client.filesystem."./".read.contents
            token:    client.env.NETLIFY_TOKEN
			site:     string | *"dagger-app"
        }
    }
}