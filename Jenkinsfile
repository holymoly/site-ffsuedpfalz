pipeline {
    agent { 
      node {
        label 'master'
        customWorkspace "/temp/.jenkins_${env.BRANCH_NAME}_site"
      }
    } 
    stages {
        stage('Clean directory') {
            steps {
              deleteDir()
            }
        }
        stage('Example Build') {
            steps {
              rocketSend channel: 'firmware_builds', message: 'Build started'
              echo "Running ${env.BUILD_ID} on on ${env.JENKINS_URL}"
              checkout scm
              sh "sh -x build-jenkins.sh ${env.BRANCH_NAME}"
            }
        }
    }
    post { 
        failure { 
            rocketSend channel: 'firmware_builds', message: 'Build error'
        }
    }
}
