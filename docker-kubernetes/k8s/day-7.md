## **Kubernetes ConfigMaps, Secrets, and Probes – Detailed Explanation**  

Kubernetes provides mechanisms to **manage configuration**, **secure sensitive data**, and **monitor application health**. Three key features are:  

1. **ConfigMaps** (For managing non-sensitive configuration data)  
2. **Secrets** (For storing sensitive information like passwords, API keys)  
3. **Probes** (For checking container health and readiness)  

Let's go through each with **detailed explanations and examples**.

---

# **1. ConfigMap**
### **What is a ConfigMap?**
A **ConfigMap** is used to store **non-sensitive configuration data** in key-value pairs. It allows you to decouple configuration details from the application code, making deployments **more flexible** and **easier to manage**.

---

### **Ways to Create a ConfigMap**
1. **From a YAML file**  
2. **From a literal key-value pair**  
3. **From an environment file**  

---

### **Example 1: Creating a ConfigMap using YAML**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: dev
data:
  APP_ENV: "production"
  APP_VERSION: "1.0"
  LOG_LEVEL: "debug"
```

🔹 **Explanation:**  
- The ConfigMap **`app-config`** contains configuration data like environment, version, and logging level.

---

### **Example 2: Mounting ConfigMap as Environment Variables in a Pod**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
    - name: app-container
      image: myapp:latest
      envFrom:
        - configMapRef:
            name: app-config
```
🔹 **Explanation:**  
- The **configMapRef** field injects all key-value pairs from `app-config` as **environment variables** in the container.

---

### **Example 3: Mounting ConfigMap as a Volume**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  config.json: |
    {
      "appName": "MyApp",
      "logLevel": "debug"
    }
---
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
    - name: app-container
      image: myapp:latest
      volumeMounts:
        - name: config-volume
          mountPath: "/etc/config"
  volumes:
    - name: config-volume
      configMap:
        name: app-config
```

🔹 **Explanation:**  
- The ConfigMap `app-config` contains a **JSON file** (`config.json`).  
- It is **mounted as a file** in `/etc/config` inside the container.  

---

### **When to Use ConfigMap?**
✅ When you need to store **non-sensitive configuration values** like app settings, environment variables, and log levels.  
✅ When you want to **decouple application configuration from the application code**.  
✅ When multiple pods **need access to the same configuration**.  

---

# **2. Secrets**
### **What is a Secret?**
A **Secret** is used to store **sensitive data** such as **passwords, API keys, and database credentials** in an **encoded format (Base64)**. This prevents exposing sensitive information in plain text inside Pod definitions.

---

### **Example 1: Creating a Secret using YAML**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  username: bXl1c2Vy   # Base64 encoded value of "myuser"
  password: c2VjdXJlMTIz  # Base64 encoded value of "secure123"
```

🔹 **Explanation:**  
- `username: bXl1c2Vy` → Base64 encoding of **"myuser"**  
- `password: c2VjdXJlMTIz` → Base64 encoding of **"secure123"**  

👉 **To decode Base64 value:**  
```sh
echo "bXl1c2Vy" | base64 --decode  # Output: myuser
```

---

### **Example 2: Using Secrets as Environment Variables in a Pod**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
    - name: app-container
      image: myapp:latest
      env:
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: username
        - name: DB_PASS
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
```

🔹 **Explanation:**  
- The secret **`db-secret`** is injected as environment variables:  
  - **`DB_USER`** → `"myuser"`  
  - **`DB_PASS`** → `"secure123"`  

---

### **Example 3: Mounting Secrets as Volumes**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
    - name: app-container
      image: myapp:latest
      volumeMounts:
        - name: secret-volume
          mountPath: "/etc/secret"
          readOnly: true
  volumes:
    - name: secret-volume
      secret:
        secretName: db-secret
```

🔹 **Explanation:**  
- The secret `db-secret` is **mounted as a file** inside the container at `/etc/secret/username` and `/etc/secret/password`.

---

### **When to Use Secrets?**
✅ When storing **sensitive data** like passwords, API keys, or tokens.  
✅ When you want to avoid hardcoding **secrets** in deployment files.  
✅ When you need **secure and controlled access** to sensitive data.  

---

# **3. Probes (Liveness, Readiness, Startup Checks)**
### **What are Probes?**
**Probes** help Kubernetes **monitor container health** and take actions like **restarting failed containers** or **removing unready containers from service discovery**.

There are **three types of probes**:
1. **Liveness Probe** – Checks if the container is still running.  
2. **Readiness Probe** – Checks if the container is ready to serve traffic.  
3. **Startup Probe** – Ensures that an application has started correctly before checking liveness/readiness.

---

## **1️⃣ Liveness Probe (Restarting Unhealthy Containers)**
A **Liveness Probe** checks if a container is still alive. If it fails, Kubernetes **restarts the container**.

### **Example: HTTP-based Liveness Probe**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
    - name: app-container
      image: myapp:latest
      livenessProbe:
        httpGet:
          path: /health
          port: 8080
        initialDelaySeconds: 5
        periodSeconds: 10
```

🔹 **Explanation:**  
- It checks the **`/health`** endpoint every **10 seconds**.  
- If the app crashes, the probe **fails** and Kubernetes **restarts the container**.  

---

## **2️⃣ Readiness Probe (Traffic Control)**
A **Readiness Probe** ensures that a container is ready to **accept traffic**. If it fails, the container **is removed from service discovery** but **not restarted**.

### **Example: TCP-based Readiness Probe**
```yaml
readinessProbe:
  tcpSocket:
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 10
```

🔹 **Explanation:**  
- Kubernetes will send TCP requests to port **8080**. If the app is not ready, it **removes the container from the service load balancer**.  

---

## **3️⃣ Startup Probe (Ensuring Application Boot Completion)**
A **Startup Probe** ensures that an app has fully started before other probes run.

### **Example: Exec-based Startup Probe**
```yaml
startupProbe:
  exec:
    command: ["cat", "/app/started"]
  initialDelaySeconds: 10
  periodSeconds: 5
  failureThreshold: 10
```

🔹 **Explanation:**  
- Kubernetes checks if **`/app/started`** exists. If not, it keeps retrying **for up to 50 seconds**.  
- Once successful, Kubernetes starts the **Liveness & Readiness probes**.  

---

### **When to Use Probes?**
✅ Use **Liveness Probe** if the app might **crash** and needs a restart.  
✅ Use **Readiness Probe** if the app **takes time to start** or **depends on external services**.  
✅ Use **Startup Probe** if the app **needs a long startup time**.  

---

🚀 **That’s the full explanation!** Let me know if you need more clarifications. 😊
## **Kubernetes Resource Quotas & Limit Ranges – Detailed Explanation**  

Kubernetes provides mechanisms to control and manage resource allocation within namespaces. These mechanisms help in **preventing resource over-utilization** and **ensuring fair distribution** among applications and teams.  

The two primary mechanisms are:  
1. **Resource Quotas** (Namespace-level restrictions)  
2. **Limit Ranges** (Per-pod or per-container restrictions)  

Let’s go through each in detail with practical use cases and examples.

---

# **1. Resource Quotas**
### **What is a Resource Quota?**
A **ResourceQuota** in Kubernetes is a way to **restrict the total resource consumption** within a namespace. It sets limits on the number of pods, CPU, memory, persistent storage, and other resources that a namespace can use.

This is useful in **multi-tenant clusters** where multiple teams share the same Kubernetes cluster, preventing any one team from consuming too many resources.

### **Key Features of Resource Quotas**
✅ Limits total **CPU**, **Memory**, and **Storage** usage in a namespace.  
✅ Restricts **number of pods, services, and volumes** that can be created.  
✅ Helps in **fair resource distribution** across teams and applications.  

---

### **Example 1: Restricting CPU and Memory Usage**  
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev
spec:
  hard:
    pods: "10"              # Max 10 pods in the namespace
    requests.cpu: "4"       # Max 4 CPU cores can be requested in total
    requests.memory: 8Gi    # Max 8 GiB of memory can be requested in total
    limits.cpu: "8"         # Max 8 CPU cores can be used
    limits.memory: 16Gi     # Max 16 GiB of memory can be used
```

🔹 **Explanation:**  
- **`pods: "10"`** → No more than 10 pods can be created in this namespace.  
- **`requests.cpu: "4"`** → Total CPU requested by all pods in this namespace cannot exceed 4 cores.  
- **`limits.cpu: "8"`** → Total CPU limit for all pods in the namespace is capped at 8 cores.  
- **`requests.memory: 8Gi`** → Total memory requested cannot exceed 8 GiB.  
- **`limits.memory: 16Gi`** → Maximum memory that can be allocated in this namespace is 16 GiB.  

---

### **Example 2: Restricting Persistent Volume Usage**  
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: storage-quota
  namespace: dev
spec:
  hard:
    persistentvolumeclaims: "5" # Only 5 PVCs allowed in this namespace
    requests.storage: "100Gi"   # Total storage requested cannot exceed 100 GiB
    limits.storage: "200Gi"     # Max storage used cannot exceed 200 GiB
```

🔹 **Explanation:**  
- **`persistentvolumeclaims: "5"`** → Users cannot create more than 5 PVCs in this namespace.  
- **`requests.storage: "100Gi"`** → The total storage requested by all PVCs cannot exceed 100 GiB.  
- **`limits.storage: "200Gi"`** → The maximum storage allowed for all PVCs in this namespace is 200 GiB.  

---

### **When to Use Resource Quotas?**
✅ When multiple teams share the same Kubernetes cluster and you want to **prevent one team from consuming all resources**.  
✅ To **ensure fair distribution** of CPU, memory, and storage across different namespaces.  
✅ To **prevent uncontrolled pod scaling** by limiting the number of pods in a namespace.  

---

# **2. Limit Ranges**
### **What is a Limit Range?**
A **LimitRange** defines **default, minimum, and maximum resource requests and limits** for individual **pods and containers** inside a namespace.  

Unlike **ResourceQuota**, which controls the total namespace-level resource allocation, **LimitRange** applies restrictions on a **per-pod** or **per-container** basis.

---

### **Example 1: Setting CPU and Memory Limits for Containers**
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: container-limits
  namespace: dev
spec:
  limits:
    - type: Container
      default:
        cpu: "500m"        # Default CPU limit (0.5 core)
        memory: "512Mi"    # Default memory limit (512Mi)
      defaultRequest:
        cpu: "250m"        # Default CPU request (0.25 core)
        memory: "256Mi"    # Default memory request (256Mi)
      min:
        cpu: "100m"        # Minimum CPU request allowed (0.1 core)
        memory: "128Mi"    # Minimum memory request allowed (128Mi)
      max:
        cpu: "2"           # Maximum CPU request allowed (2 cores)
        memory: "2Gi"      # Maximum memory request allowed (2Gi)
```

🔹 **Explanation:**  
- If a pod doesn’t specify its CPU or memory requests/limits, Kubernetes applies the **default** values:  
  - **CPU request:** 250m (0.25 core)  
  - **Memory request:** 256Mi  
  - **CPU limit:** 500m (0.5 core)  
  - **Memory limit:** 512Mi  
- **Min/max boundaries** ensure that users cannot request less than 100m CPU or more than 2 cores.  

---

### **Example 2: Enforcing Pod Limits**
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: pod-limits
  namespace: dev
spec:
  limits:
    - type: Pod
      min:
        cpu: "200m"
        memory: "256Mi"
      max:
        cpu: "4"
        memory: "8Gi"
```

🔹 **Explanation:**  
- A pod **must** request at least **200m CPU and 256Mi memory**.  
- A pod **cannot** exceed **4 CPU cores or 8 GiB memory**.  

---

### **When to Use Limit Ranges?**
✅ When you want to **set default resource limits** for containers.  
✅ To **prevent small or large resource requests** from affecting the cluster’s performance.  
✅ To **enforce per-container CPU and memory limits**, ensuring fair allocation.  

---

# **3. Resource Quotas vs. Limit Ranges**
| Feature           | **Resource Quota** | **Limit Range** |
|-------------------|------------------|---------------|
| **Scope**        | Namespace-wide    | Individual Pods/Containers |
| **Controls**     | Total CPU, Memory, Storage for the namespace | CPU, Memory limits per pod/container |
| **Enforces**     | Overall resource consumption cap | Default and max/min limits per container |
| **Use Case**     | Prevent a single namespace from consuming all cluster resources | Ensure fair allocation within a namespace |

---

# **4. Full Example: Using Both Together**
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: namespace-quota
  namespace: dev
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
---
apiVersion: v1
kind: LimitRange
metadata:
  name: container-limits
  namespace: dev
spec:
  limits:
    - type: Container
      default:
        cpu: "500m"
        memory: "512Mi"
      defaultRequest:
        cpu: "250m"
        memory: "256Mi"
      min:
        cpu: "100m"
        memory: "128Mi"
      max:
        cpu: "2"
        memory: "2Gi"
```

### **Key Takeaways**
✅ **Use ResourceQuotas** to **restrict total resource usage** at the namespace level.  
✅ **Use LimitRanges** to **enforce per-container limits and defaults**.  
✅ Together, they **prevent overuse**, **ensure fairness**, and **improve cluster efficiency**.  

---


































# Advance Scheduling Index [kops][17-03-2025]
- nodeSelector
- Affinity & Anti Affinity
- Taints & Tolerations

# Schduling
- default scheduler takes care about pod placemnet in the nodes it does not consider any constriants based on default algorithm it will find best fit node for pod 
- To control Pod placement based on specific constraints, we can use:
`Node Selector:` Assigns Pods to specific nodes based on labels.
`Node Affinity & Anti-Affinity:` Provides more advanced control over node selection using rules (soft and hard constraints).
`Taints & Tolerations:` Ensures that only specific Pods can be scheduled on tainted nodes, preventing unwanted scheduling.


✅ Must follow the rule	requiredDuringSchedulingIgnoredDuringExecution
🔵 Tries to follow the rule, but not mandatory	preferredDuringSchedulingIgnoredDuringExecution

**assigning labels**
kubectl label node <node-name> key=value
**get labels of nodes**
kubectl get nodes --show-labels
kubectl get node <node-name> --show-labels
**remove the label**
kubectl label nodes worker-node-1 key-

**node selector example**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      nodeSelector:
        name: siva
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
**Observations:**
- If the label does not match, the Pod goes into a Pending state.
- During Pod placement, only the nodeSelector label is checked; it is not enforced during execution.

### Affinity & Anti-Affinitiy

Affinity is similar to nodeSelector but more expressive. It allows using set-based operators to check node labels.
Anti-Affinity is the opposite of Affinity, ensuring that Pods do not get scheduled on the same node or within the same topology (e.g., zone, region).

Affinity has two modes:

- requiredDuringSchedulingIgnoredDuringExecution[mandatory must meet the condition if not pod went to pending state]
The scheduler must meet the rule before placing the Pod.
Functions like nodeSelector, but with a more flexible syntax.
If no matching node is found, the Pod remains in a Pending state.

- preferredDuringSchedulingIgnoredDuringExecution[optional if condtion not pod also still place]
The scheduler tries to meet the rule but will still schedule the Pod if no matching node is found.
Acts as a soft constraint rather than a strict requirement.
📝 Note:
In both types, IgnoredDuringExecution means that if the node labels change after scheduling, the Pod continues to run on the assigned node.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      affinity:
        nodeAffinity:
           requiredDuringSchedulingIgnoredDuringExecution:
             nodeSelectorTerms:
             - matchExpressions:
                - key: name
                  operator: In
                  values: ram
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      affinity:
        nodeAffinity:
           preferredDuringSchedulingIgnoredDuringExecution:
           - weight: 1
             preference:
                matchExpressions:
                 - key: name
                   operator: In
                   values:
                   - krishna
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

**Pod Affinity**
This ensures frontend pods run on the same node as backend pods.

```yaml
affinity:
  podAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app
              operator: In
              values:
                - backend
        topologyKey: "kubernetes.io/hostname"
```
📌 Effect:

The frontend pod will only be scheduled on nodes where a backend pod is already running.

📌 Use Cases:

Low-latency communication (e.g., databases and applications).
Services that benefit from being on the same node (e.g., caching services).

**Anti-Affinity**
Ensures web pods do not run on the same node.

```yaml
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app
              operator: In
              values:
                - web
        topologyKey: "kubernetes.io/hostname"
```

📌 Effect:

Each web pod will be scheduled on a different node to improve availability.
📌 Use Cases:

High availability (avoid all replicas on one node).
Prevent resource contention (spread workloads evenly).

When to Use What?
Pod Affinity → When you want pods to run together (e.g., app & database).

### Taints and Tolerations






