# set variable from file
terraform.tfvars

```
region = "ap-northeast-1"
db_name = "root"
db_password = "hogefuga"
```

# set variable from command line

```
$ terraform plan \
  -var 'region=ap-northeast-1' \
  -var 'db_name=root'
  -var 'db_name=hogefuga'
```
