# Solution - Task 1

## Prerequisites
   1. [helm](https://helm.sh/docs/intro/install/) >= v3.5.0
   2. [kubectl](v1-18.docs.kubernetes.io/docs/tasks/tools/install-kubectl/) >= v1.20
   3. Install [apache2-utils](https://developer.okta.com/blog/2019/10/15/performance-testing-with-apache-bench)

## Description
This is a guideline on how to deploy a simple `"Hello World"` [Flask](https://flask.palletsprojects.com/en/2.0.x/) application on `Kubernetes` cluster

## Deployment 
This create a simple `Hello World` HTTP application using Flask because it is simple to implemet and test but any programming language and/or framework you can do.
Here some steps to make this application runs as expected.
   1. Build docker image
      ```
      docker build -t flask-app:latest .
      ```
      The first step is to compile and build our application using docker because we want to deploy and run it into Kubernetes.
      
   2. Create a image tag
      ```
      docker tag flask-app gcr.io/fabled-ray-333502/flask-app
      ```

      This is to create a tag on image that we have built in the first step.
   3. Push the image
      ```
      docker push gcr.io/fabled-ray-333502/flask-app
      ```

   Push docker image into docker registry (this project using private registry in [Google Container Registry](cloud.google.com/container-registry))
   
   4. Create Namespace
      ```
      kubectl create ns ingress-nginx
      ```
      This namespace is to segregate between application and nginx ingress to deploy

   5. Add nginx ingress helm repository
      ```
      helm repo add ingress-nginx https://kubernetes.github.io/   ingress-nginx
      ```
      Add nginx ingress repository

   6. Update helm repository
      ```
      helm repo update
      ```
      Update helm repository to make sure using updated repository

   7. Install nginx-ingress with helm
      ```
      helm install nginx-ingress ingress-nginx/ingress-nginx --set   controller.publishService.enabled=true --namespace   ingress-nginx
      ```
      Install nginx-ingress using helm is to ease work or setup on Kubernetes and enable controller publish service as a service fronting the Ingress controller.

   8. Apply deployment.yaml
      ```
      kubectl apply -f deployment.yaml
      ``` 
      The Service here is defined to expose the deployment in cluster at port 80 and the deployment will be using port 8080. Deployment is configured to have a limit resources will be used in pod. Once the pod is running, it will have a default memory(128Mi) and CPU(100m) in normal operation; the maximum it is allowed to use is 1 CPU (1000m millicores) and 512 Mi.

   9. Apply hpa.yaml
      ```
      kubectl apply -f hpa.yaml
      ```
      HPA (HorizontalPodAutoscaler) is a great tool to ensure that critical applications are elastic and can scale out to meet increasing demand as well scale down to ensure optimal resource usage. With this HPA, deployment will scale up or down based on metrics if it is met with the configuration. Here, minimum pod will be running is 1 pod and maximum 10 pods. For scaling down, it will scale down 100% of running replica pod in fiveteen seconds and limit the total number of Pods to delete, 10% per minute. For scaling up, there is no stabilization window. If the metrics are met to scale up pod then scaling up pod will be triggered with 100% of running replicas or four replicas added every fiveteen seconds.

   10. Apply ingress.yaml
       ```
       kubectl apply -f ingress.yaml
       ```      
       Declaring an Ingress to route requests to / (root) tthe flask-app service with port 80.

## Automation
To ease deployment, provided a shell script that can automate deployment and setup on Kubernetes.
```
sh auto-deployment.sh
```

## Load Test
To test application performances, apache-bench application can be used to do so.
```
ab -n 10 -c 10 http://<application-ipAddress>
```
This command tells ab to simulate 10 connections (-n) over 10 concurrent threads (-c) to the application.

## Limitations
* Because this is just a sample application to test deployment on Kubernetes cluster, it has some limitations compare to real application or production application.
For this project, it does not use HTTPS protocol that mostly used by websites. 
* It does not have a domain name registered, this can be issue later if the website's IP Address changed then need to maintain or reconfigure website.
* Load test performance actually can be automated by using some shell script.

## Improvements
As mentioned above about limitations of this application, those can be improved by adding some other setup or configuration.
* Using HTTPS protocol to secure data from attacker or hacker to steal data between server and client.
* Register application with domain name. If IP address has changed, client can still continue access application without any issue.
* Load test can be automated with some scripts. This is very useful for effieciency instead of running it manually to reduce some effors.