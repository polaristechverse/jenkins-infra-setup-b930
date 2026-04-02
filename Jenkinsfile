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
    }
}