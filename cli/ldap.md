Install ldap search  
  sudo yum install ldapsearch 
  
  sudo yum install  openldap-clients 
  
  
Example queries 

  ldapsearch -x  -H ldap://ad-server.com -D "CN=ldap reader,OU=Service Accounts,OU=Company,DC=company,DC=com"  -b "CN=Ansible,OU=Security Groups,OU=Groups,OU=Company,DC=company,DC=dr" -w "password" 
  
  ldapsearch -x  -H ldap://ad-server.com -D "CN=ldap reader,OU=Service Accounts,OU=Company,DC=company,DC=com"  -b "cn=michael perzel,ou=group,ou=people,ou=Company,dc=company,dc=com" -w "password" 
