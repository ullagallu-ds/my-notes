# DevOps and DevSecOps
### Generic DevOps process
Devops has made it possible to develop applications fast quicker time aligning development,building,testing and ops how ever the most cases how ever the security is not part of this process and thus becoming vulnerable threats and bugs 

DevOpsSecops means integrating[incorporate] security in each and every phase of devops pratices right from development to ops

collaboeative environment between developmet and testing and ops

In Typical DevOps process security was added towards the end let's imagine a sceraio where we find vulenrabilites in prod again we need to run entire devops again for single sql injection vulnerability this involves  cost, high risk, again do new deployments in each in every environment this where industry comes with an solutions i.e why con't we implement security before deployment move the secirty into early stages it's reduce improve the resoure utilization and al the things embedding security with in the same pipeline

In simple words instead of implementing security and finding vulnerability in prod we just find vulnerabilities before the deployment by improve efficieny of app and reduce the oerational cost and low risk  

DevOps = faster the applications releases by automating entire build and test and deployment process
DevSecOps = By implementing security by align multiple security tools in CI/CD pipeline we find vulnerables and bugs at early stages it reduce the operational cost and risk [identifying issues at early stages means before deploy the app]

It's all about move securty from right[prod] to left[pipelines][SDLC-lifecycle]

1. Configuration Governance = don't expose sensitve data to sournce code management system
2. Static Code Analysis = know the code quality,code coverage ,code smells,code duplication
3. Dependency Scanning = Inorder findout any outdated dependencys and what type of vulnerabilities dependnecies have
4. Image Scanning = Scan the images which are downloading from docker because you don't who build the image 
5. Runtime Security  = monitor application and cluster for any abnormal new exploits and cves come out every day 
6. Dynamic Application Security testing = to secure API interfaces all microservice are interact with API's 

We need to run these tests continously to findout new issues and mitigate them 

- create ec2 instance[t3a.xlarge with 100GB]
- install docker ,kubeadm,java 8,Jenkins, Install jq,jc,pip3

github.com/sidd-harth/devsecops-k8s-demo

Jenkins is a opensource automation tool which uses plugins to build & test your project code continuously 

install the plugins using remote api
