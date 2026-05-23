# ☁️ Cloud Security

## Securing and Attacking Cloud Environments — AWS, Azure, GCP

---

## Overview

Cloud computing is now the standard for infrastructure. Understanding cloud security is essential as organizations migrate services to AWS, Azure, and GCP.

---

## Cloud Fundamentals

### Service Models

| Model | You Manage | Provider Manages | Example |
|-------|-----------|-----------------|---------|
| **IaaS** | OS, Apps, Data | Hardware, Network, Virtualization | AWS EC2, Azure VMs |
| **PaaS** | Apps, Data | OS, Runtime, Hardware | Heroku, Azure App Service |
| **SaaS** | Just Data | Everything else | Office 365, Gmail |

### Shared Responsibility Model

```
┌─────────────────────────────────────────────────────┐
│                    CUSTOMER                           │
│  Data, Access Management, Application Security       │
│  OS Patching (IaaS), Network Config                 │
├─────────────────────────────────────────────────────┤
│                 CLOUD PROVIDER                        │
│  Physical Security, Hardware, Network Infrastructure│
│  Hypervisor, Global Infrastructure                  │
└─────────────────────────────────────────────────────┘
```

---

## AWS Security

### IAM (Identity and Access Management)

```json
// Example IAM Policy (TOO PERMISSIVE - security risk!)
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": "*",           // ALL actions - NEVER do this!
        "Resource": "*"          // ALL resources - NEVER do this!
    }]
}

// Secure policy (least privilege)
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": [
            "s3:GetObject",
            "s3:ListBucket"
        ],
        "Resource": [
            "arn:aws:s3:::my-bucket",
            "arn:aws:s3:::my-bucket/*"
        ]
    }]
}
```

### Common AWS Misconfigurations

| Misconfiguration | Impact | Detection |
|-----------------|--------|-----------|
| Public S3 buckets | Data exposure | `aws s3 ls s3://bucket --no-sign-request` |
| Overly permissive IAM | Privilege escalation | IAM Access Analyzer |
| Unencrypted EBS volumes | Data at rest exposed | AWS Config rules |
| Open security groups (0.0.0.0/0) | Unauthorized access | Security Hub |
| Access keys in code | Account compromise | git-secrets, TruffleHog |
| IMDSv1 exposed | SSRF → credential theft | Require IMDSv2 |

### AWS Enumeration (Offensive)

```bash
# Configure with stolen credentials
aws configure

# Enumerate identity
aws sts get-caller-identity

# List S3 buckets
aws s3 ls

# List EC2 instances
aws ec2 describe-instances

# List IAM users
aws iam list-users

# Check permissions
aws iam list-attached-user-policies --user-name target-user

# Enumerate with Pacu (AWS exploitation framework)
pacu
> import_keys stolen_key
> run iam__enum_permissions
> run ec2__enum
```

### AWS Security Tools

| Tool | Purpose |
|------|---------|
| ScoutSuite | Multi-cloud security auditing |
| Prowler | AWS security best practices assessment |
| CloudMapper | AWS environment visualization |
| Pacu | AWS exploitation framework |
| TruffleHog | Find secrets in repos |

---

## Container Security (Docker & Kubernetes)

### Docker Security Issues

```bash
# Running as root (default - bad practice)
docker run -it ubuntu /bin/bash
# Container processes run as root!

# Privileged container (DANGEROUS)
docker run --privileged -it ubuntu /bin/bash
# Can access host devices, escape container!

# Mounting host filesystem
docker run -v /:/host -it ubuntu /bin/bash
# Can read ENTIRE host filesystem!

# Better practices:
# Run as non-root user
docker run --user 1000:1000 -it ubuntu /bin/bash

# Read-only filesystem
docker run --read-only -it ubuntu /bin/bash

# Drop capabilities
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE -it ubuntu /bin/bash
```

### Kubernetes Security

| Risk | Description | Mitigation |
|------|-------------|-----------|
| Exposed dashboard | Unauthorized cluster access | Authentication, network policies |
| Pod escape | Container breakout to node | Pod security policies |
| RBAC misconfiguration | Overly permissive roles | Least privilege RBAC |
| Secrets in plain text | Credential exposure | External secret management |
| Network policies missing | Unrestricted pod communication | NetworkPolicy objects |

---

## Cloud Security Best Practices

1. **Enable MFA** on all accounts, especially root/admin
2. **Least privilege** IAM policies
3. **Encrypt** data at rest and in transit
4. **Enable logging** (CloudTrail, Azure Monitor)
5. **No public storage** unless intentional
6. **Rotate credentials** regularly
7. **Use IAM roles** instead of access keys
8. **Network segmentation** (VPCs, security groups)
9. **Regular audits** with automated tools
10. **Incident response plan** for cloud environments

---

## Exercises

1. Set up a free-tier AWS account and identify misconfigurations
2. Run ScoutSuite against your account
3. Practice with CloudGoat (intentionally vulnerable AWS environment)
4. Exploit an SSRF vulnerability to access AWS metadata (in your lab)
5. Harden a Docker container following CIS benchmarks

---

**Next:** → [14-Blue-Team](../14-Blue-Team/README.md)

*"The cloud is just someone else's computer. Secure it like it's yours."*
