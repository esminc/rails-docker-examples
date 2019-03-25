## Development

```bash
minikube start # --vm-driver virtualbox

# for the first time
minikube addons enable ingress
kubectl apply -f namespace.yaml

kubectl config set-context rails-docker-examples \
  --namespace=rails-docker-examples --cluster=minikube --user=minikube
kubectl config use-context rails-docker-examples

export APP_ROOT=$(pwd | sed -e 's/^\/home/\/hosthome/')
export MINIKUBE_IP=$(minikube ip)

# deploy the app
kustomize build overlays/development | envsubst | kubectl apply -f -
kubectl exec -it $(kubectl get pods | egrep -o 'local-ops-rails-[a-z0-9-]+') -c rails -- bin/setup

# Open $(minikube ip) with a browser
# Run tests with a browser
kubectl exec -it $(kubectl get pods | egrep -o 'local-ops-rails-[a-z0-9-]+') -c rails -- bin/rails test:system

# You can view/inspect the running browser via VNC ($(minikube ip):32590)
```

## Production

```bash
# switch the kubectl context
gcloud container clusters get-credentials rails-docker-examples --zone asia-northeast1-c --project rails-docker-examples

kustomize build overlays/production | envsubst | kubectl apply -f -
kubectl exec -it \
  $(kubectl get pods --selector='deployment=ops-rails' --output='jsonpath={.items[0].metadata.name}') \
  -c rails -- bin/rails db:create db:migrate
```
