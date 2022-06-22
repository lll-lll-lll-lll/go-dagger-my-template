# syntax=docker/dockerfile:1

FROM golang:1.18-alpine as builder
WORKDIR /build

COPY ../../go.mod ../../go.sum ./
RUN go mod download
COPY ../../  ./


# C言語のライブラリを使って欲しく無い場合0
ARG CGO_ENABLED=0
ARG GOOS=linux
ARG GOARCH=amd64

# -ldflags '-s -w': 実行ファイルにアプリの動作に関係ないものを入れないためのオプションを付与
# -o /go/bin/main: 実行ファイルを/go/binの中にmainという名前で作成する
RUN go build  -ldflags '-s -m' ./cmd/web-app


EXPOSE 8080

FROM alpine as runner
COPY --from=builder /build/web-app /opt/app/
ENTRYPOINT ["/opt/app/web-app"]