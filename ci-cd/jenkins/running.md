# Jenkins[day-1][class-1]
Team deavops requirement = docker for contaierization + k8s for orchestration 
current project developed on nodejs project

we adopt scm as github entrprise for vcs and developer collaboration 

implement the unit test,code coverage measures,docker build, push to ecr and deploy to EKS and automating IT testing

Jenkins is a CI/CD tool it is open sounrce and have more customization with it's plugins and have large active community

for every code change automatically triggers rapid fire sequence for building , testing and deploying of your application 

It orchestrates entire CI/CD pipeline checkout, build test and deployment

This identifies code issues enabling faster development and high quality software 

developers merge their code changes into central repo jenkins detect changes automates build and test deploy if any thing fails in this process it automatically notify the developer means immediate feedback this process ensure minimal maual intervention

Jenkins Core Concepts:
----------------------
`Jobs` Define Specific tasks like compiling code, testing and deploying
`Builds` Jenkins maintains build history for troubleshooting
`freestyle project` UI way to create jobs
`pipeline` code way to create jobs
`stages` group related job phases like build,test and deploy
`nodes` machines where jobs are executed 
`plugins` extend jenkins functionality 

**pros**
- open source and free
- highly customizable
- pipeline as a code
- offers build execution testing artifact management and detailed build reports for trouble shooting 
- adding more build nodes  
**cons**
- take care about setup,upgradation and backup
- security concerns over a opensource

Need for SCM if no scm no way of tracking changes SCM acts as a central lib for code  keeping track of every change made overtime
- seamless collaboration
- code review
- conflict resolution
- effortless sharing
- rollback
- track every code change

Without CI Challenges
- delayed testing
- inefficient deployment
- quality assurance
[class-2]
Jenkins leverages distributed architecture to manage CI-CD pipelines efficiently this structure offers scalability and power allowing you to automate complex workflows across multiple machines 

# Distribute achitecture
- improve performance
- prevents accidental deletion

**Jenkins Controller**
- co-ordinating entire CI/CD process
- auth&auth
- job management[defining,schduling,monitoring execution]
- provides web interface for configutaion setting plugins,secrets..
**Build Node**
- It executes the Jobs
- allows parallel processing increase performance

SSH for linux, JnLp for windows one executor for node is more secure setup


/var/lib/jenkins

- freestyle project[limited workflow,non-code based configuration,limited functionality]
- pipeline 
- multibranch
- multi configuration project
- organization projects

pipeline projects are categorized into 2 ways
1. scripted pipeline
  - requires some coding knowledge to write scripted pipelines
  - you can define complex logic for your requirement
  - suitable for highly complex workflows
2. declarative pipeline
  - human readable
  - simple syntax to follow to write pipelines
  - not suitable for highly complex workflows

pipeline:
- stages allow parallel task execution
- configured via Jenkinsfile supports version control
- track the changes of pipeline
freestyle:
- sequntial order of steps
- configured via web interface les flexible
- harder to track chnages

- environment
- options
- post
- script block
- when
- credentials
- input block
- parameters
- stash/unstash
- parallel stages


- Jenkins CLI[SSH,JAR]
- Jenkins RestAPI programmatic way to interact with Jenkins

- crumb

# Security
- core principle of jenkins security is the concept of least privilege
- unauthrozed access
- malicious actions


authentication = verifys the user identity
- ldap
- jenkins own db
- active dir
authrization = determine user permissions

mock security realm

# Day-2[SettingupCI/CD pipeline]
- parallel
- environemnt
- pipeline syntx
- owasp dependnecy check 
- unit test



