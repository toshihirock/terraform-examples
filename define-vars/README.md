## define variables from file

`$vi terraform.tfvars`

```
key_name = "foo"
ami = "ami-xxxxxx"
```

## define variable form CLI

```
$ terraform plan \
  -var 'key_name=foo' \
  -var 'ami=ami-xxxxxx'
```
