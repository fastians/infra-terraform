# static-frontend (S3 + CloudFront)

Hosts the **Mek-Lab simulation SPA** (Vite build) at **mek-lab.com** / **www.mek-lab.com**. Replaces Vercel.

- **Origin:** private S3 bucket (OAC; not public)
- **CDN:** CloudFront with HTTPS (ACM cert in `us-east-1` when using custom domains)
- **SPA routing:** 403/404 → `index.html`

3D viewers (GLTF, legacy GEO meshes) still load data from `https://api.mek-lab.com` in the browser; this module only serves JS/CSS/HTML.

## Apply (production)

```bash
cd infra_terraform
make init ENV=aws-app-production
# In terraform.tfvars:
#   enable_frontend_cdn = true
#   frontend_hostnames = ["mek-lab.com", "www.mek-lab.com"]
#   frontend_route53_zone_id = "<zone id for mek-lab.com>"
make plan ENV=aws-app-production
make apply ENV=aws-app-production
make output ENV=aws-app-production
```

## Deploy build artifacts

```bash
cd infra_ansible
./scripts/deploy-frontend production
```

Requires AWS CLI credentials with `s3:PutObject` on the bucket and `cloudfront:CreateInvalidation`.
