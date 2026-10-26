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
                    credentialsId: 'github-pat',
                    url: 'https://github.com/sli366/ops300-bind-secondary.git'
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                    set -eu
                    SHORT_SHA=$(git rev-parse --short=7 HEAD)
                    podman build -f Dockerfile -t "$REGISTRY/$IMAGE:$BUILD_NUMBER" -t "$REGISTRY/$IMAGE:$SHORT_SHA" .
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
                        set -eu
                        set +x

                        AUTH_FILE=$(mktemp -u)
                        trap 'rm -f "$AUTH_FILE"' EXIT

                        printf '%s' "$REG_PASS" | podman login --authfile "$AUTH_FILE" --username "$REG_USER" --password-stdin "$REGISTRY"

                        SHORT_SHA=$(git rev-parse --short=7 HEAD)

                        podman push --authfile "$AUTH_FILE" "$REGISTRY/$IMAGE:$BUILD_NUMBER"
                        podman push --authfile "$AUTH_FILE" "$REGISTRY/$IMAGE:$SHORT_SHA"
                    '''
                }
            }
        }
    }
}
