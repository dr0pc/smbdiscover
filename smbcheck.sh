#!/usr/bin/bash

#Colores
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
NC='\033[0m'

#Variables
nmap=$(which nmap)
dir=""
dirmk=""


########################################## EJEMPLO DE USO ##########################################
if [ "$1" == "" ]; then
        echo 
        echo "Example: `basename $0` targets.txt" && echo ""
        exit 0
fi

########################################## BANNER ##########################################
echo -e "
                                                                                                     
                                                                                                                        
         $(tput setaf 7)@@@@@@   @@@@@@@@@@   @@@@@@@              @@@@@@@   @@@   @@@@@@    @@@@@@@   @@@@@@   @@@  @@@  @@@@@@@@  @@@@@@@   
        @@@@@@@   @@@@@@@@@@@  @@@@@@@@             @@@@@@@@  @@@  @@@@@@@   @@@@@@@@  @@@@@@@@  @@@  @@@  @@@@@@@@  @@@@@@@@  
        !@@       @@! @@! @@!  @@!  @@@             @@!  @@@  @@!  !@@       !@@       @@!  @@@  @@!  @@@  @@!       @@!  @@@  
        !@!       !@! !@! !@!  !@   @!@             !@!  @!@  !@!  !@!       !@!       !@!  @!@  !@!  @!@  !@!       !@!  @!@  
        !!@@!!    @!! !!@ @!@  @!@!@!@   @!@!@!@!@  @!@  !@!  !!@  !!@@!!    !@!       @!@  !@!  @!@  !@!  @!!!:!    @!@!!@!   
         !!@!!!   !@!   ! !@!  !!!@!!!!  !!!@!@!!!  !@!  !!!  !!!   !!@!!!   !!!       !@!  !!!  !@!  !!!  !!!!!:    !!@!@!    
             !:!  !!:     !!:  !!:  !!!             !!:  !!!  !!:       !:!  :!!       !!:  !!!  :!:  !!:  !!:       !!: :!!   
            !:!   :!:     :!:  :!:  !:!             :!:  !:!  :!:      !:!   :!:       :!:  !:!   ::!!:!   :!:       :!:  !:!  
        :::: ::   :::     ::    :: ::::              :::: ::   ::  :::: ::    ::: :::  ::::: ::    ::::     :: ::::  ::   :::  
        :: : :     :      :    :: : ::              :: :  :   :    :: : :     :: :: :   : :  :      :      : :: ::    :   : :                                                                                                             
        ${NC}Give me a bash and... I'll change your fucking world
"

echo -e ""
echo
echo -e "${GREEN}[*] $(date)${NC}"
sleep 1


cme=$(which crackmapexec)
if [ "$?" == "1" ]; then
        echo "No se encontro Crackmapexec... Intenta con  sudo apt install crackmapexec"
        exit 0
fi

smbc=$(which smbclient)
if [ "$?" == "1" ]; then
        echo "No se encontro smbclient... Intenta con  sudo apt install smbclient"
        exit 0
fi

out=$(ls output 2>/dev/null)
if [ "$?" != "0" ]; then
        mkdir output
fi

########################################## INTERRUPCION DEL SCRIPT ######################################
function ctrl_c(){
        echo
        echo -e "${YELLOW}[-] $(tput setaf 7)Saliendo del script madafaker >:c"
        sleep 1
        exit 1
} 

trap ctrl_c INT         #LLAMADA A LA FUNCION DEL INTERRUPCION


echo
for targets in $(cat $1)
do
        dir=$(echo $targets | awk '{print $1}' FS="/")

        echo -e "${BLUE}[*] Scaning $targets un moment plis :3${NC}" &&  timeout 20 crackmapexec smb $targets >> output/CME_SMB_$dir.txt
done
cat output/CME_SMB_*  | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'  | sort -u >> output/IPS_ENCONTRADAS.txt



echo
echo -e "${BLUE}[+] $(tput setaf 7)Sistemas Operativos detectados"
cat output/CME_SMB_* | awk '{print $6,$7,$8}' | tr ' ' '\t' | sort -u >> SISTEMAS_DETECTADOS &&  cat SISTEMAS_DETECTADOS
sleep 2
echo
echo
echo -e "${BLUE}[+] $(tput setaf 7)Dispositivos detectados con SMB"
cant_ip=$(wc output/IPS_ENCONTRADAS.txt | awk '{print $1}' )
echo
echo -e "${GREEN}[+] $cant_ip IPS ENCONTRADAS" 
sleep 2
echo
echo
echo "$(tput setaf 4)[+] $(tput setaf 7) Dispositivos con OS Obsoleta/Antigua"
cat output/CME_SMB_* | grep -E "2003|2008|Windows 7|Windows 6." >> OS_OBSOLET && cat OS_OBSOLET
cat OS_OBSOLET | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'  | sort -u >> OS_OBSOLET_IPS
echo
echo "$(tput setaf 4)[+] $(tput setaf 7) Windows Servers Detectados"
cat output/CME_SMB_* | grep -i "Windows Server" >> Servers && cat Servers
cat Servers | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'  | sort -u >> Servers_IPS
sleep 2
echo
echo "$(tput setaf 4)[+] $(tput setaf 7) Dispositivos vulnerables a $(tput setaf 1)SMB RELAY"
echo
cat output/CME_SMB_* | grep "signing:False" >> SMBRELAY && cat SMBRELAY
cat SMBRELAY | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'  | sort -u >> SMBRELAY_IPS
sleep 2
echo
echo
echo -e "${BLUE}[+] $(tput setaf 7) Dispositivos con $(tput setaf 1)SMBv1"
cat output/CME_SMB_* | grep "SMBv1:True" >> SMBV1 && cat SMBV1
cat SMBV1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'  | sort -u >> SMBv1_IPS
sleep 2
echo
echo
echo -e "${BLUE}[*] $(tput setaf 7) IPS en formato Metaspolit: msf6 auxiliary(scanner/EternalBlue) > setg rhosts 10.10.10.10 20.20.20.20"
echo
cat output/CME_SMB_* |grep  -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | tr '\n' ' '
echo
cat output/CME_SMB_* |grep  -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | tr '\n' ' ' >> METASPLOIT_FORMAT_IP
sleep 2
echo
echo -e "${GREEN}[-] $(tput setaf 7) BUSCANDO CARPETAS COMPARTDAS... ESTO PUEDE DEMORAR"
for ips in $(cat output/IPS_ENCONTRADAS.txt)
do  
        smbclient -L $ips  -N  > /dev/null 2>&1  && echo " $(tput setaf 4)[+] $(tput setaf 7) SE ENCONTRO UN CARPETA COMPARTIDA CON ANONYMOUS LOGIN EN $ips"  && echo " $(tput setaf 4) [+] $(tput setaf 6)VERIFICANDO ACCESOS" && smbclient -L $ips -N 2>/dev/null  | grep Disk | sed 's/\s*\(.\)\sDisk./\1/' | while read Folders; do echo "$(tput setaf 6)==${Folders}==$(tput setaf 7) "; smbclient "//$ips/${Folders}" -N -c dir 2>/dev/null; echo;   done && echo "  $(tput setaf 1)[-] $(tput setaf 1) NO SE LOGRO ACCEDDER A LAS CARPETAS :("    
done

exit 0

