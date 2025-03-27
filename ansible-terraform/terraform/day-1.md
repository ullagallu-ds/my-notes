## **Infrastructure as Code (IaC)**  
To host our applications, we need infrastructure like **network, compute, storage, databases, load balancers, and auto scaling groups (ASG)**.  
### **Why manually creating infrastructure is not ideal?**  
Manually setting up all these components has several disadvantages:  
- **Time-consuming** – Setting up infrastructure manually takes a lot of effort.  
- **Prone to errors** – Human mistakes can lead to misconfigurations.  
- **No consistency across environments** – Recreating the same infrastructure for different environments (dev, staging, prod) is difficult.
- Creating resources manually one by one is time-consuming and requires handling dependencies manually.
- **No tracking facility** – Hard to audit **who made what changes**.  
- **Lack of inventory management** – No easy way to keep track of created resources.  
- **No version control for infrastructure** – Cannot roll back changes or collaborate efficiently.  
### **Solution? Manage Infrastructure as Code (IaC)!**  
To solve all these issues, the industry came up with an idea – **why not manage our infrastructure as code?**  
### **Benefits of IaC:**  
✅ **Version Control System (VCS)** – Our infrastructure is stored as code, making it easy to track and manage changes.  
✅ **Consistency across environments** – We can easily **replicate** infrastructure across **dev, staging, and prod**.  
✅ **Change tracking** – Helps in identifying **who made what changes**.  
✅ **Avoids configuration drift** – Ensures infrastructure remains consistent.  
✅ **CRUD operations on the fly** – Infrastructure changes (Create, Update, Delete) can be done **quickly and efficiently**.  
✅ **Scalability** – Easily scale infrastructure as needed.  
---
## **Terraform – One of the Popular IaC Tools**  
🔹 **Uses HCL (HashiCorp Configuration Language)** to define infrastructure.  
🔹 **Maintains a state file** to track resources managed by Terraform.  
🔹 **Supports remote storage** for securing the state file.  
🔹 **Implements state locking** to **avoid parallel execution issues**.  
🔹 **Follows the DRY principle** using **modules** to **reuse infrastructure code** efficiently. 
Terraform automatically resolves internal dependencies between resources.
For external dependencies, we can use depends_on to manage resource creation order.
Terraform also creates resources in parallel, improving efficiency and reducing deployment time.
---