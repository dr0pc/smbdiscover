#!/usr/bin/bash

if [ "$1" == "" ]; then
                  echo "Usage: bash `basename $0` <ip> " && echo ""
                            echo "Example: `basename $0` 15.15.15.15" && echo ""
                                      exit 0
fi
echo [+] VERIFICANDO LA VERSION DEL SISTEMA.
cme smb $1
echo
echo [+] LISTANDO RECURSOS COMPARTIDOS.
smbclient -L $1 -N 2>/dev/null  | grep Disk | sed 's/\s*\(.*\)\sDisk.*/\1/'
echo
echo [+] VALIDANDO ACCESO A LAS CARPETAS.
smbclient -L $1 -N 2>/dev/null  | grep Disk | sed 's/\s*\(.*\)\sDisk.*/\1/' | while read Folders; do echo ==${Folders}==; smbclient "//$1/${Folders}" -N -c dir; echo;   done
