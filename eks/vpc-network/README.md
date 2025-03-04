```
aws s3 mb s3://edexa-mainnet-infra --region eu-central-1 --profile mainnet
```

```
aws s3api put-bucket-versioning --bucket edexa-mainnet-infra --versioning-configuration Status=Enabled --profile mainnet
```
