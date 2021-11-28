# hw-eks-test

Prerequisites:

Use brew (MacOS) to install the necessary binaries/packages. For example:

    docker
    dockermachine
    awscli
    terraform
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


## Infrastructure 
- Using Terraform to deploy the above mentioned and supporting resources on AWS

    1) Clone the repository (git clone https://)
    2) Change into the directory "infra"
    3) Run the Following commands :

```
    terraform init
    terraform plan -out tfplan
    terraform apply "tfplan"

``` 