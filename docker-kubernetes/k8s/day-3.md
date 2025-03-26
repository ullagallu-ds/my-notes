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
