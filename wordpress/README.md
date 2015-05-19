# set variable from file
terraform.tfvars

```
region = "ap-northeast-1"
db_name = "root"
db_password = "hogefuga"
ami = "ami-111111"
key_name = "hogeKeyPair"
ssh_key_file = "/User/hogefuga/awskey/hogefuga.pem"
```

# set variable from command line

```
$ terraform plan \
  -var 'region=ap-northeast-1' \
  -var 'db_name=root' \
  -var 'db_name=hogefuga' \
  -var 'ami=ami-111111' \
  -var 'key_name=hogeKeyPair' \
  -var 'ssh_key_file='/User/hogefuga/awskey/hogefuga.pem' \
```
