pipeline {
	agent {
		docker { image 'ubuntu:noble' }
	}
	stages {
		stage('Update') {
			steps {
				sh 'apt update'
				sh 'apt full-upgrade -y'
			}
		}
	}
}
