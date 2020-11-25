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
	    }
	    failure {
	      echo "Build failed!"
	    }
      }
    }
	stage('Push Images') {
	  when { branch 'jenkins-configuration' }
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', 'MyDockerHubCredentials') {
            def image = docker.image("3176a6a/carrentalsystem-identity")
            image.push(1.1.$env.BUILD_ID)
            //image.push('latest')
          }
		  //Todo: create for all services
        }
      }
    }
  }
}
