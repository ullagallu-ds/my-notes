# GitOps

**What is GitOps**
GitOps is a framework where the entire code delivary process is controlled via git which also includes infra code + app manifest + configuration code 

Before merging code is reviewed and approved by the consent team 

GitOps has 4 principles

1. Declarative/Imperative: approach gitops demands entire system including infra application manifest to be declare state it discourages the use of imperative approach reconcilation becomes difficult if state is imperative 

2. Make use of git: all the declarative file also known as declarative state stored in a git repo it provides version control and also enforces immutability 

3. GitOps operator known as software agents automatically pull the desired state from git automatically apply them on one or more environments or cluster 

4. Reconcilation: Operator also makes entire system self healing reduce risk of human errors the operator continously loops through 3 steps
    Observe: Checks the git repo for changes
    Diff: Comapres the changes received from git and current etcd manifests
    Act: It perform the actions make sure desired state to actual state

Industry best practices

We have also code reviews and automation tests for our code also

Traditional push based approach have some flaws
1. No configuration review
2. No tests
3. CI has read and write access to cluster
4. Users expose credentials through CLI
5. Configuration Drift due to maual changes
6. Let's not forgot about cloud disasters it could happen anytime it could be anything

**Diff b/w DevOps&GitOps**
Only change is in devops we push the change to cluster in gitops changes were pulled by the operator

**pull vs push**
