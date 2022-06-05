# syntax=docker/dockerfile:1

FROM golang:1.18-alpine
WORKDIR /app


COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY ./ ./

EXPOSE 8080

RUN echo -n hello world >> /test.txt

CMD ["go", "run", "main.go"]