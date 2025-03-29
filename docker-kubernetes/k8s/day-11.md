# Kubernetes Scheduling Mechanisms: Detailed Notes and Examples

## 1. NodeSelector

### Concept:
NodeSelector is the simplest way to assign pods to specific nodes based on node labels. It's a field in the pod specification that specifies a map of key-value pairs that must match labels on the node.

### How it works:
1. Label your nodes with key-value pairs
2. Specify nodeSelector in your pod configuration with the same key-value pairs
3. Kubernetes scheduler will only place the pod on nodes that have all the specified labels

### Example:

**Step 1: Label a node**
```bash
kubectl label nodes <node-name> disktype=ssd
```

**Step 2: Create a pod with nodeSelector**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-ssd
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    disktype: ssd
```

### Practice Exercise:
1. Label two nodes with different environment types (dev/staging)
2. Create pods that should only run on "dev" environment nodes
3. Verify pod placement using `kubectl get pods -o wide`

## 2. Affinity & Anti-Affinity

### Concept:
Affinity and anti-affinity expand the types of constraints you can define for pod scheduling. They allow more expressive language for matching node labels and can specify "soft" preferences rather than hard requirements.

### Types:
1. **Node Affinity**: Similar to nodeSelector but more expressive
   - `requiredDuringSchedulingIgnoredDuringExecution`: Hard requirement
   - `preferredDuringSchedulingIgnoredDuringExecution`: Soft preference

2. **Pod Affinity/Anti-Affinity**: Schedule pods based on other pods' labels
   - Affinity: Place pods together (e.g., for locality)
   - Anti-Affinity: Keep pods apart (e.g., for high availability)

### Examples:

**Node Affinity Example:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: with-node-affinity
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: topology.kubernetes.io/zone
            operator: In
            values:
            - us-east-1a
            - us-east-1b
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: disktype
            operator: In
            values:
            - ssd
  containers:
  - name: nginx
    image: nginx
```

**Pod Anti-Affinity Example (Spread across zones):**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-server
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-store
  template:
    metadata:
      labels:
        app: web-store
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - web-store
            topologyKey: topology.kubernetes.io/zone
      containers:
      - name: web-app
        image: nginx
```

### Practice Exercises:
1. Create a deployment with pod anti-affinity to ensure pods don't run on the same node
2. Use node affinity to prefer nodes with specific CPU architecture
3. Combine node affinity and pod anti-affinity in a single deployment

## 3. Taints & Tolerations

### Concept:
Taints and tolerations work together to ensure pods are not scheduled onto inappropriate nodes. 

- **Taints**: Applied to nodes to repel pods
- **Tolerations**: Applied to pods to allow (but not require) scheduling on tainted nodes

### Key Operators:
- `Equal`: Value must match exactly
- `Exists`: Key must exist (value doesn't matter)
- No operator: Key must exist (legacy)

### Examples:

**Step 1: Taint a node**
```bash
kubectl taint nodes <node-name> key=value:NoSchedule
```

**Step 2: Create a pod with toleration**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: nginx
    image: nginx
  tolerations:
  - key: "key"
    operator: "Equal"
    value: "value"
    effect: "NoSchedule"
```

### Common Use Cases:
1. Dedicated nodes: `kubectl taint nodes dedicated=special:NoSchedule`
2. Nodes with special hardware: `kubectl taint nodes gpu=true:NoSchedule`
3. Node maintenance: `kubectl taint nodes node1 maintenance=yes:NoExecute`

### Practice Exercises:
1. Taint a node with `environment=test:NoSchedule`
2. Create a pod that tolerates this taint
3. Create another pod without toleration and verify it's not scheduled on the tainted node
4. Experiment with different effects (`NoSchedule`, `PreferNoSchedule`, `NoExecute`)

## Comparison Table

| Feature           | NodeSelector | Affinity/Anti-Affinity | Taints/Tolerations |
|-------------------|--------------|------------------------|--------------------|
| Purpose           | Simple node selection | Complex scheduling rules | Node repelling |
| Flexibility       | Low (exact match) | High (multiple operators) | Medium |
| Soft/Hard rules   | Hard only | Both soft and hard | Hard only |
| Based on          | Node labels | Node/pod labels | Node taints |
| Direction         | Pod → Node | Pod → Node/Pod | Node → Pod |

## Advanced Practice Scenario:

**Scenario**: Create a cluster with:
- 3 nodes labeled with `environment=production` and `hardware=general`
- 1 specialized node labeled with `hardware=gpu` and tainted with `gpu=true:NoSchedule`
- 1 maintenance node tainted with `maintenance=yes:NoExecute`

**Tasks**:
1. Create a deployment that:
   - Prefers production environment nodes
   - Avoids having more than one pod per zone (use topologyKey: topology.kubernetes.io/zone)
   - Has 3 replicas
2. Create a GPU workload that tolerates the GPU taint
3. Drain the maintenance node and observe pod rescheduling

**Solution Hints**:

1. For the production deployment:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: production-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: production-app
  template:
    metadata:
      labels:
        app: production-app
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            preference:
              matchExpressions:
              - key: environment
                operator: In
                values:
                - production
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - production-app
            topologyKey: topology.kubernetes.io/zone
      containers:
      - name: app
        image: nginx
```

2. For the GPU workload:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gpu-app
spec:
  containers:
  - name: gpu-app
    image: nvidia/cuda
  tolerations:
  - key: "gpu"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
  nodeSelector:
    hardware: gpu
```

3. For maintenance:
```bash
kubectl taint nodes <maintenance-node> maintenance=yes:NoExecute
kubectl get pods -o wide # Observe pods being rescheduled
```

These concepts are fundamental for advanced Kubernetes scheduling and workload placement. Practice with different combinations to fully understand their interactions and use cases.