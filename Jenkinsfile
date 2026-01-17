pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        echo 'Code checked out successfully'
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          cd terraform
          terraform init
        '''
      }
    }
  }
}
