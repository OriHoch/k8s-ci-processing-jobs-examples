# Builder

The builder is an example of a CI job which builds a simple hello world golang app and published the binary to GitHub.

## Prerequisites

* [Fork this repository](https://github.com/OriHoch/k8s-ci-processing-jobs-examples/fork)
* [Create a personal access token with permissions for managing releases](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token)

## Get the Docker image

You can get the image using one of the following options:

* Build it: `docker build -t builder builder`
* Pull and tag it: `docker pull ghcr.io/orihoch/k8s-ci-processing-jobs-builder && docker tag ghcr.io/orihoch/k8s-ci-processing-jobs-builder builder`

## Running the image

Get the list of supported OS/ARCH combinations:

```
docker run builder --list
```

To build and publish you need the following details:

* Your GitHub personal access token
* One of the OS/ARCH combination from the above list
* Your GitHub user name which contains a fork of this repository
* A tag name which is already published in your repo (e.g. `v0.0.1`)

Run a build using the following command:

```
docker run -e TOKEN=YourPersonalAccessToken builder OS/ARCH YourGitHubUser YourTagName
```

Some examples:

```
docker run -e TOKEN=YourPersonalAccessToken builder linux/386 OriHoch v0.0.1
docker run -e TOKEN=YourPersonalAccessToken builder windows/amd64 OriHoch v0.0.1
```
