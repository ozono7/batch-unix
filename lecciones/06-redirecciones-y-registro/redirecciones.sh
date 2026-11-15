#!/bin/bash
# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Lección 06: Redirecciones y archivos de registro — redirecciones.sh
#
# Este script crea la carpeta de práctica del curso, practica-batch,
# dentro de la carpeta de usuario (~/practica-batch, la misma carpeta
# de las lecciones 02, 03, 04 y 05), genera archivos de ejemplo con
# datos de un experimento con Chlorella vulgaris y con Scenedesmus
# acutus, y después guarda resultados en archivos con las
# redirecciones >, >>, 2>, 2>> y 2>&1, descarta salidas con /dev/null,
# muestra y guarda a la vez con tee, y arma el registro de un análisis
# en un archivo. Solo trabaja dentro de ~/practica-batch, no toca
# ningún otro archivo de la computadora. Se puede ejecutar dos veces
# seguidas: vuelve a generar sus archivos de ejemplo sin borrar el
# trabajo que el alumno haya guardado dentro de practica-batch.

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

# Crear el archivo muestras-scenedesmus.txt con datos de 3 muestras
# de Scenedesmus acutus, con la misma forma que muestras.txt.
cat > practica-batch/datos/muestras-scenedesmus.txt << 'EOF'
muestra tratamiento OD680
S01 control 0.38
S02 luz_azul 0.61
S03 luz_roja 0.66
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

# Guardar las muestras con luz azul en un archivo con >.
# El archivo se crea si no existe y se vacía si ya existía.
echo "Muestras con luz_azul, guardadas en resultados/luz-azul.txt:"
grep "luz_azul" practica-batch/datos/muestras.txt > practica-batch/resultados/luz-azul.txt
cat practica-batch/resultados/luz-azul.txt

# Añadir las muestras con luz roja al mismo archivo con >>.
# Con >> el archivo no se vacía: las líneas nuevas se añaden al final.
echo "Muestras con luz, despues de anadir las de luz_roja:"
grep "luz_roja" practica-batch/datos/muestras.txt >> practica-batch/resultados/luz-azul.txt
cat practica-batch/resultados/luz-azul.txt

# Crear un archivo vacío con > y comprobar que pesa 0 bytes.
echo "Bytes de un archivo creado con > y sin nada dentro:"
> practica-batch/resultados/vacio.txt
wc -c practica-batch/resultados/vacio.txt

# Mostrar el peligro de redirigir un archivo sobre sí mismo.
# La shell vacía el archivo de destino antes de que cat lo lea,
# así que el archivo queda vacío.
cp practica-batch/datos/notas.txt practica-batch/datos/notas-copia.txt
cat practica-batch/datos/notas-copia.txt > practica-batch/datos/notas-copia.txt
echo "Lineas que quedan en notas-copia.txt despues de cat archivo > archivo:"
wc -l practica-batch/datos/notas-copia.txt

# Guardar los errores de una búsqueda en un archivo con 2>.
# El archivo no existe, así que grep escribe el error en la salida
# de errores y termina con código 2. El || true evita que el script
# se detenga por ese código, como se explica en la lección.
echo "Errores de buscar en un archivo que no existe:"
grep "luz" practica-batch/datos/no-existe.txt > practica-batch/resultados/busqueda.txt 2> practica-batch/resultados/errores-busqueda.txt || true
cat practica-batch/resultados/errores-busqueda.txt

# Guardar la salida normal y los errores juntos con 2>&1.
echo "Salida y errores juntos en resultados/todo.txt:"
grep "luz" practica-batch/datos/no-existe.txt > practica-batch/resultados/todo.txt 2>&1 || true
cat practica-batch/resultados/todo.txt

# Añadir errores a un archivo con 2>>.
# Primero se crea con 2> y después se añaden más errores con 2>>.
echo "Errores acumulados en resultados/errores.txt:"
ls practica-batch/datos/archivo-inexistente.txt 2> practica-batch/resultados/errores.txt || true
ls practica-batch/datos/otro-inexistente.txt 2>> practica-batch/resultados/errores.txt || true
cat practica-batch/resultados/errores.txt

# Mostrar el código de salida de una búsqueda sin resultados,
# descartando su salida con /dev/null. El código se guarda en la
# variable codigo porque, con ||, $? ya no sería el de grep.
echo "Codigo de salida de una busqueda sin resultados:"
grep "Scenedesmus" practica-batch/datos/muestras.txt > /dev/null 2>&1 || codigo=$?
echo "Codigo de salida: $codigo"

# Ver las muestras con luz en pantalla y guardarlas a la vez con tee.
# tee escribe en el archivo y también deja pasar la salida, que aquí
# cuenta wc -l.
echo "Muestras con luz, vistas en pantalla y guardadas con tee:"
grep "luz" practica-batch/datos/muestras.txt | tee practica-batch/resultados/luz.txt | wc -l

# Juntar las muestras de las dos especies en un solo archivo con cat y >.
echo "Muestras de Chlorella y de Scenedesmus juntas:"
cat practica-batch/datos/muestras.txt practica-batch/datos/muestras-scenedesmus.txt > practica-batch/resultados/muestras-todas.txt
cat practica-batch/resultados/muestras-todas.txt

# Armar el registro del análisis: la salida normal va al registro
# con >> y los errores van a un archivo aparte con 2>.
echo "Registro del analisis:"
echo "Registro del analisis del experimento con Chlorella vulgaris" > practica-batch/resultados/registro-analisis.txt
echo "Muestras con luz azul:" >> practica-batch/resultados/registro-analisis.txt
grep "luz_azul" practica-batch/datos/muestras.txt >> practica-batch/resultados/registro-analisis.txt
echo "Mediciones registradas en el dia:" >> practica-batch/resultados/registro-analisis.txt
grep -c "medicion" practica-batch/datos/registro.txt >> practica-batch/resultados/registro-analisis.txt
ls practica-batch/datos/no-existe.txt >> practica-batch/resultados/registro-analisis.txt 2> practica-batch/resultados/errores-analisis.txt || true
cat practica-batch/resultados/registro-analisis.txt
echo "Errores del analisis:"
cat practica-batch/resultados/errores-analisis.txt
