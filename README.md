# pla-ssp
phpLDAPadmin and SelfServicePassword in one container

This is very light and easy docker image to build simple web-ui interface for [OpenLDAP server](https://github.com/alekseydemidov/openldap-docker). 
It's based on nginx distributive and has TLS support (Only TLS to LDAP connection)  
Please pay attention: it does not support HTTPS to use it, please configure some http proxy (nginx or smth else)   

## Building:  
docker build --tag openldap-ui .  
docker run --name openldap-ui -e LDAP_URL='ldap://localhost' -e 'Many ENV :)' netflyer/openldap-ui

## Network Ports:  
8080 - for phpLDAPadmin  
8081 - for SelfServicePassword  

## Persistance volume:  
Currently is not needed

## Environment variables:  
VARIABLE = default (if not set)

## Common variables:  
DEBUG_MODE = false  
LDAP_URL = 'ldap://localhost'  
LDAP_STARTTLS = false  
LDAP_USER_DN = 'cn=admin,dc=example,dc=com'  
LDAP_USER_PASSWORD = 'secret'  
LDAP_BASE_DN = 'dc=example,dc=com'  
LDAP_LOGIN_ATTRIBUTE = 'uid'  
LDAP_FULLNAME_ATTRIBUTE = 'cn'  
LDAP_FILTER = '(\\&(objectClass=posixAccount)(uid={login}))'  Pay attention backslash is mandatory!  

## phpLDAPadmin variables:  
PHPLDAPADMIN_LDAP_BASE = 'dc=example,dc=com'  
PHPLDAPADMIN_LDAP_CLIENT_TLS = false  
PHPLDAPADMIN_LDAP_CLIENT_TLS_CRT_FILENAME = '/certs/tls.crt'  
PHPLDAPADMIN_LDAP_CLIENT_TLS_KEY_FILENAME = '/certs/tls.key'  
PHPLDAPADMIN_LDAP_CLIENT_TLS_CA_CRT_FILENAME = '/certs/ca.crt'  
PHPLDAPADMIN_LDAP_HOSTS= 'localhost'  

## SelfServicePassword variables:  
PWD_MIN_LENGTH = 0  
PWD_MAX_LENGTH = 0  
PWD_MIN_LOWER = 0  
PWD_MIN_UPPER = 0  
PWD_MIN_DIGIT = 0  
PWD_MIN_SPECIAL = 0  
PWD_NO_REUSE = true  
PWD_DIFF_LOGIN = true  
PWD_COMPLEXITY = 0  
USE_PWNEDPASSWORD = false  
PWD_SHOW_POLICY = 'never'  
PWD_COMPLEXITY = 'above'  
PWD_SHOW_POLICY_POS = 'above'  
WHO_CHANGE_PASSWORD = 'user'  
CHANGE_SSHKEY = false  
CHANGE_SSHKEY_ATTRIBUTE = 'sshPublicKey'  
WHO_CHANGE_SSHKEY = 'user'  
USE_QUESTIONS = true  
USE_TOKENS = true  
CRYPT_TOKENS = true  
MAIL_ADDRESS_USE_LDAP = false  
MAIL_FROM = 'ssp'  
MAIL_FROM_NAME = 'admin'  
MAIL_SENDMAILPATH = '/usr/sbin/sendmail'  
MAIL_SMTP_DEBUG = false  
MAIL_SMTP_HOST = 'localhost'  
MAIL_SMTP_AUTH = false  
MAIL_SMTP_USER = ''  
MAIL_SMTP_PASS = ''  
MAIL_SMTP_PORT = 25  
MAIL_SMTP_SECURE = 'tls'  
MAIL_SMTP_AUTOTLS = true  
USE_SMS = false  
KEYPHRASE = 'SOJ9QYgW0i/vnhRX'  
LANG = 'en'  
LOGO = 'images/ltb-logo.png'  
BACKGROUND_IMAGE = 'images/unsplash-space.jpeg'  


Hyperlink to [dockerhub images](https://hub.docker.com/r/netflyer/openldap-ui)
