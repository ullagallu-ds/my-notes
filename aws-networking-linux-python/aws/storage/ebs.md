# Volume Terminologies

### IOPS
- Input/Output Operations Per Second
- Measures how many read/write operations a storage device can handle per second
- Important for workloads requiring high transaction rates

### Throughput
- Measures the amount of data transferred per second (MB/s)
- Crucial for applications needing large sequential data transfers

### Latency
- Time taken for a storage request to complete
- Lower latency results in faster response times

---

# Elastic Block Store (EBS)
EBS is a highly available, reliable, and scalable block storage service used with EC2 instances.

### Features
- Provides persistent storage for OS, applications, and databases
- AZ-level storage, meaning EC2 instances must be in the same AZ as the volume
- Supports encryption using AWS KMS
- Snapshots for backup, disaster recovery, and volume replication

### Volume Types
- **General Purpose (gp2, gp3)** – Balanced performance and cost
- **Provisioned IOPS (io1, io2)** – High-performance workloads
- **Cold HDD (sc1), Throughput Optimized HDD (st1)** – Cost-effective for large sequential workloads
- **Magnetic (deprecated)** – Legacy storage option

### Encryption
- Use AWS KMS to encrypt data at rest
- Snapshots of encrypted volumes remain encrypted
- Convert unencrypted volumes to encrypted by creating and copying snapshots

---

# Attaching an EBS Volume
1. Identify the new volume:
   ```bash
   lsblk
   ```
2. Check for an existing filesystem:
   ```bash
   sudo file -s /dev/xvdf
   ```
3. Format the volume (if needed):
   ```bash
   sudo mkfs -t xfs /dev/xvdf
   ```
4. Create a mount directory:
   ```bash
   mkdir /data
   ```
5. Mount the volume:
   ```bash
   mount /dev/xvdf /data
   ```
6. Retrieve the UUID:
   ```bash
   sudo blkid
   ```
7. Persist the mount in fstab:
   ```bash
   vim /etc/fstab
   ```
   Add the entry:
   ```bash
   UUID=<ID> /data xfs defaults,nofail 0 2
   ```
8. Unmount before detaching:
   ```bash
   umount /data
   ```
9. Stop the instance and detach the volume.

---

# Extending XFS Volumes
- Subsequent increases in volume size require a waiting period of **6 hours**

---

# Snapshots
- **Point-in-time backups** including all data, configurations, and settings
- Stored in **S3** as incremental backups (only changed blocks are saved)
- Essential for **backup, disaster recovery, and creating new volumes or AMIs**
- **AMI Creation:** Cannot copy AMIs directly; must first create a snapshot, copy it to the desired region, and then create an AMI from it

---

# Lifecycle Manager
- **Amazon Data Lifecycle Manager (DLM)** automates the creation, retention, and deletion of EBS snapshots
- Helps in managing snapshot lifecycles efficiently and reducing manual effort
- Policies can be defined for **automated backups, retention, and deletion**
- Useful for enforcing compliance, cost savings, and disaster recovery
- Supports **cross-region copy of snapshots** for additional redundancy
- Policies can be configured via **AWS Console, CLI, or API**

---

### AMI (Amazon Machine Image)
- AMI is a pre-configured image that contains the OS, application software, and configurations needed to launch EC2 instances.
- It acts as a **blueprint** for launching new instances with the same settings.
- Includes:
  - **Root volume** (OS and software)
  - **Launch permissions** (Who can use the AMI)
  - **Block device mappings** (Defines attached volumes)

#### AMI Types:
1. **Public AMIs** – Available for anyone in AWS Marketplace.
2. **Private AMIs** – Created and used within an AWS account.
3. **AWS Marketplace AMIs** – Paid and free AMIs provided by vendors.
4. **Custom AMIs** – Created from an existing instance or snapshot.

#### AMI Lifecycle:
1. Create an AMI from an existing EC2 instance.
2. Copy AMI across AWS regions.
3. Share AMI with other AWS accounts.
4. Deregister AMI if it's no longer needed.

---

### AMI Catalog
- AMI Catalog is a collection of AMIs available in AWS Marketplace.
- Includes AMIs from AWS, third-party vendors, and community-contributed images.
- Can be filtered by OS, architecture, software packages, and security features.
- Helps users select pre-configured AMIs for different workloads like web hosting, databases, and machine learning.