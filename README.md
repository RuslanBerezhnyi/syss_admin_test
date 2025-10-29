# Infrastructure as Code Test Project

This project implements a minimal PHP application infrastructure using Nginx + PHP-FPM, managed via Terraform and configured with Ansible.

## Prerequisites

- Terraform >= 1.6.0
- Docker >= 20.10.0
- Ansible >= 2.9
- Docker provider for Terraform (~> 3.0)

## Project Structure

```
.
├── ansible/
│   ├── playbook.yml
│   └── roles/
│       └── web/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── providers.tf
└── .github/
    └── workflows/
        ├── terraform.yml
        └── ansible.yml
```

## Quick Start

1. Clone the repository:
```bash
git clone https://github.com/RuslanBerezhnyi/syss_admin_test.git
cd syss_admin_test
```

2. Initialize Terraform:
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

3. Run Ansible playbook:
```bash
cd ../ansible
ansible-playbook -i localhost, --connection=local playbook.yml
```

4. Verify the setup:
```bash
curl http://localhost:8080/healthz
```

Expected output:
```json
{
  "status": "ok",
  "service": "nginx",
  "env": "dev"
}
```

## Environment Variables

### Terraform Variables
- `project_name` - Project name (default: "sysadmin-infra")
- `host_port` - Host port for Nginx (default: 8080)
- `app_env` - Application environment (default: "dev")

### Required Environment Access
- Docker socket access (`/var/run/docker.sock`)
- Sudo access for Ansible playbook

## Infrastructure Components

1. **Docker Containers:**
   - Nginx (exposed on host port 8080)
   - PHP-FPM (handling PHP files)

2. **Shared Resources:**
   - Docker network for container communication
   - Volume for `/var/www/html`

3. **Configuration:**
   - Nginx configured with PHP-FPM upstream
   - PHP files served through FastCGI
   - Logrotate for Nginx logs

## CI/CD

The project includes GitHub Actions workflows for:
- Terraform validation and planning
- Ansible linting

### CI Environment Requirements
- Docker with buildx support
- Terraform >= 1.6.0
- Access to Docker socket

## Testing

To run the infrastructure tests:
```bash
./test.sh
```

This will verify:
- Container status
- Network connectivity
- Volume mounting
- PHP processing
- Nginx configuration
- Environment variables

## Troubleshooting

1. If Terraform fails in CI:
   - Ensure Docker daemon is available
   - Check Docker socket permissions
   - Verify Terraform version compatibility

2. If Ansible fails:
   - Check sudo access
   - Verify target paths exist
   - Check file permissions

## License

This project is open-source and available under the MIT License.
