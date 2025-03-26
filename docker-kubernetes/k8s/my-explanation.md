
# My Explanation
# Why K8s
My Answer
- containers are good way to bundle and run application without any dependency issues
- But containers are ephemeral we need to ensure HA, Scalable and auto restart if any container goes down
- Generally we are using port mapping to expose container to the outside world this is the biggest problem that we were faced 
- Port Mapping is manual and it drain all ports of host system if we do continuously
- Hard Track Which port is allocated to which container
- Docker is it self a single point of failure it is not distributed architecture
- I feel Sharable Storage always costly high latency 
- Managing Secrets and configuration is another challenge
This is where K8s  can address all the above problems that containers have
It is a orchestrator it will seamlessly handles pod placement , scalability , configuaration management and health checks and declratives updates of applications

can you refine it I think I pass some valuble point if feel these are valueble please appreciate thank you
---
# Can you please explain k8s architecture this is my answer
- By default k8s is a distributed architecture means it is a group of nodes we can call as cluster
- Cluster has ControlPlane Nodes and Worker Nodes
- Control Plane is responsible do complete orchestration of nodes
- It has multiple components seamlessly orchestrate workloads
  1. API Server: It frontend for k8s cluster if we do any operations it will take instruction and process
  - It is responsible for 
    - Authentication[give me little bit explanation]
    - Authorization[give me little bit explanation
    - It will validates the request[kubectl commands or manifest file] [Give me little bit explanation
  2. Scheduler: In K8s workloads are deployable means placeable  it runs the algorithm for find best fit node for workload According to the constraints in the request
  Algorithm has 2 functionalities
  - filtering: [give me little bit explanation what happens]
  - Scoring: [give me little bit explanation what happens]
  3. ETCD: It is a key-value database it store complete cluster configuration
  4. Controller Manager: It is responsible for make workloads are desired state
     - ReplicaSet[AutoHealing,Maintain desired no of pods]
     - Deployment[Gradually release the applications without any downtime and rollback for failure]
     ... Give me Multiple Controllers
- Worker nodes are responsible for accommodate run the workloads
  kubelet: It Is a agent running as process in a each and every node in the cluster it take the instructions from API server creates the pod and update the pod status to API server
  CRI: Runtime for running containers it will manage the containers lifecycle
  Kube-proxy: It Is a agent running as process in a each and every node in the cluster it manages network rules of pod and services

Hello My Dear Friend I think this content was good please appreciate me if it is a valuable content
Please refine it
---
# What are the k8s features this is my answer
K8s is a orchestrator means it has multiple features to handle workloads successfully

ServiceDiscovery&Loadbalancing:
- By default pods are ephermeral we cannot relay on pod ip for communication so services abstract from pod IP It provides static IP and it also do Loadbalancing

AutomaticBinPacking:
- We define resources that required by the pod in the manifest we can run the pods

Automatic Rollout & Rollback:
We can gradually release application without down time and rollback any failure

Auto Healing:
- K8s capable to restart failed pods

Storage Orchestrates:
- K8s can create volumes and mount to pods automatically and release the volume if not required

Cofiguration&Secrets Management:
- k8s allow you storage secrets[keys,passwords,certificates] and configiration of pods like urls

- Supports Dual IP [IPV4&IPV6]
- Supports add more fuctionalty to k8s using CRDS

# What is Namepspaces in k8s
- Namespaces are used isolate and manage workloads efficiently namesspaces

- able assign resources quota to restrict usage of resournces in a cluster
- Easy to 

---

# Pod
- Pod is a k8s object is a smallest deployable[placeable in the cluster] unit in the cluster
- It is a wrapper around one or more containers best practice one pod = one container
- Each and every pods has one IP irrespective no of containers in the pod
- Containers in the Pod can share the network[reachable via localhsot] and storage
- Don't run pods which are not associated with any controllers because it not handle any failure
- Pod gets an ip because pause container it holds netwrok namespaces and all subsequent containers attached to it

Pod Life Cycle:
---------------
Pod life cycle goes through multiple phases

pending: k8s accepts definition wait for pod placement
running: pod placed in node all containers are started or running
succeded: all containers in the pod successfully terminated not restarted
failied: one or more containers are failed k8s will not restarted them
unkonwn: k8s does not know pod status

Difference between container and pod
------------------------------------
- containers are executable packages
- each and every container has it's own network stack
- managed by container runtime

- Pods deployable objects in the k8s
- Container in the pod can share the same network stack
- managed by k8s


- kubectl commands to handle pods a to z
- basic manifest file