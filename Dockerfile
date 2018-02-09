# Build Stage
FROM alpine:latest as builder
RUN rm -rf /build-app
WORKDIR /build-app
COPY . .
RUN rm -rf ./target
RUN apk add --no-cache llvm-libunwind \
    && apk add --no-cache --virtual .build-rust rust cargo \
    && cargo build --release 

#####################################################

# Final Image Stage
FROM alpine:latest
RUN apk add --no-cache llvm-libunwind
RUN apk add --no-cache libgcc
COPY  --from=builder /build-app/target/release/response_time /app/

WORKDIR /app
EXPOSE 3000
ENTRYPOINT ["./response_time"]
