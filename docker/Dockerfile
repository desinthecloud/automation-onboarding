FROM golang:1.22-alpine AS builder

WORKDIR /app
# Only copy go.mod since we don't have go.sum yet (no external deps)
COPY app/go.mod ./
RUN go mod download || true

COPY app/*.go ./
RUN go build -o server .


FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/server .
EXPOSE 8080
ENV SANDBOX_ENV=local-dev
CMD ["./server"]

