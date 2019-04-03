# rails-docker-examples

Examples for development environment for Rails application with Docker Compose and Kubernetes

## Development with Docker Compose

The base image `hibariya/rails-docker-examples-base` is made with [Dockerfile](https://github.com/esminc/rails-docker-examples/blob/master/Dockerfile).

```bash
# Setup containers and run `rails s`
docker-compose run --rm rails bin/setup
docker-compose up -d

# Add binstubs to $PATH
export PATH=$(pwd)/compose-bin:$PATH

# Run tests with a browser
rails test:system

# You can view/inspect the running browser via VNC (localhost:5900)
```

## Development with Kubernetes

[k8s/README.md](https://github.com/esminc/rails-docker-examples/blob/master/k8s)

## Multi-stage build example

Building assets files with multi-stage build here:

[Dockerfile.production](https://github.com/esminc/rails-docker-examples/blob/master/Dockerfile.production)

## Terraform example for GKE cluster

[k8s/overlays/production](https://github.com/esminc/rails-docker-examples/blob/master/k8s/overlays/production) has been tested with an environment created by this example: [gke](https://github.com/esminc/rails-docker-examples/blob/master/gke)
