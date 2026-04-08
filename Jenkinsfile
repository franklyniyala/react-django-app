pipeline{
    agent any

    tools {
        nodejs 'NodeJS-20' 
    }
    
    stages{
        
        stage('Checkout Code'){
            steps{
                git branch: 'main',
                credentialsId: 'GITHUB_LOGIN',
                url: 'https://github.com/franklyniyala/react-django-app.git'
            }

        }

        stage ('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh '''
                    docker run --rm \
                    -e SONAR_TOKEN=$SONAR_TOKEN \
                    -v $(pwd):/usr/src \
                    sonarsource/sonar-scanner-cli \
                    -Dsonar.projectKey=frank-org_reactdjango \
                    -Dsonar.organization=frank-org \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=https://sonarcloud.io \
                    '''
                }
            }
        }

        stage('Build Frontend Image'){
            steps{
                dir('frontend'){
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Build Backend'){
            steps{
                dir('backend'){
                    sh 'pip install -r requirements.txt'
                }
            }
        }

        stage('Run Tests'){
            steps{
                dir('backend'){
                    sh 'python3 manage.py test'
                }
            }
        }

        stage('Build Docker Image'){
            steps{
                sh 'docker compose build'
            }
        }

        stage('Docker Login'){
            steps{
                withCredentials([usernamePassword(
                    credentialsId: 'DOCKER_LOGIN',
                    usernameVariable: 'USERNAME',
                    passwordVariable: 'PASSWORD'
                )]){
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'

                }
            }
        }

        stage('Push Docker Image'){
            steps{
                sh 'docker compose push'
            }
        }

        stage('Deploy Application'){
            steps{
                sh 'docker compose down'
                sh 'docker compose up -d'
            }
        }

    }

    post{
        success{
            echo ' ✅ Deployment successful!'
        }
        failure{
            echo ' ❌ Deployment failed!'
        }
    }
    
}