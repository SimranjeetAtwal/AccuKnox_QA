# Practical Assessment : Problem Statement 1

# Prerequisites
1.	Install either Docker desktop or Podman.
2.	Install Chocolatey for installing minikube.
3.	Clone the git repository.

**Kubernetes Deployment:**

Deploy the services to a local Kubernetes cluster (e.g., Minikube or Kind).

STEP 1: Install Minikube using chocolatey
                
                choco minikube install -y

STEP 2: Create a local minikube cluster.
                
                minikube start --driver=podman
                minikube status

**NOTE : minikube status command is used to check the status of the created cluster. For e.g:**

               $ minikube status
                 minikube
                 type: Control Plane
                 host: Running
                 kubelet: Running
                 apiserver: Running
                 kubeconfig: Configured


STEP 3: Deploy the kubernetes services which are in Deployment folder of the above repository. Follow the below mentioned command:
          
          $ kubectl apply -f ./Deployment/
            deployment.apps/backend-deployment created
            service/backend-service created
            deployment.apps/frontend-deployment created
            service/frontend-service created



**Verification:**

- Ensure the frontend service can successfully communicate with the backend service.
- Verify that accessing the frontend URL displays the greeting message fetched from the backend.

  Follow the below command to check the communication between frontend and backend.

  **STEP 1**: Execute the below command to get the URL :
          minikube service frontend-service –url
          ![image](https://github.com/user-attachments/assets/206eb946-aa3f-4ebe-ac77-7546a4bf45ff)

  **STEP 2**: Check the above output URL in a browser if it displays the backend messege as below:<br>
         <br> ![image](https://github.com/user-attachments/assets/5ac8ae38-e61d-4d1b-aa3a-8564c897a2a6)

  **STEP 3**: Check if the URL displays the greeting message fetched from the backend.

          simra@Simranjeet MINGW64 ~
          $ curl http://127.0.0.1:59516/
            <h1>Hello from the Backend!</h1>



**Automated Testing:**

- Write a simple test script (using a tool of your choice) to verify the integration between the frontend and backend services.
- The test should check that the frontend correctly displays the message returned by the backend.

  **Above is the automation script in the repository. The script is named as :**

             integration_test.sh

  To run the script follow the below steps:

             chmod +x integration_test.sh
             ./integration_test.sh

  If the script works without any errors it will display the below output:
             ![image](https://github.com/user-attachments/assets/4e3ed7c3-d645-43fd-b047-96793602a3cb)


# Practical Assessment : Problem Statement 2

**Objective 1. System Health Monitoring Script:**

Develop a script that monitors the health of a Linux system. It should check
CPU usage, memory usage, disk space, and running processes. If any of
these metrics exceed predefined thresholds (e.g., CPU usage > 80%), the
script should send an alert to the console or a log file.

Solution : The file name is **system_health_monitoring.sh** . To execute the script follow the below steps:
           
           chmod +x system_health_monitoring.sh
           ./system_health_monitoring.sh

The output will be displayed as :
 <br> ![image](https://github.com/user-attachments/assets/d87f55a3-6c99-4aee-8537-20318db44636)


**Objective 2. Automated Backup Solution:**

Write a script to automate the backup of a specified directory to a remote
server or a cloud storage solution. The script should provide a report on the
success or failure of the backup operation.

Solution : The file name is **automated_backup_solution.sh** . To execute the script follow the below steps:

           chmod +x automated_backup_solution.sh
           ./automated_backup_solution.sh

The script have an help function which provides the information needed to execute it. For displaying the help section run the script as:

           ./automated_backup_solution.sh -h
