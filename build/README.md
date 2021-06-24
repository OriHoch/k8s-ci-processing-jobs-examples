# Build job example

This is an example of a golang build job. It builds a simple hello world golang app for multiple OS / architectures.

Build the Docker image:

```
docker build -t example-build build
```

Get the list of supported OS/ARCH combinations:

```
docker run example-build --list
```

Build some binaries from the list:

```
docker run -v "$(pwd)/.data/build-output:/go/bin" build linux/386
docker run -v "$(pwd)/.data/build-output:/go/bin" build linux/amd64
docker run -v "$(pwd)/.data/build-output:/go/bin" build darwin/arm64
docker run -v "$(pwd)/.data/build-output:/go/bin" build windows/arm
```
