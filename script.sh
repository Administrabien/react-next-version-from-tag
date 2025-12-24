#!/bin/bash

# Detener el script si algo falla
set -e

NOMBRE=$1

echo "------------------------------------------"
echo "Iniciando proceso personalizado..."
echo "Hola, $NOMBRE. Estamos en el directorio: $(pwd)"

# Ejemplo de lógica: Crear un archivo con la fecha
FECHA=$(date +'%Y-%m-%d %H:%M:%S')
echo "Log generado el: $FECHA" > log_ejecucion.txt

# Enviar una variable de salida de vuelta a GitHub Actions
echo "estado_final=completado" >> "$GITHUB_OUTPUT"
echo "version_detectada=v1.0.0" >> "$GITHUB_OUTPUT"
echo "------------------------------------------"