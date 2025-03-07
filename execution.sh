#!/bin/bash

# 1. Solicitar el nombre del archivo
read -p "Ingrese el nombre del archivo a ejecutar: " filename

# 2. Verificar si el archivo existe
if [[ ! -f "$filename" ]]; then
    echo "Error: El archivo no existe."
    exit 1
fi

# 3. Identificar el lenguaje según la extensión
extension="${filename##*.}"

# 4. Definir la imagen y el comando a ejecutar según el lenguaje
case "$extension" in
    py) 
        lang="Python";
        image="python:3.9";
        cmd="python3 $filename" ;;

    java)
        lang="Java";
        image="openjdk:17"; 
        cmd="javac $filename && java ${filename%.java}" ;;

    cpp|cc) 
        lang="C++"; 
        image="gcc:latest"; 
        cmd="g++ $filename -o program && ./program" ;;

    js) 
        lang="JavaScript"; 
        image="node:latest"; 
        cmd="node $filename" ;;

    rb) 
        lang="Ruby";
        image="ruby:latest";
        cmd="ruby $filename" ;;

    *) 
        echo "Error: Extensión no soportada.";
        exit 1 ;;
esac

# 4. Ejecutar el código en el contenedor
echo "Ejecutando $filename en un contenedor Docker con la imagen $image..."
start_time=$(date +%s%3N)
output=$(docker run --rm -v "$(pwd):/app" -w /app "$image" bash -c "$cmd" 2>&1)  
end_time=$(date +%s%3N)

# 5. Mostrar resultados
echo "Salida del programa:"
echo "$output"
echo "Tiempo de ejecución: $((end_time - start_time)) ms"
