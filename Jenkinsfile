pipeline {
    agent any

    tools {
        maven 'maven'
    }
    
    environment {     
        DOCKERHUB_CREDENTIALS= credentials('docker-credentials')
        DOCKER_REGISTRY = "rixcypz/jenkinstest"
    } 
    
    stages {

        stage('Git Clone') {
            steps {
                cleanWs()
                dir('sourcecode'){
                    sh """
                    git clone https://github.com/RixCypz/basicjenkins.git
                    """    
                }
                
            }
        }

        stage('Build .jar') {
            steps {
                dir('sourcecode/basicjenkins'){
                    sh """
                        mvn --version
                        mvn clean install
                    """   
                }
                
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    withEnv(["PATH+DOCKER=/usr/local/bin"]) {
                        dir('sourcecode/basicjenkins'){
                            sh """
                                sudo minikube delete
                                sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-arm64
                                sudo install minikube-darwin-arm64 /usr/local/bin/minikube
                                sudo minikube start --driver=docker --force
                                sudo minikube profile list
                                sudo minikube status
                                eval \$(sudo minikube docker-env)
                                
                                sudo docker build -t mytestapp:latest .
                                sudo docker image prune -f
                                sudo docker images
                            """
                        }
                    }
                }
            }
        }
        
        stage('Deploy K8s'){
            steps {
                script {
                    withCredentials([file(credentialsId: 'kube-credentials', variable: 'KUBECONFIG_FILE')]) {
                        withEnv(["PATH+DOCKER=/usr/local/bin"]) {
                            dir('sourcecode/basicjenkins'){
                                withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                                    withEnv(["DOCKERHUB_CREDENTIALS_USR=${DOCKER_USERNAME}", "DOCKERHUB_CREDENTIALS_PSW=${DOCKER_PASSWORD}"]) {
                                        sh """
                                            rm /var/root/.docker/config.json
                                            echo $DOCKERHUB_CREDENTIALS_PSW | docker login --username $DOCKERHUB_CREDENTIALS_USR --password-stdin
                                            docker tag mytestapp:latest rixcypz/jenkinstest
                                            docker push rixcypz/jenkinstest
                                        """
                                        
                                    }
                                }


                                sh """
                                    sudo minikube status
                                    sudo cat /var/root/.kube/config
                                    sudo kubectl --kubeconfig=/var/root/.kube/config apply -f deployment.yaml
            
                                    sudo kubectl --kubeconfig=/var/root/.kube/config rollout status deployment/server-deployment

                                    sudo kubectl --kubeconfig=/var/root/.kube/config get deployment
                                    sudo kubectl --kubeconfig=/var/root/.kube/config describe deployment server-deployment
                                    sudo kubectl --kubeconfig=/var/root/.kube/config get pod
                                    
                                """
                            }
                        }
                    }
                }   
            }            
        }
    }
    // post {
    //     always{
    //         cleanWs()
    //     }
    // }
}