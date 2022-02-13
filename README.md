## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![alt text](https://github.com/ransom-ware/cybersec-bootcamp/blob/main/Diagrams/ELK.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to recreate the entire deployment pictured above. Alternatively, select portions of the below file may be configured to install only certain pieces of it, such as Filebeat.

##### fmbeat-playbook.yml
```
---
- name: Install and setup Filebeat
  hosts: webservers
  become: yes
  tasks:

  - name: Download Filebeat.deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.1-a>

  - name: Install Filebeat.deb
    command: dpkg -i filebeat-7.6.1-amd64.deb

  - name: drop in filebeat.yml
    copy:
      src: /etc/ansible/files/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

  - name: Enable and configure system module
    command: filebeat modules enable system

  - name: Setup filebeat
    command: filebeat setup

  - name: Start filebeat service
    command: service filebeat start

  - name: Start filebeat on boot
    systemd:
      name: filebeat.service
      enabled: yes

- name: Install and setup MetricBeat
  hosts: webservers
  become: yes
  tasks:

  - name: Download Metricbeat
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.4>

  - name: Install Metricbeat
    command: dpkg -i metricbeat-7.4.0-amd64.deb

  - name: drop in metricbeat.yml
    copy:
      src: /etc/ansible/files/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml

  - name: Enable and configure system module
    command: metricbeat modules enable docker

  - name: Setup Metricbeat
    command: metricbeat setup -e

  - name: Enable Metricbeat on boot
    systemd:
      name: metricbeat.service
      enabled: yes
```

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the Damn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting traffic to the network.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the logs and system metrics.

The configuration details of each machine may be found below.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Gateway  | 10.0.0.4   | Linux            |
| Web-1    | DVWA     | 10.0.0.5   | Linux            |
| Web-2    | DVWA     | 10.0.0.6   | Linux            |
| ELK-VM   | ELK      | 10.1.0.4   | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump Box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- 173.53.24.227

Machines within the network can only be accessed by the Jump Box. This Jump Box can access the ELK-VM from its IP at 10.0.0.4

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump-Box | Yes                 | 173.53.24.227        |
| Web-1    | No                  | 10.0.0.4             |
| Web-2    | No                  | 10.0.0.4             |
| ELK-VM   | No                  | 10.0.0.4             |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because:
- It can be easily deployed and redeployed on different networks
- Its setup is easily configureable

The three playbooks implement the following tasks:

##### Playbook 1: install-docker.yml

install-docker.yml is used to set up DMWA servers running in a Docker container on each of the web servies show in the diagram above. It implements the following tasks:

- Installs Docker
- Installs Python
- Installs Docker's Python Module
- Downloads and launches the DVWA Docker container
- Enables the Docker service

##### Playbook 2: install-elk.yml

install-elk.yml is used to set up and launch the ELK repository server in a Docker Container on the ELK server. It implements the following tasks:

- Installs Docker
- Installs Python
- Installs Docker's Python Module
- Increase virtual memory to support the ELK stack
- Increase memory to support the ELK stack
- Download and launch the Docker ELK container

##### Playbook 3: filebeat-playbook.yml

fm-playbook.yml is used to deploy Filebeat on each of the web servers so they can be monitored centrally using ELK services running on Elk-1. It implements the following tasks:

-Downloads and installs Filebeat
-Enables and configures the system module
-Configures and launches Filebeat
-Downloads and installs Metricbeat
-Configures and launches Metricbeat

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1: 10.0.0.5
- Web-2: 10.0.0.6

I have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- Filebeat collects logs and sends them to Elasticsearch or Logstash for indexing
- Metricbeat collects system metrics for indexing with Elasticsearch or Logstash as well

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the playbook files to Ansible Docker Container
- Update the Ansible hosts file located at `/etc/ansible/hosts` to include:
```
[webservers]
10.0.0.5 ansible_python_interpreter=/usr/bin/python3
10.0.0.6 ansible_python_interpreter=/usr/bin/python3

[elkservers]
10.1.0.4 ansible_python_interpreter=/usr/bin/python3
```
- Update the config file `/etc/ansible/ansible.cfg` and set the remote_user parameter to the admin user of the web servers

### Running the Playbooks
- ssh into the Jump Box
- Start the Ansible Docker container `~$ sudo docker start <Container Name>`
- Attach to the Ansible Docker container `~$ sudo docker attach <Container Name>`
- Run the playbooks with the following commands:
	 -	`ansible-playbook /etc/ansible/install-docker.yml`
	 -	`ansible-playbook /etc/ansible/install-elk.yml`
	 -	`ansible-playbook /etc/ansible/roles/fm-playbook.yml`

- Navigate to Kibana to verify the installation
	-	Kibana can be accessed at http://[elk-server-ip]:5601/app/kibana
