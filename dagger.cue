package main

import (
    "dagger.io/dagger"
    "universe.dagger.io/docker"
)

dagger.#Plan & { 
    client: {
        filesystem: ".": read: {
            contents: dagger.#FS 
            // daggerに入れないファイル. .gitignore的な役割
            exclude:[
                "cue.mod"
                ".env"
                ".gitignore"
                "dagger.cue"
                "README.md"
            ]
        }
        // 環境変数を設定
        env: {
            NETLIFY_TOKEN: string
        }
    }


    actions: builddocker: {
        build: docker.#Build & {
            steps: [
                docker.#Dockerfile &  {
                    source: client.filesystem.".".read.contents
                    dockerfile: {
                        path: "./Dockerfile"
                    }
                },
                docker.#Run & {
                    command: {
					name: "/bin/sh"
					args: ["-c", "echo -n hello world >> /output.txt"]
				    }
                    export: files: "./output.txt": string & "hello world"
                },
                ]
            }
    } 


}