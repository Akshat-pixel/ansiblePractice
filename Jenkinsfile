pipeline {
    
	agent any
	
	tools {
	jdk "jdk17"
        maven "mvn"
    }

    environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "172.31.31.35:8081"
        NEXUS_REPOSITORY = "vprofile"
	NEXUS_REPO_ID    = "vprofile"
        NEXUS_CREDENTIAL_ID = "nexuscred"
        ARTVERSION = "${env.BUILD_ID}"
    }
	
    stages{

        stage('Fetch Code'){
            steps{
                git branch: 'main', url: 'https://github.com/Akshat-pixel/ansiblePractice.git'
            }
        }
        
        stage('BUILD'){
            steps {
                sh 'mvn clean install -DskipTests'
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

	stage('UNIT TEST'){
            steps {
                sh 'mvn test'
            }
        }

	stage('INTEGRATION TEST'){
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }
		
        stage ('CODE ANALYSIS WITH CHECKSTYLE'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
            post {
                success {
                    echo 'Generated Analysis Result'
                }
            }
        }
	/* stage('CODE ANALYSIS with SONARQUBE') {
          
	environment {
             scannerHome = tool 'sonar6.2'
          }

          steps {
            withSonarQubeEnv('sonarserver') {
               sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile \
                   -Dsonar.projectVersion=1.0 \
		    -Dsonar.login=bfc6b9d1b35ab018295a68ce42136a404e652bd0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
            }
          }
        }*/

        stage("Upload Artifact") {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: '172.31.31.35:8081',
                    groupId: 'QA',
                    version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                    repository: 'vprofile',
                    credentialsId: 'nexuscred',
                    artifacts: [
                        [artifactId: 'vproapp',
                        classifier: '',
                        file: 'target/vprofile-v2.war',
                        type: 'war']])
            }
        }
	    stage("Installing Ansible and setting up instances"){
            steps{
                sh '''sudo apt-get install -y apt-transport-https \
		      sudo apt-get update \
                      sudo apt install software-properties-common -y \
                      sudo add-apt-repository --yes --update ppa:ansible/ansible -y \
                      sudo apt install ansible -y \
                      ansible-playbook tomcat_setup.yaml'''
            }
        }
    }
}
