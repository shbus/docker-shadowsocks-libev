# Shadowsocks-libev Docker Image (ss-local)
### Usage
* Start a container.
* Define environment variables such as `server address`, `server port`, `method`, `password`, `bind address`, `proxy port`, `timeout`.
* Additional arguments supported by `ss-local` can be passed with the environment variable `ARGS`.

```
docker run -d --name shadowsocks-libev \
  -p 1080:1080  \
  -e SERVER_ADDR={YOUR SERVER} \
  -e SERVER_PORT={SERVER PORT} \
  -e PASSWORD={YOUR PASSWORD} \
  -e METHOD=aes-256-gcm \
  -e DNS_ADDRS={DNS SERVER IPs} \
  -e LISTEN_ADDR=127.0.0.1 \
  -e LISTEN_PORT=1080 \
  -e TIMEOUT=300 \
  -e ARGS=-v \
  antileech/shadowsocks-libev
```
