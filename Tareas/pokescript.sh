#!/usr/bin/bash

#Este script consulta informacion del pokemon indicado de la api https://pokeapi.co/

#Se empieza comprobando que se ha pasado un nombre como parametro
if [ -z $1 ]
then
	#Se imprime en terminal un mensaje en caso de no pasar ningun nombre como parametro
	echo "Pokemon no indicado."
else
	#Si se pasa un nombre, se crea el link con el parametro
	enlace="https://pokeapi.co/api/v2/pokemon/$1"

	#Se crea una variable para almacenar el codigo de estado HTTP de la consulta
	status=$(curl -I -w %{http_code} -s -o /dev/null $enlace)

	#Condicinal para comprobar si status=404
	if [ $status -eq 404 ]
	then
		#status=404 en el caso de que el pokemon no exista en la api o este mal escrito
		echo "Pokemon no encontrado."
	else
		#En el caso de que el pokemon sea encontrado, se parsean los datos de id, nombre,
		#peso, altura y orden con jq. El resultado es almacenado como array en la variable res
		res=( $(curl -s $enlace | jq -r '.id, .name, .weight, .height, .order') )
		#Se imprime el resultado en la terminal de acuerdo al formato
		echo "Su resultado:"
		echo "Id=${res[0]}, name=${res[1]}, weight=${res[2]}, height=${res[3]}, order=${res[4]}"
	fi
fi
