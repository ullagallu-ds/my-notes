
### **Why Kubernetes Services?**  

In Kubernetes, **Pods are ephemeral**—they can be created, destroyed, or rescheduled at any time. This makes it difficult for applications to communicate with each other reliably. **Kubernetes Services** provide a stable way for applications to communicate **inside** and **outside** the cluster.

✅ **Services solve these problems:**  
- **Stable Networking:** Provides a **fixed IP & DNS name** for a group of pods.  
- **Load Balancing:** Distributes traffic among multiple pod replicas.  
- **Discovery & Communication:** Enables pods to communicate with each other.  
- **External Access:** Exposes internal applications to the outside world.  

---

## **Types of Kubernetes Services**  

| Service Type       | Accessible From | Exposes Pods Using | Use Case |
|--------------------|----------------|--------------------|----------|
| **ClusterIP** (default)  | Inside the cluster | Internal IP | Communication between microservices. |
| **NodePort**       | Outside the cluster (Node IP + Port) | Node's IP and a static port (30000-32767) | Expose services for external access. |
| **LoadBalancer**   | External (Cloud Provider) | Cloud-based Load Balancer | Expose services via a cloud provider's LB (AWS, GCP, Azure). |
| **ExternalName**   | Outside the cluster | DNS Name | Redirect traffic to an external service. |

---

## **1️⃣ ClusterIP (Default Service)**
**📌 Used for internal communication between microservices.**  

🔹 **Example: Service for Backend Pods**  
```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 80   # Service port
      targetPort: 8080  # Pod port
  type: ClusterIP
```
✅ **Pods in the same cluster can access it using:**  
```bash
curl http://backend-service:80
```

---

## **2️⃣ NodePort (Exposes a Service Outside the Cluster)**
**📌 Used to access services from outside the cluster via `<NodeIP>:<NodePort>`.**  

🔹 **Example: Exposing a Web App on Port 30080**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
spec:
  selector:
    app: webapp
  ports:
    - protocol: TCP
      port: 80       # Service port
      targetPort: 8080  # Pod port
      nodePort: 30080   # Exposed port
  type: NodePort
```
✅ **Access from external users using:**  
```bash
http://<NodeIP>:30080
```

---

## **3️⃣ LoadBalancer (Exposes the Service Using a Cloud Load Balancer)**
**📌 Used when deploying on cloud platforms like AWS, GCP, Azure.**  

🔹 **Example: Exposing a Public Web App**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: public-service
spec:
  selector:
    app: web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer
```
✅ **Cloud provider assigns an external IP to access the service:**  
```bash
http://<External-IP>:80
```

---

## **4️⃣ ExternalName (Redirects Requests to an External Service)**
**📌 Used for redirecting traffic to external services (e.g., database, API).**  

🔹 **Example: Redirecting to an External API**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-service
spec:
  type: ExternalName
  externalName: api.example.com
```
✅ **Calls to `external-service` are redirected to `api.example.com`.**

---

### **🔹 Choosing the Right Service Type**
| Scenario | Recommended Service Type |
|----------|-------------------------|
| Microservices talking to each other | **ClusterIP** |
| Exposing an app on a specific port | **NodePort** |
| Exposing an app publicly in the cloud | **LoadBalancer** |
| Redirecting to an external service | **ExternalName** |

### **CoreDNS Pods & kube-dns Service in Kubernetes**  

Kubernetes uses **CoreDNS** as the default **DNS server** for service discovery and internal networking. It allows Pods to communicate using **service names** instead of IP addresses.  

---

## **1️⃣ CoreDNS Pods**  
- CoreDNS runs as a **Deployment** inside the `kube-system` namespace.  
- It provides DNS resolution for services and pods in the cluster.  
- You can check CoreDNS pods with:  

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
```
✅ **Expected Output**  
```
NAME                       READY   STATUS    RESTARTS   AGE
coredns-74ff55c5b-7s89d    1/1     Running   0          15m
coredns-74ff55c5b-b5h92    1/1     Running   0          15m
```
- CoreDNS usually runs as **two pods** for high availability.  

---

## **2️⃣ kube-dns Service**  
- CoreDNS is exposed via a **kube-dns service** inside the `kube-system` namespace.  
- This service allows all cluster pods to **resolve domain names**.  

🔹 **Check kube-dns Service**
```bash
kubectl get svc -n kube-system kube-dns
```
✅ **Expected Output**  
```
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
kube-dns   ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP   15m
```
- `ClusterIP`: `10.96.0.10` (Default DNS IP in most clusters).  
- Ports: **53 UDP/TCP** (for DNS queries).  

---

## **3️⃣ How DNS Works in Kubernetes?**  
1️⃣ A Pod wants to communicate with `backend-service`.  
2️⃣ It sends a DNS request to **CoreDNS** (`10.96.0.10`).  
3️⃣ CoreDNS resolves `backend-service` to its **ClusterIP**.  
4️⃣ The Pod connects to the backend service using its IP.  

✅ **Test DNS Resolution from a Pod:**  
```bash
kubectl run test-pod --image=busybox --restart=Never -- sleep 3600
kubectl exec test-pod -- nslookup backend-service
```
✅ **Expected Output:**  
```
Server:  10.96.0.10
Address: 10.96.0.10#53

Name: backend-service.default.svc.cluster.local
Address: 10.102.1.12
```

---

## **4️⃣ Restart CoreDNS if Not Working**
If DNS resolution fails, try restarting CoreDNS:  
```bash
kubectl rollout restart deployment coredns -n kube-system
```

---

### **Summary**
| Component | Purpose |
|-----------|---------|
| **CoreDNS Pods** | Run the DNS server inside the cluster. |
| **kube-dns Service** | Exposes DNS to all pods (ClusterIP `10.96.0.10`). |
| **DNS Resolution** | Resolves service names to IPs (`svc.cluster.local`). |

### **How to Configure a Custom DNS in Kubernetes Instead of Default DNS (CoreDNS)?**  

By default, Kubernetes uses **CoreDNS** (`10.96.0.10`) for DNS resolution inside the cluster. However, you can override it with a **custom DNS server** (e.g., `8.8.8.8` or your organization's DNS).  

---

## **1️⃣ Set Custom DNS for a Specific Pod**  
If you want only a specific Pod to use a custom DNS server, modify its **`dnsConfig`** in the Pod spec:  

### **Example: Custom DNS in a Pod**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: custom-dns-pod
spec:
  containers:
  - name: app
    image: busybox
    command: ["sleep", "3600"]
  dnsPolicy: "None"  # Disable default DNS
  dnsConfig:
    nameservers:
      - 8.8.8.8
      - 1.1.1.1
    searches:
      - mydomain.local
    options:
      - name: ndots
        value: "2"
```
🔹 **Explanation:**
- **`dnsPolicy: None`** → Disables Kubernetes default DNS.
- **`dnsConfig.nameservers`** → Uses `8.8.8.8` (Google DNS) and `1.1.1.1` (Cloudflare DNS).
- **`searches`** → Specifies a search domain (`mydomain.local`).
- **`options`** → Configures additional DNS settings.

---

## **2️⃣ Update Cluster-Wide DNS (Modify CoreDNS ConfigMap)**
If you want to **override DNS settings for all pods**, update the **CoreDNS ConfigMap**.

### **Step 1: Edit CoreDNS ConfigMap**
```bash
kubectl edit configmap coredns -n kube-system
```

### **Step 2: Modify the `forward` Plugin**
Find the **`forward . /etc/resolv.conf`** section and replace it with your custom DNS servers:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        health
        ready
        log
        kubernetes cluster.local in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough in-addr.arpa ip6.arpa
            ttl 30
        }
        forward . 8.8.8.8 1.1.1.1  # Custom external DNS servers
        cache 30
        loop
        reload
        loadbalance
    }
```
🔹 **Explanation:**
- **`forward . 8.8.8.8 1.1.1.1`** → Uses Google & Cloudflare DNS instead of default CoreDNS.
- **`cache 30`** → Caches responses for 30 seconds.

---

## **3️⃣ Restart CoreDNS to Apply Changes**
After modifying the ConfigMap, restart CoreDNS to apply the new DNS settings:

```bash
kubectl rollout restart deployment coredns -n kube-system
```

---

## **4️⃣ Verify the New DNS Configuration**
To check if the new DNS settings are working, create a test pod:

```bash
kubectl run dns-test --image=busybox --restart=Never -- sleep 3600
kubectl exec dns-test -- cat /etc/resolv.conf
```

✅ **Expected Output:**
```
nameserver 8.8.8.8
nameserver 1.1.1.1
search default.svc.cluster.local svc.cluster.local cluster.local
```

---

### **Summary:**
| **Method** | **Scope** | **Changes** |
|------------|----------|-------------|
| **Pod-Level Custom DNS** | A specific Pod | Modify `dnsConfig` in the Pod YAML. |
| **Cluster-Wide Custom DNS** | All Pods | Update CoreDNS ConfigMap (`forward` plugin). |

# Extra notes
### **What is `kube-proxy`?**  
`kube-proxy` is a **networking component in Kubernetes** that maintains **network rules** on each node to enable communication between **Pods and Services**. It acts as a **service proxy** for directing traffic.

---

### **🔹 What Does `kube-proxy` Do?**
1. **Handles Service-to-Pod Communication**  
   - Ensures traffic from a **Service** reaches the correct **Pod(s)**.
   
2. **Implements Load Balancing**  
   - Distributes traffic across multiple Pods in a Service.
   
3. **Manages Network Rules**  
   - Uses **iptables** (or **IPVS**) to route requests based on Kubernetes Service configurations.
   
4. **Enables Cluster Networking**  
   - Ensures that requests between nodes and pods work efficiently.

---

### **🔹 How `kube-proxy` Works?**
1. **Listens to the API Server**  
   - Watches for changes in Services and Endpoints (Pods linked to a Service).

2. **Creates Network Rules**  
   - Configures `iptables` (or `ipvs`) to route traffic to the correct Pods.

3. **Handles Traffic Routing**  
   - Ensures external/internal requests reach the correct destination.

---

### **🔹 Modes of `kube-proxy`**
1. **iptables Mode (Default)**
   - Uses Linux **iptables** to handle routing rules.
   - Efficient but can become slow with large clusters.

2. **IPVS Mode (Recommended for Large Clusters)**
   - Uses **IP Virtual Server (IPVS)** for high-performance routing.
   - Provides better load balancing.

3. **Userspace Mode (Deprecated)**
   - Was used in earlier versions but is now **obsolete**.

---

### **🔹 Example: How `kube-proxy` Routes Traffic?**  
Imagine you have a **Service** that exposes **Pods** on `ClusterIP: 10.0.0.1`. When a request comes:

1. `kube-proxy` checks which Pods are behind the Service.
2. It finds that `Pod A (10.0.1.2)` and `Pod B (10.0.1.3)` belong to the Service.
3. It forwards the request to **one of the Pods** based on a load-balancing strategy.

---

### **🔹 Key Takeaways**
✅ **`kube-proxy` is essential for Kubernetes networking.**  
✅ It ensures **Services can communicate with Pods** reliably.  
✅ Uses **iptables or IPVS** to **route traffic efficiently**.  
✅ Required for both **internal and external traffic routing** in a cluster. 

When you create a **Pod** and a **Service** in Kubernetes, a series of internal mechanisms handle traffic routing, service discovery, and networking. Let's break it down step by step.

---

## **1. What Happens Internally When You Create a Pod and a Service?**
### **Pod Creation Process**
1. **Pod Specification Submission**  
   - You define a Pod using a YAML manifest and apply it.
   - The API server stores the request in **etcd** (Kubernetes’ key-value store).
   - The **scheduler** assigns the Pod to a suitable node.

2. **Pod Deployment on a Node**  
   - The **kubelet** on that node pulls the container images.
   - It starts the containers using the container runtime (e.g., containerd or Docker).
   - The Pod gets a unique **IP address** from the node’s **CNI (Container Network Interface)** plugin.
   - **CNI assigns a virtual network interface** to the Pod, allowing it to communicate with other Pods in the cluster.

---

### **Service Creation Process**
1. **Service Definition**  
   - You define a **Service** (e.g., ClusterIP, NodePort, LoadBalancer) in a YAML manifest.
   - The API server stores the Service object in **etcd**.

2. **kube-proxy Configures Traffic Routing**  
   - **kube-proxy** running on each node updates **iptables (Linux)** or **IPVS** rules to route traffic to the appropriate Pod IPs.
   - This allows traffic to be forwarded from the Service IP to backend Pods.

3. **Endpoints Object is Created**  
   - Kubernetes creates an **Endpoints** object, listing all Pod IPs that belong to this Service.
   - Whenever Pods change (scale up/down), this list updates automatically.

---

## **2. How kube-proxy Maintains Traffic Rules?**
- **kube-proxy runs on every node** and watches the Kubernetes API for new Services and Endpoints.
- It updates traffic rules based on the type of proxy mode:
  - **iptables mode (default)**  
    - It adds **NAT rules** so that traffic sent to a Service IP is redirected to a backend Pod.
  - **IPVS mode** (better performance for large clusters)  
    - It uses the Linux **IPVS (IP Virtual Server)** module to efficiently route packets.

### **Inspect kube-proxy Rules**
- Check iptables rules:
  ```bash
  sudo iptables -t nat -L -n -v
  ```
- Check IPVS rules:
  ```bash
  sudo ipvsadm -L -n
  ```

---

## **3. How DNS Maintains Records for Services and Pods?**
- **Kube-DNS or CoreDNS** (default in Kubernetes) provides service discovery.
- It creates **A records** (IPv4) or **AAAA records** (IPv6) in the DNS system.

### **Example DNS Entries**
1. **For a Service (`my-service` in `default` namespace)**
   ```
   my-service.default.svc.cluster.local → Service ClusterIP
   ```
2. **For a Pod (if headless service)**
   ```
   pod-ip-address.namespace.pod.cluster.local → Pod IP
   ```

### **Inspect DNS Records**
- Use `nslookup` or `dig` inside a Pod:
  ```bash
  nslookup my-service.default.svc.cluster.local
  ```
  or
  ```bash
  dig my-service.default.svc.cluster.local
  ```

- Query CoreDNS logs:
  ```bash
  kubectl logs -n kube-system -l k8s-app=kube-dns
  ```

---

### **Summary**
1. **When a Pod is created**, it gets an IP from CNI.
2. **When a Service is created**, kube-proxy updates iptables/IPVS rules.
3. **CoreDNS maintains DNS records** to resolve Service and Pod IPs.
4. **You can inspect** iptables, IPVS, and DNS records using `iptables`, `ipvsadm`, `nslookup`, or `kubectl logs`.

Let me know if you need a deeper dive! 🚀
