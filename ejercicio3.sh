#!/bin/bash

directorio_monitoriar="/home/Vmoon/Laboratorio 2/"

log_archi="/home/Vmoon/monitor_directorio.log"

echo "Inicio de monitoreo en $directorio_monitoriar" >> "$log_archi"

inotifywait -m -r -e create -e modify -e delete "$directorio_monitoriar" --format '%T %w%f %e' --timefmt '%Y-%m-%d %H:%M:%S' |

while IFS=" | " read fecha archivo evento; do

    echo "$fecha - Cambio detectado: $evento en $archivo" >> "$log_archi"

done
