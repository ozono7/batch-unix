# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Lección 02: Navegar por el sistema

# Lección 02: Navegar por el sistema

En la lección 01 abriste la terminal y escribiste tus primeros comandos. En esta lección aprendes a moverte por el sistema de archivos: saber dónde estás, ver qué hay en cada carpeta y cambiar de una carpeta a otra. Al final, el script `explora.sh` hace todo el recorrido por ti, para que veas la navegación en acción.

## Una nota sobre las salidas que verás

Todos los comandos y todas las salidas de esta lección se ejecutaron de verdad antes de escribirla. Hay tres datos que cambian de una computadora a otra y que en tu computadora dirán tus propios valores:

- El nombre de usuario que aparece como dueño de los archivos. En las pruebas de esta lección dice `root`; en tu computadora dirá tu nombre de usuario.
- La fecha y la hora de los archivos. En las pruebas dice `Nov 10 05:28`; en tu computadora dirá el día y la hora en que tú crees los archivos.
- La ruta de tu carpeta de usuario. En las pruebas es `/home/hatch`; en tu computadora será tu propia ruta, por ejemplo `/Users/tu-usuario` en Mac o `/home/tu-usuario` en Ubuntu.

Los nombres de archivos y carpetas, los tamaños en bytes y los permisos son los que deben coincidir con lo que ves aquí.

## 1. La carpeta de práctica: `~/practica-batch`

Un **directorio** es una carpeta: un lugar que guarda archivos y otros directorios. Un **archivo** es un documento con contenido: un texto, una tabla de datos, un script. La carpeta de práctica de este curso es `~/practica-batch`. El símbolo `~` es una forma corta de escribir la ruta de tu carpeta de usuario, tu carpeta personal. Así, `~/practica-batch` significa "la carpeta `practica-batch` que está dentro de tu carpeta de usuario".

Si todavía no existe, se crea con `mkdir` (el comando `mkdir` se explica a fondo en la lección 03; aquí solo se usa). La opción `-p` crea la carpeta y sus subcarpetas en un solo paso, y no da error si ya existen:

```bash
mkdir -p ~/practica-batch/datos ~/practica-batch/resultados ~/practica-batch/scripts
```

Dentro de `practica-batch` queda esta estructura de ejemplo:

```text
practica-batch/
├── datos/
│   ├── muestras.csv
│   └── notas.txt
├── resultados/
├── scripts/
└── .registro
```

Cada parte tiene un papel: `datos/` guarda los datos de un experimento, `resultados/` guarda lo que se obtiene al analizarlos y `scripts/` guarda los programas que hacen el análisis. El archivo `.registro` empieza con un punto: es un archivo oculto, y en la sección 3 verás por qué no aparece en un listado normal.

Los dos archivos de ejemplo tienen este contenido. El archivo `datos/muestras.csv` es una tabla con tres mediciones de densidad óptica a 680 nm de un cultivo de *Chlorella vulgaris*:

```text
muestra,od680
M1,0.42
M2,0.85
M3,1.10
```

El archivo `datos/notas.txt` tiene una sola línea:

```text
Notas del experimento con Chlorella vulgaris.
```

## 2. `pwd`: saber dónde estás

El comando `pwd` muestra la carpeta en la que estás parado en este momento. Sus siglas vienen del inglés *print working directory*, "imprimir el directorio de trabajo". Lo que muestra es la **ruta absoluta**, es decir, la ruta completa desde la raíz del sistema hasta tu carpeta actual. La raíz se escribe con una sola barra `/` y es el punto de partida de todas las rutas absolutas.

Entra a la carpeta de práctica y pregunta dónde estás:

```bash
cd ~/practica-batch
pwd
```

Salida real:

```text
/home/hatch/practica-batch
```

En tu computadora la salida dirá tu propia ruta de usuario, por ejemplo `/Users/tu-usuario/practica-batch` en Mac. Lo importante es la forma: una ruta completa que empieza en `/` y termina en `practica-batch`.

## 3. `ls`: ver qué hay en una carpeta

El comando `ls` lista el contenido de una carpeta: muestra los nombres de los archivos y directorios que hay dentro. Sin opciones, lista la carpeta en la que estás parado.

```bash
cd ~/practica-batch
ls
```

Salida real:

```text
datos
resultados
scripts
```

El archivo `.registro` no aparece: `ls` sin opciones no muestra los archivos ocultos. Eso se corrige con `ls -a`, más abajo.

Para ver el contenido de otra carpeta sin entrar en ella, se escribe su nombre después de `ls`:

```bash
ls datos
```

Salida real:

```text
muestras.csv
notas.txt
```

### `ls -l`: el listado con detalle

La opción `-l` (de *long*, largo) muestra una línea por cada elemento, con detalle. Es el listado que más se usa para revisar archivos.

```bash
ls -l datos
```

Salida real:

```text
total 8
-rw-rw---- 1 root root 38 Nov 10 05:28 muestras.csv
-rw-rw---- 1 root root 46 Nov 10 05:28 notas.txt
```

La línea `total 8` indica los bloques de disco que ocupa el listado; no es el tamaño de los archivos. Cada línea siguiente tiene siete columnas:

| Columna | Ejemplo | Significado |
| --- | --- | --- |
| Permisos | `-rw-rw----` | Quién puede leer, escribir y ejecutar el archivo. El primer carácter dice el tipo: `-` es un archivo y `d` es un directorio. |
| Enlaces | `1` | Número de enlaces al archivo. Para un archivo suele ser `1`; para una carpeta es `2` o más. |
| Dueño | `root` | El usuario al que pertenece el archivo. En tu computadora dirá tu nombre de usuario. |
| Grupo | `root` | El grupo al que pertenece el archivo. |
| Tamaño | `38` | El tamaño del archivo en bytes. `muestras.csv` ocupa 38 bytes y `notas.txt` ocupa 46 bytes. |
| Fecha | `Nov 10 05:28` | La fecha y la hora de la última modificación. |
| Nombre | `muestras.csv` | El nombre del archivo. |

Los permisos `-rw-rw----` se leen en tres grupos de tres letras: el dueño puede leer (`r`) y escribir (`w`), el grupo puede leer y escribir, y los demás usuarios no tienen ningún permiso (los tres guiones). La `x` de ejecutar no aparece porque estos archivos son datos, no programas.

El listado de la propia carpeta de práctica muestra carpetas, y ahí el primer carácter es `d`:

```bash
ls -l
```

Salida real:

```text
total 0
drwxrwx--- 2 root root 80 Nov 10 05:28 datos
drwxrwx--- 2 root root 40 Nov 10 05:28 resultados
drwxrwx--- 2 root root 40 Nov 10 05:28 scripts
```

La `d` inicial de `drwxrwx---` indica que `datos`, `resultados` y `scripts` son directorios. Aquí el tamaño (80, 40, 40) es el tamaño que ocupa la propia carpeta en disco, no la suma de lo que hay dentro.

### `ls -a`: mostrar también los archivos ocultos

La opción `-a` (de *all*, todo) muestra todos los elementos, incluidos los ocultos. Un **archivo oculto** es un archivo cuyo nombre empieza con un punto. Los programas guardan ahí su configuración, y por eso `ls` no los muestra en un listado normal: no son archivos para borrar sin pensar.

```bash
ls -a
```

Salida real:

```text
.
..
.registro
datos
resultados
scripts
```

Además de `.registro`, aparecen `.` y `..`: son dos entradas especiales que existen en todas las carpetas y se explican en la sección 5.

### `ls -lh`: tamaños fáciles de leer

La opción `-h` (de *human*, humano) muestra los tamaños en unidades fáciles de leer, como `K` para kilobytes o `M` para megabytes, en lugar de bytes. Se combina con `-l`:

```bash
ls -lh datos
```

Salida real:

```text
total 8.0K
-rw-rw---- 1 root root 38 Nov 10 05:28 muestras.csv
-rw-rw---- 1 root root 46 Nov 10 05:28 notas.txt
```

Los archivos pequeños siguen mostrando su tamaño en bytes (38 y 46), porque todavía no llegan a un kilobyte. Con archivos grandes la diferencia se nota: un archivo de 2048 bytes se muestra como `2.0K`.

### `ls -t`: ordenar por fecha

La opción `-t` (de *time*, tiempo) ordena el listado por fecha de modificación, del más reciente al más antiguo. Sirve para encontrar el archivo que acabas de modificar.

```bash
ls -t datos
```

Salida real (después de modificar `notas.txt`, que quedó como el archivo más reciente):

```text
notas.txt
muestras.csv
```

### Combinar opciones: `ls -lah`

Las opciones se pueden combinar en un solo grupo de letras. El comando `ls -lah` equivale a `ls -l -a -h`: listado con detalle, con archivos ocultos y con tamaños fáciles de leer.

```bash
ls -lah
```

Salida real:

```text
total 4.0K
drwxrwx--- 5 root root 120 Nov 10 05:28 .
drwxrwx--- 3 root root  60 Nov 10 05:28 ..
-rw-rw---- 1 root root  22 Nov 10 05:28 .registro
drwxrwx--- 2 root root  80 Nov 10 05:28 datos
drwxrwx--- 2 root root  40 Nov 10 05:28 resultados
drwxrwx--- 2 root root  40 Nov 10 05:28 scripts
```

Aquí se ve todo: el archivo oculto `.registro` ocupa 22 bytes, y las entradas `.` y `..` aparecen con sus propios permisos y tamaños.

## 4. `cd`: cambiar de carpeta

El comando `cd` cambia la carpeta en la que estás parado. Sus siglas vienen del inglés *change directory*, "cambiar de directorio". Después de un `cd`, los comandos siguientes (`ls`, `pwd`) se refieren a la nueva ubicación.

```bash
cd ~/practica-batch
cd datos
pwd
```

Salida real:

```text
/home/hatch/practica-batch/datos
```

### Ruta absoluta y ruta relativa

Una **ruta absoluta** empieza en la raíz `/` y describe el camino completo hasta el destino. Funciona igual estés donde estés. Una **ruta relativa** empieza en la carpeta en la que estás parado y describe el camino desde ahí. Es más corta, pero solo funciona si partes del lugar correcto.

Ruta absoluta, desde cualquier lugar:

```bash
cd /home/hatch/practica-batch/datos
pwd
```

Salida real:

```text
/home/hatch/practica-batch/datos
```

En tu computadora, la ruta absoluta dirá tu propia ruta de usuario en lugar de `/home/hatch`.

Ruta relativa, estando en `practica-batch`:

```bash
cd ~/practica-batch
cd datos
pwd
```

Salida real:

```text
/home/hatch/practica-batch/datos
```

Las dos llegan al mismo lugar. La ruta relativa `datos` es más corta porque ya estás en `practica-batch`; la ruta absoluta es más larga pero no depende de dónde estés parado.

### `cd ..`: subir un nivel

Dos puntos (`..`) significan "la carpeta padre", la carpeta que contiene a la carpeta actual. El comando `cd ..` sube un nivel:

```bash
cd ~/practica-batch/datos
pwd
cd ..
pwd
```

Salida real:

```text
/home/hatch/practica-batch/datos
/home/hatch/practica-batch
```

Se pueden encadenar dos niveles con una sola ruta: `cd ../..` sube dos niveles. Desde `datos`, el primer `..` lleva a `practica-batch` y el segundo lleva a la carpeta que contiene a `practica-batch`:

```bash
cd ~/practica-batch/datos
cd ../..
pwd
```

Salida real:

```text
/home/hatch
```

### `cd -`: volver a la carpeta anterior

El comando `cd -` vuelve a la carpeta en la que estabas justo antes. El guion `-` significa "la carpeta anterior". La terminal además escribe la ruta a la que llega, para que veas el salto:

```bash
cd ~/practica-batch
cd datos
cd -
pwd
```

Salida real:

```text
/home/hatch/practica-batch
/home/hatch/practica-batch
```

La primera línea es lo que escribe `cd -` al llegar; la segunda es lo que muestra `pwd`. Si vuelves a escribir `cd -`, regresas a `datos`: el comando salta de un lado al otro entre las dos últimas carpetas.

### `cd` sin argumentos y `cd ~`: ir a home

El comando `cd` sin nada más, y el comando `cd ~`, te llevan a tu carpeta de usuario, tu carpeta personal. Los dos hacen lo mismo:

```bash
cd
pwd
```

Salida real:

```text
/home/hatch
```

En tu computadora dirá tu propia ruta de usuario. Es el comando para volver a casa cuando ya no sabes dónde estás parado.

## 5. `.` y `..`: la carpeta actual y la carpeta padre

Hay dos nombres especiales que existen en todas las carpetas:

- Un punto (`.`) significa "esta carpeta", la carpeta en la que estás parado. Es el directorio actual.
- Dos puntos (`..`) significan "la carpeta padre", la carpeta que contiene a la carpeta actual.

Ya usaste `..` con `cd ..`. También se usan como parte de una ruta. Estando en `datos`, `ls .` lista la carpeta actual y `ls ..` lista la carpeta padre:

```bash
cd ~/practica-batch/datos
ls .
ls ..
```

Salida real:

```text
muestras.csv
notas.txt
datos
resultados
scripts
```

La primera salida es el contenido de `datos` (la carpeta actual). La segunda es el contenido de `practica-batch` (la carpeta padre). Observa que `ls ..` no muestra `.registro`, porque es un archivo oculto y `ls` sin `-a` no lo muestra.

También se usan para entrar a una carpeta vecina sin subir primero con `cd ..`. Estando en `datos`, la carpeta `resultados` está al mismo nivel, así que se llega con `../resultados`:

```bash
cd ~/practica-batch/datos
ls ../resultados
```

La salida está vacía, porque `resultados/` todavía no tiene archivos. La ruta `../resultados` significa: sube un nivel a `practica-batch` y entra a `resultados`.

## 6. Autocompletado con Tab

Escribir rutas largas letra por letra es lento y es fácil equivocarse en una letra. La terminal ayuda con el **autocompletado**: escribes las primeras letras de un nombre y pulsas la tecla `Tab`, y la terminal completa el resto por ti.

Practícalo con la carpeta de práctica. Escribe esto sin pulsar Enter todavía:

```bash
cd ~/practica-batch/da
```

Pulsa `Tab`. La terminal completa el nombre hasta `datos`, porque es la única carpeta que empieza con `da`:

```bash
cd ~/practica-batch/datos
```

Ahora pulsa Enter y comprueba con `pwd` que llegaste a `datos`.

Si hay varias opciones que empiezan igual, al pulsar `Tab` dos veces la terminal lista todas las opciones para que elijas. Por ejemplo, si escribes `cd ~/practica-batch/r` y pulsas `Tab` dos veces, la terminal muestra `resultados`, que es la única carpeta que empieza con `r`, y la completa. En `bash`, pulsar `Tab` dos veces lista las opciones; en `zsh` el comportamiento es parecido. El autocompletado también funciona con nombres de archivos y con nombres de comandos.

## 7. El script `explora.sh`: la navegación en acción

El archivo `explora.sh`, que acompaña a esta lección, crea la estructura de práctica si todavía no existe y luego entra a cada carpeta con `cd`, mostrando `pwd` y `ls` en cada parada. Así ves la navegación completa en una sola ejecución. Los comentarios del script explican cada paso directamente.

Para ejecutarlo, entra a la carpeta de la lección y escribe:

```bash
bash explora.sh
```

Salida real de la ejecución (en tu computadora, las rutas dirán tu nombre de usuario en lugar de `/home/hatch`):

```text
Estamos en:
/home/hatch/practica-batch
Contenido de practica-batch:
datos
resultados
scripts
Estamos en:
/home/hatch/practica-batch/datos
Contenido de datos:
total 8
-rw-rw---- 1 root nogroup 38 Nov 10 05:28 muestras.csv
-rw-rw---- 1 root nogroup 46 Nov 10 05:28 notas.txt
Subimos un nivel. Estamos en:
/home/hatch/practica-batch
Estamos en:
/home/hatch/practica-batch/resultados
Contenido de resultados:
Estamos en:
/home/hatch/practica-batch/scripts
Contenido de scripts:
Volvimos a home. Estamos en:
/home/hatch
```

Observa dos detalles de la salida. Primero, el contenido de `resultados` y de `scripts` está vacío: `ls` no escribe nada cuando la carpeta no tiene archivos. Segundo, el script termina con `cd` sin argumentos, así que al final siempre quedas en tu carpeta de usuario.

El script también se puede ejecutar con `sh explora.sh`. Las dos formas se probaron y dan el mismo resultado. El script solo crea archivos dentro de `practica-batch`: no toca nada fuera de esa carpeta. Si lo ejecutas dos veces, la segunda vez no duplica nada, porque los archivos de ejemplo solo se crean si todavía no existen.

Una nota sobre el manual: el comando `man ls` muestra el manual completo de `ls`, con todas sus opciones. En Mac y en Ubuntu, `man` está instalado y `man ls` se prueba ahí. En el entorno donde se verificó esta lección, `man` no está instalado, así que esa parte se comprueba en tu propia computadora.

## 8. Ejercicios

### Ejercicio 1: entrar a `datos` con ruta relativa y con ruta absoluta

Desde tu carpeta de usuario, entra a `practica-batch/datos` primero con una ruta relativa y luego con una ruta absoluta. Comprueba en cada caso con `pwd` que llegaste al mismo lugar.

```bash
cd
cd practica-batch/datos
pwd
cd
cd ~/practica-batch/datos
pwd
```

Resultado esperado: en los dos casos, `pwd` muestra la ruta completa de `datos`, con tu nombre de usuario en lugar de `/home/hatch`:

```text
/home/hatch/practica-batch/datos
/home/hatch/practica-batch/datos
```

La ruta relativa `practica-batch/datos` funciona porque partes de tu carpeta de usuario. La ruta absoluta `~/practica-batch/datos` funciona desde cualquier lugar.

### Ejercicio 2: listar solo los archivos ocultos

Desde `practica-batch`, lista únicamente los archivos ocultos, sin mostrar las carpetas. Usa la opción `-d` de `ls`, que lista los nombres tal cual sin entrar a las carpetas, combinada con el patrón de los nombres que empiezan con punto:

```bash
cd ~/practica-batch
ls -d .[^.]*
```

Resultado esperado:

```text
.registro
```

El patrón `.[^.]*` significa: un punto, seguido de cualquier carácter que no sea un punto, seguido de lo que sea. Así muestra `.registro` y deja fuera a `.` y a `..`.

### Ejercicio 3: volver a home de dos formas

Desde `practica-batch/datos`, vuelve a tu carpeta de usuario primero con `cd ..` dos veces y luego con `cd` sin argumentos. Comprueba en cada caso con `pwd`.

```bash
cd ~/practica-batch/datos
cd ../..
pwd
cd ~/practica-batch/datos
cd
pwd
```

Resultado esperado: en los dos casos, `pwd` muestra tu carpeta de usuario:

```text
/home/hatch
/home/hatch
```

## Qué aprendimos

- Un directorio es una carpeta que guarda archivos y otros directorios; un archivo es un documento con contenido. La carpeta de práctica de este curso es `~/practica-batch`, dentro de tu carpeta de usuario.
- `pwd` muestra la carpeta en la que estás parado, como ruta absoluta desde la raíz `/`.
- `ls` lista el contenido de una carpeta. Con `ls -l` se ve el detalle de cada elemento: permisos, enlaces, dueño, grupo, tamaño, fecha y nombre. Con `ls -a` se ven también los archivos ocultos, cuyos nombres empiezan con un punto. Con `ls -lh` los tamaños se leen en kilobytes o megabytes. Con `ls -t` el listado se ordena del archivo más reciente al más antiguo. Las opciones se combinan, por ejemplo `ls -lah`.
- `cd` cambia de carpeta. `cd ..` sube un nivel a la carpeta padre y `cd -` vuelve a la carpeta anterior. `cd` sin argumentos y `cd ~` llevan a tu carpeta de usuario.
- Una ruta absoluta empieza en `/` y funciona desde cualquier lugar; una ruta relativa empieza en la carpeta actual y es más corta.
- El punto (`.`) significa la carpeta actual y los dos puntos (`..`) significan la carpeta padre. Existen en todas las carpetas y se usan solos o como parte de una ruta.
- Con la tecla `Tab` la terminal completa el nombre que estás escribiendo. Si hay varias opciones, pulsar `Tab` dos veces las lista.
- El script `explora.sh` crea la estructura de práctica y recorre cada carpeta con `cd`, `pwd` y `ls`, y termina volviendo a tu carpeta de usuario.
