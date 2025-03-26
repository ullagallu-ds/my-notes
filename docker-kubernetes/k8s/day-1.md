**Why Kubernetes?**  
- Containers provide a great way to package and run applications without dependency issues.  
- However, containers are ephemeral, meaning they can stop at any time. We need a way to ensure **high availability (HA), scalability, and automatic restarts** when a container fails.  
- Exposing containers to the outside world using **port mapping** is inefficient because:  
  - It requires manual configuration.  
  - It can quickly exhaust all available ports on the host system.  
  - It’s difficult to track which port is assigned to which container.  
- **Docker itself is not a distributed system**, making it a single point of failure.  
- **Managing storage for containers** can be expensive and introduce latency, especially when using shared storage solutions.  
- **Handling secrets and configurations securely** across multiple containers is another challenge.  
This is where Kubernetes (K8s) comes in. It acts as an **orchestrator**, addressing all these challenges by:  
- Seamlessly **placing and managing pods** across a cluster.  
- **Scaling applications** automatically based on demand.  
- **Managing configurations and secrets** efficiently.  
- **Ensuring health checks** and self-healing by restarting failed containers.  
- Supporting **declarative updates**, allowing smooth application rollouts and rollbacks.  

Kubernetes provides a robust, distributed, and automated way to run containerized applications at scale.  
In Kubernetes, **resiliently** means that your application can handle failures and disruptions without significant downtime or manual intervention. Kubernetes ensures resilience by:  
1. **Self-healing** – If a pod crashes, Kubernetes automatically restarts it. If a node fails, pods are rescheduled to a healthy node.  
2. **Scaling** – It dynamically scales up or down based on load, ensuring the system adapts to demand.  
3. **Load balancing** – Traffic is distributed among healthy pods, preventing overload on a single instance.  
4. **Rolling updates & rollbacks** – It deploys updates gradually and can revert if an issue occurs.  
5. **Fault tolerance** – With multi-node clusters, failures in one node don’t impact the entire application.  
Essentially, **Kubernetes ensures that your system remains operational and performs well, even when failures occur.**
Kubernetes (K8) is an open-source container orchestration tool that automates application deployment, ensures HA, and scales application.
---
### **Kubernetes Architecture**  
Kubernetes (K8s) follows a **distributed architecture**, meaning it consists of multiple nodes grouped together, forming a **cluster**.  
A **Kubernetes cluster** consists of:  
- **Control Plane Nodes** – Responsible for orchestrating and managing the cluster.  
- **Worker Nodes** – Responsible for running application workloads.  
### **Control Plane Components**  
The **Control Plane** is responsible for the entire orchestration of the cluster, ensuring workloads are scheduled, managed, and maintained. It consists of multiple components:  
#### **1. API Server**  
- Acts as the **entry point** for the Kubernetes cluster. Any operation performed (e.g., `kubectl` commands, manifest file submissions) first interacts with the API server.  
- Responsible for:  
  - **Authentication**: Verifies the identity of the user or service trying to access the cluster using certificates, tokens, or external identity providers (e.g., OIDC, LDAP).  
  - **Authorization**: Determines whether the authenticated user has permission to perform the requested action using Role-Based Access Control (RBAC) or Attribute-Based Access Control (ABAC).  
  - **Request Validation**: Ensures that requests (from `kubectl` or YAML manifests) are properly formatted and conform to Kubernetes API standards before processing them.  
#### **2. Scheduler**  
- Responsible for **assigning workloads (pods) to nodes** based on constraints and resource availability.  
- Uses an **algorithm** with two key functionalities:  
  - **Filtering**: Eliminates nodes that **do not meet the pod's requirements** (e.g., insufficient CPU/memory, taints/tolerations).  
  - **Scoring**: Ranks the remaining nodes based on various factors like resource utilization, affinity rules, and topology to select the best fit.  
#### **3. etcd**  
- A **distributed key-value store** that holds the entire cluster state, including configuration, node/pod details, and secrets.  
- Ensures data consistency across the cluster, making it a **critical** component for Kubernetes functionality.  
#### **4. Controller Manager**  
- Ensures that the cluster **maintains the desired state** by continuously monitoring objects and making necessary changes.  
- Consists of multiple controllers:  
  - **ReplicaSet Controller** – Ensures the specified number of pod replicas are always running (self-healing).  
  - **Deployment Controller** – Manages rolling updates and rollbacks to ensure zero downtime.  
  - **Node Controller** – Monitors node health and marks them as **NotReady** if they fail.  
  - **Service Controller** – Manages Service objects to ensure network reachability.  
  - **Job Controller** – Ensures that batch jobs run to completion.  
  - **DaemonSet Controller** – Ensures that specific pods run on every node (e.g., logging or monitoring agents).  
  - **StatefulSet Controller** – Manages stateful applications that require stable identities and persistent storage.  
---
### **Worker Node Components**  
Worker nodes are responsible for **running application workloads** and consist of the following key components:  
#### **1. Kubelet**  
- An **agent** that runs on every node.  
- Communicates with the API server to receive pod definitions and ensures containers are running as expected.  
- Continuously updates pod status back to the control plane.  
#### **2. Container Runtime Interface (CRI)**  
- Responsible for **running and managing containers** inside pods.  
- Supports multiple runtimes like **containerd, CRI-O, and Docker** (although Docker is being phased out in K8s).  
#### **3. Kube-Proxy**  
- A **networking component** that runs on each node.  
- Manages **network rules and IP tables** to allow communication between pods and services, handling both internal and external traffic.  
---
Kubernetes provides a **powerful orchestration system** that automates workload placement, scaling, configuration management, health checks, and rolling updates, making containerized applications **highly available, resilient, and scalable**.  
---
### **Kubernetes Features**  
Kubernetes (K8s) is a **powerful orchestrator** that provides multiple features to efficiently manage containerized workloads.  
#### **1. Service Discovery & Load Balancing**  
- Pods are **ephemeral** and their IPs change frequently, making direct communication unreliable.  
- Kubernetes **abstracts pod IPs using Services**, which provide a **static IP and DNS name** to ensure stable communication.  
- Services also distribute incoming traffic **evenly** across pods using built-in **load balancing**.  
#### **2. Automatic Bin Packing**  
- Kubernetes optimizes resource usage by **scheduling pods efficiently** across available nodes.  
- We can define **CPU and memory requirements** in pod manifests, allowing K8s to **place workloads automatically** based on resource availability.  
#### **3. Automatic Rollout & Rollback**  
- Kubernetes enables **gradual application updates** (rolling updates) without downtime.  
- If an update fails, K8s can **automatically roll back** to the last stable version.  
#### **4. Auto-Healing**  
- If a pod **fails or crashes**, Kubernetes **automatically restarts it** to maintain high availability.  
- If a node becomes unresponsive, K8s **reschedules affected pods** on healthy nodes.  
#### **5. Storage Orchestration**  
- Kubernetes supports **dynamic volume provisioning**, where it can automatically create and attach storage (e.g., Persistent Volumes).  
- It also releases **unused storage** when pods no longer need it.  
#### **6. Configuration & Secrets Management**  
- Kubernetes provides **ConfigMaps** for managing **configuration data** (e.g., environment variables, URLs).  
- It also offers **Secrets** to securely store **sensitive data** like passwords, API keys, and certificates.  
#### **7. IPv4 & IPv6 Dual Stack Support**  
- Kubernetes supports both **IPv4 and IPv6**, allowing clusters to operate in dual-stack mode for better networking flexibility.  
#### **8. Extendability via CRDs (Custom Resource Definitions)**  
- Kubernetes allows users to extend its functionality by **creating custom resources** and controllers using **CRDs**.  
- This enables the integration of new functionalities, such as **custom operators** for managing specific applications.  
---
Kubernetes provides a **scalable, resilient, and automated** environment for managing containerized applications, ensuring smooth deployments, efficient resource utilization, and high availability.  
---

### What is a Namespace in Kubernetes?  
A **Namespace** in Kubernetes is a way to logically isolate resources within a cluster. It allows multiple teams or applications to share a single cluster while keeping their resources separate.  

### Use Cases of Namespaces  
1. Multi-Tenancy → Different teams or projects can use separate namespaces to avoid resource conflicts.  
2. Resource Isolation → Ensures that different applications do not interfere with each other.  
3. Access Control → Role-Based Access Control (RBAC) can be applied at the namespace level for security.  
4. Resource Quotas → Helps in limiting CPU, memory, and storage usage per namespace.  
5. Organized Management → Allows grouping related resources, making it easier to manage complex clusters.  

### Common Namespace Commands  

1. View Existing Namespaces  
```bash
kubectl get namespaces  
```  

2. Create a New Namespace  
```bash
kubectl create namespace <namespace-name>
```  

3. Delete a Namespace  
```bash
kubectl delete namespace <namespace-name>
```  

4. View Resources in a Specific Namespace  
```bash
kubectl get pods -n <namespace-name>
kubectl get services -n <namespace-name>
```  

5. Set a Default Namespace for kubectl  
```bash
kubectl config set-context --current --namespace=<namespace-name>
```  

6. Run a Pod in a Specific Namespace  
```bash
kubectl run nginx --image=nginx -n <namespace-name>
```

7. Get the current namespace
```bash
kubectl config view --minify
```
8. Get the all contexts avialable in your cluster
```bash
kubectl config get-contexts
```
9. Switch to another context:
```bash
kubectl config use-context test-context
```
### Default Namespaces in Kubernetes  
- default → Used when no namespace is specified.  
- kube-system → Contains system-related components like the API server and controller manager.  
- kube-public → Accessible to all users; used for public information.  
- kube-node-lease → Manages node heartbeats to determine availability.  
---
Example of Init Containers in Kubernetes  

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















































































