### **AWS Networking Troubleshooting Guide 🚀**  

Troubleshooting AWS networking issues usually falls into **four main areas**:  

1️⃣ **Connectivity Issues (VPC, Security Groups, NACLs, IGW, NAT Gateway)**  
2️⃣ **DNS & Routing Issues (Route 53, Route Tables, Load Balancers)**  
3️⃣ **Load Balancer Issues (ALB/NLB Target Health, Response Codes)**  
4️⃣ **CloudFront & CDN Issues (Caching, Origin Connectivity, SSL/TLS)**  

---

### **1️⃣ Connectivity Issues (VPC, Security Groups, NACLs, IGW, NAT Gateway)**  

| Issue | Troubleshooting Steps | Fix |
|--------|----------------|------|
| **EC2 Instance Cannot Connect to the Internet** | ✅ Check if the instance is in a **Public Subnet** (Should have an IGW) <br> ✅ Run `curl ifconfig.me` inside EC2 to check if it has a public IP <br> ✅ Check if **Security Groups & NACLs** allow outbound traffic | 🔹 Assign an **Elastic IP (EIP)** <br> 🔹 Attach an **Internet Gateway (IGW)** <br> 🔹 Modify **Security Group & NACLs** |
| **Private Subnet EC2 Cannot Reach the Internet** | ✅ Check if **NAT Gateway** is configured in a Public Subnet <br> ✅ Ensure Route Table has `0.0.0.0/0 -> NAT Gateway` | 🔹 Add a **NAT Gateway** in a Public Subnet <br> 🔹 Update **Route Table** |
| **Inter-Subnet Communication Fails** | ✅ Check **Security Groups** (`allow ALL between instances`) <br> ✅ Check **NACLs** (Make sure both Inbound & Outbound rules allow traffic) <br> ✅ Run `telnet <target-IP> <port>` | 🔹 Modify **Security Group & NACL rules** <br> 🔹 Ensure **route table has correct entries** |

---

### **2️⃣ DNS & Routing Issues (Route 53, Route Tables, Load Balancers)**  

| Issue | Troubleshooting Steps | Fix |
|--------|----------------|------|
| **Domain Name Not Resolving** | ✅ Run `dig <domain>` / `nslookup <domain>` <br> ✅ Check **Route 53 DNS Records** (A, CNAME) <br> ✅ Run `curl -I <domain>` to check response | 🔹 Update **Route 53 DNS records** <br> 🔹 Check if **TTL (Time to Live) is too high** |
| **EC2 Cannot Resolve a Domain (DNS Issue)** | ✅ Run `cat /etc/resolv.conf` to check if it's using **Amazon DNS** <br> ✅ Test with `nslookup google.com` | 🔹 Use **AWS DNS (VPC Resolver: 169.254.169.253)** <br> 🔹 If using a custom DNS, ensure it's configured in **DHCP Options** |
| **Route Table Issues (Instance Cannot Reach Another VPC)** | ✅ Run `ip route show` inside instance <br> ✅ Check **Route Tables** (`aws ec2 describe-route-tables`) | 🔹 Add a **VPC Peering** or **Transit Gateway Route** |

---

### **3️⃣ Load Balancer Issues (ALB/NLB Target Health, Response Codes)**  

| Issue | Troubleshooting Steps | Fix |
|--------|----------------|------|
| **ALB Returns 503 Service Unavailable** | ✅ Run `aws elbv2 describe-target-health` <br> ✅ Check **Target Group Health Checks** <br> ✅ Verify if backend service is running (`curl http://localhost:port`) | 🔹 Ensure backend service is **listening on the correct port** <br> 🔹 Update **Health Check Path** (`/healthz` instead of `/`) |
| **ALB Returns 502 Bad Gateway** | ✅ Check **EC2 logs (`journalctl -u nginx` or `docker logs`)** <br> ✅ Run `curl -v <backend-IP>:<port>` | 🔹 Restart **backend service** <br> 🔹 Ensure **Security Groups allow traffic** |
| **NLB Not Forwarding TCP/UDP Traffic** | ✅ Run `nc -zv <NLB-IP> <port>` <br> ✅ Check **Target Group Protocol (TCP/UDP)** | 🔹 Use **TCP instead of HTTP** for NLB <br> 🔹 Verify **backend application supports UDP if using UDP mode** |

---

### **4️⃣ CloudFront & CDN Issues (Caching, Origin Connectivity, SSL/TLS)**  

| Issue | Troubleshooting Steps | Fix |
|--------|----------------|------|
| **CloudFront Shows "403 Forbidden"** | ✅ Run `curl -I https://<cloudfront-url>` <br> ✅ Check **S3 Bucket Policy** (Should allow CloudFront) | 🔹 Update **S3 Bucket Policy to allow CloudFront OAC** <br> 🔹 Ensure **CloudFront Distribution settings match Origin** |
| **CloudFront Not Updating Cached Content** | ✅ Run `aws cloudfront create-invalidation --distribution-id <id> --paths "/*"` | 🔹 Use **"Cache-Control: no-cache" in HTTP headers** <br> 🔹 Invalidate cache in **CloudFront** |
| **SSL/TLS Certificate Errors** | ✅ Run `openssl s_client -connect <domain>:443` <br> ✅ Check **ACM Certificate Status** | 🔹 Attach a **valid SSL certificate in ACM** <br> 🔹 Use **CloudFront HTTPS Redirect** |

---

### **Summary of AWS Network Debugging Commands**  

| Command | Purpose |
|---------|---------|
| `ping <IP>` | Check if a host is reachable |
| `telnet <IP> <port>` | Check if a port is open |
| `traceroute <IP>` / `mtr <IP>` | Check network path |
| `dig <domain>` / `nslookup <domain>` | DNS resolution check |
| `curl -I <URL>` / `wget <URL>` | Check HTTP response |
| `nc -zv <host> <port>` | Check open ports |
| `ip a` / `ifconfig` | Check IP configuration |
| `netstat -tulnp` / `ss -tulnp` | Check listening ports |
| `aws ec2 describe-instances` | Get instance details |
| `aws ec2 describe-route-tables` | View Route Table info |
| `aws elbv2 describe-target-health` | Check Load Balancer target health |
| `aws cloudfront create-invalidation` | Invalidate CloudFront cache |

---

### **Final Thoughts**  
✅ **Master AWS Security Groups, NACLs, Route Tables, and Load Balancers**  
✅ **Use AWS CLI for fast troubleshooting**  
✅ **Test connectivity step-by-step (Layered approach: Network → Security → Application)**  
✅ **Automate monitoring & alerts using CloudWatch & AWS Network Firewall**  

This should help you **troubleshoot AWS networking like a pro**! Let me know if you want **detailed examples on any specific issue**. 🚀