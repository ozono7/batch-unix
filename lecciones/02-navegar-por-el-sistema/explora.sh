#!/bin/bash
# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Lección 02: Navegar por el sistema — explora.sh
# explora.sh crea la carpeta de práctica y muestra la navegación en acción.
# La carpeta de práctica es practica-batch, dentro de la carpeta de usuario.
# El script solo crea archivos dentro de practica-batch, no toca nada fuera de ella.

# PRACTICA guarda la ruta de la carpeta de práctica.
PRACTICA="$HOME/practica-batch"

# mkdir -p crea la carpeta y sus subcarpetas. La opción -p evita un error si ya existen.
mkdir -p "$PRACTICA/datos" "$PRACTICA/resultados" "$PRACTICA/scripts"

# Los dos archivos de ejemplo solo se crean si todavía no existen.
if [ ! -f "$PRACTICA/datos/muestras.csv" ]; then
  printf 'muestra,od680\nM1,0.42\nM2,0.85\nM3,1.10\n' > "$PRACTICA/datos/muestras.csv"
fi
if [ ! -f "$PRACTICA/datos/notas.txt" ]; then
  printf 'Notas del experimento con Chlorella vulgaris.\n' > "$PRACTICA/datos/notas.txt"
fi
if [ ! -f "$PRACTICA/.registro" ]; then
  printf 'Registro de practica.\n' > "$PRACTICA/.registro"
fi

# cd entra a la carpeta de práctica y pwd muestra dónde estamos.
cd "$PRACTICA"
echo "Estamos en:"
pwd
echo "Contenido de practica-batch:"
ls

# cd entra a datos, pwd confirma la nueva ubicación y ls -l muestra los archivos con detalle.
cd datos
echo "Estamos en:"
pwd
echo "Contenido de datos:"
ls -l

# cd .. sube un nivel, de datos a practica-batch.
cd ..
echo "Subimos un nivel. Estamos en:"
pwd

# cd entra a resultados y ls muestra que está vacía.
cd resultados
echo "Estamos en:"
pwd
echo "Contenido de resultados:"
ls

# cd .. vuelve a practica-batch y cd entra a scripts.
cd ..
cd scripts
echo "Estamos en:"
pwd
echo "Contenido de scripts:"
ls

# cd vuelve a la carpeta de usuario y pwd confirma que salimos de la práctica.
cd
echo "Volvimos a home. Estamos en:"
pwd
