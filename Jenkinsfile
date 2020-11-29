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
    stage('Run Integration Tests') {
      steps {
        powershell(script: './Tests/ContainerTests.ps1')  //Todo: Here my test files
      }
    }
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
	  when { branch 'main' }
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', 'MyDockerHubCredentials') {
            def identity = docker.image("3176a6a/carrentalsystem-identity")
            identity.push(env.BUILD_ID)
            def dealers = docker.image("3176a6a/carrentalsystem-dealers")
            dealers.push(env.BUILD_ID)
            def statistics = docker.image("3176a6a/carrentalsystem-statistics")
            statistics.push(env.BUILD_ID)
            def notifications = docker.image("3176a6a/carrentalsystem-notifications")
            notifications.push(env.BUILD_ID)
            def client = docker.image("3176a6a/carrentalsystem-client")
            client.push(env.BUILD_ID)
            def admin = docker.image("3176a6a/carrentalsystem-admin")
            admin.push(env.BUILD_ID)
            def watchdog = docker.image("3176a6a/carrentalsystem-watchdog")
            watchdog.push(env.BUILD_ID)
          }
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
