pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "aishwaryar20115/app"  // Docker image name, updated to include your Docker Hub repo
        VERSION = "1.0"                       // Image tag
    }

    stages {
        // 1. Checkout the latest code from the repository
        stage('Checkout') {
            steps {
                git url: 'https://github.com/aishwaryar20115/app.git'
            }
        }

        // 2. Build the Docker image for your application
        stage('Build') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${VERSION}")
                }
            }
        }

        // 3. Deploy the app to the "blue" environment on port 8082
        stage('Deploy to Blue Environment') {
            steps {
                script {
                    // Stop and remove any existing "app-blue" container if it exists
                    sh 'docker rm -f app-blue || true'
                    // Run a new "app-blue" container with the specified Docker image and version
                    sh "docker run -d -p 8082:8080 --name app-blue ${DOCKER_IMAGE}:${VERSION}"
                }
            }
        }

        // 4. Testing the Blue environment
        stage('Testing') {
            steps {
                script {
                    // Health check on the "blue" environment; update to your actual health endpoint if necessary
                    sh 'curl --retry 5 --retry-delay 5 --retry-connrefused http://localhost:8082/health || exit 1'
                }
            }
        }

        // 5. Deploy the app to the "green" environment on port 8083
        stage('Deploy to Green Environment') {
            steps {
                script {
                    // Stop and remove any existing "app-green" container if it exists
                    sh 'docker rm -f app-green || true'
                    // Run a new "app-green" container with the specified Docker image and version
                    sh "docker run -d -p 8083:8080 --name app-green ${DOCKER_IMAGE}:${VERSION}"
                }
            }
        }

        // 6. Switch traffic to the Green environment
        stage('Switch Traffic') {
            steps {
                echo "Switching traffic to the green environment..."
                // You may implement actual traffic switching here if using a load balancer
            }
        }

        // 7. Clean up the Blue environment container after switching
        stage('Clean up') {
            steps {
                script {
                    sh 'docker stop app-blue || true && docker rm app-blue || true'
                }
            }
        }
    }

    post {
        always {
            script {
                // Ensure cleanup of any containers left if the build fails unexpectedly
                sh 'docker rm -f app-blue || true'
                sh 'docker rm -f app-green || true'
            }
        }
    }
}
