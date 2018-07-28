node {
    /* .. snip .. */
    stage('Build') {
        deleteDir()
        echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
        echo "Branch: ${env.BRANCH_NAME}"
        echo "Workspace: ${WORKSPACE}"
        rocketSend avatar: 'https://www.google.de/imgres?imgurl=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2Fe%2Fe9%2FJenkins_logo.svg%2F2000px-Jenkins_logo.svg.png&imgrefurl=https%3A%2F%2Fcommons.wikimedia.org%2Fwiki%2FFile%3AJenkins_logo.svg&docid=gnswB3GeNZr3eM&tbnid=gXedvlbTkRzaBM%3A&vet=10ahUKEwj_hpSL28LcAhVCJhoKHTFwCBcQMwg3KAAwAA..i&w=2000&h=2761&safe=off&bih=703&biw=1280&q=jenkins&ved=0ahUKEwj_hpSL28LcAhVCJhoKHTFwCBcQMwg3KAAwAA&iact=mrc&uact=8', channel: 'firmware_builds', message: 'Build started'
        checkout scm
        sh "sh -x build-jenkins.sh ${env.BRANCH_NAME}"
    }
}
