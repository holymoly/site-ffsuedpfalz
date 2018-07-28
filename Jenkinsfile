node {
    /* .. snip .. */
    stage('Build') {

        deleteDir()
        echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
        echo "Branch: ${env.BRANCH_NAME}"
        echo "Workspace: ${WORKSPACE}"
        rocketSend channel: 'firmware_builds', message: 'Build started'
        checkout scm
        sh "sh -x build-jenkins.sh ${env.BRANCH_NAME}"
        rocketSend channel: 'firmware_builds', message: 'Build finished'
    }
    post { 
        failure { 
            rocketSend channel: 'firmware_builds', message: 'Build error'
        }
    }
}
