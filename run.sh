#!/bin/bash

rm -rf .terraform terraform.tfstate* terraform.tfvars
terraform init
echo "###########################################################################"
echo "THIS WILL WORK JUST FINE, WE'RE JUST SETTING THINGS UP"
echo "###########################################################################"
terraform plan
terraform apply -auto-approve

echo 'subject_alternative_names = ["b.com"]' > terraform.tfvars
echo "###########################################################################"
echo "THIS WILL FAIL, BUT I FEEL LIKE IT SHOULD SUCCEED"
echo "###########################################################################"
terraform apply -auto-approve

echo "###########################################################################"
echo "MAKING THIS MODIFICATION TO main.tf SEEMS TO ALLOW TERRAFORM TO GET THROUGH THE PLAN SUCCESSFULLY AND RUN THE APPLY AS I WOULD EXPECT IT TO"
echo "###########################################################################"
cat main.tf | sed 's/# name/name/' | sed 's/name = "testing/# \0/' > newmain.tf
diff main.tf newmain.tf
mv main.tf oldmain
mv newmain.tf main.tf
terraform plan
terraform apply -auto-approve

mv oldmain main.tf
terraform destroy
