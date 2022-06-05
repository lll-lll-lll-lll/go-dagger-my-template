package main

import (
    "dagger.io/dagger"
    "dagger.io/dagger/core"
    "universe.dagger.io/docker"
)

dagger.#Plan & {
    // 出力させないために_付けてる. vendorをキャッシュする設定
    _vendorMount: "./vendor": {
        dest: "./vendor",
        type: "cache",
        contents: core.#CacheDir &  {
            id: "vendor-cache"
        }
    }


    client: {
        filesystem: {
            "." : read: {
                contents: dagger.#FS 
                // daggerに入れないファイル. .gitignore的な役割
                exclude:[
                    "cue.mod",
                    ".env",
                    ".gitignore",
                    "dagger.cue",
                    "README.md",
                ]
            }
        }
        // 環境変数を設定
        env: {
            NETLIFY_TOKEN: dagger.#Secret
        }
    }


    actions:{
        build: docker.#Dockerfile & { 
            source: client.filesystem.".".read.contents
            dockerfile: {
                path: "./Dockerfile"
            }
        } 
        test: {
            
            gotest: docker.#Run & {
                input: build.output
                command: {
                    name: "go"
                    args: ["test"]
                }
                mounts: {
                    _vendorMount
                }
            }
        }
    }
}
