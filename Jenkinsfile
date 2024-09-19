pipeline {
	agent {
		docker { image 'ubuntu:noble' }
	}
	stages {
		stage('Update') {
			steps {
				sh 'sudo apt-get update'
				sh 'sudo apt-get full-upgrade -y'
			}
		}
	}
}
