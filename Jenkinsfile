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

                    SHORT_SHA=$(git rev-parse --short=7 HEAD)

                    podman build \

                        -t ${REGISTRY}/${IMAGE}:${BUILD_NUMBER} \

                        -t ${REGISTRY}/${IMAGE}:${SHORT_SHA} \

                        .

                '''

            }

        }



        stage('Push Image') {

            steps {

                sh '''

                    SHORT_SHA=$(git rev-parse --short=7 HEAD)

                    podman push ${REGISTRY}/${IMAGE}:${BUILD_NUMBER}
                    podman push ${REGISTRY}/${IMAGE}:${SHORT_SHA}
                '''
            }
        }
    }
}
