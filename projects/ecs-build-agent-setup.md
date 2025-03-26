
### Steps to Use ECS as a GitHub Actions Runner  

1. **Create an ECS Cluster**  
   ```sh
   aws ecs create-cluster --cluster-name github-runner-cluster
   ```  

2. **Create an IAM Role for ECS Tasks**  
   - Create an IAM Role (`ecs-github-runner-role`) with permissions to run ECS tasks and read from Secrets Manager.  
   - Attach `AmazonECSTaskExecutionRolePolicy` and `AWSSecretsManagerReadWrite`.  

3. **Create a GitHub Personal Access Token (PAT)**  
   - Generate a GitHub PAT with `repo` and `admin:org` permissions.  
   - Store it in AWS Secrets Manager.  
   ```sh
   aws secretsmanager create-secret --name GITHUB_PAT --secret-string "<TOKEN>"
   ```  

4. **Create an ECS Task Definition**  
   Example `ecs-github-runner-task.json`:  
   ```json
   {
        "privileged": true,
        "name": "github-runner",
        "image": "<AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/github-runner",
        "memory": 2048,
        "cpu": 1024,
        "essential": true,
        "environment": [
            { "name": "GITHUB_REPOSITORY", "value": "your-org/your-repo" },
            { "name": "RUNNER_NAME", "value": "ecs-runner" },
            { "name": "AWS_REGION", "value": "<REGION>" }
        ],
        "secrets": [
            {
            "name": "GITHUB_PAT",
            "valueFrom": "arn:aws:secretsmanager:<REGION>:<AWS_ACCOUNT_ID>:secret:GITHUB_PAT"
            }
        ]
    }


   ```  

5. **Create a GitHub Actions Runner Docker Image**  
   Create a `Dockerfile`:  
   ```dockerfile
   FROM ubuntu:latest
   RUN apt update && apt install -y curl jq git
   WORKDIR /actions-runner
   RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.308.0/actions-runner-linux-x64-2.308.0.tar.gz \
       && tar xzf actions-runner.tar.gz && rm actions-runner.tar.gz
   RUN ./bin/installdependencies.sh
   COPY entrypoint.sh /entrypoint.sh
   RUN chmod +x /entrypoint.sh
   ENTRYPOINT ["/entrypoint.sh"]
   ```  

6. **Create the Entrypoint Script**  
   `entrypoint.sh`:  
   ```sh
   #!/bin/bash
   GITHUB_TOKEN=$(aws secretsmanager get-secret-value --secret-id GITHUB_PAT --query SecretString --output text)
   ./config.sh --url https://github.com/${GITHUB_REPOSITORY} \
               --token $GITHUB_TOKEN \
               --name $RUNNER_NAME \
               --unattended \
               --replace
   ./run.sh
   ```  

7. **Build and Push the Image to ECR**  
   ```sh
   aws ecr create-repository --repository-name github-runner
   aws ecr get-login-password | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com
   docker build -t github-runner .
   docker tag github-runner <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/github-runner
   docker push <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/github-runner
   ```  

8. **Deploy the Runner on ECS**  
   ```sh
   aws ecs register-task-definition --cli-input-json file://ecs-github-runner-task.json
   aws ecs run-task --cluster github-runner-cluster --task-definition github-runner
   ```  

9. **Verify the Runner in GitHub**  
   - Go to GitHub → Settings → Actions → Runners.  
   - You should see the ECS runner listed.  

10. **Automate Scaling**  
   - Use AWS Lambda and EventBridge to start and stop ECS tasks based on GitHub Actions jobs.  

This will make ECS tasks work as self-hosted GitHub Actions runners. Let me know if you need any help.