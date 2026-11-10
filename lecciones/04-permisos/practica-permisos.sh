#!/bin/bash
# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Lección 04: Permisos — practica-permisos.sh
#
# Este script crea la carpeta de práctica del curso, practica-batch,
# dentro de la carpeta de usuario (~/practica-batch, la misma carpeta
# de las lecciones 02, 03 y 04), genera archivos de ejemplo con datos
# de un experimento con Chlorella vulgaris, crea el script
# scripts/analisis.sh, le da permiso de ejecución con chmod +x, lo
# ejecuta, protege un archivo privado con chmod 600 y muestra los
# permisos de los archivos creados. Solo trabaja dentro de
# ~/practica-batch, no toca ningún otro archivo de la computadora.
# Se puede ejecutar dos veces seguidas: vuelve a generar sus archivos
# de ejemplo sin borrar el trabajo que el alumno haya guardado dentro
# de practica-batch.

set -e

# cd entra a la carpeta de usuario, para que la carpeta de práctica
# sea siempre ~/practica-batch, sin importar desde dónde se ejecute el script.
cd "$HOME"

# Crear la carpeta de práctica y sus tres subcarpetas.
# mkdir -p no se queja si ya existen.
mkdir -p practica-batch/datos practica-batch/resultados practica-batch/scripts

# Devolver los permisos habituales a los archivos y carpetas de
# ejemplo, por si en los ejercicios se les cambiaron los permisos.
# Si alguno no existe todavía, chmod se queja y se sigue adelante.
chmod 644 practica-batch/datos/muestras.txt practica-batch/datos/notas.txt practica-batch/datos/lecturas.txt 2>/dev/null || true
chmod 755 practica-batch/datos practica-batch/scripts 2>/dev/null || true

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

# Crear el script analisis.sh, que cuenta las líneas de muestras.txt.
# Al crearlo con cat, el archivo nace sin permiso de ejecución.
# Se borra primero si existe de una ejecución anterior, para que
# nazca siempre con los permisos habituales de un archivo nuevo.
rm -f practica-batch/scripts/analisis.sh
cat > practica-batch/scripts/analisis.sh << 'EOF'
#!/bin/bash
# Cuenta las lineas del archivo datos/muestras.txt
echo "Lineas en muestras.txt:"
wc -l datos/muestras.txt
EOF

# Mostrar los permisos con los que nace el script.
echo "Permisos de analisis.sh al crearlo:"
ls -l practica-batch/scripts/analisis.sh

# Dar permiso de ejecución al script con chmod +x.
chmod +x practica-batch/scripts/analisis.sh

# Mostrar los permisos después de chmod +x.
echo "Permisos de analisis.sh despues de chmod +x:"
ls -l practica-batch/scripts/analisis.sh

# Entrar a la carpeta de práctica y ejecutar el script directamente.
# El script usa la ruta relativa datos/muestras.txt, por eso hay que
# ejecutarlo desde dentro de practica-batch.
cd practica-batch
./scripts/analisis.sh

# Crear un archivo privado y protegerlo: solo el propietario puede
# leerlo y escribir en él, con chmod 600. Se borra primero si existe
# de una ejecución anterior, para que nazca siempre con los permisos
# habituales de un archivo nuevo.
rm -f notas-privadas.txt
touch notas-privadas.txt
echo "Notas del experimento, solo para el propietario." > notas-privadas.txt
chmod 600 notas-privadas.txt
echo "Permisos de notas-privadas.txt:"
ls -l notas-privadas.txt

# Compartir notas.txt con el grupo, pero no con los demás usuarios,
# con chmod 640: el propietario lee y escribe, el grupo solo lee.
chmod 640 datos/notas.txt
echo "Permisos de datos/notas.txt:"
ls -l datos/notas.txt

# Mostrar el umask actual y crear un archivo nuevo, para ver con qué
# permisos nace en esta computadora. Se borra primero si existe de
# una ejecución anterior.
rm -f archivo-nuevo.txt
echo "Umask actual:"
umask
touch archivo-nuevo.txt
echo "Permisos de archivo-nuevo.txt:"
ls -l archivo-nuevo.txt

# Mostrar la estructura final de la carpeta de práctica con permisos.
# Ya estamos dentro de practica-batch, así que ls -l lista su contenido.
echo "Contenido de practica-batch:"
ls -l
echo "Contenido de practica-batch/datos:"
ls -l datos
echo "Contenido de practica-batch/scripts:"
ls -l scripts
