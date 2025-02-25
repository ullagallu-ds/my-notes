# Index[configuration&secrets][kops]
- ConfigMap
- Secrets
- ResourceMangement[requests,limits]
- HPA

# Metrics Server

Metrics Server is an in-memory metrics server that collects resource usage metrics of pods and nodes. It retrieves CPU and memory usage data from the kubelet on each node and provides it to the Kubernetes API for use by components like Horizontal Pod Autoscaler (HPA) and Vertical Pod Autoscaler (VPA).  

Metrics Server does not store historical data; it only provides real-time metrics. It is lightweight and designed for short-term monitoring within the cluster.

# HPA

HPA automatically scales the number of pod replicas in a Deployment, StatefulSet, or ReplicaSet based on CPU, memory, or custom metrics. It ensures that the application can handle increased load while optimizing resource usage.  

HPA continuously monitors the selected metrics, such as CPU usage. It increases or decreases the number of replicas based on predefined thresholds. The Kubernetes Metrics Server is used to gather resource usage data.  

Example HPA Configuration  

```yaml
apiVersion: autoscaling/v2  
kind: HorizontalPodAutoscaler  
metadata:  
  name: my-app-hpa  
spec:  
  scaleTargetRef:  
    apiVersion: apps/v1  
    kind: Deployment  
    name: my-app  
  minReplicas: 2  
  maxReplicas: 10  
  metrics:  
    - type: Resource  
      resource:  
        name: cpu  
        target:  
          type: Utilization  
          averageUtilization: 50
```

In this example, the HPA scales the my-app deployment. If CPU usage exceeds 50 percent, more replicas are added. It ensures at least two and at most ten replicas.  

HPA vs VPA (Vertical Pod Autoscaler)  

HPA scales out by increasing or decreasing the number of pods. VPA scales up by adjusting CPU and memory requests for each pod. HPA is better for handling fluctuating traffic, while VPA is useful for optimizing resource allocation.

# ConfigMap
- Used to store non-sensitive data like service configurations, nginx.conf, or application settings.
- If values are hardcoded inside a container, every change requires a full release cycle (build → deployment).
- ConfigMap decouples configuration from the container, allowing updates without rebuilding the image.

A ConfigMap is a Kubernetes object used to store configuration data in key-value pairs. It allows separating application configuration from container images, making applications more flexible and manageable.

- Stores non-sensitive configuration data such as environment variables, command-line arguments, and configuration files.
- Can be consumed by pods as environment variables, command-line arguments, or mounted as files.
- Helps manage dynamic configurations without rebuilding container images.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  APP_ENV: "production"
  APP_PORT: "8080"
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: nginx
      env:
        - name: APP_ENV
          valueFrom:
            configMapKeyRef:
              name: my-config
              key: APP_ENV
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: nginx
      volumeMounts:
        - name: config-volume
          mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: my-config
```
# Secrets
- Used to store sensitive data like passwords, API keys, and TLS certificates.
- Data is Base64-encoded (not encrypted by default).
- Secret data is Base64-encoded, whereas ConfigMap data is stored as plain text.
- Provides a more secure way to manage confidential data compared to ConfigMaps.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  username: dXNlcm5hbWU=  # Base64 encoded "username"
  password: cGFzc3dvcmQ=  # Base64 encoded "password"
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: nginx
      env:
        - name: SECRET_USERNAME
          valueFrom:
            secretKeyRef:
              name: my-secret
              key: username
        - name: SECRET_PASSWORD
          valueFrom:
            secretKeyRef:
              name: my-secret
              key: password
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: nginx
      volumeMounts:
        - name: secret-volume
          mountPath: "/etc/secret"
          readOnly: true
  volumes:
    - name: secret-volume
      secret:
        secretName: my-secret
```  

### Difference Between ConfigMap and Secret 
| Feature        | ConfigMap | Secret |
|---------------|----------|--------|
| Purpose | Stores non-sensitive data | Stores sensitive data |
| Encoding | Plain text | Base64-encoded |
| Use Case | Application config (e.g., URLs, ports) | Passwords, API keys, TLS certs |
| Security | Less secure | More secure (can be encrypted in etcd) |


# ResounrceManagement
Resource Management in Kubernetes

Kubernetes allows setting requests and limits for CPU and memory to ensure fair resource allocation and prevent excessive usage by any single pod.  

1. Requests  
- Requests define the minimum amount of CPU/memory a container needs to run.  
- The scheduler uses requests to decide where to place a pod.  

2. Limits  
- Limits define the maximum CPU/memory a container can use.  
- If a container exceeds its memory limit, it gets terminated (OOMKilled).  
- If it exceeds the CPU limit, Kubernetes throttles it instead of killing it.  

Example: Setting CPU and Memory Requests & Limits  
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: resource-demo
spec:
  containers:
    - name: demo-container
      image: nginx
      resources:
        requests:
          memory: "128Mi"
          cpu: "250m"
        limits:
          memory: "256Mi"
          cpu: "500m"
```

How It Works  
- The pod requests 128Mi memory and 250m CPU → Scheduler ensures a node with enough resources is selected.  
- The pod cannot exceed 256Mi memory and 500m CPU → If memory usage exceeds, the pod is killed; if CPU usage exceeds, it is throttled.  

Key Differences: Requests vs Limits  
| Feature   | Requests | Limits |
|-----------|---------|--------|
| Purpose  | Minimum resources required | Maximum resources allowed |
| Impact   | Helps scheduler place the pod | Enforces usage restrictions |
| Exceeding Consequence | No effect; pod can use more if available | CPU is throttled, memory causes pod eviction |