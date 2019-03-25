# rails-docker-examples

Examples for development environment with Docker Compose and Kubernetes

## Development with Docker Compose

The base image `hibariya/rails-docker-examples-base` is made with [Dockerfile](https://github.com/esminc/rails-docker-examples/blob/master/Dockerfile).

```bash
# Setup containers and run `rails s`
docker-compose run --rm rails bin/setup
docker-compose up -d

# Add binstubs to $PATH
export PATH=$(pwd)/compose-bin:$PATH

cp -p .envrc.sample .envrc
direnv allow

# Run tests with a browser
rails test:system

# You can view/inspect the running browser via VNC (localhost:5900)
```

## Development with Kubernetes

[k8s/README.md](https://github.com/esminc/rails-docker-examples/blob/master/k8s)
