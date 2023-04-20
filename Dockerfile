FROM golang:alpine AS builder
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /app/small-image

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /app/small-image /small-image
ENTRYPOINT ["/small-image"]