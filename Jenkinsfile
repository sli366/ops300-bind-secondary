pipeline {

    agent { label 'podman' }



    options {

        timestamps()

        skipDefaultCheckout(true)

    }



    environment {

        REGISTRY = 'registry.assign.sli366.300.ops:5000'

        IMAGE = 'bind-secondary'

    }



    stages {

        stage('Checkout') {

            steps {

                git branch: 'main',

                    url: 'https://github.com/sli366/ops300-bind-secondary.git',

                    credentialsId: 'github-pat'

            }

        }



        stage('Build Image') {

            steps {

                sh '''

                    podman build -t ${IMAGE}:${BUILD_NUMBER} .

                '''

            }

        }



        stage('Tag Image') {

            steps {

                sh '''

                    podman tag ${IMAGE}:${BUILD_NUMBER} ${REGISTRY}/${IMAGE}:${BUILD_NUMBER}

                '''

            }

        }



        stage('Push Image') {

            steps {

                sh '''

                    podman push ${REGISTRY}/${IMAGE}:${BUILD_NUMBER}
                '''
            }
        }
    }
}
