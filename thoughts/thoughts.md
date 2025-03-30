- migrating IRSA to Pod Identity



Your explanation is good! I'll refine it slightly for better clarity and technical accuracy:  

---

### **Understanding Linux Processes and Containers**  

- A **Linux process** is the running state of a program. When a program is loaded into memory, it gets assigned CPU resources to execute.  
- By default, Linux processes share the same **storage, network, and system resources**.  

#### **Containers & Their Relationship with Processes**  
- A **container** is a running instance of an image, and it operates as a process in the Linux system.  
- Unlike regular processes, **containers are isolated environments** that behave like independent machines.  
- Each container has its own:  
  - **Process space** (isolated process tree)  
  - **Network stack** (separate IP, interfaces, ports)  
  - **Hostname** (unique identity within its namespace)  
  - **Filesystem** (own root filesystem, separate from the host)  
  - **IPC (Inter-Process Communication) namespace** (avoiding interference between containers)  
  - **Resource control** (restricting CPU, memory, and I/O usage)  

#### **Key Kernel Features for Containerization**  
1. **Namespaces** – Provide isolation for containers, ensuring they don’t interfere with each other or the host.  
2. **cGroups (Control Groups)** – Control resource consumption like CPU, memory, and I/O, preventing a single container from consuming excessive system resources.  

---

This version keeps your original thought process but makes it clearer and more structured. Let me know if you want any refinements! 🚀



















































📋 Round 1: Online Assessment (At the Office)
The initial round was an online assessment of multiple choice and multiple selection questions. It covered:
▪️Linux Commands and scripting
▪️Network Security & Protocols
▪️Git Development Strategies
▪️Deployment & Rollout Strategies

💻 Round 2: Technical Interview - 1

Key Questions Asked:
🔹Introduce yourself.
🔹What is a Kubernetes Operator?
🔹What is a Custom Resource Definition (CRD)?
🔹What is a Custom Controller?
🔹Explain Operator architecture and how it works.
🔹What are API groups in Kubernetes?
🔹What is etcd?
🔹Explain the OSI model layers and their significance.
🔹What’s the difference between HTTP and HTTPS?
🔹What is DNS?
🔹What happens when you hit www.hashedin.com in a browser?
🔹What is recursive DNS?
🔹Explain Git lifecycle from cloning a repo to pushing code.
🔹What is Git architecture?
🔹What is a kernel? Is Linux an OS or a kernel?
🔹Write ten Linux commands and explain their usage.
🔹Difference between virtualization and containerization.
🔹Which Linux features help Docker work?
🔹What is Docker daemon?
🔹Explain Docker architecture & lifecycle.
🔹Write five Docker commands and explain them.
🔹Write a Jenkins pipeline that builds and pushes a Docker image.
🔹What are namespaces in Kubernetes?
🔹Write a Pod specification YAML file for an NGINX server.
🔹What is VPC in AWS?
🔹Difference between public and private subnets.
🔹What are NAT Gateway and Internet Gateway?
🔹Can a NAT Gateway be created inside a private subnet?
🔹How do instances in private subnets access the internet?
🔹Write and explain Terraform lifecycle commands.
🔹What is a state file in Terraform?
🔹How to manage state files in team collaboration?

💻 Round 3: Technical Interview – 2

Key Questions:
🔸Write a simple Dockerfile to create a Docker image.
🔸Explain Docker workflow.
🔸Why is it essential to make etcd highly available in Kubernetes?
🔸What happens when you hit a website URL?
🔸What is an SSL certificate?
🔸Explain the role of NAT in AWS.
🔸Difference between S3 buckets and EBS volumes.
🔸Amazon AMI vs Snapshot—what’s the difference?
🔸Explain remote state locking in Terraform.
🔸Difference between MySQL and MongoDB.
🔸What is a relational database?
🔸what’s a primary key in SQL?

💬 Round 4: Fitment Round

Key Questions:
• Do you prefer working in a team or individually?
• What does work-life balance mean to you?
• How should an ideal manager support their team?
• Work from home or office—what’s your preference?
• Tell me about your family background.
• Why do you want to join HashedIn?
• If offered a higher package from another MNC, would you still choose HashedIn?
• What’s your favorite game and preferred place in it?



🔹 Challenge 1: Write a simple Bash script that prints “Hello DevOps” along with the current date and time.
🔹 Challenge 2: Create a script that checks if a website (e.g., https://www.learnxops.com) is reachable using curl or ping. Print a success or failure message.
🔹 Challenge 3: Write a script that takes a filename as an argument, checks if it exists, and prints the content of the file accordingly.
🔹 Challenge 4: Create a script that lists all running processes and writes the output to a file named process_list.txt.
🔹 Challenge 5: Write a script that installs multiple packages at once (e.g., git, vim, curl). The script should check if each package is already installed before attempting installation.
🔹 Challenge 6: Create a script that monitors CPU and memory usage every 5 seconds and logs the results to a file.
🔹 Challenge 7: Write a script that automatically deletes log files older than 7 days from /var/log.
🔹 Challenge 8: Automate user account creation – Write a script that takes the username as an argument, checks, if the user exists, gives the message “user already exists“ else creates a new user, adds it to a “devops“ group, and sets up a default home directory.
🔹 Challenge 9: Use awk or sed in a script to process a log file and extract only error messages.
🔹 Challenge 10: Set up a cron job that runs a script to back up (zip/tar) a directory daily.
💡 Bonus Challenge: Customize your Bash prompt to display the current user and working directory. (Hint: export PS1="\u@\h:\w\$ "), try to make it permanent, so terminal closing and opening don’t default!




1.Can you walk us through your experience as a DevOps Engineer? 
2.What has been your biggest challenge in DevOps, and how did you handle it? 3.What DevOps tools have you used for CI/CD pipeline automation? Can you describe how you set up a pipeline? 
4.Have you worked with GitOps? Can you explain how it differs from traditional CI/CD? 
5.How do you manage pipeline security and ensure compliance with DevSecOps best practices? 
6.Have you used GitHub Actions? Can you describe a complex automation workflow you implemented? 
7.How do you deploy and manage Kubernetes clusters in a production environment?
 8.What challenges have you faced with Kubernetes deployments, and how did you troubleshoot them? 
9.How do you handle Docker container security in a DevOps pipeline? 
10.Can you explain the use of ArgoCD or Flux in an automated deployment setup?
11.Can you explain how you automate infrastructure provisioning using Terraform or Ansible?
12.How do you ensure IaC scripts remain maintainable and do not introduce vulnerabilities?
13.What experience do you have with AWS cloud technologies?
14.How do you manage multi-cloud (AWS & Azure) deployments effectively?
15.How do you optimize cloud costs while ensuring performance?
16.Have you developed applications using Java or Quarkus?
17.Can you explain the differences between RESTful APIs and GraphQL?
18.How do you handle authentication and security in API development?
19.What best practices do you follow for PostgreSQL database performance tuning?
20.Can you describe a critical production issue you encountered and how you resolved it?
21.How do you handle Incident Management (IM) and Critical Incident Management (CIM)?
22.What strategies do you use to reduce system downtime?
23.How do you approach Problem Management (PM) and Change Management (CM)?
24.What are the best practices you follow for securing applications and cloud infrastructure?
25.Have you worked with ITIL operation processes (Incident, Problem, Change management)?
26.How do you ensure compliance with industry security standards?
27.How do you integrate security scanning in CI/CD pipelines?
28.Have you worked in an Agile environment? How do you handle rapid changes in requirements?
29.How do you balance technical priorities vs. business needs?
30.How do you manage cross-functional collaboration in a DevOps team?
31.How do you handle conflict resolution within a team?
32.Have you worked with microservices architecture? How do you manage service communication and security?
33.Do you have experience with Nagios or other monitoring tools?
34.Can you describe a time when you had to mediate a dispute between team members?



       How would you design a highly available, fault-tolerant, and scalable architecture on AWS for a production workload?
·       What are the key differences between AWS ECS, EKS, and Fargate? When would you choose one over the other?
·       How do you optimize AWS costs in a DevOps environment?
·       What is AWS Landing Zone, and how would you use it for multi-account governance?
·       How do you handle secret management in AWS while ensuring security and compliance?
·       How do you ensure high availability in a Kubernetes cluster?
·       What are the different ways to perform zero-downtime deployments in Kubernetes?
·       How do you debug pod failures in Kubernetes? Walk me through a troubleshooting process.
·       What are Kubernetes Operators, and how are they different from Helm charts?
·       How do you handle persistent storage in Kubernetes, and what are the key considerations for stateful applications?
·       How does Terraform’s state management work? How do you handle state locking in a team environment?
·       What are Terraform modules, and how do they help in infrastructure automation?
·       How do you enforce security best practices in Terraform?
·       Explain how Terraform workspaces help in managing multiple environments.
·       What are the key differences between Terraform and AWS CloudFormation?
·       How would you design a GitLab CI/CD pipeline for a microservices application?
·       How do you handle rollback mechanisms in a CI/CD pipeline?
·       What is canary deployment vs. blue-green deployment? Which would you choose in a Kubernetes setup?
·       How do you implement dynamic environment provisioning in CI/CD pipelines using Terraform?
·       What are self-hosted vs. cloud-managed runners in GitLab CI/CD, and when should you use each?
·       How do you implement IAM roles and policies in AWS to follow the principle of least privilege?
·       What security measures do you take to protect CI/CD pipelines?
·       How do you secure Kubernetes clusters from external threats?
·       How do you implement AWS Config rules and AWS Security Hub for continuous compliance monitoring?
·       How do you manage vulnerability scanning in containerized environments?
·       How do you set up observability for microservices running on Kubernetes?
·       What are the differences between Prometheus and CloudWatch for monitoring?
·       How do you handle log aggregation across multiple cloud accounts?
·       How do you set up proactive alerting for potential failures in a production environment?




Interviewer: "A pod is not terminating. What could be the issue, and how would you troubleshoot it?"
me: "First, I’d check the pod’s status using kubectl get pods. If it's stuck in the Terminating state, there could be a few reasons—like finalizers, stuck volumes, or a container that isn’t shutting down properly."

Interviewer: "Okay, how would you dig deeper?"
me: "I’d describe the pod with kubectl describe pod <pod-name> to look at events and see if Kubernetes is waiting on something, like a volume detachment. I’d also check logs with kubectl logs <pod-name> --all-containers to see if a process inside the container is hanging."

Interviewer: "What if it's still not terminating?"
me: "I’d check for finalizers using kubectl get pod <pod-name> -o json | jq '.metadata.finalizers'. If a finalizer is preventing deletion, I’d manually remove it with a patch. If it’s a deployment-managed pod, I’d scale down the deployment to avoid automatic restarts."

Interviewer: "What about force deletion?"
me: "If nothing else works, I’d use kubectl delete pod <pod-name> --force --grace-period=0, but only as a last resort since it bypasses graceful shutdown mechanisms. Before doing that, I'd ensure there are no dependencies like a mounted volume that could cause issues."

Key Takeaway:

 The key takeaway is to demonstrate a structured, systematic approach while being technically sound and efficient in troubleshooting."