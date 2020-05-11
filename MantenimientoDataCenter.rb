#!/bin/bash
# -*- ENCODING: UTF-8 -*-

#=========================================================================================
# Function: mostrarMenu
#
# Despliega el menú de usuario, explicándole cada una de las funcionaldiades del script
#
# Returns:
#
# Cadenas de texto evidenciando las opciones del programa
#
#==========================================================================================
function mostrarMenu() {
	clear
	echo -e "===== OPCIONES DE MANTENIMIENTO =====\n"
	echo "1. Desplegar cinco procesos que más usen la CPU."
    echo "2. Mostrar archivos del sistema o discos conectados."
    echo "3. Mostrar el archivo más grande en disco."
    echo "4. Mostrar espacio libre de memoria y el espacio de Swap en uso."
    echo "5. Mostrar las conexiones de red activas"
    echo -e "S. Presione 'S' para salir.\n"
}

#=========================================================================================
# Function: pause
#
# Pausa el programa para ver los resultados y reanuda su progreso pulsando [Enter]
#
#==========================================================================================
function pause() {
   read -p "$*"
}

#=========================================================================================
# Function: requerimiento1
#
# Encargado de ordenar y desplegar los 5 procesos que más consumen CPU (De mayor a menor)
#
# Returns:
#
# Los 5 procesos que más consumen CPU
#
#==========================================================================================
function requerimiento1() {
	ps -Ao user,uid,comm,pid,pcpu --sort=-pcpu | head -n 6
}

#=========================================================================================
# Function: requerimiento2
#
# Muestra los archivos del sistema y discos conectados al computador con su respectiva
# capacidad y consumo en bytes.
#
# Returns:
#
# Los archivos del sistema y discos conectados
#
#==========================================================================================
function requerimiento2() {
	df -T | grep -E "Usados|sd"
}

#=========================================================================================
# Function: requerimiento3
#
# Despliega los 5 archivos más pesados con su ruta a partir de un directorio base
#
# Parameters:
#
# $1 - La ubicación base para empezar la búsqueda
#
# Returns:
#
# Los 5 archivos más pesados
#
#==========================================================================================
function requerimiento3() {
	sudo find $ubicacion -type f -printf '%s %p\n'| sort -nr | numfmt --to=iec| head -5
}

#=========================================================================================
# Function: requerimiento4
#
# Encargado de mostrar el espacio libre de memoria y el espacio de swap en uso en bytes
# con sus respectivos porcentajes
#
# Returns:
#
# El espacio libre de memoria y swap en uso (bytes) con sus porcentajes
#
#==========================================================================================
function requerimiento4() {
	free | grep 'Memoria' | awk '{printf "Memoria Libre: " $4 "B"}'
	free | grep 'Memoria' | awk '{print "   "$4/$2 * 100.0 "%"}' 
	free | grep 'Swap' | awk '{printf "Swap usado: " $3  "B"}'
	free | grep 'Swap' | awk '{print "   "$3/$2 * 100.0 "%"}' 
}

#=========================================================================================
# Function: requerimiento5
#
# Muestra el número y las conexiones de red activas actualmente 
#
# Returns:
#
# El número y conexiones de red activas
#
#==========================================================================================
function requerimiento5() {
	sudo netstat -putona | grep -E "Estado|ESTABLECIDO" 
	sudo netstat -putona | grep -E "Estado|ESTABLECIDO" | wc -l | awk '{print "Número de conexiones de red activas: " $0-1}'
}

while true; do 
	mostrarMenu
	echo -n "Ingrese la opción deseada: "
	read opcion 
	case $opcion in
        1)
			requerimiento1;;
		2)
			requerimiento2;;
		3)	
			echo -n "Escriba la ubicación del directorio donde desee empezar la búsqueda: "
			read ubicacion
			requerimiento3;;
		4)
			requerimiento4;;
		5)
			requerimiento5;;
		S)
			break;;
		s)
			break;;
		*)
			echo 'Seleccione un número correcto';;
	esac
	pause 'Presiona [Enter] para continuar...'
done

echo "Gracias por usar nuestro programa"
