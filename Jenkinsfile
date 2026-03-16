pipeline{
    agent any
    
    stages{
        
        stage('Checkout Code'){
            steps{
                git 'https://github.com/franklyniyala/react-django-app.git'
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

        stage('Build Docker Images'){
            steps{
                sh 'docker compose build'
            }
        }

        stage('Deploy Application'){
            steps{
                sh 'docker compose down'
                sh 'docker compose up -d'
            }
        }

    }
    
}