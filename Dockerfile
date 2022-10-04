FROM golang:alpine as builder

WORKDIR /app

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download

COPY cloudflare.go cloudflare.go
COPY main.go main.go
COPY prometheus.go prometheus.go

RUN CGO_ENABLED=0 GOOS=linux go build -o cloudflare_exporter .

FROM alpine:3.16

RUN apk update && apk add ca-certificates

COPY --from=builder /app/cloudflare_exporter cloudflare_exporter

ENV CF_API_KEY ""
ENV CF_API_EMAIL ""

ENTRYPOINT [ "./cloudflare_exporter" ]
