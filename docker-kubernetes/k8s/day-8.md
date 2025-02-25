# Security[EKS][Admin-Activity]
- ServiceAccount
- RBAC
- Exercise[IRSA]
- Network polycies

# Service Account  
A ServiceAccount in Kubernetes provides an identity for pods to interact with the Kubernetes API securely. Each pod uses a service account to authenticate when making API requests within the cluster.  

1. **Default Service Account**  
   - Every namespace has a default service account named `default`.  
   - If no service account is specified in a pod, it automatically uses the default one.  
   - The token of the service account is automatically mounted inside the pod at `/var/run/secrets/kubernetes.io/serviceaccount/`.  

2. **Creating a Custom Service Account**  

   Step 1: Define a ServiceAccount  
   ```yaml
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: my-service-account
     namespace: default
   ```  
   Apply it using:  
   ```sh
   kubectl apply -f service-account.yaml
   ```  

   Step 2: Assign the ServiceAccount to a Pod  
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: my-pod
   spec:
     serviceAccountName: my-service-account
     containers:
       - name: my-container
         image: nginx
   ```  

3. **Checking Service Accounts**  
   List service accounts in a namespace:  
   ```sh
   kubectl get serviceaccounts -n default
   ```  
   Describe a specific service account:  
   ```sh
   kubectl describe serviceaccount my-service-account -n default
   ```  

4. **Use Cases of Service Accounts**  
   - Grant specific permissions using RBAC (Role-Based Access Control).  
   - Secure pod-to-API communication within the cluster.  
   - Prevent excessive access by limiting API privileges.  

# RBAC
### RBAC in Kubernetes  

RBAC (Role-Based Access Control) controls access to Kubernetes resources by defining roles and permissions for users, groups, and service accounts.  

#### Role  
A **Role** grants permissions within a **specific namespace**.  

Example: Role allowing read access to pods in the default namespace  
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: default
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
```

#### RoleBinding  
A **RoleBinding** assigns a **Role** to a user, group, or service account within a **namespace**.  

Example: Binding the Role to a ServiceAccount  
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: default
subjects:
  - kind: ServiceAccount
    name: my-service-account
    namespace: default
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

#### ClusterRole  
A **ClusterRole** grants permissions **cluster-wide** or for non-namespaced resources like nodes.  

Example: ClusterRole allowing read access to all pods  
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-pod-reader
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
```

#### ClusterRoleBinding  
A **ClusterRoleBinding** assigns a **ClusterRole** to a user, group, or service account across **all namespaces**.  

Example: Binding the ClusterRole to a ServiceAccount  
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-pod-reader-binding
subjects:
  - kind: ServiceAccount
    name: my-service-account
    namespace: default
roleRef:
  kind: ClusterRole
  name: cluster-pod-reader
  apiGroup: rbac.authorization.k8s.io
```

#### Key Differences  

| Feature | Role | RoleBinding | ClusterRole | ClusterRoleBinding |
|---------|------|------------|-------------|--------------------|
| Scope | Single Namespace | Single Namespace | Cluster-wide | Cluster-wide |
| Grants Permissions to | Resources in a Namespace | Users, Groups, or ServiceAccounts | Resources across all Namespaces | Users, Groups, or ServiceAccounts across all Namespaces |
| Works with | RoleBinding | Role | ClusterRoleBinding | ClusterRole |
