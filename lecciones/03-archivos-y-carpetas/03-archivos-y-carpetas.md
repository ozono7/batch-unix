# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Lección 03: Archivos y carpetas

# Lección 03: Archivos y carpetas

En esta lección vas a crear, copiar, mover, renombrar, borrar y ver
archivos y carpetas desde la terminal. Todo lo que hagas aquí ocurre
dentro de una carpeta de práctica, así que puedes equivocarte sin
riesgo: nada de lo que borres aquí afecta al resto de tu computadora.

Primero, algunas palabras que usaremos en toda la lección:

- **Archivo**: un conjunto de datos guardado con un nombre, por ejemplo
  `muestras.txt`. Un archivo de texto contiene líneas de texto que se
  pueden leer.
- **Carpeta** (también llamada **directorio**): un contenedor que guarda
  archivos y otras carpetas. Por ejemplo, la carpeta `datos/` guarda los
  archivos de un experimento.
- **Ruta**: la dirección de un archivo o carpeta. Una **ruta relativa**
  se escribe desde la carpeta donde estás parado, por ejemplo
  `datos/muestras.txt`. Una **ruta absoluta** se escribe desde la raíz
  del sistema, por ejemplo `/home/usuario/practica-batch/datos`.
- **`~`**: es un atajo que significa tu **carpeta personal** (tu home).
  En tu computadora, `~/practica-batch` es la carpeta `practica-batch`
  dentro de tu carpeta personal. En tu computadora verás tu propio
  nombre de usuario y tu propia ruta en lugar de los de estos ejemplos.

Antes de empezar, abre la terminal y comprueba en qué carpeta estás:

```bash
pwd
```

`pwd` muestra la ruta de la carpeta donde estás parado. Todos los
ejemplos de esta lección usan rutas relativas, así que las salidas se
ven igual en cualquier computadora. Donde la salida depende de la
máquina (tu nombre de usuario, tu ruta personal, la fecha y la hora),
se indica en el texto.

## 1. Crear carpetas con `mkdir`

`mkdir` crea una carpeta nueva. Su nombre viene de *make directory*,
"crear directorio" en inglés.

La carpeta de práctica de este curso se llama `practica-batch`.
Créala en tu carpeta personal, junto con tres subcarpetas: `datos/`
para los archivos del experimento, `resultados/` para las copias y
`scripts/` para los programas:

```bash
mkdir ~/practica-batch
mkdir ~/practica-batch/datos ~/practica-batch/resultados ~/practica-batch/scripts
```

`mkdir` acepta varias carpetas en un solo comando, separadas por
espacios. Después, entra a la carpeta de práctica y mira su contenido:

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

### `mkdir -p`: crear una carpeta y sus carpetas padre

Si intentas crear una carpeta dentro de otra que todavía no existe,
`mkdir` se queja y no crea nada. La opción `-p` crea también las
carpetas padre que falten, en un solo paso:

```bash
mkdir -p experimento-01/muestras/dia1
```

Este comando crea `experimento-01/`, dentro de ella `muestras/` y
dentro de esta `dia1/`, aunque ninguna existía antes. Compruébalo:

```bash
ls -R experimento-01
```

Salida real:

```text
experimento-01:
muestras

experimento-01/muestras:
dia1

experimento-01/muestras/dia1:
```

`ls -R` lista una carpeta y todo lo que hay dentro de ella, carpeta
por carpeta.

`mkdir -p` tiene otra ventaja: si la carpeta ya existe, no se queja.
Mira la diferencia. Sin `-p`, crear una carpeta que ya existe da un
error y el comando termina con código 1 (código distinto de cero
significa que algo salió mal):

```bash
mkdir datos
```

Salida real:

```text
mkdir: cannot create directory 'datos': File exists
```

Con `-p`, el mismo comando no muestra ningún error:

```bash
mkdir -p datos
```

El texto exacto del mensaje de error puede variar un poco según el
sistema, pero la idea es la misma: la carpeta ya existe.

## 2. Crear archivos vacíos con `touch`

`touch` crea un archivo vacío, es decir, un archivo que existe pero
no tiene contenido. Su nombre viene de "tocar" en inglés: toca el
archivo para que exista.

```bash
touch notas.txt
```

Comprueba que el archivo existe y que está vacío (tamaño 0):

```bash
ls -l notas.txt
```

Salida real:

```text
-rw-rw---- 1 root root 0 Nov 10 05:28 notas.txt
```

Lee esta salida de izquierda a derecha: los primeros caracteres
describen los permisos, el número `0` es el tamaño en bytes (el
archivo está vacío) y `Nov 10 05:28` es la fecha y hora de la última
modificación. En tu computadora verás tu propio nombre de usuario en
lugar de `root` y tu propia fecha y hora.

### ¿Qué hace `touch` si el archivo ya existe?

Si el archivo ya existe, `touch` no borra su contenido y no cambia
nada de lo que hay dentro. Lo único que hace es actualizar la fecha
y hora de última modificación a la fecha y hora actual. Es una forma
segura de "refrescar" la fecha de un archivo sin tocar su contenido.
Puedes comprobarlo tú mismo: anota la fecha que muestra `ls -l`,
trabaja un rato en otra cosa, ejecuta `touch notas.txt` de nuevo y
vuelve a mirar `ls -l`: la fecha habrá cambiado.

## 3. Copiar archivos y carpetas con `cp`

`cp` copia archivos. Su nombre viene de *copy*, "copiar" en inglés.
La forma básica es `cp origen destino`: el archivo de origen queda
intacto y aparece un segundo archivo en el destino.

Copia el archivo de muestras a la carpeta `resultados/` con otro
nombre:

```bash
cp datos/muestras.txt resultados/muestras-copia.txt
ls resultados/
```

Salida real:

```text
muestras-copia.txt
```

Si el destino es una carpeta que ya existe, `cp` guarda la copia
dentro de ella con el mismo nombre:

```bash
cp datos/muestras.txt datos/muestras-respaldo.txt
ls datos/
```

Salida real:

```text
lecturas.txt
muestras-respaldo.txt
muestras.txt
notas.txt
```

### Copiar una carpeta completa con `cp -r`

Para copiar una carpeta y todo lo que hay dentro de ella se usa la
opción `-r` (de *recursive*, "recursivo": entra en la carpeta y copia
todo su contenido, carpeta por carpeta):

```bash
cp -r datos datos-copia
ls
ls datos-copia/
```

Salida real:

```text
datos
datos-copia
experimento-01
notas.txt
resultados
scripts
```

```text
lecturas.txt
muestras-respaldo.txt
muestras.txt
notas.txt
```

Sin `-r`, copiar una carpeta no funciona. El comando se niega y
muestra un mensaje:

```bash
cp datos resultados/copia-datos
```

Salida real:

```text
cp: -r not specified; omitting directory 'datos'
```

El texto exacto del mensaje puede variar un poco según el sistema,
pero la idea es la misma: para copiar una carpeta hay que usar `-r`.

## 4. Mover y renombrar con `mv`

`mv` mueve archivos y carpetas. Su nombre viene de *move*, "mover"
en inglés. Mover y renombrar son el mismo comando: renombrar es
mover un archivo al mismo lugar con otro nombre.

Renombrar un archivo (moverlo al mismo lugar con otro nombre):

```bash
mv datos/muestras-respaldo.txt datos/muestras-viejo.txt
ls datos/
```

Salida real:

```text
lecturas.txt
muestras-viejo.txt
muestras.txt
notas.txt
```

Mover archivos a otra carpeta:

```bash
mv datos-copia datos/muestras-viejo.txt resultados/
ls resultados/
ls datos/
```

Salida real:

```text
datos-copia
muestras-copia.txt
muestras-viejo.txt
```

```text
lecturas.txt
muestras.txt
notas.txt
```

`mv` acepta varios archivos de origen y una carpeta de destino, como
en el ejemplo: los dos archivos terminaron dentro de `resultados/`.

Ten cuidado con un detalle: si el destino ya existe y es un archivo,
`mv` lo sobrescribe sin preguntar. Por ejemplo, si existe
`resultados/destino.txt` con el texto `viejo` y mueves encima un
archivo con el texto `nuevo`, el archivo destino queda con el texto
`nuevo` y el texto `viejo` se pierde. Compruébalo:

```bash
echo "viejo" > resultados/destino.txt
echo "nuevo" > datos/origen.txt
mv datos/origen.txt resultados/destino.txt
cat resultados/destino.txt
```

Salida real:

```text
nuevo
```

Por eso, antes de mover un archivo sobre otro, revisa que el destino
no contenga algo que necesites.

## 5. Borrar archivos y carpetas con `rm`

`rm` borra archivos. Su nombre viene de *remove*, "quitar" en inglés.

```bash
rm archivo-temporal.txt
```

### Advertencia: `rm` no tiene papelera

Esto es lo más importante de toda la lección: **lo que borra `rm`
no va a ninguna papelera y no se puede recuperar**. No hay forma de
deshacer un `rm`. Por eso, practica solo dentro de `practica-batch`
y revisa dos veces el nombre del archivo antes de pulsar Enter.

Nunca ejecutes estos dos comandos:

```bash
rm -rf /
rm -rf ~
```

El primero intentaría borrar todo el sistema y el segundo borraría
toda tu carpeta personal. No los ejecutes ni para probar.

### Borrar una carpeta con `rm -r`

Para borrar una carpeta y todo lo que hay dentro de ella se usa la
opción `-r`, igual que con `cp -r`:

```bash
rm -r resultados/datos-copia
ls resultados/
```

Salida real:

```text
muestras-copia.txt
muestras-viejo.txt
```

La carpeta `datos-copia` y todos sus archivos desaparecieron.

### Borrar con confirmación: `rm -i`

La opción `-i` (de *interactive*, "interactivo") hace que `rm`
pregunte antes de borrar cada archivo. Es la forma segura de borrar
cuando no estás seguro:

```bash
touch temporal.txt
rm -i temporal.txt
```

El comando pregunta y espera tu respuesta:

```text
rm: remove regular empty file 'temporal.txt'?
```

Si escribes `n` y pulsas Enter, el archivo no se borra. Compruébalo:

```bash
printf 'n\n' | rm -i temporal.txt
ls temporal.txt
```

Salida real:

```text
temporal.txt
```

El archivo sigue ahí. Si escribes `y` y pulsas Enter, el archivo se
borra:

```bash
printf 'y\n' | rm -i temporal.txt
ls temporal.txt
```

Salida real:

```text
ls: cannot access 'temporal.txt': No such file or directory
```

`ls` ya no encuentra el archivo: fue borrado. El texto exacto de la
pregunta y del mensaje de error puede variar un poco según el sistema.

## 6. Ver el contenido completo de un archivo con `cat`

`cat` muestra el contenido completo de un archivo en la terminal. Su
nombre viene de *concatenate*, "concatenar" en inglés: une archivos
y los muestra uno tras otro.

Primero hay que crear archivos con contenido. Para escribir varias
líneas en un archivo desde la terminal se usa `cat` con un
**heredoc**: se escribe `cat > archivo << 'EOF'`, luego las líneas
del contenido, y al final una línea que solo dice `EOF` para indicar
que el texto terminó. `EOF` significa *end of file*, "fin del
archivo". El símbolo `>` guarda la salida en el archivo en lugar de
mostrarla en pantalla.

Crea el archivo `datos/muestras.txt` con los datos de 5 muestras.
Cada línea tiene tres datos separados por espacios: el nombre de la
muestra, el tratamiento y la OD680, que es la densidad óptica medida
a 680 nm:

```bash
cat > datos/muestras.txt << 'EOF'
muestra tratamiento OD680
M01 control 0.42
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
M05 control 0.44
EOF
```

La primera línea es el encabezado (los nombres de las columnas) y
las 5 líneas siguientes son las 5 muestras. Crea también un archivo
de notas del experimento:

```bash
cat > datos/notas.txt << 'EOF'
Experimento con Chlorella vulgaris.
Tratamientos: control, luz azul y luz roja.
La densidad óptica se mide a 680 nm (OD680).
EOF
```

Ahora muestra el contenido de cada archivo con `cat`:

```bash
cat datos/muestras.txt
```

Salida real:

```text
muestra tratamiento OD680
M01 control 0.42
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
M05 control 0.44
```

```bash
cat datos/notas.txt
```

Salida real:

```text
Experimento con Chlorella vulgaris.
Tratamientos: control, luz azul y luz roja.
La densidad óptica se mide a 680 nm (OD680).
```

`cat` también muestra varios archivos seguidos, uno tras otro:

```bash
cat datos/muestras.txt datos/notas.txt
```

Salida real:

```text
muestra tratamiento OD680
M01 control 0.42
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
M05 control 0.44
Experimento con Chlorella vulgaris.
Tratamientos: control, luz azul y luz roja.
La densidad óptica se mide a 680 nm (OD680).
```

`cat` es perfecto para archivos cortos. Para archivos largos, el
contenido pasa volando por la pantalla; para esos casos usa `less`,
que se explica en la siguiente sección.

## 7. Ver un archivo largo por páginas con `less`

`less` muestra un archivo por páginas: ves una pantalla llena de
texto a la vez y avanzas cuando quieres. Es la herramienta adecuada
para archivos largos, por ejemplo un registro de lecturas con cientos
de líneas.

```bash
less datos/lecturas.txt
```

Al abrirlo, la pantalla muestra las primeras líneas del archivo y
abajo del todo una línea de aviso con el nombre del archivo y dos
puntos (`:`). Mientras estás dentro de `less`, el archivo no se
modifica: solo lo estás mirando.

Teclas para moverte dentro de `less`:

- `q`: salir de `less` y volver a la terminal.
- Flecha abajo y flecha arriba: moverse una línea hacia abajo o hacia
  arriba.
- Espacio: avanzar una página completa.
- `/` seguido de una palabra y Enter: buscar esa palabra en el
  archivo. Por ejemplo, `/0.74` busca la lectura `0.74`. Con `n` se
  salta a la siguiente coincidencia.

Para salir, pulsa `q`. No hay captura de pantalla que mostrar aquí
porque `less` es interactivo: lo que ves es el texto del archivo en
tu propia terminal, una página a la vez.

## 8. Ver el principio y el final de un archivo con `head` y `tail`

`head` muestra las primeras líneas de un archivo y `tail` muestra
las últimas líneas. Son útiles cuando solo necesitas echar un vistazo
rápido al principio o al final de un archivo de datos.

Crea el archivo `datos/lecturas.txt` con 10 lecturas de OD680
tomadas a lo largo del día. La primera línea es el encabezado y las
10 líneas siguientes son las lecturas:

```bash
cat > datos/lecturas.txt << 'EOF'
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
```

Sin opciones, `head` muestra las primeras 10 líneas y `tail` las
últimas 10 líneas:

```bash
head datos/lecturas.txt
```

Salida real:

```text
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
```

El archivo tiene 11 líneas en total, así que `head` sin opciones
muestra todas menos la última. Con la opción `-n` se elige cuántas
líneas mostrar. Para ver las primeras 3 líneas:

```bash
head -n 3 datos/lecturas.txt
```

Salida real:

```text
lectura hora OD680
1 08:00 0.40
2 09:00 0.45
```

Para ver las últimas 3 líneas:

```bash
tail -n 3 datos/lecturas.txt
```

Salida real:

```text
8 15:00 0.72
9 16:00 0.73
10 17:00 0.74
```

Y `tail` sin opciones muestra las últimas 10 líneas:

```bash
tail datos/lecturas.txt
```

Salida real:

```text
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
```

### Seguir un archivo en vivo con `tail -f`

La opción `-f` (de *follow*, "seguir") hace que `tail` no termine:
se queda mostrando en pantalla cada línea nueva que se agregue al
archivo, en el momento en que se agrega. Sirve para vigilar archivos
que crecen solos, como el registro de un equipo que va guardando
lecturas. Para detenerlo se pulsa `Ctrl+C`.

## 9. El script `organiza-archivos.sh`

El archivo `organiza-archivos.sh`, que acompaña a esta lección,
reúne todo lo aprendido en un solo script: crea la estructura de
carpetas, genera los archivos de ejemplo con datos, los copia,
renombra uno, muestra contenidos y borra un archivo temporal.

Para ejecutarlo, entra a la carpeta donde guardaste el script y
ejecútalo con `bash` (el script entra solo a tu carpeta de usuario,
así que funciona sin importar desde dónde lo llames):

```bash
bash organiza-archivos.sh
```

El script solo trabaja dentro de la carpeta de práctica de tu
carpeta de usuario, `~/practica-batch`, la misma de esta lección.
No toca ningún otro archivo de la computadora. Además, se puede
ejecutar dos veces seguidas: vuelve a generar sus archivos de
ejemplo sin borrar el trabajo que tú hayas guardado dentro de
`practica-batch` (por ejemplo, la carpeta `experimento-01` de los
ejercicios se conserva).

Salida real de `bash organiza-archivos.sh`:

```text
Contenido de muestras.txt:
muestra tratamiento OD680
M01 control 0.42
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
M05 control 0.44
Primeras 3 líneas de lecturas.txt:
lectura hora OD680
1 08:00 0.40
2 09:00 0.45
Últimas 3 líneas de lecturas.txt:
8 15:00 0.72
9 16:00 0.73
10 17:00 0.74
Estructura final de practica-batch:
practica-batch:
datos
resultados
scripts

practica-batch/datos:
lecturas.txt
muestras.txt
notas.txt
registro.txt

practica-batch/resultados:
datos-copia
muestras-final.txt

practica-batch/resultados/datos-copia:
lecturas.txt
muestras.txt
notas.txt
registro.txt

practica-batch/scripts:
```

El script también funciona con `sh`:

```bash
sh organiza-archivos.sh
```

La salida es idéntica con `bash` y con `sh`, y es idéntica cada vez
que se ejecuta. Eso se comprobó ejecutando el script varias veces
seguidas con los dos intérpretes.

Lee el script línea por línea y fíjate en los comentarios: cada paso
explica directamente lo que hace el comando que sigue.

## 10. Ejercicios

Haz estos ejercicios dentro de `practica-batch`, después de haber
ejecutado el script de la sección 9. Primero entra a la carpeta de
práctica y comprueba cada resultado con `ls`:

```bash
cd ~/practica-batch
```

### Ejercicio 1: crear una carpeta y copiar un archivo

Crea la carpeta `experimento-01` y copia `muestras.txt` a
`resultados/` con el nombre `muestras-experimento-01.txt`:

```bash
mkdir experimento-01
cp datos/muestras.txt resultados/muestras-experimento-01.txt
ls experimento-01 resultados/
```

Resultado esperado:

```text
experimento-01:

resultados/:
datos-copia
muestras-experimento-01.txt
muestras-final.txt
```

La carpeta `experimento-01` está vacía, por eso no aparece nada
debajo de su nombre.

### Ejercicio 2: renombrar una copia y borrar un archivo temporal

Renombra la copia a `muestras-exp01.txt`, crea un archivo temporal,
bórralo y comprueba que ya no existe:

```bash
mv resultados/muestras-experimento-01.txt resultados/muestras-exp01.txt
touch temporal-ejercicio.txt
rm temporal-ejercicio.txt
ls resultados/
ls temporal-ejercicio.txt
```

Resultado esperado:

```text
datos-copia
muestras-exp01.txt
muestras-final.txt
ls: cannot access 'temporal-ejercicio.txt': No such file or directory
```

El mensaje de `ls` confirma que el archivo temporal fue borrado.
En Mac el mensaje es parecido: `ls: temporal-ejercicio.txt: No such
file or directory`.

### Ejercicio 3: mirar el principio y el final de las lecturas

Muestra las primeras 3 líneas y las últimas 3 líneas de
`datos/lecturas.txt`:

```bash
head -n 3 datos/lecturas.txt
tail -n 3 datos/lecturas.txt
```

Resultado esperado:

```text
lectura hora OD680
1 08:00 0.40
2 09:00 0.45
8 15:00 0.72
9 16:00 0.73
10 17:00 0.74
```

## Ayuda de los comandos

Cada comando trae su propia ayuda con la opción `--help`. Por
ejemplo, `mkdir --help` muestra cómo se usa `mkdir` y qué opciones
tiene. Su primera línea es:

```text
Usage: mkdir [OPTION]... DIRECTORY...
```

El texto exacto de la ayuda puede variar un poco según el sistema.
En la computadora donde se preparó esta lección, el comando `man`
no está instalado, así que `--help` es la forma de consultar la
ayuda de cada comando.

## Qué aprendimos

- `mkdir` crea carpetas; `mkdir -p` crea también las carpetas padre
  que falten y no se queja si la carpeta ya existe.
- `touch` crea un archivo vacío, y si el archivo ya existe solo
  actualiza su fecha de última modificación sin cambiar su contenido.
- `cp` copia archivos; `cp -r` copia una carpeta completa con todo
  su contenido.
- `mv` mueve archivos y carpetas, y renombrar es mover un archivo al
  mismo lugar con otro nombre. `mv` sobrescribe el destino sin
  preguntar, así que hay que revisar el destino antes de mover.
- `rm` borra archivos y `rm -r` borra carpetas completas. Lo borrado
  con `rm` no va a la papelera y no se recupera. `rm -i` pregunta
  antes de borrar cada archivo. Nunca se usa `rm -rf /` ni
  `rm -rf ~`.
- `cat` muestra el contenido completo de un archivo, y con un
  heredoc (`cat > archivo << 'EOF'`) se escribe un archivo de varias
  líneas desde la terminal.
- `less` muestra un archivo largo por páginas; se sale con `q`, se
  busca con `/` y se mueve con las flechas.
- `head` muestra las primeras líneas de un archivo y `tail` las
  últimas; con `-n` se elige cuántas líneas mostrar, y `tail -f`
  sigue mostrando las líneas nuevas que se agreguen al archivo.
- El script `organiza-archivos.sh` reúne todos estos comandos:
  crea la estructura, genera archivos de ejemplo con datos de un
  experimento, los copia, renombra uno, muestra contenidos con
  `cat`, `head` y `tail`, y borra un archivo temporal.
