# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Lección 06: Redirecciones y archivos de registro

# Lección 06: Redirecciones y archivos de registro

En esta lección vas a guardar la salida de un comando en un archivo
con `>` y `>>`, separar la salida normal de los errores con `2>`,
ver la salida en pantalla y guardarla a la vez con `tee`, darle
entrada a un comando con `<` y guardar el registro de un análisis
en un archivo. Al terminar sabrás guardar los resultados de un
comando en un archivo, añadir resultados a un archivo existente sin
borrarlo y guardar un registro de lo que hizo un análisis.

Todo lo que hagas aquí ocurre dentro de la carpeta de práctica
`~/practica-batch`, la misma de las lecciones 02, 03, 04 y 05, así
que puedes equivocarte sin riesgo: nada de lo que cambies aquí
afecta al resto de tu computadora.

Primero, algunas palabras que usaremos en toda la lección:

- **Salida estándar**: lo que un comando escribe en la terminal
  cuando termina bien. Por ejemplo, la lista de líneas que muestra
  `grep` es su salida estándar. En inglés se llama *standard
  output* y se abrevia *stdout*.
- **Salida de errores**: lo que un comando escribe en la terminal
  cuando algo sale mal. Por ejemplo, el mensaje "No existe el
  archivo" que muestra `ls` cuando el archivo no está. En inglés
  se llama *standard error* y se abrevia *stderr*. La salida
  estándar y la salida de errores son dos salidas distintas: un
  comando puede escribir en una, en la otra o en las dos.
- **Entrada estándar**: lo que un comando lee para trabajar,
  cuando no se le da un archivo. En inglés se llama *standard
  input* y se abrevia *stdin*. En la lección 05 se vio que `sort`
  sin archivo lee de su entrada estándar lo que le llega por una
  tubería.
- **Descriptor de archivo**: el número que la shell usa para
  referirse a cada una de esas tres vías: `0` es la entrada
  estándar, `1` es la salida estándar y `2` es la salida de
  errores. Por eso la salida estándar se redirige con `>` (que
  es lo mismo que `1>`) y la salida de errores con `2>`.
- **Redirección**: cambiar a dónde va la salida de un comando o
  de dónde viene su entrada, usando `>`, `>>`, `<`, `2>` o
  `2>&1`. Con una redirección, la salida deja de aparecer en la
  terminal y va a parar a un archivo, o la entrada deja de
  venir del teclado y viene de un archivo.
- **Archivo de registro**: un archivo de texto en el que se van
  guardando, en orden, los resultados y los mensajes de un
  análisis, para revisarlos después. En inglés se llama *log
  file* y también se le dice *log*. Un registro se construye
  añadiendo líneas con `>>`, para no borrar lo que ya se guardó.
- **Sobrescribir**: escribir en un archivo borrando antes todo
  lo que tenía. La redirección `>` sobrescribe: si el archivo ya
  existía, su contenido anterior se pierde.
- **Añadir**: escribir al final de un archivo, sin borrar lo que
  ya tenía. La redirección `>>` añade: si el archivo ya existía,
  las líneas nuevas se escriben detrás de las que ya había.

## 0. Antes de empezar

Entra a la carpeta de práctica:

```bash
cd ~/practica-batch
```

En esta lección se usan los archivos de las lecciones 03, 04 y 05
(`muestras.txt`, `lecturas.txt`, `notas.txt`, `registro.txt`,
`tratamientos.txt` y `resumen.txt`) y un archivo nuevo:
`muestras-scenedesmus.txt`, con datos de 3 muestras de
*Scenedesmus acutus*, con la misma forma que `muestras.txt`. Los
resultados se guardan en la carpeta `resultados`.

Crea el archivo `muestras-scenedesmus.txt` con los datos de las
3 muestras. Cada línea tiene: muestra, tratamiento y OD680:

```bash
cat > datos/muestras-scenedesmus.txt << 'EOF'
muestra tratamiento OD680
S01 control 0.38
S02 luz_azul 0.61
S03 luz_roja 0.66
EOF
```

Comprueba que los archivos están en su lugar:

```bash
ls datos
```

Salida real:

```text
lecturas.txt
muestras-scenedesmus.txt
muestras.txt
notas.txt
registro.txt
respaldo
tratamientos.txt
```

En las salidas de esta lección, los mensajes de error aparecen en
inglés, porque la computadora donde se preparó está configurada
con el idioma en inglés. En una Mac configurada en español, los
mismos mensajes aparecen en español, por ejemplo "No existe el
archivo o el directorio" en lugar de "No such file or directory".
Lo que importa es el nombre del archivo que no existe y el código
de salida del comando, que son los mismos en los dos idiomas.

Dos advertencias sobre el orden de las salidas. Primera: `grep -r`
recorre los archivos en el orden en que los encuentra, y ese orden
puede cambiar de una computadora a otra. En las salidas de esta
lección aparece el orden que se obtuvo al prepararla; en la tuya
puede ser otro, y lo que importa es que aparezcan los mismos
archivos y las mismas líneas. Segunda: la fecha que se muestra en
la sección 7 es la del día en que se preparó esta lección; en tu
computadora aparecerá la fecha del día en que tú ejecutes el
comando.

## 1. Guardar la salida en un archivo con `>`

La redirección `>` guarda la salida estándar de un comando en un
archivo, en lugar de mostrarla en la terminal. La forma básica es:

```text
comando > archivo
```

### Guardar el resultado de una búsqueda

Guarda las muestras con luz azul en un archivo nuevo:

```bash
grep "luz_azul" datos/muestras.txt > resultados/luz-azul.txt
```

El comando no muestra nada en la terminal: su salida fue a parar
al archivo. Para ver lo que se guardó, se lee el archivo con
`cat`, como se vio en la lección 03:

```bash
cat resultados/luz-azul.txt
```

Salida real:

```text
M02 luz_azul 0.68
M04 luz_azul 0.65
```

El archivo `luz-azul.txt` contiene las dos líneas que encontró
`grep`. Si el archivo no existía, `>` lo crea. Si ya existía,
`>` lo vacía primero y después escribe la salida nueva. Por eso
`>` sirve para guardar un resultado nuevo, y no para añadir a un
archivo que ya tiene algo que se quiere conservar: para eso está
`>>`, que se explica en la sección 2.

### Crear un archivo vacío con `>`

Con solo `>` y un nombre de archivo, sin ningún comando delante,
se crea un archivo vacío. También sirve para vaciar un archivo
que ya existe:

```bash
> resultados/vacio.txt
```

Comprueba que el archivo se creó y que pesa 0 bytes:

```bash
wc -c resultados/vacio.txt
```

Salida real:

```text
0 resultados/vacio.txt
```

La opción `-c` de `wc` cuenta los bytes del archivo, como se vio
en la lección 05. Un archivo vacío pesa 0 bytes.

### El peligro de redirigir un archivo sobre sí mismo

Como `>` vacía el archivo de destino antes de que el comando se
ejecute, redirigir un archivo sobre sí mismo lo deja vacío. Haz
primero una copia de las notas, para no perder el archivo
original:

```bash
cp datos/notas.txt datos/notas-copia.txt
```

Ahora lee la copia y guarda el resultado en la misma copia:

```bash
cat datos/notas-copia.txt > datos/notas-copia.txt
```

Comprueba cuántas líneas quedan en la copia:

```bash
wc -l datos/notas-copia.txt
```

Salida real:

```text
0 datos/notas-copia.txt
```

La copia quedó vacía. La shell vació el archivo al ver el `>`,
antes de que `cat` empezara a leerlo, así que `cat` ya no encontró
nada que leer. La regla es: nunca se usa el mismo archivo como
entrada y como salida de una redirección en el mismo comando. Si
se quiere cambiar un archivo, se guarda el resultado en un
archivo nuevo y después se mueve con `mv`, como se vio en la
lección 03.

El archivo original, `datos/notas.txt`, sigue intacto, porque
solo se tocó la copia. La copia vacía se puede borrar al final
de la lección, o dejarla como recordatorio de lo que pasa cuando
se redirige un archivo sobre sí mismo.

## 2. Añadir sin borrar con `>>`

La redirección `>>` guarda la salida estándar al final de un
archivo, sin borrar lo que ya tenía. La forma básica es:

```text
comando >> archivo
```

Si el archivo no existe, `>>` lo crea, igual que `>`. La
diferencia está cuando el archivo ya existe: con `>` se vacía y
con `>>` se conserva lo que tenía y se añade la salida nueva al
final.

### Añadir las muestras con luz roja al archivo anterior

El archivo `resultados/luz-azul.txt` ya tiene las dos muestras
con luz azul. Añade las muestras con luz roja:

```bash
grep "luz_roja" datos/muestras.txt >> resultados/luz-azul.txt
```

Lee el archivo para ver lo que contiene ahora:

```bash
cat resultados/luz-azul.txt
```

Salida real:

```text
M02 luz_azul 0.68
M04 luz_azul 0.65
M03 luz_roja 0.71
```

Las dos líneas de luz azul siguen ahí, y la línea de luz roja
se añadió al final. Si se hubiera usado `>` en lugar de `>>`,
las dos líneas de luz azul se habrían perdido y el archivo solo
tendría la línea de luz roja.

### Añadir un texto y un recuento al mismo archivo

Con `echo` también se puede añadir texto a un archivo. Añade una
línea con un título y después el recuento de muestras con luz,
que se calcula con `grep -c`, como se vio en la lección 05:

```bash
echo "Total de muestras con luz:" >> resultados/luz-azul.txt
grep -c "luz" datos/muestras.txt >> resultados/luz-azul.txt
```

Lee el archivo completo:

```bash
cat resultados/luz-azul.txt
```

Salida real:

```text
M02 luz_azul 0.68
M04 luz_azul 0.65
M03 luz_roja 0.71
Total de muestras con luz:
3
```

El archivo tiene ahora 5 líneas: las 3 muestras con luz, el
título y el recuento, que es 3. Cada comando con `>>` añadió sus
líneas al final, sin tocar las anteriores. Así se construye un
archivo paso a paso, y así se construye también el registro de
un análisis, como se verá en la sección 7.

## 3. Separar la salida normal de los errores con `2>`

Hasta aquí, las redirecciones guardaban la salida estándar. Los
errores van por otra vía, la salida de errores, y se redirigen
con `2>`. El `2` es el descriptor de archivo de la salida de
errores, como se explicó al principio de la lección.

### Dónde aparece un error si no se redirige

Lista un archivo que no existe:

```bash
ls datos/archivo-inexistente.txt
```

Salida real:

```text
ls: cannot access 'datos/archivo-inexistente.txt': No such file or directory
```

El mensaje de error aparece en la terminal, porque no se
redirigió nada. El comando termina con código de salida `2`,
que es el código que usa `ls` cuando no encuentra el archivo.
Compruébalo:

```bash
ls datos/archivo-inexistente.txt; echo $?
```

Salida real:

```text
ls: cannot access 'datos/archivo-inexistente.txt': No such file or directory
2
```

El código de salida se guarda en `$?`, como se vio en la
lección 04. El `2` que aparece al final es el código de salida
de `ls`, no parte del mensaje de error.

### Guardar los errores en un archivo con `2>`

Guarda el error en un archivo, en lugar de dejarlo en la
terminal:

```bash
ls datos/archivo-inexistente.txt 2> resultados/errores.txt
```

Esta vez no aparece nada en la terminal: el mensaje de error fue
a parar al archivo. Lee el archivo:

```bash
cat resultados/errores.txt
```

Salida real:

```text
ls: cannot access 'datos/archivo-inexistente.txt': No such file or directory
```

El mensaje es el mismo que antes, pero ahora está guardado en
el archivo y se puede revisar después. El código de salida sigue
siendo `2`: redirigir los errores no cambia el resultado del
comando, solo cambia a dónde va su mensaje.

### Guardar la salida y los errores en archivos distintos

Cuando un comando puede escribir en las dos salidas, se
redirige cada una a su propio archivo. Busca una palabra en un
archivo que no existe:

```bash
grep "luz" datos/no-existe.txt > resultados/busqueda.txt 2> resultados/errores-busqueda.txt
```

El comando no muestra nada en la terminal. Su salida estándar,
que está vacía porque `grep` no encontró nada que mostrar, fue
a `busqueda.txt`, y su error fue a `errores-busqueda.txt`. El
comando termina con código `2`, porque el archivo no existe:

```bash
grep "luz" datos/no-existe.txt > resultados/busqueda.txt 2> resultados/errores-busqueda.txt; echo $?
```

Salida real:

```text
2
```

Comprueba los dos archivos:

```bash
cat resultados/busqueda.txt
```

Salida real:

```text
```

```bash
cat resultados/errores-busqueda.txt
```

Salida real:

```text
grep: datos/no-existe.txt: No such file or directory
```

El archivo `busqueda.txt` está vacío: `grep` no escribió nada
en su salida estándar. Fíjate en que `>` creó el archivo vacío
aunque el comando fallara: la shell crea o vacía el archivo de
destino antes de ejecutar el comando, y eso pasa tanto si el
comando termina bien como si termina mal. El archivo
`errores-busqueda.txt` contiene el mensaje de error de `grep`.

### Añadir errores sin borrar con `2>>`

Igual que `>>` añade salida estándar, `2>>` añade errores al
final de un archivo sin borrar lo que ya tenía. Guarda dos
errores en el mismo archivo:

```bash
ls datos/archivo-inexistente.txt 2> resultados/errores.txt
ls datos/otro-inexistente.txt 2>> resultados/errores.txt
```

Lee el archivo:

```bash
cat resultados/errores.txt
```

Salida real:

```text
ls: cannot access 'datos/archivo-inexistente.txt': No such file or directory
ls: cannot access 'datos/otro-inexistente.txt': No such file or directory
```

El primer comando creó el archivo con el primer error, y el
segundo añadió el segundo error al final. Con `2>` en el segundo
comando, el primer error se habría perdido.

### Guardar la salida y los errores juntos con `2>&1`

La redirección `2>&1` dice "la salida de errores va a donde va
la salida estándar". Con ella, las dos salidas terminan en el
mismo archivo. La forma es:

```text
comando > archivo 2>&1
```

Guarda la salida y el error de la búsqueda anterior en un solo
archivo:

```bash
grep "luz" datos/no-existe.txt > resultados/todo.txt 2>&1
```

Lee el archivo:

```bash
cat resultados/todo.txt
```

Salida real:

```text
grep: datos/no-existe.txt: No such file or directory
```

El error quedó guardado en `todo.txt`, junto con la salida
estándar, que en este caso estaba vacía. El orden importa: `2>&1`
tiene que ir después del `>`, porque `2>&1` copia el destino
que la salida estándar tiene en ese momento. Si se escribe al
revés, el error va a la terminal:

```bash
grep "luz" datos/no-existe.txt 2>&1 > resultados/solo-salida.txt
```

Salida real:

```text
grep: datos/no-existe.txt: No such file or directory
```

El mensaje de error apareció en la terminal, porque cuando la
shell leyó el `2>&1`, la salida estándar todavía iba a la
terminal: el `>` que la manda al archivo viene después. Y el
archivo quedó vacío, como se comprueba leyéndolo:

```bash
cat resultados/solo-salida.txt
```

Salida real:

```text
```

### La forma corta `&>` en bash y en zsh

En bash y en zsh, la redirección `&>` hace lo mismo que
`> archivo 2>&1`: manda la salida estándar y la salida de
errores al mismo archivo:

```bash
grep "luz" datos/no-existe.txt &> resultados/todo2.txt
```

Lee el archivo:

```bash
cat resultados/todo2.txt
```

Salida real:

```text
grep: datos/no-existe.txt: No such file or directory
```

El resultado es el mismo que con `> resultados/todo.txt 2>&1`.
La forma `&>` es más corta, pero no funciona en todas las
shells: en `sh`, por ejemplo, no existe. La forma `> archivo
2>&1` funciona en bash, en zsh y en `sh`, así que es la que
conviene usar en los scripts, que deben correr en cualquier
shell. En esta lección, el script de la sección 8 usa la forma
larga.

## 4. Descartar la salida con `/dev/null`

`/dev/null` es un archivo especial del sistema que no guarda
nada: todo lo que se escribe en él se descarta. Sirve para
tirar una salida que no interesa, sin que aparezca en la
terminal ni se guarde en ningún archivo.

### Comprobar si algo se encontró, sin ver el resultado

En la lección 05 se vio que `grep` termina con código `0` si
encontró algo y con código `1` si no encontró nada. Para saber
solo si algo está o no está, sin ver las líneas, se manda la
salida a `/dev/null` y se mira el código de salida. Busca
`Scenedesmus` en las muestras, que solo tienen *Chlorella*:

```bash
grep "Scenedesmus" datos/muestras.txt > /dev/null 2>&1; echo $?
```

Salida real:

```text
1
```

No aparece nada en la terminal: la salida estándar fue a
`/dev/null` y tampoco hubo errores. El código `1` dice que
`grep` no encontró nada. Con una búsqueda que sí encuentra
algo, el código sería `0`, como se comprobó en la lección 05.

### Callar los errores de un comando

Para callar solo los errores, se redirige la salida de errores
a `/dev/null`. Lista los archivos `.csv` de datos, que no
existen:

```bash
ls datos/*.csv 2> /dev/null; echo $?
```

Salida real:

```text
2
```

No aparece ningún mensaje de error, porque fue a parar a
`/dev/null`. El comando sigue terminando con código `2`, porque
no hay ningún archivo `.csv` en la carpeta: descartar el mensaje
no cambia el resultado del comando, solo lo calla. Lo mismo vale
para la búsqueda en un archivo que no existe:

```bash
grep "luz" datos/no-existe.txt 2> /dev/null; echo $?
```

Salida real:

```text
2
```

El error se descartó y solo queda el código de salida, `2`.
Descartar la salida con `/dev/null` conviene cuando solo importa
el código de salida de un comando, o cuando se sabe que un
comando va a escribir errores que no aportan nada. No conviene
usarlo para esconder errores que sí hay que revisar: un error
descartado no se puede leer después.

## 5. Ver la salida y guardarla a la vez con `tee`

`tee` lee de su entrada estándar, escribe lo que lee en un
archivo y, a la vez, lo deja pasar a su salida estándar. Su
nombre viene de la letra T: la entrada se divide en dos, una
rama va al archivo y la otra sigue adelante. Se usa en medio de
una tubería, cuando se quiere ver el resultado en pantalla y
guardarlo en un archivo al mismo tiempo. La forma básica es:

```text
comando | tee archivo
```

### Ver y guardar en un solo paso

Busca las muestras con luz, guárdalas en un archivo y cuéntalas
a la vez:

```bash
grep "luz" datos/muestras.txt | tee resultados/luz.txt | wc -l
```

Salida real:

```text
3
```

El `3` es el recuento de `wc -l`: hay 3 muestras con luz. El
archivo `resultados/luz.txt` se creó con las mismas 3 líneas.
Léelo para comprobarlo:

```bash
cat resultados/luz.txt
```

Salida real:

```text
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
```

Sin `tee`, habría que guardar el resultado en un archivo con
`>` y después leerlo con `cat`, o verlo en pantalla y después
volver a ejecutar el comando para guardarlo. Con `tee`, un solo
comando hace las dos cosas.

`tee` también escribe en varios archivos a la vez, si se le dan
varios nombres. Y su salida se puede seguir encadenando con más
filtros, como se hizo aquí con `wc -l`.

### Añadir con `tee -a`

Igual que `>` vacía el archivo y `>>` añade al final, `tee`
vacía el archivo y `tee -a` añade al final. La opción `-a` es
de *append*, "añadir" en inglés. Añade una medición nueva al
archivo anterior:

```bash
echo "M06 luz_roja 0.69" | tee -a resultados/luz.txt
```

Salida real:

```text
M06 luz_roja 0.69
```

La línea apareció en la terminal y también se añadió al archivo.
Léelo:

```bash
cat resultados/luz.txt
```

Salida real:

```text
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
M06 luz_roja 0.69
```

El archivo tiene ahora 4 líneas: las 3 muestras que guardó el
primer `tee` y la medición M06 que añadió el segundo con `-a`.
Sin la opción `-a`, el segundo `tee` habría vaciado el archivo
y solo tendría la línea M06.

## 6. Darle entrada a un comando con `<`

La redirección `<` le da a un comando la entrada estándar desde
un archivo, en lugar de leerla del teclado o de una tubería. La
forma básica es:

```text
comando < archivo
```

### Contar líneas sin que aparezca el nombre del archivo

Cuenta las líneas de `muestras.txt` de las dos formas y compara:

```bash
wc -l < datos/muestras.txt
```

Salida real:

```text
6
```

```bash
wc -l datos/muestras.txt
```

Salida real:

```text
6 datos/muestras.txt
```

Con `<`, `wc` lee el archivo por su entrada estándar y no sabe
cómo se llama, así que solo muestra el número: `6`. Con el
nombre de archivo como argumento, `wc` muestra el número y el
nombre: `6 datos/muestras.txt`. Las 6 líneas son el encabezado
más las 5 muestras. La diferencia es solo de presentación, pero
importa cuando el número se va a usar en otro comando: con `<`,
la salida es solo el número, sin el nombre detrás.

### Ordenar y contar desde un archivo

La redirección `<` también se combina con tuberías. Ordena los
tratamientos y cuenta cuántas veces se aplicó cada uno, como se
hizo en la lección 05, pero leyendo el archivo por la entrada
estándar:

```bash
sort < datos/tratamientos.txt | uniq -c
```

Salida real:

```text
      3 control
      3 luz_azul
      2 luz_roja
```

El resultado es el mismo que con `sort datos/tratamientos.txt |
uniq -c`. Con `<`, `sort` lee de su entrada estándar; con el
nombre de archivo, `sort` abre el archivo por sí mismo. Las dos
formas dan lo mismo, y se usa una u otra según convenga.

### Juntar dos archivos en uno con `cat` y `>`

`cat` también concatena archivos: con dos nombres, muestra el
contenido de uno detrás del otro. Con `>`, ese contenido junto
se guarda en un archivo nuevo. Junta las muestras de *Chlorella*
y las de *Scenedesmus* en un solo archivo:

```bash
cat datos/muestras.txt datos/muestras-scenedesmus.txt > resultados/muestras-todas.txt
```

Lee el archivo resultante:

```bash
cat resultados/muestras-todas.txt
```

Salida real:

```text
muestra tratamiento OD680
M01 control 0.42
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
M05 control 0.44
muestra tratamiento OD680
S01 control 0.38
S02 luz_azul 0.61
S03 luz_roja 0.66
```

El archivo tiene 10 líneas: las 6 de `muestras.txt` y las 4 de
`muestras-scenedesmus.txt`. El encabezado aparece dos veces,
porque cada archivo trae el suyo. Cuando se juntan archivos con
encabezado, el encabezado repetido se quita después, por
ejemplo con `grep -v`, como se vio en la lección 05, o se
trabaja con los archivos por separado.

## 7. Guardar el registro de un análisis

Un análisis se registra guardando sus resultados en un archivo,
paso a paso, con `>>`. La salida normal va al registro y los
errores van a un archivo aparte, para que un error no se mezcle
con los resultados. Así, al terminar, el registro dice qué se
hizo y qué salió, y el archivo de errores dice qué falló.

Arma el registro del análisis de las muestras con luz azul.
Primero crea el registro con el título, usando `>`, porque el
archivo es nuevo:

```bash
echo "Registro del analisis del experimento con Chlorella vulgaris" > resultados/registro-analisis.txt
```

Después añade cada paso con `>>`. Añade un título y las muestras
con luz azul:

```bash
echo "Muestras con luz azul:" >> resultados/registro-analisis.txt
grep "luz_azul" datos/muestras.txt >> resultados/registro-analisis.txt
```

Añade otro título y el recuento de mediciones del día:

```bash
echo "Mediciones registradas en el dia:" >> resultados/registro-analisis.txt
grep -c "medicion" datos/registro.txt >> resultados/registro-analisis.txt
```

Añade un paso que falla, para ver a dónde va su error. El
comando intenta listar un archivo que no existe, y su salida
estándar, que está vacía, iría al registro, mientras que su
error va al archivo de errores:

```bash
ls datos/no-existe.txt >> resultados/registro-analisis.txt 2> resultados/errores-analisis.txt
```

El comando termina con código `2`, como se comprobó en la
sección 3. Lee el registro:

```bash
cat resultados/registro-analisis.txt
```

Salida real:

```text
Registro del analisis del experimento con Chlorella vulgaris
Muestras con luz azul:
M02 luz_azul 0.68
M04 luz_azul 0.65
Mediciones registradas en el dia:
4
```

El registro tiene los resultados de cada paso, en orden: el
título, las dos muestras con luz azul y las 4 mediciones del
día. El error del último paso no aparece en el registro, porque
su salida estándar estaba vacía y su error fue a otro archivo.
Lee el archivo de errores:

```bash
cat resultados/errores-analisis.txt
```

Salida real:

```text
ls: cannot access 'datos/no-existe.txt': No such file or directory
```

El error quedó guardado aparte, donde se puede revisar sin
mezclarse con los resultados. Si se hubiera usado `2>&1` en
lugar de `2>`, el error habría quedado dentro del registro,
detrás de las mediciones.

### Añadir la fecha al registro

Para saber cuándo se hizo el análisis, se añade la fecha al
registro con `date`. El comando `date` muestra la fecha y la
hora actuales:

```bash
date +%Y-%m-%d
```

Salida real:

```text
2026-11-15
```

La opción `+%Y-%m-%d` le dice a `date` que muestre solo la
fecha, en el orden año-mes-día: `2026` es el año, `11` es el mes
y `15` es el día. La fecha que aparece es la del día en que se
preparó esta lección; en tu computadora aparecerá la fecha del
día en que tú ejecutes el comando. Para añadirla al registro:

```bash
date +%Y-%m-%d >> resultados/registro-analisis.txt
```

Con `>>`, la fecha se añade al final del registro, sin borrar
lo que ya tenía. Así, cada vez que se repite el análisis, se
puede añadir la fecha nueva y los resultados nuevos al mismo
registro, y queda la historia completa de lo que se hizo.

## 8. El script `redirecciones.sh`

El archivo `redirecciones.sh`, que acompaña a esta lección,
reúne todo lo aprendido en un solo script: crea la estructura
de carpetas, genera los archivos de ejemplo con datos del
experimento con *Chlorella vulgaris* y con *Scenedesmus
acutus*, guarda resultados en archivos con `>` y `>>`, guarda
los errores aparte con `2>` y `2>>`, guarda la salida y los
errores juntos con `2>&1`, descarta salidas con `/dev/null`,
muestra y guarda a la vez con `tee`, junta las muestras de las
dos especies en un archivo y arma el registro de un análisis.

Para ejecutarlo, entra a la carpeta donde guardaste el script y
ejecútalo con `bash` (el script entra solo a tu carpeta de
usuario, así que funciona sin importar desde dónde lo llames):

```bash
bash redirecciones.sh
```

El script solo trabaja dentro de la carpeta de práctica de tu
carpeta de usuario, `~/practica-batch`, la misma de esta
lección. No toca ningún otro archivo de la computadora. Además,
se puede ejecutar dos veces seguidas: vuelve a generar sus
archivos de ejemplo sin borrar el trabajo que tú hayas guardado
dentro de `practica-batch`.

Salida real de `bash redirecciones.sh`:

```text
Muestras con luz_azul, guardadas en resultados/luz-azul.txt:
M02 luz_azul 0.68
M04 luz_azul 0.65
Muestras con luz, despues de anadir las de luz_roja:
M02 luz_azul 0.68
M04 luz_azul 0.65
M03 luz_roja 0.71
Bytes de un archivo creado con > y sin nada dentro:
0 practica-batch/resultados/vacio.txt
Lineas que quedan en notas-copia.txt despues de cat archivo > archivo:
0 practica-batch/datos/notas-copia.txt
Errores de buscar en un archivo que no existe:
grep: practica-batch/datos/no-existe.txt: No such file or directory
Salida y errores juntos en resultados/todo.txt:
grep: practica-batch/datos/no-existe.txt: No such file or directory
Errores acumulados en resultados/errores.txt:
ls: cannot access 'practica-batch/datos/archivo-inexistente.txt': No such file or directory
ls: cannot access 'practica-batch/datos/otro-inexistente.txt': No such file or directory
Codigo de salida de una busqueda sin resultados:
Codigo de salida: 1
Muestras con luz, vistas en pantalla y guardadas con tee:
3
Muestras de Chlorella y de Scenedesmus juntas:
muestra tratamiento OD680
M01 control 0.42
M02 luz_azul 0.68
M03 luz_roja 0.71
M04 luz_azul 0.65
M05 control 0.44
muestra tratamiento OD680
S01 control 0.38
S02 luz_azul 0.61
S03 luz_roja 0.66
Registro del analisis:
Registro del analisis del experimento con Chlorella vulgaris
Muestras con luz azul:
M02 luz_azul 0.68
M04 luz_azul 0.65
Mediciones registradas en el dia:
4
Errores del analisis:
ls: cannot access 'practica-batch/datos/no-existe.txt': No such file or directory
```

El script también funciona con `sh`:

```bash
sh redirecciones.sh
```

La salida es idéntica con `bash` y con `sh`, y es idéntica cada
vez que se ejecuta. Eso se comprobó ejecutando el script varias
veces seguidas con los dos intérpretes.

Lee el script línea por línea y fíjate en los comentarios: cada
paso explica directamente lo que hace el comando que sigue. En
los pasos en los que un comando termina con un código distinto
de cero, como la búsqueda en un archivo que no existe, el script
usa `|| true` o guarda el código en una variable, para que el
script no se detenga a la mitad. Eso pasa porque el script
empieza con `set -e`, que detiene el script cuando un comando
falla, como se vio en la lección 04. Sin `|| true`, la primera
búsqueda fallida detendría el script y no se ejecutarían los
pasos siguientes.

## 9. Ejercicios

Haz estos ejercicios dentro de `practica-batch`, después de
haber ejecutado el script de la sección 8. Primero entra a la
carpeta de práctica:

```bash
cd ~/practica-batch
```

### Ejercicio 1: guardar las muestras de control en un archivo

Guarda las muestras de control en un archivo nuevo y cuenta
cuántas líneas tiene:

```bash
grep "control" datos/muestras.txt > resultados/control.txt
wc -l resultados/control.txt
```

Resultado esperado:

```text
2 resultados/control.txt
```

Son 2: M01 y M05, las dos muestras de control. El encabezado no
aparece, porque no contiene la palabra `control`.

### Ejercicio 2: guardar el error de `ls` en un archivo

Lista un archivo que no existe, guarda su error en un archivo y
lee el archivo:

```bash
ls datos/no-existe.txt 2> resultados/error-ls.txt
cat resultados/error-ls.txt
```

Resultado esperado:

```text
ls: cannot access 'datos/no-existe.txt': No such file or directory
```

El mensaje no apareció en la terminal, porque fue a parar al
archivo. En una Mac configurada en español, el mensaje diría
"No existe el archivo o el directorio" en lugar de "No such file
or directory".

### Ejercicio 3: ordenar, guardar y contar con `tee`

Ordena los tratamientos, guárdalos ordenados en un archivo con
`tee` y cuenta cuántas veces se aplicó cada uno:

```bash
sort datos/tratamientos.txt | tee resultados/tratamientos-ordenados.txt | uniq -c
```

Resultado esperado:

```text
      3 control
      3 luz_azul
      2 luz_roja
```

El control y la luz azul se aplicaron 3 veces cada uno, y la luz
roja 2 veces. El archivo `resultados/tratamientos-ordenados.txt`
quedó con los 8 tratamientos ordenados, y el recuento se vio en
la terminal.

## Ayuda de los comandos

Cada comando trae su propia ayuda con la opción `--help`. Por
ejemplo, `tee --help` muestra cómo se usa `tee` y qué opciones
tiene. Sus primeras líneas son:

```text
Usage: tee [OPTION]... [FILE]...
Copy standard input to each FILE, and also to standard output.

  -a, --append              append to the given FILEs, do not overwrite
  -i, --ignore-interrupts   ignore interrupt signals
```

El texto exacto de la ayuda puede variar un poco según el
sistema. En la computadora donde se preparó esta lección, el
comando `man` no está instalado, así que `--help` es la forma
de consultar la ayuda de cada comando. Para `cat`, `echo`,
`grep`, `ls`, `sort` y `wc`, la ayuda se consulta igual: `cat
--help`, `echo --help`, `grep --help`, `ls --help`, `sort
--help` y `wc --help`.

## Qué aprendimos

- `comando > archivo` guarda la salida estándar de un comando
  en un archivo. Si el archivo no existe, lo crea; si ya
  existe, lo vacía primero. Con solo `> archivo`, sin comando,
  se crea un archivo vacío. Nunca se usa el mismo archivo como
  entrada y como salida en el mismo comando, porque la shell lo
  vacía antes de que el comando lo lea.
- `comando >> archivo` añade la salida estándar al final de un
  archivo, sin borrar lo que ya tenía. Si el archivo no existe,
  lo crea. Así se construye un archivo paso a paso y así se
  arma el registro de un análisis.
- La salida estándar y la salida de errores son dos salidas
  distintas. Sus descriptores de archivo son `1` y `2`. Con
  `2> archivo` se guardan los errores en un archivo, y con
  `2>> archivo` se añaden al final sin borrar lo que ya tenía.
  Con `> archivo 2>&1` se guardan la salida y los errores
  juntos en el mismo archivo, y el orden importa: el `2>&1`
  tiene que ir después del `>`. En bash y en zsh, `&> archivo`
  hace lo mismo, pero no funciona en `sh`.
- `/dev/null` es un archivo especial que descarta todo lo que
  se escribe en él. Sirve para tirar una salida que no
  interesa, por ejemplo para comprobar si `grep` encontró algo
  mirando solo su código de salida: `0` si encontró algo y `1`
  si no encontró nada. Descartar un mensaje no cambia el código
  de salida del comando.
- `comando | tee archivo` muestra la salida en pantalla y la
  guarda en un archivo al mismo tiempo. Con `tee -a archivo`,
  la salida se añade al final del archivo en lugar de vaciarlo.
- `comando < archivo` le da a un comando la entrada estándar
  desde un archivo. Con `<`, `wc -l` muestra solo el número,
  sin el nombre del archivo. `cat archivo1 archivo2 > archivo3`
  junta dos archivos en uno.
- El registro de un análisis se arma con `>>`: cada paso añade
  sus resultados al registro, y los errores van a un archivo
  aparte con `2>`. La fecha del análisis se añade con `date
  +%Y-%m-%d >> registro.txt`.
- El script `redirecciones.sh` reúne todo esto: crea la
  estructura, genera los archivos de ejemplo con datos del
  experimento con *Chlorella vulgaris* y con *Scenedesmus
  acutus*, guarda resultados con `>` y `>>`, guarda los errores
  aparte con `2>` y `2>>`, guarda la salida y los errores
  juntos con `2>&1`, descarta salidas con `/dev/null`, muestra
  y guarda a la vez con `tee`, junta las muestras de las dos
  especies y arma el registro de un análisis. En los pasos en
  los que un comando termina con un código distinto de cero,
  el script usa `|| true` o guarda el código en una variable,
  para que `set -e` no lo detenga a la mitad.
