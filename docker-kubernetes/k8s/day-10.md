# **1️⃣ Service Account**
### **What is a Service Account?**
- A **Service Account** in Kubernetes is used for **authentication** when pods interact with the **Kubernetes API server**.  
- Every pod in Kubernetes runs under a **default ServiceAccount** unless explicitly specified.

---

### **Why Use a Service Account?**
✅ To **authenticate** workloads inside the cluster.  
✅ To **assign permissions** using **RBAC (Role-Based Access Control)**.  
✅ To securely allow pods to **access Kubernetes API resources**.  

---

### **Types of Service Accounts**
1. **Default Service Account** – Assigned automatically to every pod.  
2. **Custom Service Account** – Created manually for specific workloads with restricted access.  

---

### **Example: Create a Custom Service Account**
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: custom-sa
  namespace: default
```
🔹 This creates a ServiceAccount named **`custom-sa`** in the `default` namespace.  

---

### **Lab: Assign Service Account to a Pod**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  serviceAccountName: custom-sa
  containers:
    - name: my-container
      image: nginx
```
🔹 This pod will use `custom-sa` instead of the default ServiceAccount.  

---

### **List Service Accounts**
```sh
kubectl get serviceaccounts
kubectl get serviceaccount custom-sa -o yaml
```

---

### **Service Account Token**
- Each ServiceAccount gets a **token** stored as a **Kubernetes Secret**.  
- Pods use this token to authenticate with the **Kubernetes API server**.

```sh
kubectl get secret
```

---

# **2️⃣ RBAC (Role-Based Access Control)**
### **What is RBAC?**
- RBAC **controls access** to Kubernetes resources **based on roles and permissions**.  
- Uses **Roles, RoleBindings, ClusterRoles, and ClusterRoleBindings**.

---

### **RBAC Components**
| Component | Description |
|-----------|-------------|
| **Role** | Defines permissions **within a namespace** |
| **ClusterRole** | Defines permissions **cluster-wide** |
| **RoleBinding** | Assigns a **Role** to a user or ServiceAccount **in a namespace** |
| **ClusterRoleBinding** | Assigns a **ClusterRole** to a user or ServiceAccount **cluster-wide** |

---

### **Example: Create a Role (Namespace-Specific)**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: default
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list"]
```
🔹 This **Role** allows reading pods in the **default namespace**.  

---

### **Example: Bind Role to a Service Account**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: default
subjects:
  - kind: ServiceAccount
    name: custom-sa
    namespace: default
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```
🔹 This **binds the `pod-reader` Role** to the **`custom-sa` ServiceAccount**.  

---

### **Lab: Test RBAC Permissions**
```sh
kubectl auth can-i get pods --as=system:serviceaccount:default:custom-sa
```
✅ Expected output: **yes** (if RBAC is correct).  

---

### **Example: ClusterRole for Cluster-Wide Access**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-pod-reader
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list"]
```
🔹 This **ClusterRole** allows reading pods **across all namespaces**.  

---

### **Example: ClusterRoleBinding**
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-pod-reader-binding
subjects:
  - kind: ServiceAccount
    name: custom-sa
    namespace: default
roleRef:
  kind: ClusterRole
  name: cluster-pod-reader
  apiGroup: rbac.authorization.k8s.io
```
🔹 This **binds the ClusterRole to the ServiceAccount**.  

---

# **3️⃣ Network Policies**
### **What is a Network Policy?**
- **Network Policies** control **ingress (incoming) and egress (outgoing) traffic** for pods in Kubernetes.  
- By default, all pods **can communicate freely** unless a Network Policy is applied.  

---

### **Why Use Network Policies?**
✅ To **restrict** pod-to-pod communication.  
✅ To allow only **specific ingress/egress traffic**.  
✅ To enhance **security** in multi-tenant environments.  

---

### **Example: Allow Traffic Only from a Specific Namespace**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: backend
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              role: frontend
      ports:
        - protocol: TCP
          port: 80
```
🔹 This **allows traffic** to `backend` pods **only from the frontend namespace**.  

---

### **Example: Allow Only Internal Communication**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-external
  namespace: default
spec:
  podSelector: {}
  ingress:
    - from:
        - podSelector: {}
```
🔹 This **blocks all external traffic** and allows **only internal pod communication**.  

---

### **Example: Allow Egress to a Specific IP**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-egress-to-db
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: backend
  egress:
    - to:
        - ipBlock:
            cidr: 192.168.1.0/24
```
🔹 This **allows backend pods to communicate only with `192.168.1.0/24`**.  

---

### **Lab: Apply and Test Network Policy**
#### **1️⃣ Create a Backend Pod**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: backend
  labels:
    app: backend
spec:
  containers:
    - name: nginx
      image: nginx
```
#### **2️⃣ Create a Frontend Pod**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  labels:
    app: frontend
spec:
  containers:
    - name: curl
      image: curlimages/curl
      command: ["/bin/sh", "-c", "sleep 3600"]
```
#### **3️⃣ Test Connectivity**
```sh
kubectl exec frontend -- curl http://backend
```
✅ If unrestricted, the request should succeed.  
❌ If a NetworkPolicy is applied, the request may **fail**.  

---

# **Summary**
| Feature | Purpose |
|---------|---------|
| **Service Account** | Provides authentication for pods |
| **RBAC** | Controls access to Kubernetes resources |
| **Network Policies** | Restrict pod communication |

💡 **Next Steps:**  
- **Practice Labs** by deploying **RBAC, ServiceAccounts, and Network Policies** in a real Kubernetes cluster.  
- **Test permissions and connectivity** using `kubectl auth can-i` and `curl`.  

🚀 **Let me know if you need more details!**