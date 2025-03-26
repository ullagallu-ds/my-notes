
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






