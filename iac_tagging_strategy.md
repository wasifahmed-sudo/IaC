# Enterprise Infrastructure as Code Tagging Strategy

## 1. Tag Classification System

### **Release Type Tags**
```
stable/{version}     - Production-ready releases
hotfix/{version}     - Critical fixes for production issues  
bugfix/{version}     - Non-critical bug fixes
security/{version}   - Security patches and updates
feature/{version}    - New functionality releases
experimental/{version} - Experimental/beta features
rollback/{version}   - Rollback-specific releases
```

### **Environment Promotion Tags**
```
promoted-dev/{version}
promoted-staging/{version}  
promoted-prod/{version}
```

### **Change Classification Tags**
```
breaking-change/{version}  - Requires manual intervention
backward-compatible/{version} - Safe to auto-deploy
infrastructure-only/{version} - No application impact
database-migration/{version} - Contains DB changes
network-change/{version}     - Network topology changes
```

## 2. Tag Naming Convention

### **Primary Format**
```
{release_type}/{major}.{minor}.{patch}-{modifier}
```

**Examples:**
- `stable/8.7.5`
- `hotfix/8.7.6-critical`
- `security/8.7.7-cve-2024-001`
- `bugfix/8.7.8-minor`
- `feature/8.8.0-eks-upgrade`

### **Secondary Classification Tags**
```
impact-{level}/{version}     # high, medium, low
risk-{level}/{version}       # high, medium, low  
tested-{env}/{version}       # dev, staging, prod
approved-{team}/{version}    # security, platform, compliance
```

## 3. Enterprise Status Dashboard

| Region | Environment | Version | Release Type | Impact | Risk | Test Status | Approval | Deployed By | Date |
|--------|-------------|---------|--------------|--------|------|-------------|----------|-------------|------|
| West | prod | v1.7.4 | `stable/1.7.4` | 🔴 High | 🔴 High | ❌ Outdated | ❌ Expired | wasif | 2024-07-15 |
| West | prod-dr | v1.8.4 | `hotfix/1.8.4-db` | 🔴 High | 🔴 High | ❌ Outdated | ❌ Expired | wasif | 2024-07-20 |
| Central | prod | v8.7.5 | `stable/8.7.5` | 🟡 Medium | 🟡 Medium | ✅ Staging | ✅ Platform | wasif | 2024-08-20 |
| Central | prod-dr | v8.7.5 | `stable/8.7.5` | 🟡 Medium | 🟡 Medium | ✅ Staging | ✅ Platform | wasif | 2024-08-20 |
| Central | staging | v8.7.5 | `stable/8.7.5` | 🟡 Medium | 🟡 Medium | ✅ Dev | ✅ Platform | wasif | 2024-08-20 |
| Central | dev | v8.7.5 | `stable/8.7.5` | 🟡 Medium | 🟡 Medium | ✅ Unit | ✅ Dev Team | wasif | 2024-08-20 |
| Central | test | v8.7.5 | `stable/8.7.5` | 🟡 Medium | 🟡 Medium | ✅ Unit | ✅ Dev Team | wasif | 2024-08-20 |
| East | prod | v8.7.5 | `stable/8.7.5` | 🟡 Medium | 🟡 Medium | ✅ Staging | ✅ Platform | wasif | 2024-08-20 |
| East | prod-dr | v8.8.7 | `stable/8.8.7` | 🟢 Low | 🟢 Low | ✅ Prod | ✅ All Teams | wasif | 2024-08-26 |
| East | staging | v8.7.5 | `stable/8.7.5` | 🟡 Medium | 🟡 Medium | ✅ Dev | ✅ Platform | wasif | 2024-08-20 |
| East | dev | v8.7.5 | `stable/8.7.5` | 🟡 Medium | 🟡 Medium | ✅ Unit | ✅ Dev Team | wasif | 2024-08-20 |

## 4. Release Pipeline with Tag Management

### **Development Flow**
```
1. Feature Development
   └── feature/8.9.0-vpc-redesign
   
2. Testing & Validation
   └── tested-dev/8.9.0-vpc-redesign
   └── tested-staging/8.9.0-vpc-redesign
   
3. Risk Assessment
   └── risk-high/8.9.0-vpc-redesign (breaking changes)
   └── impact-high/8.9.0-vpc-redesign (network changes)
   
4. Approvals
   └── approved-security/8.9.0-vpc-redesign
   └── approved-platform/8.9.0-vpc-redesign
   └── approved-compliance/8.9.0-vpc-redesign
   
5. Production Release
   └── stable/8.9.0
   └── promoted-prod/8.9.0
```

### **Hotfix Flow**
```
1. Critical Issue Identified
   └── hotfix/8.8.8-security-patch
   
2. Emergency Testing
   └── tested-staging/8.8.8-security-patch
   
3. Risk Assessment
   └── risk-medium/8.8.8-security-patch
   └── impact-high/8.8.8-security-patch
   
4. Fast-track Approval
   └── approved-security/8.8.8-security-patch
   
5. Production Deployment
   └── promoted-prod/8.8.8-security-patch
```

## 5. Tag-Based Automation Rules

### **Deployment Policies**
```yaml
deployment_policies:
  production:
    allowed_tags:
      - "stable/*"
      - "hotfix/*-critical"
      - "security/*"
    required_approvals:
      - "approved-security/*"
      - "approved-platform/*"
    required_testing:
      - "tested-staging/*"
  
  staging:
    allowed_tags:
      - "stable/*"
      - "feature/*"
      - "bugfix/*"
      - "hotfix/*"
    required_testing:
      - "tested-dev/*"
  
  development:
    allowed_tags: ["*"]
    required_testing: []
```

### **Automated Tag Management**
```yaml
auto_tagging_rules:
  - trigger: "security_scan_passed"
    action: "add_tag"
    tag: "security-validated/{version}"
    
  - trigger: "compliance_check_passed" 
    action: "add_tag"
    tag: "compliance-approved/{version}"
    
  - trigger: "staging_deployment_success"
    action: "add_tag"  
    tag: "tested-staging/{version}"
    
  - trigger: "production_deployment_success"
    action: "add_tag"
    tag: "promoted-prod/{version}"
```

## 6. Governance Dashboard

### **Release Health Metrics**
| Metric | Current | Target | Status |
|--------|---------|---------|---------|
| Production Environments on Stable Tags | 7/11 | 100% | 🔴 |
| Environments with Security Approval | 9/11 | 100% | 🟡 |
| Environments with Current Testing | 9/11 | 100% | 🟡 |
| Average Deployment Lag | 6 days | 2 days | 🔴 |

### **Risk Assessment**
| Risk Level | Count | Environments | Action Required |
|------------|-------|--------------|-----------------|
| 🔴 Critical | 2 | west-prod, west-prod-dr | Immediate upgrade required |
| 🟡 High | 0 | - | - |
| 🟡 Medium | 9 | Most environments | Schedule upgrade within 1 week |
| 🟢 Low | 1 | east-prod-dr | No action needed |

## 7. Best Practices for Tag Management

### **DO's**
- ✅ Use consistent naming conventions
- ✅ Automate tag creation where possible  
- ✅ Include metadata in tag descriptions
- ✅ Implement tag-based access controls
- ✅ Regular tag cleanup and archival
- ✅ Document tag meanings and usage

### **DON'Ts**  
- ❌ Don't use personal/team-specific tags
- ❌ Don't create tags without approval process
- ❌ Don't deploy untagged releases to production
- ❌ Don't skip testing tags for production releases
- ❌ Don't use ambiguous tag names

## 8. Emergency Procedures

### **Critical Hotfix Process**
1. Create `hotfix/{version}-critical` tag
2. Deploy to staging with `tested-staging/{version}` 
3. Get emergency approval: `approved-security/{version}`
4. Deploy to production with monitoring
5. Add `promoted-prod/{version}` on success

### **Rollback Process**
1. Identify last known good version
2. Create `rollback/{version}-to-{previous_version}` tag
3. Execute rollback with `risk-assessment/{version}`
4. Add `rollback-completed/{version}` tag

This comprehensive tagging strategy provides enterprise-level governance, traceability, and automation capabilities for your Infrastructure as Code deployments.
