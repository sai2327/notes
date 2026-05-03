# 14. Cloud Security

## Table of Contents
- [14.1 Cloud Computing Basics](#141-cloud-computing-basics)
- [14.2 Cloud Security Risks](#142-cloud-security-risks)
- [14.3 Shared Responsibility Model](#143-shared-responsibility-model)
- [14.4 Cloud Security Best Practices](#144-cloud-security-best-practices)
- [14.5 AWS / Azure / GCP Security Tools](#145-aws--azure--gcp-security-tools)
- [14.6 Common Mistakes & Interview Tips](#146-common-mistakes--interview-tips)
- [14.7 Practice & Assessment](#147-practice--assessment)

---

## 14.1 Cloud Computing Basics

### Service Models

| Model | What You Manage | What Provider Manages | Example |
|-------|----------------|----------------------|---------|
| **IaaS** (Infrastructure as a Service) | OS, Apps, Data | Hardware, Network, Virtualization | AWS EC2, Azure VM |
| **PaaS** (Platform as a Service) | Apps, Data | Everything else | Heroku, AWS Elastic Beanstalk |
| **SaaS** (Software as a Service) | Just data/config | Everything | Gmail, Office 365, Salesforce |

### Deployment Models

| Model | Description | Use Case |
|-------|-------------|----------|
| **Public Cloud** | Resources shared across organizations | Startups, web apps |
| **Private Cloud** | Dedicated to one organization | Banks, government |
| **Hybrid Cloud** | Mix of public and private | Most enterprises |
| **Multi-Cloud** | Multiple cloud providers | Avoid vendor lock-in |

---

## 14.2 Cloud Security Risks

### Top Cloud Threats (CSA — Cloud Security Alliance)

| Risk | Description | Real-World Example |
|------|-------------|-------------------|
| **Misconfiguration** | Wrongly configured cloud resources | S3 bucket left public → data exposed |
| **Insufficient Access Control** | Over-permissive IAM policies | `*:*` policy giving full admin access |
| **Insecure APIs** | Unprotected cloud APIs | API key leaked in GitHub repo |
| **Data Breach** | Unauthorized data access | Capital One breach (2019) — SSRF on AWS |
| **Account Hijacking** | Stolen cloud credentials | Phished admin credentials → full access |
| **Insider Threat** | Malicious or negligent employee | Employee downloads customer database |
| **Shadow IT** | Unauthorized cloud usage | Employees using personal Dropbox for work |

### Common Misconfigurations

```
✗ S3 bucket set to public             → Anyone can download your data
✗ Security group allowing 0.0.0.0/0   → Open to the entire internet
✗ Root account used for daily tasks    → Full access if compromised
✗ No MFA on cloud console login        → Password alone can be stolen
✗ Unused resources still running       → Attack surface + cost waste
✗ Encryption not enabled on storage    → Data readable if accessed
✗ Logging disabled                     → Can't detect or investigate attacks
```

---

## 14.3 Shared Responsibility Model

```
┌──────────────────────────────────────────────────┐
│              SHARED RESPONSIBILITY                │
├────────────────────┬─────────────────────────────┤
│  CUSTOMER          │  CLOUD PROVIDER              │
│  (Your Job)        │  (Their Job)                 │
├────────────────────┼─────────────────────────────┤
│ Data protection    │ Physical data center security│
│ Access management  │ Hardware maintenance          │
│ OS patching (IaaS) │ Network infrastructure       │
│ Application code   │ Hypervisor security          │
│ Firewall rules     │ Global network backbone      │
│ Encryption config  │ Compliance certifications    │
│ IAM policies       │ Availability zones           │
│ Monitoring/logging │ DDoS basic protection        │
└────────────────────┴─────────────────────────────┘

Simple Rule:
  Provider secures the cloud (infrastructure)
  Customer secures what's IN the cloud (data, access, config)
```

---

## 14.4 Cloud Security Best Practices

### Identity & Access Management (IAM)

```
1. NEVER use root/owner account for daily tasks
   → Create individual IAM users

2. Enable MFA on ALL accounts (especially admin)
   → Hardware key > Authenticator app > SMS

3. Follow least privilege principle
   → Grant only permissions needed
   → Review permissions regularly

4. Use IAM roles instead of access keys where possible
   → Roles are temporary; keys are permanent

5. Rotate access keys regularly
   → Every 90 days minimum

6. Use groups for permission management
   → Assign permissions to groups, add users to groups
```

### Data Protection

```
Encryption at rest:
  → Enable default encryption on all storage
  → AWS: S3 default encryption, EBS encryption
  → Azure: Storage Service Encryption
  → Use customer-managed keys (CMK) for sensitive data

Encryption in transit:
  → Enforce HTTPS/TLS for all connections
  → Use VPN or private endpoints for internal traffic
  → Disable older TLS versions (< 1.2)

Backup:
  → Automated backups with defined retention
  → Test restore procedures regularly
  → Cross-region backups for disaster recovery
```

### Network Security

```
Virtual Private Cloud (VPC):
  → Isolate resources in private networks
  → Use public subnets only for load balancers
  → Keep databases in private subnets (no internet access)

Security Groups (AWS) / NSGs (Azure):
  → Default deny all inbound
  → Allow only needed ports from needed sources
  → NEVER use 0.0.0.0/0 except for public web ports (80/443)

Example — Secure AWS Architecture:
  Internet → ALB (public subnet) → EC2 (private subnet) → RDS (private subnet)
  Only ALB is publicly accessible. EC2 and RDS have no public IPs.
```

---

## 14.5 AWS / Azure / GCP Security Tools

| Category | AWS | Azure | GCP |
|----------|-----|-------|-----|
| Identity | IAM, Organizations | Azure AD, RBAC | Cloud IAM |
| Network | Security Groups, VPC | NSG, VNet | VPC Firewall Rules |
| Monitoring | CloudTrail, CloudWatch | Monitor, Log Analytics | Cloud Audit Logs |
| Threat Detection | GuardDuty | Defender for Cloud | Security Command Center |
| Key Management | KMS | Key Vault | Cloud KMS |
| Compliance | Config, Audit Manager | Policy, Blueprints | Security Health Analytics |
| WAF | AWS WAF | Azure WAF | Cloud Armor |
| Secrets | Secrets Manager | Key Vault | Secret Manager |

### AWS CLI Security Commands

```bash
# Check who you are
aws sts get-caller-identity

# List S3 buckets
aws s3 ls

# Check bucket ACL
aws s3api get-bucket-acl --bucket my-bucket

# Check if bucket is public
aws s3api get-public-access-block --bucket my-bucket

# List IAM users
aws iam list-users

# Check user policies
aws iam list-attached-user-policies --user-name admin

# Enable CloudTrail logging
aws cloudtrail create-trail --name my-trail --s3-bucket-name my-log-bucket
```

---

## 14.6 Common Mistakes & Interview Tips

### Interview Questions

**Q: What is the Shared Responsibility Model?**
> The cloud provider is responsible for security OF the cloud (physical infrastructure, hypervisor, network). The customer is responsible for security IN the cloud (data, access, configuration, applications).

**Q: How do you secure an S3 bucket?**
> Block public access, enable default encryption, use bucket policies with least privilege, enable versioning, enable access logging, and use CloudTrail to monitor API calls.

**Q: What is the difference between Security Groups and NACLs in AWS?**
> Security Groups are stateful (return traffic automatically allowed) and operate at the instance level. NACLs are stateless (must explicitly allow return traffic) and operate at the subnet level.

---

## 14.7 Practice & Assessment

### MCQs

**Q1.** In the Shared Responsibility Model, who is responsible for patching the OS on an EC2 instance?
- A) AWS
- B) Customer
- C) Both equally
- D) Neither

**Answer:** B) Customer — in IaaS, the customer manages the OS.

---

**Q2.** The most common cloud security issue is:
- A) DDoS attacks
- B) Misconfiguration
- C) Zero-day exploits
- D) Insider threats

**Answer:** B) Misconfiguration

---

**Q3.** Which AWS service provides API activity logging?
- A) CloudWatch
- B) GuardDuty
- C) CloudTrail
- D) Inspector

**Answer:** C) CloudTrail

---

> **Next Topic:** [15 - Digital Forensics](15-digital-forensics.md)
