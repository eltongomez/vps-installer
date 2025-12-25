---
layout: default
title: VPS Installer
description: Professional VPS Provisioning Tool with 13 Containerized Stacks
---

# 🚀 VPS Installer v2.0.0

**Production-Ready VPS Provisioning Tool with Professional Documentation**

[![GitHub Release](https://img.shields.io/badge/release-v2.0.0-brightgreen)](https://github.com/eltongomez/vps-installer/releases/tag/v2.0.0)
[![License](https://img.shields.io/badge/license-MIT-blue)](https://github.com/eltongomez/vps-installer/blob/main/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/eltongomez/vps-installer)](https://github.com/eltongomez/vps-installer)
[![GitHub Forks](https://img.shields.io/github/forks/eltongomez/vps-installer)](https://github.com/eltongomez/vps-installer)

---

## ⚡ Quick Start

```bash
git clone https://github.com/eltongomez/vps-installer.git
cd vps-installer
chmod +x setup-vps.sh
./setup-vps.sh
```

---

## ✨ Features

### 13 Containerized Stacks

| # | Stack | Descrição | Type |
|---|-------|-----------|------|
| 1 | **Traefik** | Reverse Proxy + SSL/TLS | Infrastructure |
| 2 | **Portainer** | Docker Management UI | Management |
| 3 | **Chatwoot** | Customer Support Platform | Communication |
| 4 | **n8n** | Workflow Automation | Automation |
| 5 | **Evolution** | Email Server | Communication |
| 6 | **Evo-AI** | AI Integration | AI |
| 7 | **Prometheus** | Metrics Collection | Monitoring |
| 8 | **Grafana** | Visualization & Alerts | Monitoring |
| 9 | **PostgreSQL** | Database | Data |
| 10 | **Redis** | Cache Layer | Data |
| 11 | **Backup** | Automated Backup Scheduler | Operations |
| 12 | **Restore** | Backup Restoration | Operations |
| 13 | **Odoo 17.0** | ERP System | Business |

### Core Capabilities

✅ **Interactive & Non-Interactive Modes**
- Menu-driven installation for users
- CI/CD automation via environment variables

✅ **Security Hardened**
- SSH ed25519 (256-bit encryption)
- Regex validation (domain, email)
- Automatic hardening policies
- Health checks on all services

✅ **Flexible Backup System**
- Configurable frequency (hourly/daily/weekly/monthly)
- Time selection (0-23 hours)
- Retention policy (days)
- Automatic restoration interface

✅ **Professional Code Quality**
- 1,208 lines of production-ready bash
- Input validation & error handling
- Comprehensive documentation
- MIT License

---

## 📚 Documentation

### For Users
- **[Installation Guide](README_PROJETO.md)** - 5-minute quick start
- **[Detailed Setup](README.md)** - Complete installation reference
- **[Troubleshooting](TROUBLESHOOTING.md)** - 30+ solutions to common issues

### For Developers
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute
- **[Git Workflow](GIT_WORKFLOW.md)** - Branch strategy & conventions
- **[Commit Examples](COMMIT_EXAMPLES.md)** - 13 real-world examples
- **[Project Structure](PROJECT_STRUCTURE.md)** - Architecture & design

### For Operations
- **[Non-Interactive Mode](README_NONINTERACTIVE.md)** - CI/CD automation
- **[Security Policies](SECURITY.md)** - Security hardening checklist
- **[Documentation Index](DOCUMENTATION_INDEX.md)** - Complete navigation guide

### Reference
- **[Changelog](CHANGELOG.md)** - Version history
- **[License](LICENSE)** - MIT License

---

## 🔒 Security

**Implemented Security Features:**

✅ SSH ed25519 key generation (256-bit)
✅ Automatic hardening (PermitRootLogin=no, PasswordAuthentication=no)
✅ Input validation with regex patterns
✅ Health checks on all services
✅ Automated backup with retention policies
✅ Isolated Docker networks
✅ Strong password generation with openssl

[See Security Policies →](SECURITY.md)

---

## 🚀 Usage

### Interactive Mode
```bash
./setup-vps.sh
# Follow the menu to select stacks and configure
```

### Non-Interactive Mode (CI/CD)
```bash
# Copy and configure the template
cp noninteractive.env.example noninteractive.env
# Edit variables
NONINTERACTIVE=1 ./setup-vps.sh
```

### Menu Options
1. **Traefik** - Reverse Proxy with SSL
2. **Portainer** - Docker Management
3. **Chatwoot** - Support Platform
4. **n8n** - Automation
5. **Evolution** - Email Server
6. **Evo-AI** - AI Integration
7. **Monitoring** - Prometheus + Grafana
8. **Backup** - Configure Scheduler
9. **SSH** - Key Generation & Hardening
10. **Non-Interactive Mode** - CI/CD Setup
11. **Restore** - Backup Recovery
12. **Odoo 17.0** - ERP System

[See Full Documentation →](README.md)

---

## 📊 Statistics

```
Code:
- 1,208 lines of professional bash
- 13 containerized stacks
- 2 installation modes
- 12 menu options

Documentation:
- 13 markdown files
- 3,500+ lines of guides
- 30+ troubleshooting solutions
- 13 commit examples

Quality:
- MIT License
- 100% documentation coverage
- Input validation & error handling
- Security hardening included
```

---

## 🔄 Roadmap

### v2.1.0 (Coming Soon)
- [ ] Nextcloud Stack (File Storage)
- [ ] Email Alerts (Monitoring)
- [ ] Web Dashboard UI
- [ ] GitHub Actions CI/CD

### v3.0.0 (Future)
- [ ] S3/Cloud Backup Support
- [ ] Terraform Templates
- [ ] Kubernetes Support
- [ ] Multi-server Orchestration

[See Changelog →](CHANGELOG.md)

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for:
- How to report bugs
- How to request features
- Code standards & requirements
- Pull request process

[Code of Conduct](CONTRIBUTING.md#code-of-conduct)

---

## 📝 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

---

## 🆘 Support

### Having Issues?
Check our [Troubleshooting Guide](TROUBLESHOOTING.md) with 30+ solutions.

### Need Help?
- 📖 Read the [Complete Documentation](README.md)
- 🔍 Search [Existing Issues](https://github.com/eltongomez/vps-installer/issues)
- 💬 [Open a New Issue](https://github.com/eltongomez/vps-installer/issues/new)

---

## 📱 Stay Updated

- ⭐ Star the repository
- 👁️ Watch for releases
- 🔔 Enable notifications

---

**VPS Installer v2.0.0** | [GitHub Repository](https://github.com/eltongomez/vps-installer) | Production Ready ✅

**Last Updated:** December 24, 2025
