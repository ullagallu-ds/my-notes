### **What is a Pod?**  
- A **Pod** is the **smallest deployable unit** in Kubernetes.  
- It acts as a **wrapper** around one or more **containers** (best practice: **one container per pod**).  
- Each Pod gets a **unique IP address**, regardless of the number of containers inside it.  
- **Containers inside a Pod** share the same **network namespace** (reachable via `localhost`) and **storage volumes**.  
- **Avoid running standalone Pods** (without controllers like Deployments), as they **won't be restarted** automatically if they fail.  
- Pods **receive an IP** because of the **pause container**, which holds the **network namespace** for the Pod, and all other containers attach to it.  

---

### **Pod Lifecycle**  
A Pod transitions through multiple phases during its lifecycle:  

1. **Pending** – Kubernetes accepts the Pod definition, but it is **waiting for node assignment**.  
2. **Running** – The Pod has been **placed on a node**, and all containers are either **starting or running**.  
3. **Succeeded** – All containers inside the Pod have **terminated successfully** and **won't restart**.  
4. **Failed** – One or more containers have **crashed**, and Kubernetes **won’t restart them**.  
5. **Unknown** – The Pod’s status is **unreachable**, usually due to a node communication issue. 


When we say **"Pod is created"**, it means the **Kubernetes API server** has received the request to create a Pod and has stored its definition in **etcd (Kubernetes' key-value store)**.  

At this point, the Pod object **exists in Kubernetes**, but it does not yet have a Node assigned to run on. The Kubernetes scheduler is responsible for picking a suitable Node based on resources, affinity rules, and other constraints.  

So, **"Pod created" does not mean it is running**—it only means that Kubernetes knows about it and is working on placing it on a Node.

---

### **Difference Between a Container and a Pod**  

| Feature      | Container | Pod |
|-------------|-----------|----------------|
| **Definition** | Executable package of software | Deployable object in Kubernetes |
| **Networking** | Has its own network stack | Shares the network namespace with other containers in the same Pod |
| **Management** | Managed by **container runtime** (Docker, containerd) | Managed by **Kubernetes** |
| **Scalability** | Cannot be directly scaled in Kubernetes | Kubernetes scales **Pods**, not individual containers |

---

### **Managing Pods with kubectl**  

#### **Basic Commands**  
```bash
kubectl get pods              # List all pods
kubectl describe pod <pod-name>  # Detailed information about a pod
kubectl delete pod <pod-name>  # Delete a pod
kubectl logs <pod-name>        # View logs of a pod
kubectl exec -it <pod-name> -- /bin/sh  # Access a running pod
```

#### **Creating a Pod Using a Manifest File**  
Here’s a **basic Pod manifest (`pod.yaml`)**:  
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: nginx
      ports:
        - containerPort: 80
```
To create the Pod, run:  
```bash
kubectl apply -f pod.yaml
```

---

### **Final Thoughts**  
Pods are the **fundamental building blocks** of Kubernetes. They enable containerized applications to run efficiently **with shared networking and storage** while being managed and orchestrated by Kubernetes. 

# Init Containers in Kubernetes  

Init containers are specialized containers that run before the main application container starts. They are used for tasks like setting up configurations, waiting for dependencies, or performing database migrations.  

Scenario:  
You have an Nginx pod, but before it starts, you need to download an index.html file from an external server and place it in a shared volume.  

YAML Example:  
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
   app: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html
  initContainers:
  - name: init-git-clone
    image: alpine/git
    command:
    - sh
    - "-c"
    - |
      git clone https://github.com/sivaramakrishna-konka/hello-world.git /work-dir && \
      cp /work-dir/wish.html /work-dir/index.html
    volumeMounts:
    - name: shared-data
      mountPath: /work-dir
  volumes:
  - name: shared-data
    emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```  

How It Works:  
1. The `init-downloader` container runs first. It:  
   - Uses the `busybox` image.  
   - Runs `wget` to download an HTML file.  
   - Stores the file in a shared volume (`emptyDir`).  

2. Once the init container completes, the main Nginx container starts.  
   - It serves the downloaded `index.html` from the shared volume.  

Key Points About Init Containers:  
- They always run before the main container.  
- They must complete successfully before the main container starts.  
- They can have different images and dependencies from the main container.  
- All init containers are run sequentially, meaning one must complete before the next starts.  
- Useful for setup tasks, data preparation, and waiting for services.
---
# Shared Netwrok
Yes, if two containers are in the **same Pod**, they share the **same network namespace**, meaning they can communicate with each other using `localhost`.  

### **Example: Shared Network in a Pod**  
Here’s a simple example where two containers (`nginx` and `alpine`) are in the same Pod, and the `alpine` container pings the `nginx` container using `localhost`.  

#### **YAML Example:**  
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: shared-network-pod
spec:
  containers:
  - name: nginx
    image: nginx
  - name: alpine
    image: alpine
    command: ["sh", "-c", "sleep 3600"]
```

#### **How It Works:**  
1. The Pod has **two containers**:  
   - `nginx` (web server)  
   - `alpine` (used for testing network communication)  

2. Since they are in the **same Pod**, they share the same **network namespace** and can communicate over `localhost`.  

#### **Testing Inside the Pod:**  
After the Pod is running, you can **exec into the `alpine` container** and ping the `nginx` container:  
```sh
kubectl exec -it shared-network-pod -c alpine -- sh
```
Now inside the container, try:  
```sh
ping localhost
curl localhost
```
Both should work, confirming that both containers share the same network namespace.

#### **Key Points:**  
- Containers in the same **Pod** can communicate over `localhost`.  
- They **do not** need a separate IP address since they share the same **network namespace**.  
- This is useful for **sidecar patterns**, such as logging, monitoring, or security proxies.  
---
### What is a Pause Container?  
A Pause Container is a special container that acts as the parent container for all containers within a Pod in Kubernetes. It is created automatically by Kubernetes when a Pod is scheduled.  

### Why is a Pause Container Needed?  
Kubernetes uses Pause Containers for networking and process management within a Pod.  

1. Pod’s Network Namespace →  
   - All containers in a Pod share the same network namespace.  
   - The Pause Container holds this namespace, allowing other containers to join it.  
   - This ensures containers in a Pod can communicate internally using `localhost`.  

2. Pod Lifecycle Management →  
   - Even if application containers restart, the Pause Container keeps the Pod’s IP and network consistent.  
   - Without it, network settings would reset every time a container restarts.  

### How Does it Work?  
- When a Pod is created, Kubernetes first starts a Pause Container.  
- All other containers in the Pod use the network and process namespaces of the Pause Container.  
- The Pause Container does nothing except sleep indefinitely to keep the namespace alive.  

### Command to View Pause Containers  
On a Kubernetes Node, you can check the running Pause Containers using:  
```bash
sudo ctr -n k8s.io containers ls
sudo ctr -n k8s.io containers list
```
### Key Takeaways  
- The Pause Container is the first container started in a Pod.  
- It acts as a namespace holder for networking and process sharing.  
- It ensures that the Pod’s IP and network remain stable, even if application containers restart.  
- It uses very low resources since it only runs a sleep process.  
---

Yes! A **Kubernetes Cluster** consists of **Control Plane Nodes** and **Worker Nodes**.  

### **Control Plane Responsibilities**  
The **Control Plane** is responsible for decision-making in the cluster. It consists of multiple components that handle different tasks:

1. **Authentication & Authorization**  
   - The **API Server (kube-apiserver)** manages authentication and authorization.
   - It verifies if users, services, or components have the right permissions to access resources.

2. **Manifest File Validation**  
   - The API Server validates incoming Kubernetes YAML manifests before applying them.

3. **Scheduling**  
   - The **kube-scheduler** decides which worker node should run a Pod based on resource availability, constraints, and affinity rules.

4. **Storing Cluster Information**  
   - **etcd** (a distributed key-value store) stores all cluster data, including configuration, state, and resource information.

5. **Controller for HA, Scalability, and Self-Healing**  
   - The **kube-controller-manager** runs controllers that ensure high availability and scalability:
     - **Node Controller**: Detects failed nodes and reschedules Pods.
     - **Replication Controller**: Ensures the desired number of Pods are always running.
     - **Endpoint Controller**: Updates Service and Pod mappings.
     - **Job Controller**: Manages batch jobs and cleanup.
     - **Horizontal Pod Autoscaler (HPA)**: Scales Pods based on CPU/memory usage.

---

### **Worker Node Responsibilities**  
Worker Nodes **execute workloads** and run application containers.

| **Component**  | **Responsibility** |
|---------------|----------------|
| **Kubelet** | Ensures containers in Pods are running and healthy. |
| **Container Runtime** | Runs containers (Docker, containerd, CRI-O). |
| **Kube Proxy** | Handles networking, service discovery, and load balancing. |

---

### **Summary**
- The **Control Plane** is the brain of Kubernetes, making all the decisions.
- The **Worker Nodes** execute those decisions and run application workloads.















































































































































































































































































# Index[kops][11-03-2025]
- ReplicaSet and Replication Controller
- Deployment
- Services[ClusterIP,NodePort,LoadBalancer,ExternalName]

### ReplicaSet and Replication Controller

Both ReplicaSet (RS) and ReplicationController (RC) ensure a specified number of pod replicas are running at all times, but ReplicaSet is the newer version with more features.  

#### 1. Replication Controller (RC) – Legacy Approach  
- Ensures a fixed number of pod replicas are always running.  
- Does not support set-based selectors (only exact match).  
- Deprecated in favor of ReplicaSet.  

**Example: Replication Controller**  
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: my-app-rc
spec:
  replicas: 3
  selector:
    app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: nginx
          image: nginx
```  
#### 2. ReplicaSet (RS) – Improved Version  
- Enhances ReplicationController with support for set-based selectors.  
- Used internally by Deployments for rolling updates.
- Rolling updates require ReplicaSet, which supports set-based selectors and rolling updates.  

**Example: ReplicaSet**  
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: my-app-rs
spec:
  replicas: 3
  selector:
    matchExpressions:
      - key: app
        operator: In
        values:
          - my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: nginx
          image: nginx
```  
This ensures that three replicas of `my-app` are always running, with support for set-based selectors.  

#### Key Differences  

| Feature | Replication Controller (RC) | ReplicaSet (RS) |
|---------|-----------------------------|-----------------|
| API Version | v1 | apps/v1 |
| Selector Type | Exact match | Set-based match |
| Usage in Deployments | Not used | Used inside Deployment |
| Status | Deprecated | Recommended |

#### When to Use What?  
- Use **Deployments** instead of directly using ReplicaSets.  
- ReplicaSets are useful for standalone replication but are mostly managed by Deployments.  
- Do not use ReplicationControllers as they are outdated. 

**observations**
- detach pods from replicaset by change to label of pod for debugging purpose
- I have pod with label app: hello and also have rs pods with label app: hi later i was changed my pod label from app: hello to hi what happend[possible out come is it matches with rs lables the pod comes under rs so it delete extra pod]
- To delete a ReplicaSet without deleting its managed pods, you can use the --cascade=orphan option in kubectl delete. This ensures that the pods remain running even after the ReplicaSet is deleted.

kubectl delete rs my-replicaset --cascade=orphan

Effect: The ReplicaSet is deleted, but its pods continue running as orphaned pods.

Why? The --cascade=orphan flag prevents Kubernetes from propagating the delete action to the pods.

# Deployments
ReplicaSet (RS) is responsible for maintaining a specified number of pod replicas running at all times. If a pod goes down, the ReplicaSet creates a new one to replace it. However, it does not support rolling updates or versioning.

Deployment provides a declarative way to manage ReplicaSets and perform updates to applications. It automatically handles rolling updates and rollbacks, ensuring zero downtime while updating the application.

When updating the application (e.g., changing the container image), the Deployment gradually replaces old pods with new ones by creating a new ReplicaSet while scaling down the old one.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: nginx
          image: nginx:1.21
```

### Services in Kubernetes  

By default, pods are ephemeral, meaning they can be created and destroyed frequently. Every time a pod restarts, it gets a new IP address. Since we cannot rely on pod IPs for communication, Kubernetes provides Services to enable stable networking.  

A Service is a Kubernetes object that provides a static IP address and load balancing for a group of pods. It abstracts communication from dynamic pod IPs and ensures seamless connectivity.  

Types of Services  

`ClusterIP` is the default service type. It is accessible only within the cluster and is used for internal service-to-service communication. An example is a backend service that should not be exposed outside the cluster.  

`NodePort` exposes the service on a static port across all worker nodes. It is accessible externally via NodeIP:NodePort and extends ClusterIP by allowing external access. An example is accessing the service using http://NodeIP:NodePort.  

`LoadBalancer` creates a cloud provider’s native load balancer, such as AWS ELB, GCP LB, or Azure LB. It extends NodePort by automatically provisioning a cloud load balancer and routing traffic to the service. It is costly since it creates a new load balancer for each service.  

`ExternalName` does not create a traditional service but acts as a CNAME record to an external domain. It is used to access external services such as example.com from within the cluster. No ClusterIP, NodePort, or LoadBalancer is assigned.  

Let me know if you need further refinements or an example for any type. 


