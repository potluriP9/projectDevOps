# projectDevOps
Potluri’s Project:

Documented the procedure which I followed to accomplish the given project.

-	Started with launching an ubuntu instances in AWS using Amazon AMI.
-	Logged into the instance using the key provide by AWS and Public DNS name using Putty.
-	Installed open source puppetmaster in one instance and in another instance installed puppetagent.
-	Changed the name of puppetagent as “Potluri.puppetagent” in /etc/hostname for my convenience and rebooted the instance.
-	Defined master as server to the agent by providing master hostname and IP. Whole process should be done in the agents. Same process should be performed in master but need not to mention the server IP as it is a server.
-	Given proper permissions:-
-	For communication between master and agent, performed “puppet agent –t” & “puppet agent –-enable” in puppetagent for getting certification from puppetmaster. Thus gains successful communication.	


Wrote AWS module in init.pp using the below services provide by AWS:

-	EC2 Instances(Potluri webserver) 
-	Security group(PotluriSecurity) 
-	VPC(PotluriVPC)
-	Elastic Load Balancer(PotluriLoadBalancer)
-	Routetable(PotluriRoute)
-	Subnet(PotluriSubNet)
-	Internet gateway(PotluriIGW) 
-	And for user data template of "apache-potluripuppet.sh".


 Wrote apache module in site.pp to configuring: 

- Apache
- HTTP
- HTTPS requests.
