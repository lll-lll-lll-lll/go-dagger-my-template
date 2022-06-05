package main

import (
    "dagger.io/dagger"
    "dagger.io/dagger/core"
    "universe.dagger.io/docker"
    "universe.dagger.io/go"
    "universe.dagger.io/docker/cli"

)
#Config: core.#ImageConfig & {
    expose: "8080/tcp": {}
}   

#GoBuildDocker: docker.#Dockerfile & {
    dockerfile: {
        path: "./Dockerfile"
    }
}

dagger.#Plan & {
    client: { 
        filesystem: "./": read: contents: dagger.#FS
        network: "unix:///var/run/docker.sock": connect: dagger.#Socket
    }

    actions: {
        params: image: {
            tag:      "latest"
            localTag: "daggerimage"
        }

        // ローカルの./Dockerfileからimageをビルド
        build: #GoBuildDocker & {
            source: client.filesystem."./".read.contents
        }

        // goのtestを実行する
        test: go.#Test & {
            source:  client.filesystem."./".read.contents
            package: "./..."
        }

        // ローカルにimageを作成する
        load: cli.#Load & {
            image: build.output
            host:  client.network."unix:///var/run/docker.sock".connect
            tag:   params.image.localTag
        }

        // local hostを起動
        startup: {
        
            run: cli.#Run & {
                host:   client.network."unix:///var/run/docker.sock".connect
                always: true
                env: {
                    IMAGE_NAME: params.image.localTag
                    PORTS:      "8080"
                    DEP:        "\(load.success)"
                }
                command: {
                    name: "sh"
                    flags: "-c": #"""
                        docker run --expose "$PORTS" daggerimage
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
    }
}