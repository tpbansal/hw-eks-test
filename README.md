# hw-eks-test

Prerequisites:

- Local Machine: Use brew (MacOS) to install the necessary binaries/packages. For example:

    - docker
    - dockermachine
    - awscli
    - terraform

- Remote:  

    - Access to AWS Cloud Account
    - Setup AWS Account Creds (AWS Access Key ID, Secret Access Key, Secret Token) - Securely managed in ~/.aws/config and/or *.tfvars
    - Verify AWS ID Setup
        ``` aws sts get-caller-identity ```
## Task Requirements

    1) Hello World App
        - Conditions: 
            1. Must Run on a Container

        Solution: 
        a) Simple Hello World "App", Running on a Container - Docker lite with html
        b) Use AWS ECR

    2) Infrastructure using Terraform for the Application
        - Conditions:
            1. Must use Terraform
            2. Extra Points - EKS

        Solution:
        Infrastructure on AWS Main components:
            a) VPC
            b) EKS
    

## Application

- Use docker to build, tag and push the image to ECR. Run the following command:
    1) Chane into directory "app"
    2) Run the following commands:   

- IMPORTANT NOTE: 
    1) Use "eu-central-1" as region wherever applicable OR make necessary changes in TF Code
    2) < STRING > denotes variables, substitute with the known

```
    # OPTIONAL: Setup a local registry, so Kubernetes can pull the image(s) from there:
    docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

```
    # Build the docker image locally
    docker build . --tag my-hw-app
    
    # Verify by running and NOTE the image ID:
    docker images

    # Get ECR Credentials    
    aws ecr get-login-password --region <region> \
    | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com

    # Create an ECR Repo
    aws ecr create-repository --repository-name dribing \
     --image-scanning-configuration scanOnPush=true --region eu-central-1

    # Use the local image and tag it with the following string, tag the image (w.r.t K8 deployments):
    docker tag <local-image-ID> <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<my-ecr-repository>:tag

    # Push docker image to the ECR repo
    docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<my-ecr-repository>:tag
    

```


IMPORTANT NOTE:

Copy the ECR Image Tag to be used in the deployment object to be defined in TF

```
    <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<my-ecr-repository>:tag 
    
    For eg:

    172222222226.dkr.ecr.eu-central-1.amazonaws.com/dribing:my-app-hw

```

## Infrastructure 
- Using Terraform to deploy the above mentioned and supporting resources on AWS

    1) Clone the repository (git clone https://)
    2) Change into the directory "infra"
    3) Run the Following commands :

```
    terraform init
    
    # Check for errors
    terrafform va
    
    # Use tfplan for maintaining the local config
    terraform plan -out tfplan

    # Simply use apply and on prompt provide the region in focus (eu-central-1)
    terraform apply

``` 

- Copy the below command into terminal session you created EKS using TF and Configure your kubectl context to EKS:

```
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

```


### Verify Infra and App status

- Run the following commands to verify EKS & its node status:

```

    aws eks list-clusters --region eu-central-1

    aws eks describe-cluster --name <cluster_name> --region eu-central-1
    
    kubectl get nodes

```
> For example, check status:

```
    aws eks describe-cluster --name dribing-test-eks-JM2orR3u --region eu-central-1 --query cluster.status
   
```


- Run the following command to access the Hello World App through the "my-app-hw-service":

```
    kubectl get services

```

- NEXT: 

    -> You'll notice a column name "External-IP" alongside the "my-app-hw-service"

    -> Command + Click the link OR COPY-PASTE the link into your Browser
    
    -> You should see a "Hello Dribing" prompt in the top left corner


## Cleanup

- Remote cleanup

```
    # Run from the infra directory
    
    terraform Destroy

    # Cleanup the ECR Repo

    aws ecr batch-delete-image \
      --repository-name <my-ecr-repository> \
      --image-ids imageTag=latest
      --region <region>

    aws ecr delete-repository \
      --repository-name <my-ecr-repository> \
      --force
      --region <region>
```


# Summary & Other Considerations

- The defined task is completed - Running Hello World in a container on EKS
- Security & HA - This is no way a production grade code
- Security - With respect to time, I skipped defining variables and using *.tfvars as a source of input
- Security - AWS creds shouldn't be use for local->remote development
- Security - Use CI scanner (SAMPLE PROVIDED - .github workflow)
- Security Benchmarks missing
    - There's Open "Egress"
    - Skipped using cluster endpoint 
    - Logging
    - Unencrypted EBS block storage