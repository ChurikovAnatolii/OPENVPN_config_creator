#!/bin/bash

read -p 'Укажите имя клиента ' CLIENT_NAME
read -p 'Укажите EMAIL ' MAIL

CLIENT_NAME_FULL=/etc/openvpn/client/$CLIENT_NAME.ovpn

function KEY_INSERT()
{
        cp /usr/share/EasyRSA-3.0.8/pki/sample_ovpn/client.ovpn /etc/openvpn/client/$CLIENT_NAME.ovpn
        cd /etc/openvpn/client/
        echo "<cert>" >> $CLIENT_NAME_FULL
        sed -n '/BEGIN CERTIFICATE/,/END CERTIFICATE/p' </usr/share/EasyRSA-3.0.8/pki/issued/$CLIENT_NAME.crt >> $CLIENT_NAME_FULL 
        echo "</cert>" >> $CLIENT_NAME_FULL
        echo "<key>" >> $CLIENT_NAME_FULL
        sed -n '/BEGIN ENCRYPTED PRIVATE KEY/,/END ENCRYPTED PRIVATE KEY/p' </usr/share/EasyRSA-3.0.8/pki/private/$CLIENT_NAME.key >> $CLIENT_NAME_FULL
        echo "</key>" >> $CLIENT_NAME_FULL
}

function KEY_PRODUCE()
{
        cd /usr/share/EasyRSA-3.0.8/
        ./easyrsa build-client-full $CLIENT_NAME
}

function MAIL_SEND()
{

        echo "This is the body" | mutt -s "Config file" $MAIL -a $CLIENT_NAME_FULL 
}

KEY_PRODUCE
sleep 3
KEY_INSERT
sleep 2
MAIL_SEND
