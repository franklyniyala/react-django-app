pipeline{
    agent any
    tools{
        git 'git'
    }
    
    stages{
        
        stage('Checkout Code'){
            steps{
                git branch: main,
                credentialsId: 'GITHUB_CRED',
                url: 'https://github.com/franklyniyala/react-django-app.git'
            }
        }

        stage('Build Frontend'){
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
                    sh 'python manage.py test'
                }
            }
        }

        stage('Build Docker Image'){
            steps{
                sh 'docker compose build'
            }
        }

        stage(Login Docker){
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