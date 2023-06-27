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
                sh """
                    mvn --version
                    cd basicjenkins
                    ls
                    mvn clean install
                """
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    withEnv(["PATH+DOCKER=/usr/local/bin"]) {
                        sh """
                            docker pull openjdk:17-jdk-slim-buster
                            cd basicjenkins
                            minikube start
                            eval $(minikube docker-env)   
                            docker build -t mytestapp .
                        """
                    }
                }
            }
        }
        
        stage('Deploy K8s'){
            steps {
                script {
                    withEnv(["PATH+DOCKER=/usr/local/bin"]){
                        sh """
                            kubectl apply -f deployment.yaml
                            kubectl get all
                            POD_NAME=$(kubectl get pods -l app=server -o jsonpath='{.items[0].metadata.name}')
                            kubectl logs $POD_NAME
                        """
                    }
                }
            }            
        }
        // stage('Docker Run') {
        //     steps {
        //         script {
        //             withEnv(["PATH+DOCKER=/usr/local/bin"]) {
        //                 sh """
        //                     docker run -p 8081:8081 mytestapp
        //                 """
        //             }
        //         }
        //     }
        // }
    }
    // post {
    //     always{
    //         cleanWs()
    //     }
    // }
}