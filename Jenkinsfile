pipeline {
    agent {
        label 'Dev'
    }
       parameters {
        choice(
            name: 'PACKER_BUILD', choices: ['no', 'yes'], description: 'Select the build requirement'
        )
        choice(name: 'Terraform_BUILD', choices: ['no', 'yes'], description: 'Select the build requirement')
        choice(name: 'Terraform_Destroy', choices: ['no', 'yes'], description: 'Select the build requirement')
    }
    stages{
        stage('Check the software') {
            steps{
                sh '''
                terraform version
                packer version
                '''
            }
        }
        stage('Packer validate') {
             steps{
                sh '''
                packer version
                packer plugins install github.com/hashicorp/amazon
                packer validate --var-file packer-vars.json packer.json
                '''
             }
        }
        stage('Packer_build') {
               when {
                expression { return params.PACKER_BUILD == 'yes' }
             }
             steps{
                sh 'packer build --var-file packer-vars.json packer.json'
             }
        }
        stage('capture amiid'){
            when{
                expression { return params.PACKER_BUILD == 'yes' }
            }
            steps{
                sh '''
                AMI_ID=$(jq -r '.builds[-1].artifact_id' manifest.json | cut -d ':' -f2)
                echo "Extracted AMI: $AMI_ID"
                sed -i "s/^ami *= *.*/ami = \\"$AMI_ID\\"/" terraform.tfvars
                echo "Updated terraform.tfvars:"
                cat terraform.tfvars
                '''
            }
        }
        stage('capture the latest ami'){
            steps {
                sh '''
                AMIID=$(aws ec2 describe-images --owners self --query 'Images | sort_by(@, &CreationDate)[-1].ImageId' --output text)
                echo "Extracted AMI: $AMIID"
                sed -i "s/^ami *= *.*/ami = \\"$AMIID\\"/" terraform.tfvars
                echo "Updated terraform.tfvars:"
                cat terraform.tfvars
                '''
            }
        }
        stage('Terraform_Setup'){
            when {
                expression { return params.Terraform_BUILD == 'yes' }
            }
            steps{
                sh '''
                terraform version
                terraform init
                terraform fmt
                terraform validate
                terraform plan 
                terraform apply --auto-approve
                '''
            } 
        }
        stage('Terraform_Destory') {
            when {
                expression { return params.Terraform_Destroy == 'yes' }
            }
            steps {
                sh 'terraform destroy --auto-approve'
            }
        }
    }
}