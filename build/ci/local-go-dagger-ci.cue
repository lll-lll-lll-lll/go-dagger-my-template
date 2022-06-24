package main

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
	"universe.dagger.io/go"
)

dagger.#Plan & {
	client: {
		filesystem: {
			"./": read: contents: dagger.#FS
		}
	}

	actions: {
		params: image: {
			tag:      "latest"
			localTag: "daggerimage"
		}

		// ローカルのDockerfileからimageをビルド
		build: docker.#Dockerfile & {
			source: client.filesystem."./".read.contents
			target: "builder"
		}

		// goのtestを実行する
		test: go.#Test & {
			source:  client.filesystem."./".read.contents
			package: "./..."
		}

	}
}
