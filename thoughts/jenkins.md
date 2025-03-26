# Interview Questions
1. How do you setup CI/CD pipeline for an aws hosted application
To setup CI/CD pipeline we need consider some points

Collaborate with devloper to get more insights from application
- programming lang and version
- Build Tool
- Which Branching Strategy they are used
- What is you deployment platform

Operations team as we do
- SetUp the Build Server in Distributed architecture
- Integrate all required things to build the applications
- like build tool,owasp depenendcy check,docker,sonarqube,twist lock,ECR ....
- Testing all the integrations
- writing CI/CD pipelines testing the each and every stage
- implement Shared Libs for reusability

with Testing
- implement the pipelines for testing
- Integrating selenium tests with pipeline

2. How do you handle roll backs in CI/CD
3. How do you ensure zero downtime in deployments
4. Explain CI/CD pipeline you implemented
5. How do handle deployment failures
6. Difference between CI/CD/CD
CI = code is build and tested
CD = Continouous Delivery manaually release the application to the prod
CD = Continuous Deployment means release application without manual intervention to prod
7. How would you design a scalable CI/CD  pipeline for microservices
8. How can you ensure security in a devops pipeline