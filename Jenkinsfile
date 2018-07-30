pipeline {
  agent { 
    node {
      label 'master'
      customWorkspace "/temp/.jenkins_${env.BRANCH_NAME}_site"
    }
  }
  parameters {
    string(name: 'GLUON_VERSION', defaultValue: 'v2017.1.8', description: 'Gluon version')
  }
  stages {
      stage('prepare build') {
          steps {
            rocketSend channel: 'firmware_builds', message: 'Build started'
            echo "Running ${env.BUILD_ID} on on ${env.JENKINS_URL}"
            checkout scm
            sh "sh -x build-jenkins.sh ${env.BRANCH_NAME} ${params.GLUON_VERSION}"
          }
      }
      stage('build ar71xx-generic') {
          steps {
            dir("/temp/${env.BRANCH_NAME}") {
              sh "make -j7 V=s GLUON_TARGET=ar71xx-generic GLUON_BRANCH=experimental GLUON_RELEASE=${params.GLUON_VERSION}"
            }
          }
      }
      stage('build ar71xx-tiny') {
          steps {
            dir("/temp/${env.BRANCH_NAME}") {
              sh "make -j7 V=s GLUON_TARGET=ar71xx-tiny GLUON_BRANCH=experimental GLUON_RELEASE=${params.GLUON_VERSION}"
            }
          }
      }
      stage("build ar71xx-nand") {
          steps {
            dir("/temp/${env.BRANCH_NAME}") {
              sh "make -j7 V=s GLUON_TARGET=ar71xx-nand GLUON_BRANCH=experimental GLUON_RELEASE=${params.GLUON_VERSION}"
            }
          }
      }
      stage("build brcm2708-bcm2708") {
          steps {
            dir("/temp/${env.BRANCH_NAME}") {
              sh "make -j7 V=s GLUON_TARGET=brcm2708-bcm2708 GLUON_BRANCH=experimental GLUON_RELEASE=${params.GLUON_VERSION}"
            }
          }
      }
      stage("build brcm2708-bcm2709") {
          steps {
            dir("/temp/${env.BRANCH_NAME}") {
              sh "make -j7 V=s GLUON_TARGET=brcm2708-bcm2709 GLUON_BRANCH=experimental GLUON_RELEASE=${params.GLUON_VERSION}"
            }
          }
      }
      stage('build mpc85xx-generic') {
          steps {
            dir("/temp/${env.BRANCH_NAME}") {
              sh "make -j7 V=s GLUON_TARGET=mpc85xx-generic GLUON_BRANCH=experimental GLUON_RELEASE=${params.GLUON_VERSION}"
            }
          }
      }
       stage('build ramips-mt7621') {
          steps {
            dir("/temp/${env.BRANCH_NAME}") {
              sh "make -j7 V=s GLUON_TARGET=ramips-mt7621 GLUON_BRANCH=experimental GLUON_RELEASE=${params.GLUON_VERSION}"
            }
          }
      }
      stage('build x86-generic') {
          steps {
            dir("/temp/${env.BRANCH_NAME}") {
              sh "make -j7 V=s GLUON_TARGET=x86-generic GLUON_BRANCH=experimental GLUON_RELEASE=${params.GLUON_VERSION}"
            }
          }
      }
      stage('build x86-geode') {
          steps {
            dir("/temp/${env.BRANCH_NAME}") {
              sh "make -j7 V=s GLUON_TARGET=x86-geode GLUON_BRANCH=experimental GLUON_RELEASE=${params.GLUON_VERSION}"
            }
          }
      }
      stage('build x86-64') {
          steps {
            dir("/temp/${env.BRANCH_NAME}") {
              sh "make -j7 V=s GLUON_TARGET=x86-64 GLUON_BRANCH=experimental GLUON_RELEASE=${params.GLUON_VERSION}"
            }
          }
      }
      stage('move images') {
          steps {
            sh "mkdir -p /mnt/images/${env.BRANCH_NAME}"
            sh "yes | cp -rf /temp/${env.BRANCH_NAME}/output/images/ /mnt/images/${env.BRANCH_NAME}/"
          }
      }
      stage('clean directory') {
          steps {
            sh "rm -r /temp/${env.BRANCH_NAME}"
          }
      }
  }
  post { 
      failure { 
          rocketSend channel: 'firmware_builds', message: 'Build error'
      }
  }
}
