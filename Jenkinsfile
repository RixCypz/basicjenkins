pipeline {
    agent any

    tools {
        maven 'maven'
    }
    
    stages {
        stage('Git Clone') {
            steps {
                cleanWs()
                sh """
                git clone https://github.com/RixCypz/basicjenkins.git
                """
            }
        }

        stage('Build .jar') {
            steps {
                sh 'mvn clean install'
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

        // stage('Clean up') {
        //     steps {
        //         cleanWs()
        //     }
        // }

    }
    post {
        always{
            cleanWs()
        }
    }
}