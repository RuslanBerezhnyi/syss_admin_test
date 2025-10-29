## Project Setup and Testing Instructions

## Initial Setup

1. **Environment Setup**
   ```bash
    # Install required tools
    sudo apt-get update
    sudo apt-get install -y docker.io ansible terraform

    # Add your user to docker group (optional)
    sudo usermod -aG docker $USER

2. **Repository Setup**
    git clone https://github.com/RuslanBerezhnyi/syss_admin_test.git
    cd syss_admin_test

## Deployment Steps

    1. Move to terraform directory
    cd terraform

    # Initialize Terraform (downloads providers)
    terraform init

    # Plan deployment (safe, without interactive prompts)
    terraform plan -input=false -out=tfplan

    # Apply the planned changes
    terraform apply tfplan

2. **Ansible Configuration**
    cd ../ansible
    ansible-playbook -i localhost, --connection=local playbook.yml

## Testing

1. **Basic Connectivity**
   ```bash
   curl http://localhost:8080/
   ```

2. **Health Check**
   ```bash
   curl http://localhost:8080/healthz
   ```

3. **Full Test Suite**
   ```bash
   ./test.sh
   ```

## Validation Steps

1. **Terraform Validation**
   ```bash
   cd terraform
   terraform fmt -check
   terraform validate
   ```

2. **Ansible Validation**
   ```bash
   cd ../ansible
   ansible-lint playbook.yml
   ```

3. **Infrastructure Verification**
   ```bash
   docker ps
   docker network ls
   docker volume ls
   ```

## Cleanup

```bash
cd terraform
terraform destroy
```

## Common Issues and Solutions

1. **Docker Socket Access**
   ```bash
   sudo chmod 666 /var/run/docker.sock
   ```

2. **Nginx Port Conflict**
   ```bash
   # Check if port 8080 is in use
   sudo lsof -i :8080
   ```

3. **PHP-FPM Connection Issues**
   ```bash
   # Check PHP-FPM logs
   docker logs sysadmin-infra_php
   ```
