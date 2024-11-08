pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "app"      // Docker image name
        VERSION = "1.0"           // Image tag
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/aishwaryar20115/app.git' // Your actual repo URL
            }
        }

        stage('Build') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${VERSION}")
                }
            }
        }

        stage('Deploy to Blue Environment') {
            steps {
                script {
                    // Stop and remove any existing "app-blue" container
                    sh 'docker rm -f app-blue || true'
                    // Deploy the new "app-blue" container
                    sh 'docker run -d -p 8082:8080 --name app-blue ${DOCKER_IMAGE}:${VERSION}'
                }
            }
        }

        stage('Testing') {
            steps {
                script {
                    sh 'curl http://localhost:8082/health' // Adjust based on your app's health check endpoint
                }
            }
        }

        stage('Deploy to Green Environment') {
            steps {
                script {
                    // Stop and remove any existing "app-green" container
                    sh 'docker rm -f app-green || true'
                    // Deploy the new "app-green" container
                    sh 'docker run -d -p 8083:8080 --name app-green ${DOCKER_IMAGE}:${VERSION}'
                }
            }
        }

        stage('Switch Traffic') {
            steps {
                echo "Switching traffic to the green environment..."
                // Code to manage traffic switching (e.g., updating a load balancer) would go here
            }
        }

        stage('Clean up') {
            steps {
                script {
                    sh 'docker stop app-blue || true && docker rm app-blue || true'
                }
            }
        }
    }
}
