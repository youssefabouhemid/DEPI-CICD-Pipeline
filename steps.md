### Terraform
1. cd to terraform/
2. run `terraform apply`
   1. it will generate the private key under terraform/.ssh
   2. make note of the EC2 instance IPs in the terraform output



### Ansible
1. cd to ansible/
2. plug in ec2 instance ips in `inventory.ini`
3. run `ansible-playbook -i inventory.ini playbook.yaml` 

### Jenkins
#### Publish Over SSH
1. Download `Publish Over SSH` plugin
2. Go to `manage jenkins -> System`, then search for `Publish Over SSH` section
   1. copy private key contents generated using terraform in the previous steps in the `key` section
   2. under `SSH Servers` go to `SSH Server`
      1. **name** = `kuberenetes_server`
      2. **Hostname** = <k3s_instance_ip> -----> INPUT YOUR IP HERE 
      3. **username** = `ubuntu`
   3. click on `Test Configuration` button to test that the connection if succesful.

#### Creating Pipeline
1. Go to `New Item` and choose **Pipeline**
2. In the **General Section check** `GitHub Project` and `This project is parameterized`
   1. add parameters: `awsRegion`, `ecrRepo`,`accountId` and add your account values in.
   ```
    awsRegion = us-east-1 // Your AWS region
    def ecrRepo = python/depi_project // Your ECR repository name
    def accountId = 539247483379 // Your AWS account ID
   ```
3. In the **Build Triggers Section** check `GitHub hook trigger for GITScm polling` 
4. In the **Pipeline Section** choose `pipeline script from SCM` under **Definition**
   1. change **Branch Specifier** value to `*/main`
   2. change **Script Path** value to `JenkinsFile`
5. That's it! hopefully if everything's well you can try building the pipeline inshallah :)