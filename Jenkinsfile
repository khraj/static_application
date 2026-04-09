pipeline{
  agent any

  environment {
    DOCKER_CREDS = credentials('docker-hub-credentials')
    DOCKER_IMAGE = "${DOCKER_CREDS_USR}/static-website"
    IMAGE_TAG = "${BUILD_NUMBER}"
  }
  stages{
    stage ('cloning repo'){
      steps {
        sh '''
      rm -r static_application
      git clone https://github.com/khraj/static_application.git
      cd static_application
      git checkout main
      ls
      '''
    }
    }
    stage ('Docker image build'){
      steps {
        sh '''
        docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
        docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
        echo "Docker Image was built successully"
        docker images | grep static-website
        '''
      }
    }
    stage('Push to dockerhub'){
      steps {
        sh '''
        echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin
        docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
        docker push ${DOCKER_IMAGE}:latest
        docker logout
        '''
      }
    }
    stage('Spinning the docker container'){
      steps{
        sh '''
        docker run -d -p 8092:80 --name=static-website --restart=always ${DOCKER_IMAGE}:latest
        '''
      }
    }
    stage('Verify the deployment'){
      steps {
        sh '''
        sleep 5
        docker ps | grep static-website
        curl http://localhost:8092 | head -n 20
        '''

        echo "website is live"
      }
    }
  }

  post {
        success {
            echo "========== PIPELINE SUCCESS =========="
            echo "✓ Deployment completed successfully"
            echo "✓ Website accessible at: http://localhost:8092"
        }
        failure {
            echo "========== PIPELINE FAILED =========="
            echo "Check logs above for errors"
        }
    }
  
}
