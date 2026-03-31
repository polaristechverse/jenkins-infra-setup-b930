pipeline {
    agent {
        label 'Dev'
    }
       parameters {
        choice(
            name: 'PACKER_BUILD',
            choices: ['no', 'yes'], 
            description: 'Select the build requirement'
        )
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
        stage('Packer build') {
            when {
                expression { return params.PACKER_BUILD == 'yes' }
             }
             steps{
                sh '''
                packer version
                packer validate --var-file packer-vars.json packer.json
                packer plugins install github.com/hashicorp/amazon
                '''
             }
        }
    }
}