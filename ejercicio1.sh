#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then 
	echo "Error, debe ejecutarse como root" >&2

	exit 1

fi

if [ "$#" -ne 3 ]; then
	
	echo "Error, $0 falta  <Usuario> <Grupo> <Ruta_Archivo>" >&2
	
	exit 1
fi

Usuario=$1
Grupo=$2
Archivo=$3

if [ !  -e "$Archivo" ]; then


	echo "Error, Archivo $Archivo inexistente" >&2


	exit 1
fi

if grep -q "^$Grupo:" /etc/group; then

    echo "Grupo $Grupo, existente"

else

    groupadd "$Grupo" && echo "Grupo $Grupo creado"

fi


if id "$Usuario" &>/dev/null; then

    echo "Usuario $Usuario,existente"

else

    useradd -m -G "$Grupo" "$Usuario" && echo "Usuario $Usuario creado"

fi



usermod -a -G "$Grupo" "$Usuario"

chown "$Usuario":"$Grupo" "$Archivo"


chmod 750 "$Archivo"

echo "Permisos del archivo $Archivo actualizados"

