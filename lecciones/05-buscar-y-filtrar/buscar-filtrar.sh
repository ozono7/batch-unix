#!/bin/bash
# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Lección 05: Buscar y filtrar — buscar-filtrar.sh
#
# Este script crea la carpeta de práctica del curso, practica-batch,
# dentro de la carpeta de usuario (~/practica-batch, la misma carpeta
# de las lecciones 02, 03, 04 y 05), genera archivos de ejemplo con
# datos de un experimento con Chlorella vulgaris, y después busca y
# filtra en ellos con grep, find, sort, uniq y wc. Solo trabaja dentro
# de ~/practica-batch, no toca ningún otro archivo de la computadora.
# Se puede ejecutar dos veces seguidas: vuelve a generar sus archivos
# de ejemplo sin borrar el trabajo que el alumno haya guardado dentro
# de practica-batch.

set -e

# cd entra a la carpeta de usuario, para que la carpeta de práctica
# sea siempre ~/practica-batch, sin importar desde dónde se ejecute el script.
cd "$HOME"

# Crear la carpeta de práctica y sus subcarpetas.
# mkdir -p no se queja si ya existen.
mkdir -p practica-batch/datos/respaldo practica-batch/resultados practica-batch/scripts

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

# Crear el archivo notas.txt con notas del experimento.
cat > practica-batch/datos/notas.txt << 'EOF'
Experimento con Chlorella vulgaris.
Tratamientos: control, luz azul y luz roja.
La densidad óptica se mide a 680 nm (OD680).
EOF

# Crear el archivo registro.txt con el registro del día de trabajo.
# Cada línea tiene: fecha, hora y lo que se hizo.
cat > practica-batch/datos/registro.txt << 'EOF'
2026-11-10 08:00 inicio del cultivo control
2026-11-10 08:15 medicion OD680 control
2026-11-10 09:00 cambio a luz_azul
2026-11-10 09:30 medicion OD680 luz_azul
2026-11-10 10:00 cambio a luz_roja
2026-11-10 10:30 medicion OD680 luz_roja
2026-11-10 11:00 medicion OD680 luz_azul
2026-11-10 11:30 fin del dia
EOF

# Crear el archivo tratamientos.txt con un tratamiento por línea.
# Cada línea es el tratamiento que se aplicó en una medición.
# Hay tratamientos repetidos, para contarlos con sort y uniq.
cat > practica-batch/datos/tratamientos.txt << 'EOF'
control
luz_azul
luz_roja
luz_azul
control
luz_azul
luz_roja
control
EOF

# Crear una copia de respaldo de muestras.txt en datos/respaldo.
cp practica-batch/datos/muestras.txt practica-batch/datos/respaldo/muestras-2026-11-05.txt

# Crear el archivo resumen.txt con un resumen del experimento.
cat > practica-batch/resultados/resumen.txt << 'EOF'
Resumen del experimento con Chlorella vulgaris.
Muestras analizadas: 5
Tratamientos: control, luz azul y luz roja.
EOF

# Crear el script analisis.sh de la lección 04, por si se borró.
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
chmod +x practica-batch/scripts/analisis.sh

# Buscar las muestras con luz azul.
echo "Muestras con luz_azul:"
grep "luz_azul" practica-batch/datos/muestras.txt

# Contar cuántas mediciones se registraron en el día.
echo "Mediciones registradas en registro.txt:"
grep -c "medicion" practica-batch/datos/registro.txt

# Listar los archivos de texto de la carpeta datos, ordenados.
echo "Archivos .txt en datos:"
find practica-batch/datos -name "*.txt" | sort

# Contar las líneas de cada archivo de datos.
echo "Lineas en cada archivo de datos:"
wc -l practica-batch/datos/*.txt

# Contar cuántas veces se aplicó cada tratamiento.
echo "Veces que se aplico cada tratamiento:"
sort practica-batch/datos/tratamientos.txt | uniq -c

# Contar cuántas veces se menciona cada luz en el registro del día.
echo "Menciones de cada luz en registro.txt:"
grep -o "luz_[a-z]*" practica-batch/datos/registro.txt | sort | uniq -c

# Ordenar las muestras por su valor de OD680, de menor a mayor.
echo "Muestras ordenadas por OD680:"
LC_ALL=C sort -k3 -n practica-batch/datos/muestras.txt

# Mostrar las 3 muestras con mayor OD680.
echo "Las 3 muestras con mayor OD680:"
LC_ALL=C sort -k3 -nr practica-batch/datos/muestras.txt | head -3

# Mostrar qué archivos de datos mencionan OD680.
echo "Archivos de datos que mencionan OD680:"
grep -l "OD680" practica-batch/datos/*.txt
