# compile the code to an executable using an intermediary image
FROM registry.access.redhat.com/ubi8/go-toolset@sha256:6c2c40207abfef2e46426f39c7fe0aca177b9da73d2b223bc0ddc7c5c56485c4 as builder

# VULN_SCAN_TIME=

WORKDIR /build
COPY *.mod \
     *.go \
     *.sum \
     ./

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags '-w -s' -installsuffix cgo -a -o out/image-awaiter

# present the result within a slimmed image
FROM scratch

COPY --from=builder /build/out/image-awaiter /image-awaiter

# To debug / develop this code
# ----------------------------
# 1. Setup a kubectl proxy
# > kubectl proxy --port=8080

# 2. Try the API using the proxy...
# > curl http://localhost:8080/apis/apps/v1/namespaces/<namespace>/demonsets/hook-image-puller

# 3. Try the container using the proxy...
# > docker build --tag <name:tag> .
# > docker run -it --rm --net=host <name:tag> /image-awaiter -debug -namespace <namespace> -daemonset hook-image-puller
