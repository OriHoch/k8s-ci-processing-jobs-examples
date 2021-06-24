FROM golang:1.16
RUN apt-get update && apt-get install -y jq
COPY main.go src/
COPY entrypoint.sh ./
ENV GOOS=linux
ENV GOARCH=amd64
ENTRYPOINT ["./entrypoint.sh"]