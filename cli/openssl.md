Common commands:
----------------

Find finger print of private key
openssl x509 -in certificate.pem -fingerprint

Encrypt file with openssl
openssl enc -aes-192-cbc -in input_file -out output_file.enc -k password

Convert pki to pem
openssl pkcs12 -in certificate.pfx -out certificate.pem

The pem file will contain the private key, CA etc

To test authenticating to F5 – WIP
curl https://172.26.122.226/2415/AuthenticatingXmlServer.aspx -k --cert ./both.pem

To test if a certificate is revoked
openssl ocsp -issuer Surescripts-Issuing-Certification-Authority.crt -url http://172.25.201.100/ocsp -cert Test.crt -noverify 

Combine private and public key
openssl pkcs12 -export -in public.cer -inkey private.key -out merged.pfx

Retrieve Server Information from a Site
openssl s_client -connect stash.surescripts.local:443

Look for "Server certificate" to see the public key of the server you are interacting with
Look for "CA names" to see the certificate authorities trusted by the server if it requires a client cert
Trust a new CA
Copy CA public key to /etc/pki/ca-trust/source/anchors 
sudo update-ca-trust

To test

 curl https://stash.surescripts.local
