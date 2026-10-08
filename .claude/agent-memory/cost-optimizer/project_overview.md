---
name: portfolio-site-infrastructure
description: Static HTML/CSS portfolio site deployed via S3 + CloudFront with Terraform
metadata:
  type: project
---

**Project Type**: Static portfolio website (HTML5 + CSS3, no JavaScript, no build step)

**Current Infrastructure**:
- S3 bucket: Standard storage class, no lifecycle rules
- CloudFront: PriceClass_200 (covers NA, Europe, Middle East, Africa, India)
- Origin Access Control (OAC) properly configured
- Backend: S3 + DynamoDB configuration available but currently unused (local state)
- Region: ap-south-1 (Mumbai)

**Cost Profile**:
- Low absolute costs (small static site)
- Primary costs: CloudFront data transfer + S3 storage (minimal)
- Secondary costs: Terraform state management when enabled

**Key Optimization Areas Identified**:
1. CloudFront geographic distribution (PriceClass can be optimized based on traffic pattern)
2. S3 lifecycle policies for versioning/old objects
3. Cache TTL optimization for static assets
4. Terraform state bucket lifecycle configuration when enabled
