pipeline {
    agent any
    stages {
        stage('Git Clone') {
            steps {
                sh """
                git clone https://github.com/RixCypz/basicjenkins.git
                """
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                docker build -t mytestapp .
                """
            }
        }

        stage('Docker Run') {
            steps {
                sh """
                docker run -p 8081:8081 mytestapp
                """
            }
        }

        stage('Clean up') {
            steps {
                cleanWs()
            }
        }

    }
}