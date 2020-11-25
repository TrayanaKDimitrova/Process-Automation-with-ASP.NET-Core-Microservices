pipeline {
  agent any
  stages {
     stage('Verify Branch') {
       steps {
         echo "$GIT_BRANCH"
       }
     }	
	 stage('Run Unit Tests') {
      steps {
        powershell(script: """ 
          cd Server
          dotnet test
          cd ..
        """)
      }
    }
    stage('Docker Build') {
      steps {
        powershell(script: 'docker-compose build')     
        powershell(script: 'docker images -a')
      }
    }
	 stage('Run Test Application') {
      steps {
        powershell(script: 'docker-compose up -d')    
      }
    }
  //   stage('Run Integration Tests') {
  //     steps {
  //       powershell(script: './Tests/ContainerTests.ps1')  //Todo: Here my test files
  //     }
  //   }
	stage('Stop Test Application') {
      steps {
        powershell(script: 'docker-compose down') 
        //powershell(script: 'docker volumes prune -f')   		
      }
      post {
        success {
          echo "Build successfull!"
          emailext body: 'Pipeline Finished: Success', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Car Rental System'
        }
        failure {
          echo "Build failed!"
          emailext body: 'Pipeline Failed :(', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Car Rental System'
        }
      }
    }
	stage('Push Images') {
	  when { branch 'jenkins-configuration' }
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', 'MyDockerHubCredentials') {
            def image = docker.image("3176a6a/carrentalsystem-identity")
            image.push(env.BUILD_ID)
            //image.push('latest')
          }
		  //Todo: create for all services
        }
      }
      post {
        success {
          echo "Images pushed!"
          emailext body: 'Images Pushed', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Car Rental System'
        }
        failure {
          echo "Images push failed!"
          emailext body: 'Images Push Failed', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Car Rental System'
        }
      }
    }
  }
}
