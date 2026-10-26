pipeline {

    agent { label 'podman' }



    options {

        timestamps()

        skipDefaultCheckout(true)

    }



    environment {

        REGISTRY = 'registry.assign.sli366.300.ops:5000'

        IMAGE = 'bind-secondary'

        REGISTRY_AUTH_FILE = "${WORKSPACE}/.registry-auth.json"

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

                withCredentials([
                    usernamePassword(
                        credentialsId: 'registry-creds',
                        usernameVariable: 'REG_USER',
                        passwordVariable: 'REG_PASS'
                    )
                ]) {
                    sh '''
                        set +x
                        printf '%s' "$REG_PASS" | podman login \
                            --authfile "$REGISTRY_AUTH_FILE" \
                            --username "$REG_USER" \
                            --password-stdin \
                            "$REGISTRY"

                        SHORT_SHA=$(git rev-parse --short=7 HEAD)

                        podman push \
                            --authfile "$REGISTRY_AUTH_FILE" \
                            ${REGISTRY}/${IMAGE}:${BUILD_NUMBER}

                        podman push \
                            --authfile "$REGISTRY_AUTH_FILE" \
                            ${REGISTRY}/${IMAGE}:${SHORT_SHA}
                       '''
                }
            }
        }
    }

    post {
        always {
            sh '''
                rm -f "$REGISTRY_AUTH_FILE"
            '''
        }
    }
}
