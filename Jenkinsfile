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
        sh '''
          docker run --rm \
            -v $(pwd):/project \
            aquasec/trivy:latest config /project/terraform
        '''
      }
    }

    stage('Terraform Init & Plan') {
      steps {
        sh '''
          docker run --rm \
            -v $(pwd)/terraform:/infra \
            -w /infra \
            hashicorp/terraform:1.6 \
            init
          
          docker run --rm \
            -v $(pwd)/terraform:/infra \
            -w /infra \
            hashicorp/terraform:1.6 \
            plan
        '''
      }
    }
  }
}
