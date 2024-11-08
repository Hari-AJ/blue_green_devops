pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "app"      // Docker image name
        VERSION = "1.0"           // Image tag
    }

    stages {
        // 1. Pulls the latest code from the repository
        stage('Checkout') {
            steps {
                git url: 'https://github.com/aishwaryar20115/app' // Replace with your actual repo
            }
        }

        // 2. Builds the Docker image for your application
        stage('Build') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${VERSION}")
                }
            }
        }

        // 3. Deploys the app to the "blue" environment on port 8082
        stage('Deploy to Blue Environment') {
            steps {
                script {
                    sh 'docker run -d -p 8082:8080 --name app-blue ${DOCKER_IMAGE}:${VERSION}'
                }
            }
        }

        // 4. Tests the blue environment to ensure it's running correctly
        stage('Testing') {
            steps {
                script {
                    sh 'curl http://localhost:8082/health' // Adjust based on your app's health check endpoint
                }
            }
        }

        // 5. Deploys the app to the "green" environment on port 8083
        stage('Deploy to Green Environment') {
            steps {
                script {
                    sh 'docker run -d -p 8083:8080 --name app-green ${DOCKER_IMAGE}:${VERSION}'
                }
            }
        }

        // 6. Switches production traffic to the "green" environment
        stage('Switch Traffic') {
            steps {
                echo "Switching traffic to the green environment..."
                // Here you might configure a load balancer to point to port 8083 or manage routing as needed
            }
        }

        // 7. Cleans up the "blue" environment after switching
        stage('Clean up') {
            steps {
                script {
                    sh 'docker stop app-blue || true && docker rm app-blue || true'
                }
            }
        }
    }
}
