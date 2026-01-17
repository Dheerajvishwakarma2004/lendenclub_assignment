pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Security Scan') {
            steps {
                bat '''
                docker run --rm ^
                  -v "%cd%:/project" ^
                  aquasec/trivy:latest config /project/terraform
                '''
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                bat '''
                docker run --rm ^
                -v "%cd%\\terraform:/infra" ^
                -w /infra ^
                hashicorp/terraform:1.6 init -lock=false -reconfigure

                docker run --rm ^
                -v "%cd%\\terraform:/infra" ^
                -w /infra ^
                hashicorp/terraform:1.6 plan -lock=false
                '''
            }
        }
    }
}
