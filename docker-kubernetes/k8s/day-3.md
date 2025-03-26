
# Labels & Selectors
#### Labels Purpose  
Labels are key-value pairs attached to Kubernetes objects (Pods, Services, Deployments, etc.). They help in organizing and grouping resources for easier management.  

#### Why Use Labels?  
- Grouping Resources → Identify and group related resources (e.g., all Pods of an app).  
- Selection & Filtering → Easily find resources using `kubectl` commands.  
- Scaling & Updates → Controllers (like Deployments) use labels to manage Pods dynamically.  
- Network Policies → Used to define security rules based on labels.  

#### Selectors Purpose  
Selectors help to filter and match Kubernetes objects based on their labels. They are mainly used by Services, Deployments, and other controllers to target specific Pods.  

### Types of Label Selectors  

#### 1. Equality-Based Selectors  
These selectors match objects where the label value is exactly equal (`=` or `==`) or not equal (`!=`).  

Examples:  
- Get Pods where the label **app=nginx**:  
  ```bash
  kubectl get pods -l app=nginx
  ```
- Get Pods where the label **tier is not equal to frontend**:  
  ```bash
  kubectl get pods -l tier!=frontend
  ```

#### 2. Set-Based Selectors  
These selectors match objects where the label value is in a set or not in a set.  

Examples:  
- Get Pods where **env is either dev or test**:  
  ```bash
  kubectl get pods -l 'env in (dev,test)'
  ```
- Get Pods where **env is not in staging or prod**:  
  ```bash
  kubectl get pods -l 'env notin (staging,prod)'
  ```
- Get Pods that have the label **app** (regardless of value):  
  ```bash
  kubectl get pods -l app
  ```

### Common Commands for Labels & Selectors  

#### 1. Add a Label to a Resource  
```bash
kubectl label pod mypod app=nginx
```  

#### 2. Remove a Label from a Resource  
```bash
kubectl label pod mypod app-
```  

#### 3. View Labels for All Pods  
```bash
kubectl get pods --show-labels
```  

#### 4. Get Pods Matching a Label Selector  
```bash
kubectl get pods -l app=nginx
```  

#### 5. Get Resources with Multiple Label Conditions  
```bash
kubectl get pods -l app=nginx,env=dev
``` 
---

### **ReplicaSet & ReplicationController in Kubernetes**
A **ReplicationController (RC)** ensures that a specific number of **identical pod replicas** are always running in a cluster. If a pod fails, it automatically creates a new one.  

🚀 **ReplicationController is now mostly replaced by ReplicaSet, but it’s still supported.**  

---

### **Features of ReplicationController:**
1. **Ensures Pod Availability** – Keeps the desired number of pod replicas running.  
2. **Self-Healing** – If a pod crashes, a new pod is created.  
3. **Manual Scaling** – You can scale replicas up/down manually.  
4. **Uses Label Selectors** – Manages pods based on labels.  
5. **Limited Rolling Updates** – Unlike Deployments, ReplicationController does not support rolling updates efficiently.

---

### **ReplicationController Example**
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx-rc
spec:
  replicas: 3
  selector:
    app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

---

### **Explanation:**
1. **`replicas: 3`** – Ensures 3 pods are running at all times.  
2. **`selector: {app: nginx}`** – Only manages pods with this label.  
3. **`template:`** – Defines the pod specification.  
   - Runs an **Nginx container** on port **80**.  

---

### **How to Use?**
#### **1. Create the ReplicationController**
```bash
kubectl apply -f nginx-rc.yaml
```

#### **2. Verify the Pods**
```bash
kubectl get pods
```

#### **3. Scale Up/Down**
```bash
kubectl scale --replicas=5 rc nginx-rc
```

#### **4. Delete the ReplicationController**
```bash
kubectl delete rc nginx-rc
``` 
---
#### **2. What is a ReplicaSet?**  
A **ReplicaSet** is the next-generation version of ReplicationController with more flexible **label selectors**. It ensures that a specified number of Pods are always running and automatically replaces failed Pods.  

##### **Key Features:**  
- Supports **set-based selectors** (e.g., `env in (dev, prod)`).  
- Ensures high availability by maintaining the desired number of replicas.  
- Works with **Deployments** for rolling updates and rollback features.  
---
### **Comparison: ReplicaSet vs. ReplicationController**  

| Feature               | ReplicationController | ReplicaSet |
|-----------------------|----------------------|-----------|
| Ensures replica count | ✅ Yes | ✅ Yes |
| Auto-replaces failed Pods | ✅ Yes | ✅ Yes |
| Supports rolling updates | ❌ No | ✅ Yes (with Deployments) |
| Supports set-based selectors | ❌ No | ✅ Yes |
| Considered deprecated | ✅ Yes | ❌ No |

#### **Which One to Use?**  
- **Use ReplicaSet** instead of ReplicationController since it is more advanced and supports flexible label selectors.  
- However, **Deployments** are preferred over ReplicaSets for better management, updates, and rollback capabilities.  

### **ReplicaSet & ReplicationController in Kubernetes**  

#### **1. Create a ReplicaSet**  
```bash
kubectl apply -f replicaset.yaml
```  

#### **2. List All ReplicaSets**  
```bash
kubectl get replicaset
```  

#### **3. Describe a ReplicaSet**  
```bash
kubectl describe replicaset my-replicaset
```  

#### **4. Scale a ReplicaSet**  
```bash
kubectl scale replicaset my-replicaset --replicas=5
```  

#### **5. Delete a ReplicaSet**  
```bash
kubectl delete replicaset my-replicaset
```  

#### **6. Get ReplicaSet YAML Definition**  
```bash
kubectl get replicaset my-replicaset -o yaml
```  
---
#### **7. Create a ReplicationController**  
```bash
kubectl apply -f replicationcontroller.yaml
```  

#### **8. List All ReplicationControllers**  
```bash
kubectl get rc
```  

#### **9. Describe a ReplicationController**  
```bash
kubectl describe rc my-replicationcontroller
```  

#### **10. Scale a ReplicationController**  
```bash
kubectl scale rc my-replicationcontroller --replicas=3
```  

#### **11. Delete a ReplicationController**  
```bash
kubectl delete rc my-replicationcontroller
```  

#### **12. Get ReplicationController YAML Definition**  
```bash
kubectl get rc my-replicationcontroller -o yaml
``` 
### **What is a Deployment in Kubernetes?**  
A **Deployment** in Kubernetes is used to manage and update applications by controlling **ReplicaSets**. It provides **rolling updates, rollbacks, and self-healing** capabilities, making it the preferred choice over ReplicaSets and ReplicationControllers.

A Deployment is a higher-level controller in Kubernetes that manages ReplicaSets and automates application updates, rollbacks, and scaling. It ensures that your application is deployed gradually without downtime.


Why Deployment Over ReplicaSet?
ReplicaSet ensures that a specified number of pod replicas are running but does not control application releases.
Deployment provides: ✅ Rolling updates (zero downtime)
✅ Rollbacks in case of failure
✅ Version control of application releases
✅ Scaling up/down the application easily


### **Key Features of Deployments:**  
- **Rolling Updates** → Updates Pods gradually to avoid downtime.  
- **Rollbacks** → Reverts to a previous version if something goes wrong.  
- **Scaling** → Easily scales Pods up or down.  
- **Self-Healing** → Automatically replaces failed Pods.  
- **Declarative Management** → Uses YAML to define the desired state.  

---

## **Deployment Commands**  

### **1. Create a Deployment**  
```bash
kubectl create deployment myapp --image=nginx
```

### **2. List All Deployments**  
```bash
kubectl get deployments
```

### **3. Get Detailed Deployment Information**  
```bash
kubectl describe deployment myapp
```

### **4. Get Deployment in a Specific Namespace**  
```bash
kubectl get deployments -n <namespace-name>
```

### **5. Update the Deployment Image**  
```bash
kubectl set image deployment myapp nginx=nginx:1.21
```

### **6. Rollback to the Previous Version**  
```bash
kubectl rollout undo deployment myapp
```

### **7. View Deployment Rollout Status**  
```bash
kubectl rollout status deployment myapp
```

### **8. Scale a Deployment (Increase Replicas)**  
```bash
kubectl scale deployment myapp --replicas=5
```

### **9. Delete a Deployment**  
```bash
kubectl delete deployment myapp
```

### **10. Get the YAML Definition of a Deployment**  
```bash
kubectl get deployment myapp -o yaml
```

### **11. Apply a Deployment from a YAML File**  
```bash
kubectl apply -f myapp-deployment.yaml
```

---

### **Rolling Update Example (Zero Downtime Update)**  
```bash
kubectl set image deployment myapp nginx=nginx:latest
kubectl rollout status deployment myapp
```
- Ensures smooth updates without stopping the application.  

---

### **Rollback Example**  
If the new version has issues, rollback to the previous version:  
```bash
kubectl rollout undo deployment myapp
```

| Feature                        | ReplicationController | ReplicaSet | Deployment |
|--------------------------------|----------------------|------------|------------|
| Ensures a fixed number of Pods | ✅ Yes               | ✅ Yes      | ✅ Yes      |
| Replaces failed Pods           | ✅ Yes               | ✅ Yes      | ✅ Yes      |
| Supports rolling updates       | ❌ No                | ❌ No       | ✅ Yes      |
| Supports rollback              | ❌ No                | ❌ No       | ✅ Yes      |
| Manages multiple ReplicaSets   | ❌ No                | ❌ No       | ✅ Yes      |
| Supports declarative updates   | ❌ No                | ✅ Yes      | ✅ Yes      |
| Recommended for production     | ❌ No                | ❌ No       | ✅ Yes      |
---
















































































































































































































































































































# Index[configuration&secrets][kops][12-03-2025]
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