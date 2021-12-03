#!/bin/sh
docker build -t flask-app:latest .
docker tag flask-app gcr.io/fabled-ray-333502/flask-app
docker push gcr.io/fabled-ray-333502/flask-app
kubectl create ns ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true --namespace nginx-ingress
kubectl apply -f deployment.yaml
kubectl apply -f hpa.yaml
kubectl apply -f ingress.yaml
echo "Wait for a while..."
sleep 1m
echo "==Test application=="
publicIP=$(kubectl get svc nginx-ingress-ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl -v http://$publicIP