#!/bin/bash


if [ "$#" -ne 1 ]; then 

	echo "Sin <comando> $0 " >&2

	exit 1
fi 

Coma_p=$1
log_archivos="Monitorear_${Coma_p}.log"

$Coma_p & 

Identificador_p=$!

echo "Se esta monitoreando el proceso $Coma_p (PID: $Identificador_p)"

echo "Tiempo, CPU, Mem" > "$log_archivos"

while ps -p "$Identificador_p" > /dev/null; do

	Estado=$(ps -p "$Identificador_p" -o %cpu,%mem --no-headers)
	Tiempo=$(date +"%Y-%m-%d %H:%M:%S")

    echo "$Tiempo,$Estado" >> "$log_archivos"

    sleep 1
done

echo "Generando gráfico"
gnuplot <<- EOF

    set terminal png

    set output 'monitor_${Coma_p}.png'

    set title "Monitoreo de ${Coma_p}"

    set xdata time

    set timefmt "%Y-%m-%d %H:%M:%S"

    set format x "%H:%M:%S"

    set xlabel "Tiempo"

    set ylabel "Porcentaje"

    plot "${log_archivos}" using 1:2 with lines title "CPU %", \

         "${log_archivos}" using 1:3 with lines title "Memoria %"

EOF



echo "Gráfico del monitor_${Coma_p}.png"                                                                                                                                          
