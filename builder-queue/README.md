# Builder with queue

This image extends the builder image with queue capabilities backed by Redis.

## Prerequisites

* See [builder/README.md](../builder/README.md)
* A Redis server running on localhost
    * You can use the following command to start one locally:
    * `docker run --rm -d --name redis -p 6379:6379 redis`

## Get the Docker image

You can get the image using one of the following options:

* Build it: `docker build -t builder-queue builder-queue`
* Pull and tag it: `docker pull ghcr.io/orihoch/k8s-ci-processing-jobs-builder-queue && docker tag ghcr.io/orihoch/k8s-ci-processing-jobs-builder-queue builder-queue`

## Running the image

Add all supported OS architectures to the queue (replace GitHubUserName and TagName with relevant values):

```
docker run --network host builder-queue --rq-add all GitHubUserName TagName
```

Check the queue status, you should see 44 jobs in the queue

```
docker run --network host builder-queue --rq-info
```

Start 2 workers which will handle jobs from the queue in the background

```
docker run -d --name worker1 --network host builder-queue --rq-worker
docker run -d --name worker2 --network host builder-queue --rq-worker
```

You can check worker logs for progress:

```
docker logs worker1
docker logs worker2
```

## Running using a job queue on Kubernetes

Deploy the Redis server and wait for it to be available:

```
kubectl apply -f manifests/redis.yaml &&\
kubectl wait deployment/redis --for condition=available
```

Start a port-forward to the Redis:

```
kubectl port-forward deployment/redis 6379
```

In a new terminal, add all the build jobs to the queue (replace GitHubUserNAme and TagName):

```
docker run --network host ghcr.io/orihoch/k8s-ci-processing-jobs-builder-queue \
  --rq-add all GitHubUserName TagName
```

Set your GitHub token in env var:

```
export GITHUB_TOKEN=
```

Deploy the multi-pod job:

```
cat manifests/multi-pod-job.yaml | envsubst | kubectl apply -f -
```

Check the pods

```
kubectl get pods
```

Check the queue status

```
docker run --network host ghcr.io/orihoch/k8s-ci-processing-jobs-builder-queue \
  --rq-info
```
