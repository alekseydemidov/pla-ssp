#!/bin/bash

echo "Init environment variables"

DEBUG_MODE=${DEBUG_MODE:-false}
LDAP_URL=${LDAP_URL:-'ldap://localhost'}
LDAP_STARTTLS=${LDAP_STARTTLS:-false}
LDAP_USER_DN=${LDAP_USER_DN:-'cn=admin,dc=example,dc=com'}
LDAP_USER_PASSWORD=${LDAP_USER_PASSWORD:-'secret'}
LDAP_BASE_DN=${LDAP_BASE_DN:-'dc=example,dc=com'}
LDAP_LOGIN_ATTRIBUTE=${LDAP_LOGIN_ATTRIBUTE:-'uid'}
LDAP_FULLNAME_ATTRIBUTE=${LDAP_FULLNAME_ATTRIBUTE:-'cn'}
LDAP_FILTER=${LDAP_FILTER:-'(\&(objectClass=posixAccount)(uid={login}))'}

PWD_MIN_LENGTH=${PWD_MIN_LENGTH:-0}
PWD_MAX_LENGTH=${PWD_MAX_LENGTH:-0}
PWD_MIN_LOWER=${PWD_MIN_LOWER:-0}
PWD_MIN_UPPER=${PWD_MIN_UPPER:-0}
PWD_MIN_DIGIT=${PWD_MIN_DIGIT:-0}
PWD_MIN_SPECIAL=${PWD_MIN_SPECIAL:-0}
PWD_NO_REUSE=${PWD_NO_REUSE:-true}
PWD_DIFF_LOGIN=${PWD_DIFF_LOGIN:-true}
PWD_COMPLEXITY=${PWD_COMPLEXITY:-0}
USE_PWNEDPASSWORD=${USE_PWNEDPASSWORD:-false}
PWD_SHOW_POLICY=${PWD_SHOW_POLICY:-'never'}
PWD_COMPLEXITY=${PWD_COMPLEXITY:-'above'}
PWD_SHOW_POLICY_POS=${PWD_SHOW_POLICY_POS:-'above'}
WHO_CHANGE_PASSWORD=${WHO_CHANGE_PASSWORD:-'user'}
CHANGE_SSHKEY=${CHANGE_SSHKEY:-false}
CHANGE_SSHKEY_ATTRIBUTE=${CHANGE_SSHKEY_ATTRIBUTE:-'sshPublicKey'}
WHO_CHANGE_SSHKEY=${WHO_CHANGE_SSHKEY:-'user'}
USE_QUESTIONS=${USE_QUESTIONS:-true}
USE_TOKENS=${USE_TOKENS:-true}
CRYPT_TOKENS=${CRYPT_TOKENS:-true}
MAIL_ADDRESS_USE_LDAP=${MAIL_ADDRESS_USE_LDAP:-false}
MAIL_FROM=${MAIL_FROM:-'ssp'}
MAIL_FROM_NAME=${MAIL_FROM_NAME:-'admin'}
MAIL_SENDMAILPATH=${MAIL_SENDMAILPATH:-'/usr/sbin/sendmail'}
MAIL_SMTP_DEBUG=${MAIL_SMTP_DEBUG:-false}
MAIL_SMTP_HOST=${MAIL_SMTP_HOST:-'localhost'}
MAIL_SMTP_AUTH=${MAIL_SMTP_AUTH:-false}
MAIL_SMTP_USER=${MAIL_SMTP_USER:-''}
MAIL_SMTP_PASS=${MAIL_SMTP_PASS:-''}
MAIL_SMTP_PORT=${MAIL_SMTP_PORT:-25}
MAIL_SMTP_SECURE=${MAIL_SMTP_SECURE:-'tls'}
MAIL_SMTP_AUTOTLS=${MAIL_SMTP_AUTOTLS:-true}
USE_SMS=${USE_SMS:-false}
KEYPHRASE=${KEYPHRASE:-'SOJ9QYgW0i/vnhRX'}
LANG=${LANG:-'en'}
LOGO=${LOGO:-'images/ltb-logo.png'}
BACKGROUND_IMAGE=${BACKGROUND_IMAGE:-'images/unsplash-space.jpeg'}

PHPLDAPADMIN_LDAP_BASE=${PHPLDAPADMIN_LDAP_BASE:-'dc=example,dc=com'}
PHPLDAPADMIN_LDAP_CLIENT_TLS=${PHPLDAPADMIN_LDAP_CLIENT_TLS:-false}
PHPLDAPADMIN_LDAP_CLIENT_TLS_CRT_FILENAME=${PHPLDAPADMIN_LDAP_CLIENT_TLS_CRT_FILENAME:-'/certs/tls.crt'}
PHPLDAPADMIN_LDAP_CLIENT_TLS_KEY_FILENAME=${PHPLDAPADMIN_LDAP_CLIENT_TLS_KEY_FILENAME:-'/certs/tls.key'}
PHPLDAPADMIN_LDAP_CLIENT_TLS_CA_CRT_FILENAME=${PHPLDAPADMIN_LDAP_CLIENT_TLS_CA_CRT_FILENAME:-'/certs/ca.crt'}
PHPLDAPADMIN_LDAP_HOSTS=${PHPLDAPADMIN_LDAP_HOSTS:-'localhost'}

if [ ! -f /etc/.init ]; then
echo "Configure phpLDAPadmin"

rm -rf /usr/share/phpldapadmin/templates/creation/sendmail*
rm -rf /usr/share/phpldapadmin/templates/creation/samba*
rm -rf /usr/share/phpldapadmin/templates/creation/courierMail*
rm -rf /usr/share/phpldapadmin/templates/creation/mozillaOrgPerson.xml

#sed -i '/ldap_pla/d' /usr/share/phpldapadmin/config/config.php
cp /usr/share/phpldapadmin/config/config.php /usr/share/phpldapadmin/config/config.php.bck
sed '/^$servers = new Datastore();/,$d' /usr/share/phpldapadmin/config/config.php.bck > /usr/share/phpldapadmin/config/config.php

echo "\$servers = new Datastore();" >> /usr/share/phpldapadmin/config/config.php
echo "\$servers->newServer('ldap_pla');" >> /usr/share/phpldapadmin/config/config.php
echo "\$servers->setValue('server','name','LDAP Server');" >> /usr/share/phpldapadmin/config/config.php
echo "\$servers->setValue('server','host','"$PHPLDAPADMIN_LDAP_HOSTS"');" >> /usr/share/phpldapadmin/config/config.php
echo "\$servers->setValue('server','base',array('$PHPLDAPADMIN_LDAP_BASE'));" >> /usr/share/phpldapadmin/config/config.php
if [ "${PHPLDAPADMIN_LDAP_CLIENT_TLS,,}" == "true" ]; then
    echo "\$servers->setValue('server','tls','"$PHPLDAPADMIN_LDAP_CLIENT_TLS"');" >> /usr/share/phpldapadmin/config/config.php
    cp $PHPLDAPADMIN_LDAP_CLIENT_TLS_CRT_FILENAME /usr/local/share/ca-certificates/
    cp $PHPLDAPADMIN_LDAP_CLIENT_TLS_CA_CRT_FILENAME  /usr/local/share/ca-certificates/
    /usr/sbin/update-ca-certificates
fi
echo "?>" >> /usr/share/phpldapadmin/config/config.php

echo "Configure self service password"
sed -i -e "s|\$debug.*|\$debug = $DEBUG_MODE;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$ldap_url.*|\$ldap_url = \"$LDAP_URL\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$ldap_starttls.*|\$ldap_starttls = $LDAP_STARTTLS;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$ldap_binddn.*|\$ldap_binddn = \"$LDAP_USER_DN\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$ldap_bindpw.*|\$ldap_bindpw = \"$LDAP_USER_PASSWORD\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$ldap_base.*|\$ldap_base = \"$LDAP_BASE_DN\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$ldap_login_attribute.*|\$ldap_login_attribute = \"$LDAP_LOGIN_ATTRIBUTE\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$ldap_fullname_attribute.*|\$ldap_fullname_attribute = \"$LDAP_FULLNAME_ATTRIBUTE\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$ldap_filter.*|\$ldap_filter = \'$LDAP_FILTER\';|g" /usr/share/self-service-password/conf/config.inc.php

sed -i -e "s|\$pwd_min_length.*|\$pwd_min_length = $PWD_MIN_LENGTH;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$pwd_max_length.*|\$pwd_max_length = $PWD_MAX_LENGTH;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$pwd_min_lower.*|\$pwd_min_lower = $PWD_MIN_LOWER;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$pwd_min_upper.*|\$pwd_min_upper = $PWD_MIN_UPPER;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$pwd_min_digit.*|\$pwd_min_digit = $PWD_MIN_DIGIT;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$pwd_min_special.*|\$pwd_min_special = $PWD_MIN_SPECIAL;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$pwd_no_reuse.*|\$pwd_no_reuse = $PWD_NO_REUSE;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$pwd_diff_login.*|\$pwd_diff_login = $PWD_DIFF_LOGIN;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$pwd_complexity.*|\$pwd_complexity = $PWD_COMPLEXITY;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$use_pwnedpasswords.*|\$use_pwnedpasswords = $USE_PWNEDPASSWORD;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$pwd_show_policy.*|\$pwd_show_policy = \"$PWD_SHOW_POLICY\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$pwd_show_policy_pos.*|\$pwd_show_policy_pos = \"$PWD_SHOW_POLICY_POS\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$who_change_password.*|\$who_change_password = \"$WHO_CHANGE_PASSWORD\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$change_sshkey =.*|\$change_sshkey = $CHANGE_SSHKEY;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$change_sshkey_attribute.*|\$change_sshkey_attribute = \"$CHANGE_SSHKEY_ATTRIBUTE\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$who_change_sshkey.*|\$who_change_sshkey = \"$WHO_CHANGE_SSHKEY\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$use_questions.*|\$use_questions = $USE_QUESTIONS;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$use_tokens.*|\$use_tokens = $USE_TOKENS;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$crypt_tokens.*|\$crypt_tokens = $CRYPT_TOKENS;|g" /usr/share/self-service-password/conf/config.inc.php

sed -i -e "s|\$mail_address_use_ldap.*|\$mail_address_use_ldap = $MAIL_ADDRESS_USE_LDAP;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$mail_from.*|\$mail_from = \"$MAIL_FROM\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$mail_from_name.*|\$mail_from_name = \"$MAIL_FROM_NAME\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$mail_sendmailpath.*|\$mail_sendmailpath = \"$MAIL_SENDMAILPATH\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$mail_smtp_debug.*|\$mail_smtp_debug = $MAIL_SMTP_DEBUG;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$mail_smtp_host.*|\$mail_smtp_host = \"$MAIL_SMTP_HOST\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$mail_smtp_auth.*|\$mail_smtp_auth = \"$MAIL_SMTP_AUTH\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$mail_smtp_user.*|\$mail_smtp_user = \"$MAIL_SMTP_USER\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$mail_smtp_pass.*|\$mail_smtp_pass = \"$MAIL_SMTP_PASS\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$mail_smtp_port.*|\$mail_smtp_port = $MAIL_SMTP_PORT;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$mail_smtp_secure.*|\$mail_smtp_secure = \"$MAIL_SMTP_SECURE\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$mail_smtp_autotls.*|\$mail_smtp_autotls = $MAIL_SMTP_AUTOTLS;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$use_sms.*|\$use_sms = $USE_SMS;|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$keyphrase.*|\$keyphrase = \"$KEYPHRASE\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$lang.*|\$lang = \"$LANG\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$logo.*|\$logo = \"$LOGO\";|g" /usr/share/self-service-password/conf/config.inc.php
sed -i -e "s|\$background_image.*|\$background_image = \"$BACKGROUND_IMAGE\";|g" /usr/share/self-service-password/conf/config.inc.php
touch /etc/.init
fi

echo "Starting php-fpm"
php-fpm7.3 -D
echo "Starting nginx"
nginx -g "daemon off;"
