# cc_sysadmintht

This is the repo for CODING COLLECTIVE Sytem Administrator Take Home Technical Test

[TEST CASE 1]

- COUNT THE LAST 10 MINUTES OF HTTPS 500s
  
To run the script for counting 500 apache response code, simply go to TESTCASE1 and then run the script using the following command:

##bash 1_count_500s_apache.sh**

or you can use:
chmod +x 1_count_500s_apache.sh && ./1_count_500s_apache.sh


- DOCKER SONARQUBE SETUP

Notes: according to below link (SonarQube Community Forum):
https://community.sonarsource.com/t/when-did-sonarqube-started-supporting-golang/81545
SonarQube has already supported Go since 2018 and later, thus I do not add sonar-golang plugin

To run the docker sonarqube with postgres db, simply go to TESTCASE1/2_docker-sonarqube-setup and run the following command:

##bash init-sonar.sh**



[TEST CASE 2]

**Notes:** For task number 1 and 3 I make it in to one script named 1_3_lemp-laravel-helloworld-dockercompose.sh
       To run script for task 1 and 3, simply go to TESTCASE2 and run: **bash 1_3_lemp-laravel-helloworld-dockercompose.sh**

1. Create script bash shell for automation install LEMP (Linux, Nginx, MariaDb, PhpFpm) using docker compose.
2. Script for block brute force ssh request
   To run script for task 2, simply go to TESTCASE2 and run:
   **bash 2_block_ssh_bruteforce.sh**
4. Create simple laravel project (using LEMP on no 1)  using docker compose environment, the project just contain hello world with your name
5. Create script backup database, compress the db and retain 30 days
   To run script for task 4 simply go to TESTCASE2 and run:
   **bash 4_backupdb.sh**
