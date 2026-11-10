# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Ruta de aprendizaje (ROADMAP)

# Ruta de aprendizaje: de principiante a intermedio

Esta es la ruta completa del curso, en orden. Cada lección usa lo aprendido en las anteriores, por lo que se siguen de la 01 a la 14 sin saltarse ninguna.

Se publica una lección nueva cada dos días. La guía de uso del repositorio, los requisitos por sistema operativo y las advertencias de seguridad están en [README.md](README.md).

## Estado de las lecciones

- **Listas:** lecciones 01, 02, 03 y 04.
- **En preparación:** lecciones 05 a 14.

## Bloque 1. Primeros pasos en la terminal

Requisito previo: ninguno. Solo se necesita una terminal con una shell Unix, según el sistema operativo (ver [README.md](README.md)).

### 01. La terminal y la shell — Lista

Qué es la terminal, qué es la shell, qué es el prompt y cómo se escribe y se ejecuta un primer comando.

Al terminar, el alumno sabrá abrir la terminal, distinguir la terminal de la shell, leer el prompt y ejecutar comandos sencillos.

### 02. Navegar por el sistema — Lista

Moverse entre carpetas con `pwd`, `ls` y `cd`, y entender la ruta absoluta y la ruta relativa.

Al terminar, el alumno sabrá decir en qué carpeta está, ver qué contiene una carpeta y moverse a otra carpeta por su ruta.

### 03. Archivos y carpetas — Lista

Crear, copiar, mover, renombrar y borrar archivos y carpetas con `mkdir`, `touch`, `cp`, `mv` y `rm`, y ver el contenido de un archivo con `cat`, `less`, `head` y `tail`.

Al terminar, el alumno sabrá organizar sus archivos desde la terminal y crear la carpeta de práctica `~/practica-batch`, que se usa en todo el curso.

## Bloque 2. Manejar archivos con seguridad y precisión

Requisito previo: lecciones 01 a 03.

### 04. Permisos — Lista

Leer los permisos de un archivo, cambiarlos con `chmod`, cambiar el propietario con `chown` y entender qué es `umask`.

Al terminar, el alumno sabrá leer los permisos de un archivo, dar o quitar permiso de lectura, escritura y ejecución, y entender por qué un script necesita permiso de ejecución para correrse como `./script.sh`.

### 05. Buscar y filtrar — En preparación

Buscar texto dentro de archivos con `grep`, buscar archivos con `find`, encadenar comandos con pipes (`|`) y ordenar, contar y resumir resultados con `sort`, `uniq` y `wc`.

Al terminar, el alumno sabrá buscar una palabra dentro de varios archivos, localizar archivos por nombre o por fecha y combinar comandos para filtrar y contar resultados.

### 06. Redirecciones y archivos de registro — En preparación

Guardar la salida de un comando en un archivo con `>` y `>>`, separar la salida normal de los errores con `2>`, y ver la salida en pantalla y guardarla a la vez con `tee`.

Al terminar, el alumno sabrá guardar los resultados de un comando en un archivo, añadir resultados a un archivo existente sin borrarlo y guardar un registro de lo que hizo un análisis.

## Bloque 3. El entorno y los primeros scripts

Requisito previo: lecciones 01 a 06.

### 07. Variables y entorno — En preparación

Crear y usar variables, entender qué es `$PATH` y por qué la shell encuentra unos comandos y otros no, guardar valores con `export` y guardar la configuración en `.bashrc` o en `.zshrc`, según la shell.

Al terminar, el alumno sabrá guardar un valor en una variable y usarlo en un comando, añadir una carpeta al `$PATH` y guardar su configuración para que se cargue cada vez que abre la terminal.

### 08. Primer script `.sh` — En preparación

Escribir un script con su shebang, darle permiso de ejecución con `chmod +x`, correrlo como `./script.sh` y recibir datos con los argumentos `$1` y `$2`.

Al terminar, el alumno sabrá escribir un archivo `.sh` que agrupe varios comandos, ejecutarlo de las dos formas explicadas en el README y pasarle datos como argumentos.

### 09. Bucles y condicionales — En preparación

Repetir una acción sobre varios archivos con `for` y con `while`, y decidir qué hacer según una condición con `if`.

Al terminar, el alumno sabrá escribir un script que aplique el mismo comando a todos los archivos de una carpeta y que actúe de forma distinta según el resultado de una comprobación.

## Bloque 4. Datos y herramientas

Requisito previo: lecciones 01 a 09.

### 10. Procesar archivos de datos con `awk` y `cut` — En preparación

Elegir columnas de un archivo de texto con `cut`, y seleccionar y resumir filas y columnas con `awk`.

Al terminar, el alumno sabrá extraer una columna de un archivo tabulado, filtrar filas por el valor de una columna y calcular resúmenes sencillos, como contar filas o sumar valores de una columna.

### 11. Descargar y descomprimir datos — En preparación

Descargar archivos de internet con `curl` y con `wget`, y descomprimirlos con `tar`, `unzip` y `gzip`.

Al terminar, el alumno sabrá descargar un archivo de datos desde la terminal, comprobar que la descarga se completó y descomprimirlo en la carpeta de trabajo.

## Bloque 5. Conda y automatización

Requisito previo para las lecciones 12 y 13: lecciones 08, 09 y 11. Para instalar herramientas con conda y usarlas en un script hay que saber escribir un script (08), repetir una acción sobre varios archivos (09) y descargar datos (11).

Requisito previo para la lección 14: lección 08. Para programar un script con cron hay que tener un script que funcione por sí solo.

### 12. Conda: instalar Miniconda y crear ambientes — En preparación

Instalar Miniconda y crear, activar, desactivar y borrar ambientes de conda.

Al terminar, el alumno sabrá instalar Miniconda en su computadora, crear un ambiente aislado para un proyecto y activar y desactivar ese ambiente.

### 13. Conda para bioinformática — En preparación

Instalar herramientas de bioinformática en un ambiente de conda, como `fastqc`, `multiqc` y `samtools`, y usarlas sobre archivos de datos.

Al terminar, el alumno sabrá instalar herramientas de bioinformática sin mezclarlas con el resto del sistema, comprobar que quedaron instaladas y correr un control de calidad o un análisis sencillo dentro de su ambiente.

### 14. Automatizar con cron y crontab — En preparación

Programar un script para que se ejecute solo en una fecha y hora con `cron` y `crontab`, y revisar si la tarea programada se ejecutó.

Al terminar, el alumno sabrá escribir una entrada de crontab para un script, programar su ejecución periódica y comprobar que la tarea se ejecutó y dónde quedó su salida.

## Qué se podrá hacer al terminar el curso

Al terminar las 14 lecciones, el alumno podrá:

- Manejar datos por terminal: navegar entre carpetas, organizar archivos, buscar texto dentro de ellos, filtrar y resumir tablas y descargar y descomprimir datos.
- Escribir scripts que repitan un análisis: guardar una serie de comandos en un archivo `.sh`, pasarle datos como argumentos, repetirlo sobre varios archivos con bucles y ejecutarlo de nuevo sin escribir cada comando a mano.
- Instalar y usar herramientas bioinformáticas con conda: crear ambientes aislados, instalar herramientas como `fastqc`, `multiqc` y `samtools`, y usarlas sobre sus propios datos.
- Programar tareas automáticas: programar un script con cron para que se ejecute solo en la fecha y hora indicadas, y guardar su salida en un archivo de registro para revisarla después.
