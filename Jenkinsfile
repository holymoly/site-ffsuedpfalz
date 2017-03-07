node {
    /* .. snip .. */
    stage('Build') {
        ws('/tmp/${env.BRANCH_NAME}/') {
            deleteDir()
            echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
            echo "Branch: ${env.BRANCH_NAME}"
            echo "Workspace: ${WORKSPACE}"
            checkout scm
            sh "sh -x build-jenkins.sh"
        }
    }
}
