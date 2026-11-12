# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Lección 05: Buscar y filtrar

# Lección 05: Buscar y filtrar

En esta lección vas a buscar texto dentro de archivos con `grep`,
buscar archivos con `find`, encadenar comandos con tuberías (`|`) y
ordenar, contar y resumir resultados con `sort`, `uniq` y `wc`. Al
terminar sabrás buscar una palabra dentro de varios archivos,
localizar archivos por su nombre o por su fecha, y combinar comandos
para filtrar y contar resultados.

Todo lo que hagas aquí ocurre dentro de la carpeta de práctica
`~/practica-batch`, la misma de las lecciones 02, 03 y 04, así que
puedes equivocarte sin riesgo: nada de lo que cambies aquí afecta
al resto de tu computadora.

Primero, algunas palabras que usaremos en toda la lección:

- **Patrón**: el texto que se busca. Puede ser una palabra, como
  `luz_azul`, o una forma de describir un texto, como `^M01` para
  las líneas que empiezan con `M01`.
- **Coincidencia**: una línea que contiene el patrón que se busca.
  `grep` muestra las líneas que coinciden con el patrón y se salta
  las demás.
- **Salida estándar**: lo que un comando escribe en la terminal
  cuando termina. Por ejemplo, la lista de líneas que muestra
  `grep` es su salida estándar.
- **Entrada estándar**: lo que un comando lee para trabajar, cuando
  no se le da un archivo. Por ejemplo, `sort` sin archivo lee de
  su entrada estándar lo que le llega por una tubería.
- **Tubería** (`|`, en inglés *pipe*): el símbolo que conecta la
  salida estándar de un comando con la entrada estándar del
  siguiente. Con una tubería, el segundo comando trabaja sobre
  lo que produjo el primero, sin guardar nada en un archivo.
- **Filtro**: un comando que lee texto, lo transforma de alguna
  manera y lo escribe de nuevo. `sort`, `uniq` y `wc` son filtros:
  reciben líneas, las ordenan, las resumen o las cuentan.
- **Expresión regular**: una forma de describir un texto por su
  forma, en lugar de escribirlo tal cual. Por ejemplo, `^` significa
  "al principio de la línea", `$` significa "al final de la línea"
  y `|` significa "o". En esta lección se usan solo estas tres
  piezas; las expresiones regulares completas se practican en
  lecciones posteriores, cuando hagan falta.

## 0. Antes de empezar

Entra a la carpeta de práctica:

```bash
cd ~/practica-batch
```

En esta lección se usan los archivos de las lecciones 03 y 04
(`muestras.txt`, `lecturas.txt` y `notas.txt`) y tres archivos
nuevos: `registro.txt`, con el registro del día de trabajo;
`tratamientos.txt`, con un tratamiento por línea; y una copia de
respaldo de `muestras.txt` en la carpeta `datos/respaldo`. También
se crea un resumen en `resultados/resumen.txt`.

Crea el archivo `registro.txt` con el registro del día. Cada línea
tiene la fecha, la hora y lo que se hizo:

```bash
cat > datos/registro.txt << 'EOF'
2026-11-10 08:00 inicio del cultivo control
2026-11-10 08:15 medicion OD680 control
2026-11-10 09:00 cambio a luz_azul
2026-11-10 09:30 medicion OD680 luz_azul
2026-11-10 10:00 cambio a luz_roja
2026-11-10 10:30 medicion OD680 luz_roja
2026-11-10 11:00 medicion OD680 luz_azul
2026-11-10 11:30 fin del dia
EOF
```

Crea el archivo `tratamientos.txt` con un tratamiento por línea.
Cada línea es el tratamiento que se aplicó en una medición. Hay
tratamientos repetidos, porque en esta lección se van a contar:

```bash
cat > datos/tratamientos.txt << 'EOF'
control
luz_azul
luz_roja
luz_azul
control
luz_azul
luz_roja
control
EOF
```

Crea la carpeta de respaldo y copia en ella el archivo de muestras:

```bash
mkdir -p datos/respaldo
cp datos/muestras.txt datos/respaldo/muestras-2026-11-05.txt
```

Crea el resumen del experimento en la carpeta `resultados`:

```bash
cat > resultados/resumen.txt << 'EOF'
Resumen del experimento con Chlorella vulgaris.
Muestras analizadas: 5
Tratamientos: control, luz azul y luz roja.
EOF
```

Comprueba que los archivos están en su lugar:

```bash
ls datos
```

Salida real:

```text
lecturas.txt
muestras.txt
notas.txt
registro.txt
respaldo
tratamientos.txt
```

El contenido de los archivos nuevos es este:

```bash
cat datos/registro.txt
```

Salida real:

```text
2026-11-10 08:00 inicio del cultivo control
2026-11-10 08:15 medicion OD680 control
2026-11-10 09:00 cambio a luz_azul
2026-11-10 09:30 medicion OD680 luz_azul
2026-11-10 10:00 cambio a luz_roja
2026-11-10 10:30 medicion OD680 luz_roja
2026-11-10 11:00 medicion OD680 luz_azul
2026-11-10 11:30 fin del dia
```

```bash
cat datos/tratamientos.txt
```

Salida real:

```text
control
luz_azul
luz_roja
luz_azul
control
luz_azul
luz_roja
control
```

```bash
cat resultados/resumen.txt
```

Salida real:

```text
Resumen del experimento con Chlorella vulgaris.
Muestras analizadas: 5
Tratamientos: control, luz azul y luz roja.
```

En las salidas de esta lección verás el usuario `root` y el grupo
`root`, porque así está configurada la computadora donde se
preparó. En tu computadora verás tu propio nombre de usuario y
tu propio grupo, y tu propia fecha y hora. Lo que importa en esta
lección son los nombres de los archivos y las líneas que muestra
cada comando.

Dos advertencias sobre el orden de las salidas. Primera: `find`
y `grep -r` recorren los archivos en el orden en que los
encuentran, y ese orden puede cambiar de una computadora a otra.
En las salidas de esta lección aparece el orden que se obtuvo al
prepararla; en la tuya puede ser otro, y lo que importa es que
aparezcan los mismos archivos y las mismas líneas. Segunda: en
los ejemplos con `sort` se escribe `LC_ALL=C` delante del
comando. Eso fija el orden alfabético para que sea el mismo en
cualquier computadora, como se explica en la sección 5.

## 1. Buscar texto dentro de un archivo con `grep`

`grep` busca un patrón dentro de un archivo y muestra las líneas
que coinciden con él. Su nombre viene de *global regular
expression print*, "imprimir las líneas que coinciden con una
expresión regular" en inglés. La forma básica es:

```text
grep "patrón" archivo
```

### La búsqueda básica

Busca las muestras que recibieron luz azul en el archivo de
muestras:

```bash
grep "luz_azul" datos/muestras.txt
```

Salida real:

```text
M02 luz_azul 0.68
M04 luz_azul 0.65
```

`grep` muestra las dos líneas que contienen `luz_azul` y se salta
las demás. El patrón va entre comillas para que la shell lo pase
tal cual a `grep`, sin interpretar nada de lo que contiene. Con
un patrón de una sola palabra sin caracteres especiales, las
comillas no cambian el resultado, pero conviene usarlas siempre:
con un patrón que tiene espacios, como `luz azul`, son
obligatorias, porque sin ellas la shell partiría el patrón en
dos palabras y `grep` lo leería como dos argumentos distintos.

### Buscar sin distinguir mayúsculas y minúsculas con `-i`

La opción `-i` (de *insensitive*, "insensible" a las mayúsculas)
busca el patrón sin distinguir entre mayúsculas y minúsculas.
En las notas, la palabra aparece como `Chlorella`, con mayúscula
inicial, pero la búsqueda con minúsculas la encuentra igual:

```bash
grep -i "chlorella" datos/notas.txt
```

Salida real:

```text
Experimento con Chlorella vulgaris.
```

Sin la opción `-i`, esa misma búsqueda no encontraría nada,
porque `chlorella` con minúscula no aparece tal cual en el
archivo. Con `-i`, `grep` encuentra `Chlorella`, `CHLORELLA` o
`chlorella` por igual.

### Buscar un patrón con espacios

El patrón puede tener espacios, siempre que vaya entre comillas.
Busca la frase `luz azul` en las notas:

```bash
grep "luz azul" datos/notas.txt
```

Salida real:

```text
Tratamientos: control, luz azul y luz roja.
```

### Mostrar el número de línea con `-n`

La opción `-n` (de *number*) muestra, delante de cada línea, el
número de línea en la que apareció la coincidencia. Busca todas
las líneas que mencionan `luz`:

```bash
grep -n "luz" datos/muestras.txt
```

Salida real:

```text
3:M02 luz_azul 0.68
4:M03 luz_roja 0.71
5:M04 luz_azul 0.65
```

El patrón `luz` coincide con `luz_azul` y con `luz_roja`, porque
las dos palabras empiezan por `luz`. Los números dicen en qué
línea del archivo está cada coincidencia: la línea 3, la 4 y la
5. La línea 1 es el encabezado y la línea 2 es la muestra M01,
que no menciona ninguna luz.

### Contar las coincidencias con `-c`

La opción `-c` (de *count*) no muestra las líneas: muestra
cuántas líneas coinciden con el patrón. Cuenta las muestras de
control:

```bash
grep -c "control" datos/muestras.txt
```

Salida real:

```text
2
```

Hay dos muestras de control, M01 y M05. Fíjate en que `-c`
cuenta líneas, no apariciones: si una línea contuviera la
palabra dos veces, seguiría contando como una sola línea.

### Mostrar lo que no coincide con `-v`

La opción `-v` invierte la búsqueda: muestra las líneas que no
contienen el patrón. Muestra todas las muestras menos las de
control:

```bash
grep -v "control" datos/muestras.txt
```

Salida real:

```text
muestra tratamiento OD680
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
```

El encabezado también aparece, porque no contiene la palabra
`control`. La opción `-v` es útil para quitar de en medio las
líneas que no interesan antes de seguir trabajando con el resto.

### Buscar una palabra completa con `-w`

La opción `-w` (de *word*) busca el patrón como palabra
completa, no como parte de otra palabra. Busca la muestra M01:

```bash
grep -w "M01" datos/muestras.txt
```

Salida real:

```text
M01 control 0.42
```

Sin `-w`, el patrón `M0` coincide con las cinco muestras,
porque las cinco empiezan por `M0`:

```bash
grep "M0" datos/muestras.txt
```

Salida real:

```text
M01 control 0.42
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
M05 control 0.44
```

### Buscar por la posición en la línea: `^` y `$`

Dos símbolos describen la posición del patrón dentro de la
línea: `^` significa "al principio de la línea" y `$` significa
"al final de la línea". Busca las líneas que empiezan con `M01`:

```bash
grep "^M01" datos/muestras.txt
```

Salida real:

```text
M01 control 0.42
```

Y busca la línea que termina con `0.42`:

```bash
grep "0.42$" datos/muestras.txt
```

Salida real:

```text
M01 control 0.42
```

Sin el `^`, el patrón `M01` coincidiría con cualquier línea que
lo contuviera en cualquier posición. Con el `^`, solo coinciden
las líneas que empiezan por él. Lo mismo vale para `$`: sin él,
`0.42` coincidiría en cualquier posición de la línea; con él,
solo al final.

### Buscar una cosa o la otra con `-E`

La opción `-E` (de *extended*, "extendida") activa las
expresiones regulares extendidas, en las que el símbolo `|`
significa "o". Busca las muestras con luz azul o con luz roja:

```bash
grep -E "luz_azul|luz_roja" datos/muestras.txt
```

Salida real:

```text
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
```

El patrón `luz_azul|luz_roja` se lee "luz_azul o luz_roja", y
coincide con las tres muestras que recibieron alguna luz. Sin
la opción `-E`, el símbolo `|` se leería como un carácter más
del patrón y no como "o".

## 2. Buscar en varios archivos y en carpetas

`grep` también busca en varios archivos a la vez y dentro de
carpetas enteras.

### Buscar en varios archivos

Se escriben los archivos uno tras otro, separados por espacios.
Cuando hay más de un archivo, `grep` escribe delante de cada
línea el nombre del archivo en el que la encontró. Busca la
palabra `control` en las muestras y en las notas:

```bash
grep "control" datos/muestras.txt datos/notas.txt
```

Salida real:

```text
datos/muestras.txt:M01 control 0.42
datos/muestras.txt:M05 control 0.44
datos/notas.txt:Tratamientos: control, luz azul y luz roja.
```

El nombre del archivo y la línea se separan con dos puntos.
Con un solo archivo, `grep` no escribe el nombre, como se vio
en la sección 1. Con varios, lo escribe siempre, para que se
sepa de dónde salió cada línea.

El comodín `*` también sirve para buscar en todos los archivos
de texto de una carpeta. En la sección 3 se explica cómo
listarlos primero con `find`, para saber en cuáles se está
buscando.

### Buscar dentro de una carpeta con `-r`

La opción `-r` (de *recursive*, "recursiva") busca dentro de una
carpeta y de todas las carpetas que hay dentro de ella. Busca
`luz_azul` en toda la carpeta `datos`, incluida la carpeta de
respaldo:

```bash
grep -r "luz_azul" datos
```

Salida real:

```text
datos/muestras.txt:M02 luz_azul 0.68
datos/muestras.txt:M04 luz_azul 0.65
datos/registro.txt:2026-11-10 09:00 cambio a luz_azul
datos/registro.txt:2026-11-10 09:30 medicion OD680 luz_azul
datos/registro.txt:2026-11-10 11:00 medicion OD680 luz_azul
datos/tratamientos.txt:luz_azul
datos/tratamientos.txt:luz_azul
datos/tratamientos.txt:luz_azul
datos/respaldo/muestras-2026-11-05.txt:M02 luz_azul 0.68
datos/respaldo/muestras-2026-11-05.txt:M04 luz_azul 0.65
```

La búsqueda encontró `luz_azul` en cuatro archivos: en las
muestras, en el registro, en la lista de tratamientos y en la
copia de respaldo. Fíjate en que la copia de respaldo duplica
los resultados de `muestras.txt`: al buscar en una carpeta
entera, las copias de un archivo aparecen como resultados
aparte, y conviene tenerlo en cuenta al contar.

Las opciones se pueden combinar. Con `-rn` se busca dentro de
una carpeta y se muestra el número de línea de cada coincidencia:

```bash
grep -rn "luz_roja" datos
```

Salida real:

```text
datos/muestras.txt:4:M03 luz_roja 0.71
datos/registro.txt:5:2026-11-10 10:00 cambio a luz_roja
datos/registro.txt:6:2026-11-10 10:30 medicion OD680 luz_roja
datos/tratamientos.txt:3:luz_roja
datos/tratamientos.txt:7:luz_roja
datos/respaldo/muestras-2026-11-05.txt:4:M03 luz_roja 0.71
```

### Mostrar solo los nombres de los archivos con `-l`

La opción `-l` (de *list*, "lista", en minúscula) no muestra las
líneas: muestra solo los nombres de los archivos que contienen
el patrón. Es la forma rápida de saber en qué archivos aparece
una palabra, sin ver cada línea. Busca en qué archivos de datos
aparece `OD680`:

```bash
grep -l "OD680" datos/*.txt
```

Salida real:

```text
datos/lecturas.txt
datos/muestras.txt
datos/notas.txt
datos/registro.txt
```

El comodín `*.txt` le dice a la shell que pase a `grep` todos
los archivos de texto de la carpeta `datos`. Los cuatro archivos
mencionan `OD680`; `tratamientos.txt` no, porque solo contiene
nombres de tratamientos. La copia de respaldo no aparece porque
el comodín `datos/*.txt` solo toma los archivos que están
directamente en `datos`, no los de las carpetas de dentro.

Para ver las líneas, además de los nombres, se usa `grep -r`
sin `-l`:

```bash
grep -r "OD680" datos
```

Salida real:

```text
datos/muestras.txt:muestra tratamiento OD680
datos/notas.txt:La densidad óptica se mide a 680 nm (OD680).
datos/lecturas.txt:lectura hora OD680
datos/registro.txt:2026-11-10 08:15 medicion OD680 control
datos/registro.txt:2026-11-10 09:30 medicion OD680 luz_azul
datos/registro.txt:2026-11-10 10:30 medicion OD680 luz_roja
datos/registro.txt:2026-11-10 11:00 medicion OD680 luz_azul
datos/respaldo/muestras-2026-11-05.txt:muestra tratamiento OD680
```

En total son 8 líneas, contando el encabezado de cada archivo
y las cuatro mediciones del registro. Compruébalo contando las
líneas del resultado, como se explica en la sección 7.

### El código de salida de `grep`

`grep` termina con un código de salida que dice si encontró
algo o no: `0` si encontró al menos una coincidencia y `1` si
no encontró ninguna. Ese código se guarda en `$?`, como se vio
en la lección 04. Busca una palabra que no está en el archivo:

```bash
grep "Scenedesmus" datos/muestras.txt; echo $?
```

Salida real:

```text
1
```

`grep` no muestra nada, porque `Scenedesmus` no aparece en
`muestras.txt`, y termina con código `1`. En cambio, una
búsqueda que sí encuentra algo termina con código `0`:

```bash
grep "OD680" datos/muestras.txt; echo $?
```

Salida real:

```text
muestra tratamiento OD680
0
```

El código de salida sirve para que un script decida qué hacer
según se haya encontrado algo o no, como se verá en la lección
09. Por ahora basta con recordar: `0` significa "lo encontré"
y `1` significa "no lo encontré".

## 3. Buscar archivos con `find`

`find` busca archivos y carpetas por su nombre, su tipo, su
tamaño o su fecha, en lugar de buscar texto dentro de ellos.
La forma básica es:

```text
find carpeta -name "nombre"
```

### Buscar por el nombre con `-name`

Lista todos los archivos de texto de la carpeta `datos`:

```bash
find datos -name "*.txt"
```

Salida real:

```text
datos/muestras.txt
datos/notas.txt
datos/lecturas.txt
datos/registro.txt
datos/tratamientos.txt
datos/respaldo/muestras-2026-11-05.txt
```

El patrón `*.txt` significa "cualquier nombre que termine en
`.txt`", y va entre comillas para que lo interprete `find` y no
la shell. Si no se ponen comillas, la shell expande el `*`
antes de que `find` lo vea y el comando busca otra cosa.
`find` entra también en las carpetas de dentro, por eso aparece
la copia de respaldo.

Para buscar los scripts, se busca por la terminación `.sh` en
toda la carpeta de práctica:

```bash
find . -name "*.sh"
```

Salida real:

```text
./scripts/analisis.sh
```

El punto `.` significa "la carpeta actual", que es
`practica-batch`. El único script que hay es `analisis.sh`,
creado en la lección 04.

### Buscar por el tipo con `-type`

La opción `-type` distingue archivos de carpetas: `f` significa
archivo normal (*file*) y `d` significa carpeta (*directory*).
Lista las carpetas de la práctica:

```bash
find . -type d
```

Salida real:

```text
.
./datos
./datos/respaldo
./resultados
./scripts
```

Las opciones se pueden combinar. Para contar los archivos de
texto de `datos`, se combina `-type f` con `-name` y se cuenta
el resultado con `wc -l`, como se explica en las secciones 4 y 7:

```bash
find datos -type f -name "*.txt" | wc -l
```

Salida real:

```text
6
```

Son los seis archivos de texto de la carpeta `datos`, contando
la copia de respaldo.

### Buscar por el tamaño con `-size`

La opción `-size` busca archivos por su tamaño. La unidad `c`
significa bytes, así que `+100c` significa "más de 100 bytes".
Lista los archivos de `datos` que pesan más de 100 bytes:

```bash
find datos -type f -size +100c
```

Salida real:

```text
datos/muestras.txt
datos/notas.txt
datos/lecturas.txt
datos/registro.txt
datos/respaldo/muestras-2026-11-05.txt
```

`tratamientos.txt` no aparece, porque pesa 69 bytes, menos de
100. El signo `+` significa "más de" y el signo `-` significa
"menos de": con `-size -100c` se listarían los archivos de menos
de 100 bytes. Otras unidades habituales son `k` para kilobytes
y `M` para megabytes.

### Buscar por la fecha con `-mtime`

La opción `-mtime` busca archivos por su fecha de última
modificación. El número es la cantidad de días: `-mtime -1`
significa "modificado hace menos de 1 día", es decir, hoy.
Lista los archivos de texto de `datos` modificados hoy:

```bash
find datos -mtime -1 -name "*.txt"
```

Salida real:

```text
datos/muestras.txt
datos/notas.txt
datos/lecturas.txt
datos/registro.txt
datos/tratamientos.txt
datos/respaldo/muestras-2026-11-05.txt
```

Aparecen los seis, porque el script de la lección 04 y los
comandos de la sección 0 los crearon o los modificaron hoy. Si
haces este ejemplo otro día, sin haber tocado los archivos,
la lista saldrá vacía: `find` no muestra nada cuando ningún
archivo cumple la condición. Con `-mtime -7` se listarían los
modificados en la última semana, y con `-mtime +30` los que
llevan más de 30 días sin modificarse.

### Ejecutar un comando sobre cada archivo con `-exec`

La opción `-exec` ejecuta un comando sobre cada archivo que
encuentra `find`. El comando se escribe después de `-exec`, el
nombre del archivo se escribe como `{}` y el comando se cierra
con `\;`. Busca en qué archivos de texto de `datos` aparece
`OD680`, ejecutando `grep -l` sobre cada uno:

```bash
find datos -name "*.txt" -exec grep -l "OD680" {} \;
```

Salida real:

```text
datos/muestras.txt
datos/notas.txt
datos/lecturas.txt
datos/registro.txt
datos/respaldo/muestras-2026-11-05.txt
```

Es el mismo resultado que `grep -l "OD680" datos/*.txt`, pero
con una diferencia: `find` también entra en la carpeta de
respaldo, así que la copia aparece en la lista. La opción
`-exec` sirve para aplicar cualquier comando a los archivos
encontrados, por ejemplo contar sus líneas o copiarlos, y se
vuelve a usar en lecciones posteriores.

## 4. Contar con `wc`

`wc` cuenta líneas, palabras y bytes de un archivo. Su nombre
viene de *word count*, "contador de palabras" en inglés. La
forma básica es:

```text
wc archivo
```

### Contar líneas con `-l`

La opción `-l` (de *lines*) cuenta las líneas de un archivo.
Cuenta las líneas de `muestras.txt`:

```bash
wc -l datos/muestras.txt
```

Salida real:

```text
6 datos/muestras.txt
```

Son 6 líneas: el encabezado más las 5 muestras. Con varios
archivos, `wc` cuenta cada uno y añade una línea con el total:

```bash
wc -l datos/muestras.txt datos/lecturas.txt
```

Salida real:

```text
  6 datos/muestras.txt
 11 datos/lecturas.txt
 17 total
```

### Contar palabras con `-w` y bytes con `-c`

La opción `-w` (de *words*) cuenta las palabras, separadas por
espacios. Cuenta las palabras de las notas:

```bash
wc -w datos/notas.txt
```

Salida real:

```text
20 datos/notas.txt
```

La opción `-c` (de *characters*, en realidad bytes) cuenta los
bytes del archivo. Cuenta los bytes de `muestras.txt`:

```bash
wc -c datos/muestras.txt
```

Salida real:

```text
114 datos/muestras.txt
```

Ese número es el mismo que muestra `ls -l` como tamaño del
archivo, porque en estos archivos cada carácter ocupa un byte.

### Contar las tres cosas a la vez

Sin opciones, `wc` muestra las tres cuentas juntas: líneas,
palabras y bytes, en ese orden:

```bash
wc datos/muestras.txt
```

Salida real:

```text
  6  18 114 datos/muestras.txt
```

Se lee así: 6 líneas, 18 palabras y 114 bytes. Las 18 palabras
son las 3 del encabezado más las 3 de cada una de las 5
muestras.

### Contar las líneas de todos los archivos de datos

Con el comodín `*`, `wc -l` cuenta las líneas de cada archivo
de texto de `datos` y muestra el total:

```bash
wc -l datos/*.txt
```

Salida real:

```text
 11 datos/lecturas.txt
  6 datos/muestras.txt
  3 datos/notas.txt
  8 datos/registro.txt
  8 datos/tratamientos.txt
 36 total
```

En total hay 36 líneas en los archivos de datos. La copia de
respaldo no aparece, porque el comodín `datos/*.txt` solo toma
los archivos que están directamente en `datos`. Fíjate en que
la lista sale ordenada por el nombre del archivo: es la shell
la que ordena los nombres al expandir el comodín, antes de
que `wc` los vea.

## 5. Ordenar con `sort`

`sort` ordena las líneas de un archivo o de su entrada estándar.
La forma básica es:

```text
sort archivo
```

### Ordenar líneas de texto

Ordena la lista de tratamientos:

```bash
sort datos/tratamientos.txt
```

Salida real:

```text
control
control
control
luz_azul
luz_azul
luz_azul
luz_roja
luz_roja
```

`sort` ordena las líneas por orden alfabético y las escribe en
la terminal. No cambia el archivo: el archivo sigue igual y lo
que se ve es solo la salida ordenada. Para guardar el resultado
ordenado en un archivo se usa la redirección `>`, que se explica
en la lección 06.

La opción `-u` (de *unique*, "único") ordena y quita las líneas
repetidas en un solo paso:

```bash
sort -u datos/tratamientos.txt
```

Salida real:

```text
control
luz_azul
luz_roja
```

La opción `-r` (de *reverse*, "al revés") ordena de mayor a
menor, o de la Z a la A:

```bash
sort -r datos/tratamientos.txt
```

Salida real:

```text
luz_roja
luz_roja
luz_azul
luz_azul
luz_azul
control
control
control
```

### Ordenar con el mismo orden en cualquier computadora

El orden alfabético depende de la configuración de idioma de la
computadora, y puede cambiar entre Mac y Linux. Por ejemplo, en
algunas configuraciones las mayúsculas y las minúsculas se
ordenan mezcladas, y en otras van primero todas las mayúsculas.
Para que el orden sea el mismo en cualquier computadora, se
escribe `LC_ALL=C` delante del comando. Eso fija el orden
alfabético simple, en el que las mayúsculas van antes que las
minúsculas y los dígitos antes que las letras.

Ordena el archivo de muestras. Fíjate en dónde queda el
encabezado:

```bash
LC_ALL=C sort datos/muestras.txt
```

Salida real:

```text
M01 control 0.42
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
M05 control 0.44
muestra tratamiento OD680
```

El encabezado queda al final, porque empieza por minúscula y
las minúsculas van después de las mayúsculas en este orden.
`sort` no sabe que la primera línea es un encabezado: la ordena
como una línea más. Por eso, cuando se ordena un archivo con
encabezado, conviene ordenarlo por una columna numérica, como
se hace a continuación, para que el encabezado quede primero
por no ser un número.

### Ordenar por una columna con `-k` y `-n`

La opción `-k` elige por qué columna se ordena, y la opción
`-n` (de *numeric*, "numérico") ordena por valor numérico en
lugar de por orden alfabético. Las columnas se separan por
espacios y se cuentan desde 1. En `muestras.txt`, la tercera
columna es el OD680. Ordena las muestras por su OD680, de
menor a mayor:

```bash
LC_ALL=C sort -k3 -n datos/muestras.txt
```

Salida real:

```text
muestra tratamiento OD680
M01 control 0.42
M05 control 0.44
M04 luz_azul 0.65
M02 luz_azul 0.68
M03 luz_roja 0.71
```

Esta vez el encabezado queda primero, porque su tercera
columna, `OD680`, no es un número y se ordena como si valiera
cero. Las muestras quedan ordenadas por su OD680: la de menor
valor es M01 con 0.42 y la de mayor valor es M03 con 0.71.
Sin la opción `-n`, el orden sería alfabético y `0.71` quedaría
antes que `0.42`, porque el carácter `7` va antes que el `4`.

Con `-r` se invierte el orden, de mayor a menor. Combinado con
`head -3`, que muestra las tres primeras líneas y se vio en la
lección 03, se obtienen las tres muestras con mayor OD680:

```bash
LC_ALL=C sort -k3 -nr datos/muestras.txt | head -3
```

Salida real:

```text
M03 luz_roja 0.71
M02 luz_azul 0.68
M04 luz_azul 0.65
```

La muestra con mayor OD680 es M03, con luz roja y 0.71. El
encabezado no aparece, porque al ordenar de mayor a menor queda
al final, al no ser un número.

El mismo orden sirve para las lecturas del día. Ordena las
lecturas por su OD680:

```bash
LC_ALL=C sort -k3 -n datos/lecturas.txt
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
10 17:00 0.74
```

Las lecturas ya estaban ordenadas por hora, y la OD680 crece a
lo largo del día, así que el orden por OD680 coincide con el
orden por hora. Si un día la OD680 bajara a media tarde, el
orden por OD680 sería distinto del orden por hora, y este
comando lo mostraría.

## 6. Filas repetidas con `uniq`

`uniq` quita las líneas repetidas que están seguidas, es decir,
las líneas iguales que aparecen una detrás de otra. Su nombre
viene de *unique*, "único" en inglés. La forma básica es:

```text
uniq archivo
```

### Quitar las repeticiones seguidas

`uniq` solo funciona bien si la entrada está ordenada, porque
solo compara cada línea con la anterior. Por eso se usa
después de `sort`, unidos por una tubería, como se explica en
la sección 7. Muestra cada tratamiento una sola vez:

```bash
sort datos/tratamientos.txt | uniq
```

Salida real:

```text
control
luz_azul
luz_roja
```

Es el mismo resultado que `sort -u`, porque `-u` hace las dos
cosas: ordena y quita las repeticiones.

### Contar las repeticiones con `-c`

La opción `-c` (de *count*) muestra, delante de cada línea,
cuántas veces aparecía repetida. Cuenta cuántas veces se aplicó
cada tratamiento:

```bash
sort datos/tratamientos.txt | uniq -c
```

Salida real:

```text
      3 control
      3 luz_azul
      2 luz_roja
```

Cada tratamiento se aplicó así: control 3 veces, luz azul 3
veces y luz roja 2 veces. En total son 8 aplicaciones, las 8
líneas del archivo. Esta combinación, `sort | uniq -c`, es una
de las más usadas en el trabajo con datos: sirve para contar
cuántas veces aparece cada valor de una columna, cada palabra
de un texto o cada código de una lista.

### Mostrar solo lo repetido con `-d`

La opción `-d` (de *duplicated*, "duplicado") muestra solo las
líneas que aparecen más de una vez. Muestra los tratamientos
que se repitieron:

```bash
sort datos/tratamientos.txt | uniq -d
```

Salida real:

```text
control
luz_azul
luz_roja
```

Los tres tratamientos se repitieron, así que aparecen los tres.
Si un tratamiento se hubiera aplicado una sola vez, no
aparecería en esta lista.

### Por qué hay que ordenar antes

Si se usa `uniq` sin ordenar antes, solo quita las repeticiones
que están seguidas. En `tratamientos.txt`, las repeticiones no
están seguidas, así que `uniq` no quita ninguna:

```bash
uniq datos/tratamientos.txt
```

Salida real:

```text
control
luz_azul
luz_roja
luz_azul
control
luz_azul
luz_roja
control
```

Salen las 8 líneas tal cual, porque ninguna es igual a la
anterior. Por eso, la regla es: primero `sort` y después
`uniq`. Sin el `sort`, el resultado de `uniq` no dice cuántos
valores distintos hay.

### Ordenar el recuento de mayor a menor

El recuento de `uniq -c` se puede ordenar a su vez, para ver
primero los valores que más se repiten. Ordena el recuento de
tratamientos de mayor a menor:

```bash
sort datos/tratamientos.txt | uniq -c | sort -nr
```

Salida real:

```text
      3 luz_azul
      3 control
      2 luz_roja
```

La luz azul y el control se aplicaron 3 veces cada uno, y la
luz roja 2 veces. Cuando dos valores empatan en el recuento,
`sort -nr` los ordena por el texto que sigue al número, de
mayor a menor, y por eso `luz_azul` sale antes que `control`.

## 7. Encadenar comandos con tuberías

Una tubería, `|`, conecta la salida estándar de un comando con
la entrada estándar del siguiente. El segundo comando trabaja
sobre lo que produjo el primero, sin guardar nada en un archivo.
Se lee de izquierda a derecha: primero se ejecuta el comando
de la izquierda y su salida pasa al comando de la derecha.
Se pueden encadenar más de dos comandos, y cada uno es un
filtro que transforma lo que recibe.

### Contar las líneas de una búsqueda

Cuenta cuántas muestras mencionan alguna luz, buscando las
líneas con `luz` y contándolas con `wc -l`:

```bash
grep "luz" datos/muestras.txt | wc -l
```

Salida real:

```text
3
```

Son 3: M02 y M04 con luz azul, y M03 con luz roja. Sin la
tubería, habría que guardar el resultado de `grep` en un
archivo y después contar sus líneas con `wc -l`. Con la
tubería, el resultado pasa directamente de un comando al otro.

Cuenta cuántas mediciones se registraron en el día:

```bash
grep "medicion" datos/registro.txt | wc -l
```

Salida real:

```text
4
```

Son 4 mediciones: a las 08:15, a las 09:30, a las 10:30 y a
las 11:00. Las demás líneas del registro son el inicio del
cultivo, los cambios de luz y el fin del día, y no contienen
la palabra `medicion`.

### Extraer, ordenar y contar en una sola cadena

La opción `-o` de `grep` (de *only*, "solo") muestra solo la
parte de la línea que coincide con el patrón, en lugar de la
línea completa. Con el patrón `luz_[a-z]*`, `grep -o` extrae
cada mención de una luz del registro: `luz_azul` o `luz_roja`,
seguidas de letras minúsculas. Encadenado con `sort` y
`uniq -c`, cuenta cuántas veces se menciona cada luz:

```bash
grep -o "luz_[a-z]*" datos/registro.txt | sort | uniq -c
```

Salida real:

```text
      3 luz_azul
      2 luz_roja
```

La luz azul se menciona 3 veces en el registro y la luz roja
2 veces. La cadena hace tres pasos: `grep -o` extrae las
menciones, `sort` las ordena para juntar las iguales y
`uniq -c` cuenta cuántas hay de cada una. Sin el `sort` del
medio, `uniq -c` contaría mal, porque las menciones no están
seguidas en el registro.

### Ordenar el resultado de `find`

`find` no ordena sus resultados, como se advirtió en la
sección 0. Para ver la lista ordenada, se encadena con `sort`:

```bash
find datos -name "*.txt" | sort
```

Salida real:

```text
datos/lecturas.txt
datos/muestras.txt
datos/notas.txt
datos/registro.txt
datos/respaldo/muestras-2026-11-05.txt
datos/tratamientos.txt
```

### Ordenar el resultado de `wc`

Lo mismo vale para `wc`: su salida se puede ordenar con
`sort -n`, para ver los archivos de menor a mayor número de
líneas:

```bash
wc -l datos/*.txt | sort -n
```

Salida real:

```text
  3 datos/notas.txt
  6 datos/muestras.txt
  8 datos/registro.txt
  8 datos/tratamientos.txt
 11 datos/lecturas.txt
 36 total
```

El archivo con menos líneas es `notas.txt`, con 3, y el de más
líneas es `lecturas.txt`, con 11. La línea del total, `36
total`, queda al final, porque 36 es el número mayor.

## 8. El script `buscar-filtrar.sh`

El archivo `buscar-filtrar.sh`, que acompaña a esta lección,
reúne todo lo aprendido en un solo script: crea la estructura
de carpetas, genera los archivos de ejemplo con datos del
experimento con Chlorella vulgaris, busca las muestras con luz
azul, cuenta las mediciones del registro, lista los archivos
de texto, cuenta sus líneas, cuenta cuántas veces se aplicó
cada tratamiento y cuántas veces se menciona cada luz en el
registro, ordena las muestras por su OD680, muestra las tres
con mayor OD680 y lista los archivos que mencionan OD680.

Para ejecutarlo, entra a la carpeta donde guardaste el script y
ejecútalo con `bash` (el script entra solo a tu carpeta de
usuario, así que funciona sin importar desde dónde lo llames):

```bash
bash buscar-filtrar.sh
```

El script solo trabaja dentro de la carpeta de práctica de tu
carpeta de usuario, `~/practica-batch`, la misma de esta
lección. No toca ningún otro archivo de la computadora. Además,
se puede ejecutar dos veces seguidas: vuelve a generar sus
archivos de ejemplo sin borrar el trabajo que tú hayas guardado
dentro de `practica-batch`.

Salida real de `bash buscar-filtrar.sh`:

```text
Muestras con luz_azul:
M02 luz_azul 0.68
M04 luz_azul 0.65
Mediciones registradas en registro.txt:
4
Archivos .txt en datos:
practica-batch/datos/lecturas.txt
practica-batch/datos/muestras.txt
practica-batch/datos/notas.txt
practica-batch/datos/registro.txt
practica-batch/datos/respaldo/muestras-2026-11-05.txt
practica-batch/datos/tratamientos.txt
Lineas en cada archivo de datos:
 11 practica-batch/datos/lecturas.txt
  6 practica-batch/datos/muestras.txt
  3 practica-batch/datos/notas.txt
  8 practica-batch/datos/registro.txt
  8 practica-batch/datos/tratamientos.txt
 36 total
Veces que se aplico cada tratamiento:
      3 control
      3 luz_azul
      2 luz_roja
Menciones de cada luz en registro.txt:
      3 luz_azul
      2 luz_roja
Muestras ordenadas por OD680:
muestra tratamiento OD680
M01 control 0.42
M05 control 0.44
M04 luz_azul 0.65
M02 luz_azul 0.68
M03 luz_roja 0.71
Las 3 muestras con mayor OD680:
M03 luz_roja 0.71
M02 luz_azul 0.68
M04 luz_azul 0.65
Archivos de datos que mencionan OD680:
practica-batch/datos/lecturas.txt
practica-batch/datos/muestras.txt
practica-batch/datos/notas.txt
practica-batch/datos/registro.txt
```

El script también funciona con `sh`:

```bash
sh buscar-filtrar.sh
```

La salida es idéntica con `bash` y con `sh`, y es idéntica cada
vez que se ejecuta. Eso se comprobó ejecutando el script varias
veces seguidas con los dos intérpretes.

Lee el script línea por línea y fíjate en los comentarios: cada
paso explica directamente lo que hace el comando que sigue.

## 9. Ejercicios

Haz estos ejercicios dentro de `practica-batch`, después de
haber ejecutado el script de la sección 8. Primero entra a la
carpeta de práctica:

```bash
cd ~/practica-batch
```

### Ejercicio 1: contar las menciones de luz azul en el registro

Cuenta cuántas líneas del registro mencionan `luz_azul`:

```bash
grep "luz_azul" datos/registro.txt | wc -l
```

Resultado esperado:

```text
3
```

Son 3: el cambio a luz azul de las 09:00 y las mediciones de
las 09:30 y las 11:00.

### Ejercicio 2: contar los archivos de texto de datos

Lista los archivos de texto de la carpeta `datos` y cuenta
cuántos son:

```bash
find datos -name "*.txt" | wc -l
```

Resultado esperado:

```text
6
```

Son 6, contando la copia de respaldo de `muestras.txt` que está
en `datos/respaldo`.

### Ejercicio 3: las tres lecturas con mayor OD680

Ordena las lecturas del día por su OD680, de mayor a menor, y
muestra las tres primeras:

```bash
LC_ALL=C sort -k3 -nr datos/lecturas.txt | head -3
```

Resultado esperado:

```text
10 17:00 0.74
9 16:00 0.73
8 15:00 0.72
```

Las tres lecturas con mayor OD680 son las tres últimas del día,
porque la OD680 creció a lo largo del día: 0.74 a las 17:00,
0.73 a las 16:00 y 0.72 a las 15:00.

## Ayuda de los comandos

Cada comando trae su propia ayuda con la opción `--help`. Por
ejemplo, `grep --help` muestra cómo se usa `grep` y qué
opciones tiene. Sus primeras líneas son:

```text
Usage: grep [OPTION]... PATTERNS [FILE]...
Search for PATTERNS in each FILE.
Example: grep -i 'hello world' menu.h main.c
PATTERNS can contain multiple patterns separated by newlines.
```

El texto exacto de la ayuda puede variar un poco según el
sistema. En la computadora donde se preparó esta lección, el
comando `man` no está instalado, así que `--help` es la forma
de consultar la ayuda de cada comando. Para `find`, `sort`,
`uniq` y `wc`, la ayuda se consulta igual: `find --help`,
`sort --help`, `uniq --help` y `wc --help`.

## Qué aprendimos

- `grep "patrón" archivo` muestra las líneas de un archivo que
  contienen el patrón. Sus opciones más usadas son `-i` para
  buscar sin distinguir mayúsculas y minúsculas, `-n` para
  mostrar el número de línea, `-c` para contar las líneas que
  coinciden, `-v` para mostrar las que no coinciden, `-w` para
  buscar una palabra completa, `-o` para mostrar solo la parte
  que coincide y `-l` para mostrar solo los nombres de los
  archivos. Con `-r` busca dentro de una carpeta y de todas
  las carpetas que hay dentro. Con `-E`, el símbolo `|` significa
  "o", y con `^` y `$` se busca al principio y al final de la
  línea. `grep` termina con código `0` si encontró algo y con
  código `1` si no encontró nada.
- `find carpeta -name "patrón"` busca archivos por su nombre,
  entrando también en las carpetas de dentro. Con `-type f` busca
  solo archivos y con `-type d` solo carpetas. Con `-size` busca
  por tamaño y con `-mtime` por fecha de última modificación.
  Con `-exec` ejecuta un comando sobre cada archivo encontrado.
- `wc` cuenta líneas con `-l`, palabras con `-w` y bytes con
  `-c`. Sin opciones muestra las tres cuentas juntas. Con varios
  archivos añade una línea con el total.
- `sort` ordena las líneas de un archivo o de su entrada
  estándar. Con `-u` quita las repeticiones, con `-r` ordena de
  mayor a menor, con `-k` elige por qué columna se ordena y con
  `-n` ordena por valor numérico. Con `LC_ALL=C` delante, el
  orden es el mismo en cualquier computadora. `sort` no cambia
  el archivo: solo muestra la salida ordenada.
- `uniq` quita las líneas repetidas que están seguidas, por lo
  que se usa después de `sort`. Con `-c` cuenta cuántas veces
  aparecía cada línea y con `-d` muestra solo las que se
  repitieron.
- La tubería `|` conecta la salida estándar de un comando con
  la entrada estándar del siguiente, sin guardar nada en un
  archivo. Con ella se encadenan filtros: `grep` busca,
  `sort` ordena, `uniq -c` cuenta y `wc -l` cuenta líneas.
  Por ejemplo, `grep -o "luz_[a-z]*" datos/registro.txt |
  sort | uniq -c` cuenta cuántas veces se menciona cada luz en
  el registro, y `find datos -name "*.txt" | sort` lista los
  archivos de texto ordenados.
- El script `buscar-filtrar.sh` reúne todo esto: crea la
  estructura, genera los archivos de ejemplo con datos del
  experimento con Chlorella vulgaris, busca las muestras con
  luz azul, cuenta las mediciones y los tratamientos, ordena
  las muestras por su OD680 y lista los archivos que mencionan
  OD680.
