# Elastic Compute Cloud (EC2)

Amazon EC2 is a compute service offering different types of machines to deploy workloads. It is scalable, highly available, and provides flexible pricing options.

## Features
- **Pay-as-you-go** model, no upfront payment required
- **Instance variety:** General-purpose, Memory-optimized, Compute-optimized, Storage-optimized, GPU-based, FPGA-based
- **Secure** using security groups (SG) and key pairs
- **Easily integrates** with other AWS services
- **Amazon Linux** is preferred for better AWS integration

## Instance Types
1. **General Purpose** - Balanced CPU, memory, and network resources
2. **Memory Optimized** - Best for memory-intensive workloads
3. **Compute Optimized** - Best for compute-intensive applications
4. **Storage Optimized** - Best for large-scale storage workloads
5. **GPU Instances** - Designed for graphics and ML workloads
6. **FPGA Instances** - Custom hardware acceleration

## Status Checks
1. **System Status Check** - Issues with AWS infrastructure
2. **Instance Status Check** - Issues inside the EC2 instance
3. **EBS Volume Status Check** - Checks the health of attached storage

If status checks fail, restarting the instance may help.

## Elastic IP (EIP)
- Public IPs change on restart; an **Elastic IP (EIP)** is a **static IP** that remains the same.
- Useful for instances requiring a fixed IP address.

## EC2 Pricing Models

1. **Spot Instances**
   - **Description:** Unused EC2 capacity at a discounted rate
   - **Use cases:** Batch processing, fault-tolerant workloads

2. **On-Demand Instances**
   - **Description:** Pay for what you use, no long-term commitment
   - **Use cases:** Short-term applications, unpredictable workloads

3. **Savings Plans**
   - **Description:** Commit to consistent usage for cost savings
   - **Use cases:** Steady workloads, long-term projects

4. **Reserved Instances (RIs)**
   - **Description:** Discounted pricing for a 1- or 3-year term
   - **Use cases:** Predictable workloads requiring long-term commitment

5. **Dedicated Hosts**
   - **Description:** Physical servers dedicated to your use
   - **Use cases:** Compliance, software licensing

6. **Scheduled Instances**
   - **Description:** Run instances on a defined schedule
   - **Use cases:** Workloads that run periodically

7. **Capacity Reservation**
   - **Description:** Reserves compute capacity for future use
   - **Use cases:** Mission-critical applications needing guaranteed availability

## Preferred Pricing Models
- **On-Demand** for flexibility
- **Savings Plans** for cost optimization

## AWS Support: Key Pair Lost
- If the key pair is lost, access to the EC2 instance may be difficult.
- Solution:
  - Use another key pair if previously added.
  - Stop the instance, detach the root volume, attach it to another instance, add a new key pair, and reattach the volume.
  - Contact AWS Support for recovery assistance.

