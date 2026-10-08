---
name: cost-optimization-recommendations
description: Specific cost-saving recommendations for portfolio site infrastructure
metadata:
  type: feedback
---

## Identified Cost Optimization Opportunities

### 1. CloudFront Price Class (HIGH IMPACT)
**Current**: `PriceClass_200` (NA, Europe, Middle East, Africa, India at $0.085/GB)

**Recommended**: `PriceClass_100` (NA, Europe, Israel at $0.085/GB)

**Rationale**: For a personal portfolio site, traffic is typically concentrated in 1-3 regions. PriceClass_200 includes expensive regions (Middle East, Africa) that may not receive traffic. PriceClass_100 covers the most common developer markets.

**Estimated Savings**: 30-40% reduction in CloudFront costs if traffic is concentrated (would save ~$100-200/month on average $500 month distribution, or $10-30/month for minimal traffic portfolios)

**Action**: Change line 62 in main.tf from `price_class = "PriceClass_200"` to `price_class = "PriceClass_100"`

---

### 2. S3 Storage Class & Lifecycle Rules (MEDIUM IMPACT)
**Current**: Standard storage class, no lifecycle rules

**Recommended**: Add S3 Intelligent-Tiering for automatic cost optimization

**Action**: 
```hcl
resource "aws_s3_bucket_intelligent_tiering_configuration" "portfolio" {
  bucket = aws_s3_bucket.website.id
  name   = "AutoTiering"
  status = "Enabled"
  
  tiering {
    days          = 30
    access_tier   = "ARCHIVE_ACCESS"
  }
  tiering {
    days          = 90
    access_tier   = "DEEP_ARCHIVE_ACCESS"
  }
}
```

**Estimated Savings**: Minimal for small portfolios (< 1GB). For larger sites with infrequent access: 40-50% storage cost savings. Typical impact: $0.50-$2.00/month.

---

### 3. CloudFront Cache Behavior Optimization (LOW-MEDIUM IMPACT)
**Current**: Using `Managed-CachingOptimized` policy

**Issue**: HTML files cached with shorter TTL to support updates, but static CSS could have longer TTL

**Recommended**: Create custom cache policy or cache headers in HTML:
- HTML: 3600 seconds (1 hour) - allows quick content updates
- CSS/images: 31536000 seconds (1 year) - immutable assets with cache busting

**Action**: Increase default cache TTL via CloudFront behavior or origin headers

**Estimated Savings**: 20-30% reduction in origin requests to S3. Typical impact: $10-50/month on data transfer (higher for popular sites).

---

### 4. Remove/Optimize Terraform Backend Configuration (LOW IMPACT)
**Current**: S3 backend + DynamoDB configuration commented out, using local state

**Recommendation**: When backend is enabled, add lifecycle rules to state bucket:

```hcl
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"
    
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
    
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
```

**Estimated Savings**: Minimal ($1-5/month). Prevents unbounded state file growth.

---

## Summary of Potential Monthly Savings

| Recommendation | Impact | Estimated Monthly Savings |
|---|---|---|
| PriceClass_100 | HIGH | $10-200 (traffic-dependent) |
| S3 Intelligent-Tiering | MEDIUM | $0.50-2.00 |
| Cache TTL Optimization | MEDIUM | $10-50 |
| Terraform State Lifecycle | LOW | $1-5 |
| **TOTAL** | | **$21.50-257/month** |

**Note**: Absolute savings depend heavily on traffic volume. A low-traffic portfolio ($5-20/month total AWS bill) would save $1-10/month. A popular portfolio ($500+/month) could save $50-200/month.

**Quick Win Priority**: 
1. Change PriceClass_200 → PriceClass_100 (immediate, no downtime)
2. Add cache header optimization (review cache behavior)
3. Enable S3 Intelligent-Tiering when ready (no breaking changes)
