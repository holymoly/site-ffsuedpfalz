pipeline {
    agent { 
      node {
        label 'master'
        customWorkspace "/temp/${env.BRANCH_NAME}_${env.BUILD_ID}"
      }
    } 
    stages {
        stage('Example Build') {
            steps {
               echo "Running ${env.BUILD_ID} on on ${env.JENKINS_URL}"
            }
        }
    }
}
