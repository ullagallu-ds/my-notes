# ClusterAutoScaler and Karpenter
**CA**
- It creates ASG Behind Scenes it has MAX,MIN,DESIRED
- NodeGroup means collections of EC2 insances
- Limitations with CA
  - Fixed instance type while creating CA

For example

App1 requires 1 cpu and 4GB RAM
App2 requires 1 cpu and 4GB RAM
App3 requires 2 cpu and 4GB RAM


EKS Control Plane with Multiple Node Groups for example
 - NG1 with instance type t3a.xlarge with MIN,MAX and Desired Capacity
 - NG2 with instance type M5.xlarge with MIN,MAX and Desired Capacity
 - NG3 with instance type C.xlarge with MIN,MAX and Desired Capacity

**Karpenter**
provision and deprovision on demand

- NodeClass have
  - ami
- NodePool
  - specify the instance types
  - Nodes
  - budgets
  - limit,cpu,memeory
  - instance catagory


M6i large for 3 yrs reserve