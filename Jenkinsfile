pipeline {
    agent any

    environment {
        AWS_ACCES_KEY_ID = credentials('AWS_ACCES_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Set Terraform Path') {
            steps {
                script {
                    def tfHome = tool name: 'Terraform'
                    env.PATH = "${tfHome}:${env.PATH}"
                }
                sh 'terraform -version'
            }
        }

        stage('Provision infrastructure') {
            steps {
                dir('dev') {
                    sh 'terraform init'
                    sh "terraform plan -out=plan \
                        -var AWS_ACCES_KEY=$AWS_ACCES_KEY_ID \
                        -var AWS_SECRET_ACCESS=$AWS_SECRET_ACCESS_KEY"
                    // sh ‘terraform destroy -auto-approve’
                    sh 'terraform apply plan'
                }
            }
        }

        stage('Destroy infrastructure') {
            steps {
                dir('dev') {
                    sh "terraform destroy -auto-approve \
                    -var AWS_ACCES_KEY=$AWS_ACCES_KEY_ID \
                    -var AWS_SECRET_ACCESS=$AWS_SECRET_ACCESS_KEY"
                }
            }
        }
    }
}