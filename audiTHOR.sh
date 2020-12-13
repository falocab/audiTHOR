#!/bin/bash
# audithor

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo -e '\e[1m\e[93m

░█████╗░██╗░░░██╗██████╗░██╗████████╗██╗░░██╗░█████╗░██████╗░
██╔══██╗██║░░░██║██╔══██╗██║╚══██╔══╝██║░░██║██╔══██╗██╔══██╗
███████║██║░░░██║██║░░██║██║░░░██║░░░███████║██║░░██║██████╔╝
██╔══██║██║░░░██║██║░░██║██║░░░██║░░░██╔══██║██║░░██║██╔══██╗
██║░░██║╚██████╔╝██████╔╝██║░░░██║░░░██║░░██║╚█████╔╝██║░░██║
╚═╝░░╚═╝░╚═════╝░╚═════╝░╚═╝░░░╚═╝░░░╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝
'
echo -e "\e[34mIntroduzca el dominio a auditar: \e[96m"
read dominio1
#COMPROBACION DE DOMINIO
if ( fping $dominio1 > /dev/null 2>&1 );
then
	
	echo -e "\n\e[92m El activo esta disponible"
else
	echo -e "\n\e[91m El activo no esta disponible";
	exit 1
fi
host $dominio1
#INFORMACION WHATWEB
echo -e '\n\e[34m------Informacion------\e[96m'
whatweb $dominio1 | sed "s/, /\n\t/g"
#TRACEROUTE
echo -e '\n\e[34m\e[1m------Traceroute------\e[96m'
traceroute $dominio1
#PUERTOS
echo -e '\n\e[34m\e[1m------Puertos Abiertos------\e[96m'
nmap -sV $dominio1 | grep "open  "
#INYECCION SQL
echo -e '\n\e[34m\e[1m------Inyeccion SQL------\e[96m'
sqliv -t $dominio1
#CABECERAS
echo -e '\n\e[34m------Cabeceras------\e[96m'
cab=`curl -sI $dominio1`
curl -sI $dominio1
echo -e "\e[34m"
#SERVER
if echo "$cab" | grep -q Server;
then    
        echo -e "\e[34mServer: \e[92mImplementada\e[34m"
else    
        echo -e "Server: \e[91mNo implementada\e[34m"
fi
#X-POWERED-BY
if echo "$cab" | grep -q X-Powered-By;
then    
        echo -e "\e[34mX-Powered-By: \e[92mImplementada\e[34m"
else    
        echo -e "X-Powered-By: \e[91mNo implementada\e[34m"
fi
#CONTENT-SECURITY-POLICY
if echo "$cab" | grep -q Content-Security-Policy;
then    
        echo -e "\e[34mContent-Security-Policy: \e[92mImplementada\e[34m"
else    
        echo -e "Content-Security-Policy: \e[91mNo implementada\e[34m"
fi
#X-FRAME-OPTIONS
if echo "$cab" | grep -q X-Frame-Options;
then    
        echo -e "\e[34mX-Frame-Options: \e[92mImplementada\e[34m"
else    
        echo -e "X-Frame-Options: \e[91mNo implementada\e[34m"
fi
#X-XSS-PROTECTION
if echo "$cab" | grep -q X-XSS-Protection;
then    
        echo -e "X-XSS-Protection: \e[92mImplementada\e[34m" 
else    
        echo -e "X-XSS-Protection: \e[91mNo implementada\e[34m"
fi
#X-CONTENT-TYPE-OPTIONS
if echo "$cab" | grep -q X-Content-Type-Options;
then    
        echo -e "X-Content-Type-Options: \e[92mImplementada\e[34m" 
else    
        echo -e "X-Content-Type-Options: \e[91mNo implementada\e[34m"
fi
#STRIC-TRANSPORT-SECURITY
if echo "$cab" | grep -q Strict-Transport-Security;
then    
        echo -e "Strict-Transport-Security: \e[92mImplementada\e[34m" 
else    
        echo -e "Strict-Transport-Security: \e[91mNo implementada\e[34m"
fi
#TESTSSL (versiones)
echo -e '\n\e[34m\e[1m-------Version SSL/TLS------\e[96m'

tes=`$DIR/testssl/testssl.sh $dominio1`
echo -e "\e[39m"
echo "$tes" | grep "SSLv2      "
echo "$tes" | grep "SSLv3      "
echo "$tes" | grep "TLS 1      "
echo "$tes" | grep "TLS 1.1    "
echo "$tes" | grep "TLS 1.2    "
echo "$tes" | grep "TLS 1.3    "

#VULNERABILIDADES TLS/SSL
echo -e '\n\e[34m\e[1m--------Vulnerabilidades  SSL/TLS------\e[96m\e[39m'

echo -e "\e[39m"
echo "$tes" | grep "Start "
echo "$tes" | grep "Heartbleed (CVE-2014-0160)"
echo "$tes" | grep "CCS"
echo "$tes" | grep "Ticketbleed"
echo "$tes" | grep "ROBOT"
echo "$tes" | grep "Secure Renegotiation "
echo "$tes" | grep "Secure Client-Initiated Renegotiation"
echo "$tes" | grep "CRIME, TLS"
echo "$tes" | grep "BREACH"
echo "$tes" | grep "POODLE, SSL"
echo "$tes" | grep "TLS_FALLBACK_SCSV"
echo "$tes" | grep "SWEET32"
echo "$tes" | grep "FREAK"
echo "$tes" | grep "DROWN"
echo "$tes" | grep "LOGJAM"
echo "$tes" | grep "BEAST"
echo "$tes" | grep "LUCKY13"
echo "$tes" | grep "RC4"
#SCORE
echo -e '\n\e[34m\e[1m--------Puntuacion  SSL/TLS------\e[96m\e[39m'
echo "$tes" | grep "Protocol Support"
echo "$tes" | grep "Key Exchange"
echo "$tes" | grep "Cipher Strength"
echo "$tes" | grep "Final Score"
echo "$tes" | grep "Overall Grade"

#Directorios
echo -e '\n\e[34m\e[1m--------Directorios------\e[96m\e[39m'
dir=`wfuzz -w diccionario.txt --sc 200 https://$dominio1/FUZZ`
echo "$dir" | grep "200  "

#WAF
echo -e '\n\e[34m\e[1m--------escaner WAF------\e[96m\e[39m'
waf=`wafw00f $dominio1`
echo "$waf" | grep 'Checking'
echo "$waf" | grep 'The site'
echo "$waf" | grep 'Number of requests'
echo "$waf" | grep 'No WAF detected'

echo  "FIN"






