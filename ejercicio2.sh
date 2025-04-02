#!/bin/bash


if [ "$#" -ne 1]; then 

	echo "Sin $0 <comando_del_proceso>" >&2

	exit 1
fi 

Coma_p=$1
log_archi="Monitorear_${Coma_p}.log"

$Coma_p & 

pid=$!

echo "Se esta monitoreando el proceso $Coma_p (PID: $pid)"

echo "Tiempo, CPU, Mem" > "$log_archi"

while ps -p "$pid" > /dev/null; do

	Estado=$(ps -p "$pid" -o %cpu,%mem --no-headers)
	tiempopa=$(date +"%Y-%m-%d %H:%M:%S")

    echo "$tiempopa,$Estado" >> "$log_archi"

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

    plot "${log_archi}" using 1:2 with lines title "CPU %", \

         "${log_archi}" using 1:3 with lines title "Memoria %"

EOF



echo "Gráfico generado en monitor_${Coma_p}.png"
~                                                                                                                       
                                                                                                  
