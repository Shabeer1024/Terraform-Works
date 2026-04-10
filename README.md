# 🏗️ Azure Infrastructure Automation with Terraform

Enterprise-grade Azure infrastructure built using **modular Terraform architecture**, 
simulating real-world cloud deployments for banking and enterprise environments.

---

## 📁 Labs Overview

| Lab | Azure Services | Key Concepts |
|-----|---------------|--------------|
| **Azure Firewall** | Firewall, Firewall Policy, UDR | Rule Collections, DNAT, Route Tables |
| **Azure Application Gateway** | App Gateway, Load Balancer | Path-based routing, WAF, Backend Pools |
| **Azure Traffic Manager** | Traffic Manager, Web Apps | Weighted routing, Multi-region |
| **Load Balancer** | Azure LB, VMs, VNet | Internal/External LB, Health Probes |
| **VM Scale Sets** | VMSS, Auto-scaling | Scale-in/out policies |
| **VNet Peering** | VNet, Peering, NSG | Hub-Spoke topology |
| **Web App** | App Service, VNet Integration | PaaS deployment |
| **Meta Arguments** | Terraform Core | count, for_each, depends_on, lifecycle |
| **terraform-modules** | All services | Reusable module patterns |

---

## 🏛️ Architecture Principles

- ✅ **Modular design** — every service is a reusable module
- ✅ **Separation of concerns** — networking, compute, security split into layers
- ✅ **No hardcoded secrets** — all sensitive values via variables
- ✅ **Enterprise patterns** — mirrors real UAE/Gulf banking infrastructure

---

## 📂 Module Structure

\`\`\`
├── modules/
│   ├── networking/
│   │   ├── vnet/
│   │   ├── firewall/
│   │   ├── firewall_policy/
│   │   ├── route_table/
│   │   ├── loadbalancer/
│   │   └── app_gateway/
│   ├── compute/
│   │   └── VirtualMachines/
│   └── general/
│       └── resource/
├── main.tf
├── variables.tf
├── providers.tf
└── terraform.tfvars.example
\`\`\`

---

## 🚀 How to Use

\`\`\`bash
# Clone the repo
git clone https://github.com/Shabeer1024/Terraform-Works.git

# Navigate to any lab
cd "Azure Firewall"

# Copy and fill variables
cp terraform.tfvars.example terraform.tfvars

# Deploy
terraform init
terraform plan
terraform apply
\`\`\`

---

## 🛠️ Tech Stack

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![Azure DevOps](https://img.shields.io/badge/Azure_DevOps-0078D7?style=for-the-badge&logo=azure-devops&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

---

## 👨‍💻 Author

**Shabeer** — Azure EUC Architect | AZ-104 | AZ-700 | 
🔗 [LinkedIn](https://www.linkedin.com/in/shabeer-s-82690a156/)  
📧 Cloud Architect | 13 Years Enterprise IT
