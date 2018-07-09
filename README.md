# Filerun_Docker
Dockerized Filerun app with smb share support


Usage:

	docker create --name=filerun 
		-v /path/to/data:/app/data 
		-v /path/to/config:/app/config 
		-e TZ="Continent/Capital"
		-p 80:80 
		-p 443:443 
		wilply/filerun_docker
              
	/app/config store all filerun files and the logs files, 
  	config will be lost if you dont bind it.
 
	You can pass -e LOCAL_DB="true" to enable mariadb in the container, 
		db name = filerun 
		user = root
		password = P@ssw0rd
  
	/!\ DATABASE WILL BE LOST IF YOU DELETE THE CONTAINER, 
		ONLY FOR TESTING/DEVLOPMENT.
  
	You can change the path of /app by setting -e DIR="/your/path", 
 		dont forget to change it when you bind your volumes.
   
   
	TODO: 
		-add support fot smbshare 
		-add configurable uid/gid nginx/php run as
