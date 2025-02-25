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


