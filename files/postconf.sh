#!/bin/bash

# Postfix config from https://www.howtoforge.com/tutorial/perfect-server-debian-8-4-jessie-apache-bind-dovecot-ispconfig-3-1/#-install-postfix-dovecot-mysql-phpmyadmin-rkhunter-binutils
postconf -M submission/inet="submission inet n       -       -       -       -       smtpd"
postconf -P "submission/inet/syslog_name=postfix/submission"
postconf -P "submission/inet/smtpd_tls_security_level=encrypt"
postconf -P "submission/inet/smtpd_sasl_auth_enable=yes"
postconf -P "submission/inet/smtpd_client_restrictions=permit_sasl_authenticated,reject"
postconf -M smtps/inet="smtps     inet  n       -       -       -       -       smtpd"
postconf -P "smtps/inet/syslog_name=postfix/smtps"
postconf -P "smtps/inet/smtpd_tls_wrappermode=yes"
postconf -P "smtps/inet/smtpd_sasl_auth_enable=yes"
postconf -P "smtps/inet/smtpd_client_restrictions=permit_sasl_authenticated,reject"

# Enhanced e-mail SPAM protection
postconf -e 'smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_invalid_hostname, reject_non_fqdn_hostname, reject_unknown_recipient_domain, reject_non_fqdn_recipient, reject_unauth_destination, reject_non_fqdn_sender, reject_unknown_sender_domain, reject_unknown_recipient_domain, reject_rbl_client cbl.abuseat.org,reject_rbl_client dul.dnsbl.sorbs.net,reject_rbl_client ix.dnsbl.manitu.net, check_recipient_access mysql:/etc/postfix/mysql-virtual_recipient.cf, reject_unauth_destination'