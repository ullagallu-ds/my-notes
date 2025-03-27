# why and what is terraform
We need infrastructure means network,storage,compute,databases,load balancers,auto scaling groups ... to host our applications
To host our application we need infrastructure like network,compute,storage,databases,load balancers and asg ...
To create all these components manually has several disadvantages
- create the resources one by one time consuming and takes care about dependencies
- prone to error
- there is no chance of replicate same infra across different environemts
- hard to audit who did what changes means no tracking facility
- we need to maintain inventory what resources created
- No VCS of out infrastructure

To address all above issues industry comes with an solution i.e why con't we manage our infrastructure as code

- The first benefit of make infrastructure as code is VCS
- We can easily create similar type of infra across different environemnts
- Track chnages who made what changes
- It avoids configuration drift we can create consistent infra
- doing curd operations on the fly it won't much time and also create scalable infra

Terraform is one of the IAC tool
- It used HCL language to create and manage infrastructure
- maintinas statefile to track the resources that managed by terraform to secure statefile it will support remote storage and avoid parallel execution of terraform by implementing locking meachanism
- implement the DRY priciple by using modules[reusable-resources]
---