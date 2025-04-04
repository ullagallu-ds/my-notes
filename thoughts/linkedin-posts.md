# LinkedIn Posts

- What is nat how it is working
  - nat in aws
  - nat in docker
  - nat k8s 

- What is DNS how DNS works
 - DNS is custom bridge network
 - DNS in k8s

- ISO/OSI or TCP/IP model

- DRY principle implementation in DevOps
  - Jenkins Shared Libs
  - Terraform modules
  - Helm Charts
  - Ansible Modules


# Incident-1
Nice one, IN! 🔥 That’s a solid real-world example showing proactive security, automation, and governance. Here's how you could present it clearly and impactfully—either on your resume, in an interview, or in a project summary:

---

### 🔐 AWS Security Group Change Notification – POC Implementation

**Problem:**
- In an early phase of the project, unexpected downtime occurred because someone unintentionally modified a **Security Group rule**, which blocked access to the application.
- After deep debugging, we identified the root cause as an unauthorized change in **SG inbound/outbound rules**.

**Solution:**
- **Updated the Security Group rules** to restore access.
- Implemented an **automated monitoring and notification mechanism** to alert the team on any changes to SG configurations.

**Implementation Highlights:**
- Developed a **POC** to monitor changes across multiple AWS services using:
  - **AWS CloudTrail** to track Security Group API calls.
  - **Amazon EventBridge Rule** to filter specific events like `AuthorizeSecurityGroupIngress`, `RevokeSecurityGroupEgress`, etc.
  - **AWS Lambda** function to process the event and format the alert.
  - **SNS Topic** to notify DevSecOps/Infra teams in real-time.

**Preventive Governance:**
- Enforced a policy to **restrict console access** for critical infrastructure changes.
- All changes to Security Groups and other infrastructure components are now strictly managed via **Terraform (IaC)** to ensure auditability and prevent drift.
- No unauthorized SG rule changes since the enforcement.
- Improved infra governance, traceability, and change audit via version control.
- Reduced escalations and increased confidence from the security and app teams.

---

Would you like this reformatted for a resume bullet, a LinkedIn post, or a portfolio project write-up?