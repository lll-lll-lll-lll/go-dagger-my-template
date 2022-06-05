package main

import (
    "dagger.io/dagger"
    "universe.dagger.io/docker"
)
#GoDockerBuild : docker.#Dockerfile &  {
    // docker file path
    dockerfile: path: "Dockerfile"
}