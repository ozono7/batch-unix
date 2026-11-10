#!/bin/bash
# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Lección 03: Archivos y carpetas — organiza-archivos.sh
#
# Este script crea la carpeta de práctica del curso, practica-batch,
# dentro de la carpeta de usuario (~/practica-batch, la misma carpeta
# de las lecciones 02 y 03), genera archivos de ejemplo con datos de
# un experimento, los copia, renombra uno, muestra su contenido y
# borra un archivo temporal. Solo trabaja dentro de ~/practica-batch,
# no toca ningún otro archivo de la computadora. Se puede ejecutar dos
# veces seguidas: vuelve a generar sus archivos de ejemplo sin borrar
# el trabajo que el alumno haya guardado dentro de practica-batch.

set -e

# cd entra a la carpeta de usuario, para que la carpeta de práctica
# sea siempre ~/practica-batch, sin importar desde dónde se ejecute el script.
cd "$HOME"

# Crear la carpeta de práctica y sus tres subcarpetas.
# mkdir -p no se queja si ya existen.
mkdir -p practica-batch/datos practica-batch/resultados practica-batch/scripts

# Crear el archivo muestras.txt con datos de 5 muestras.
# Cada línea tiene: muestra, tratamiento y OD680.
# OD680 es la densidad óptica medida a 680 nm.
cat > practica-batch/datos/muestras.txt << 'EOF'
muestra tratamiento OD680
M01 control 0.42
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
M05 control 0.44
EOF

# Crear el archivo notas.txt con notas del experimento.
cat > practica-batch/datos/notas.txt << 'EOF'
Experimento con Chlorella vulgaris.
Tratamientos: control, luz azul y luz roja.
La densidad óptica se mide a 680 nm (OD680).
EOF

# Crear el archivo lecturas.txt con 10 lecturas de OD680 a lo largo del día.
cat > practica-batch/datos/lecturas.txt << 'EOF'
lectura hora OD680
1 08:00 0.40
2 09:00 0.45
3 10:00 0.51
4 11:00 0.58
5 12:00 0.63
6 13:00 0.67
7 14:00 0.70
8 15:00 0.72
9 16:00 0.73
10 17:00 0.74
EOF

# Crear un archivo vacío con touch, para llevar un registro del experimento.
touch practica-batch/datos/registro.txt

# Copiar muestras.txt a la carpeta resultados.
cp practica-batch/datos/muestras.txt practica-batch/resultados/muestras-copia.txt

# Borrar solo la copia anterior de datos, si existe, para que cp -r
# no la copie dentro de sí misma al ejecutar el script dos veces.
# Es una carpeta que genera este mismo script, no trabajo del alumno.
rm -rf practica-batch/resultados/datos-copia

# Copiar toda la carpeta datos a resultados, con cp -r.
cp -r practica-batch/datos practica-batch/resultados/datos-copia

# Renombrar la copia con mv: cambiar el nombre del archivo.
mv practica-batch/resultados/muestras-copia.txt practica-batch/resultados/muestras-final.txt

# Mostrar el contenido completo de muestras.txt con cat.
echo "Contenido de muestras.txt:"
cat practica-batch/datos/muestras.txt

# Mostrar las primeras 3 líneas de lecturas.txt con head.
echo "Primeras 3 líneas de lecturas.txt:"
head -n 3 practica-batch/datos/lecturas.txt

# Mostrar las últimas 3 líneas de lecturas.txt con tail.
echo "Últimas 3 líneas de lecturas.txt:"
tail -n 3 practica-batch/datos/lecturas.txt

# Crear un archivo temporal y borrarlo con rm.
touch practica-batch/temporal.txt
rm practica-batch/temporal.txt

# Mostrar la estructura final de la carpeta de práctica.
echo "Estructura final de practica-batch:"
ls -R practica-batch
