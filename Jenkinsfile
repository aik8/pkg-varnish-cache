env.VERSION = '6'
pipeline {
    agent {
        docker {
            image 'ubuntu:jammy'
            args '-u root:sudo -e DEBIAN_FRONTEND=noninteractive -e DEBFULLNAME=Jiannis -e DEBEMAIL=email@example.com '
        }
        
    }
    
    stages {
        stage('Update') {
            steps {
                sh 'apt-get update'
                sh 'apt-get upgrade -y'
                sh 'apt-get dist-upgrade -y'
            }
        }
        stage ('Install Deps') {
            steps {
                sh 'ln -fs /usr/share/zoneinfo/Europe/Athens /etc/localtime'
                sh 'apt-get install -y build-essential devscripts dh-make fakeroot lintian debhelper git pkg-config python3-docutils python3-sphinx curl libpcre2-dev libpcre3-dev libjemalloc-dev libedit-dev libncurses-dev libtool autoconf automake python3-pytest rename wget'
            }
        }
        stage ('Build') {
            steps {
                git 'https://github.com/aik8/pkg-varnish-cache.git'
                sh './build-pkg.sh ${VERSION} ${BUILD_NUMBER}'
            }
        }
    }
    
    post {
        success {
            archiveArtifacts artifacts: '*.deb', fingerprint: true
        }
    }
}
