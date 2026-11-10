# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Lección 04: Permisos

# Lección 04: Permisos

En esta lección vas a leer los permisos de un archivo, cambiarlos
con `chmod`, cambiar el propietario con `chown` y el grupo con
`chgrp`, y entender qué es `umask`. Al terminar sabrás por qué un
script necesita permiso de ejecución para correrse como
`./script.sh`, y cómo proteger un archivo para que solo tú puedas
leerlo.

Todo lo que hagas aquí ocurre dentro de la carpeta de práctica
`~/practica-batch`, la misma de las lecciones 02 y 03, así que
puedes equivocarte sin riesgo: nada de lo que cambies aquí afecta
al resto de tu computadora.

Primero, algunas palabras que usaremos en toda la lección:

- **Permiso**: lo que se le permite hacer a alguien con un archivo
  o una carpeta: leerlo, modificarlo o ejecutarlo.
- **Propietario**: el usuario dueño de un archivo o una carpeta. En
  general, es el usuario que lo creó.
- **Grupo**: un conjunto de usuarios que comparten archivos. Por
  ejemplo, los integrantes de un laboratorio pueden formar un grupo
  y compartir sus archivos de resultados entre ellos.
- **Otros**: todos los usuarios que no son el propietario ni
  pertenecen al grupo del archivo.
- **Lectura** (`r`, de *read*): poder ver el contenido de un
  archivo, o ver la lista de archivos de una carpeta.
- **Escritura** (`w`, de *write*): poder modificar un archivo, o
  crear y borrar archivos dentro de una carpeta.
- **Ejecución** (`x`, de *execute*): poder correr un archivo como
  un programa, o entrar a una carpeta y usar lo que hay dentro.
- **`umask`**: un ajuste de la shell que decide con qué permisos
  nacen los archivos y las carpetas nuevas.

## 0. Antes de empezar

Entra a la carpeta de práctica y comprueba tu `umask`, es decir,
el ajuste con el que nacen tus archivos nuevos:

```bash
cd ~/practica-batch
umask
```

Salida real:

```text
0022
```

En la mayoría de las computadoras el `umask` inicial es `022`.
Si en la tuya es otro valor, los permisos iniciales de los
archivos que crees en esta lección serán distintos de los que se
muestran aquí; en la sección 8 se explica qué significa cada
valor y cómo cambiarlo.

En las salidas de esta lección verás el usuario `root` y el grupo
`root`, porque así está configurada la computadora donde se
preparó. En tu computadora verás tu propio nombre de usuario y
tu propio grupo, y tu propia fecha y hora. Los permisos, que son
lo que importa en esta lección, se ven igual en cualquier
computadora.

## 1. Leer los permisos con `ls -l`

`ls -l` muestra los permisos de cada archivo, junto con su
propietario, su grupo, su tamaño y su fecha de última
modificación. Míralo con el archivo de muestras de la lección 03:

```bash
ls -l datos/muestras.txt
```

Salida real:

```text
-rw-r--r-- 1 root root 114 Nov 10 15:49 datos/muestras.txt
```

Lee esta salida de izquierda a derecha:

- `-rw-r--r--` son el tipo y los permisos. Se leen en cuatro
  partes: el primer carácter es el tipo (`-` significa archivo
  normal, `d` significa carpeta), y después vienen tres grupos
  de tres letras: los permisos del propietario, los del grupo y
  los de los demás usuarios.
- `1` es la cantidad de enlaces al archivo. Para un archivo
  normal suele ser `1`.
- `root` es el propietario y el segundo `root` es el grupo.
- `114` es el tamaño en bytes.
- `Nov 10 15:49` es la fecha y hora de la última modificación.
- `datos/muestras.txt` es el nombre del archivo.

Los permisos `-rw-r--r--` se leen así:

| Parte | Significado |
|---|---|
| `-` | Es un archivo normal, no una carpeta. |
| `rw-` | El propietario puede leer (`r`) y escribir (`w`), pero no ejecutar (`-`). |
| `r--` | El grupo solo puede leer (`r`). |
| `r--` | Los demás usuarios solo pueden leer (`r`). |

Para ver los permisos de una carpeta se usa `ls -ld`, con la
opción `-d` para que `ls` muestre la carpeta misma y no su
contenido:

```bash
ls -ld datos
```

Salida real:

```text
drwxr-xr-x 2 root root 120 Nov 10 15:49 datos
```

La primera letra es `d`: es una carpeta. Sus permisos son
`rwxr-xr-x`: el propietario puede leer, escribir y entrar en
ella (`rwx`), y el grupo y los demás usuarios pueden leer y
entrar (`r-x`), pero no escribir dentro de ella.

Para ver los permisos de todos los archivos de una carpeta:

```bash
ls -l datos/
```

Salida real:

```text
total 12
-rw-r--r-- 1 root root 150 Nov 10 15:49 lecturas.txt
-rw-r--r-- 1 root root 114 Nov 10 15:49 muestras.txt
-rw-r--r-- 1 root root 126 Nov 10 15:49 notas.txt
-rw-r--r-- 1 root root   0 Nov 10 15:49 registro.txt
```

Los cuatro archivos tienen los mismos permisos: el propietario
lee y escribe, y los demás solo leen. Esa es la combinación
habitual para un archivo de datos.

## 2. Qué significa cada permiso, en archivos y en carpetas

Los tres permisos significan algo distinto según se apliquen a
un archivo o a una carpeta:

| Permiso | En un archivo | En una carpeta |
|---|---|---|
| `r` (lectura) | Ver el contenido del archivo con `cat`, `less` o `head`. | Ver la lista de archivos de la carpeta con `ls`. |
| `w` (escritura) | Modificar el contenido del archivo. | Crear y borrar archivos dentro de la carpeta. |
| `x` (ejecución) | Correr el archivo como un programa, por ejemplo `./script.sh`. | Entrar a la carpeta con `cd` y usar las rutas de lo que hay dentro. |

Fíjate en el permiso `x` de una carpeta: sin él no se puede
entrar a la carpeta, aunque se pueda ver su lista. Pruébalo con
una carpeta de prueba:

```bash
mkdir carpeta-prueba
chmod a-x carpeta-prueba
ls carpeta-prueba
```

`ls` funciona y no muestra nada, porque la carpeta está vacía
y todavía tienes permiso de lectura. Pero entrar ya no se puede:

```bash
cd carpeta-prueba
```

Salida real:

```text
bash: cd: carpeta-prueba: Permission denied
```

El texto exacto del mensaje puede variar un poco según el
sistema, pero la idea es la misma: sin permiso de ejecución no
se entra a la carpeta. Devuelve el permiso y entra:

```bash
chmod a+x carpeta-prueba
cd carpeta-prueba
pwd
cd ..
```

La última línea, `cd ..`, te devuelve a `practica-batch`. La
carpeta de prueba queda vacía y se puede borrar al final de la
lección, con `rm -r carpeta-prueba`, como se vio en la lección 03.

El permiso `w` de una carpeta también merece atención: con `w`
se pueden crear y borrar archivos dentro de la carpeta, incluso
archivos de otros usuarios. Por eso, una carpeta compartida en la
que todos pueden escribir es un lugar donde cualquiera puede
borrar el trabajo de los demás, y conviene pensar antes de
dar ese permiso.

## 3. Cambiar permisos con `chmod`: la forma simbólica

`chmod` cambia los permisos de un archivo o una carpeta. Su
nombre viene de *change mode*, "cambiar el modo" en inglés. La
forma simbólica se escribe así:

```text
chmod [quién][+,-,=][permiso] archivo
```

- **Quién**: `u` es el propietario (*user*), `g` es el grupo,
  `o` son los demás usuarios (*others*) y `a` son todos a la vez
  (*all*).
- **Acción**: `+` añade el permiso, `-` lo quita y `=` deja
  exactamente los permisos indicados.
- **Permiso**: `r`, `w` o `x`.

Primero mira los permisos actuales de `muestras.txt`:

```bash
ls -l datos/muestras.txt
```

Salida real:

```text
-rw-r--r-- 1 root root 114 Nov 10 15:49 datos/muestras.txt
```

### Añadir un permiso con `+`

Da permiso de escritura al grupo, para que los compañeros del
laboratorio puedan corregir el archivo de muestras:

```bash
chmod g+w datos/muestras.txt
ls -l datos/muestras.txt
```

Salida real:

```text
-rw-rw-r-- 1 root root 114 Nov 10 15:49 datos/muestras.txt
```

El grupo ahora tiene `rw-` en lugar de `r--`. Quita ese permiso
de nuevo:

```bash
chmod g-w datos/muestras.txt
ls -l datos/muestras.txt
```

Salida real:

```text
-rw-r--r-- 1 root root 114 Nov 10 15:49 datos/muestras.txt
```

El archivo vuelve a quedar como estaba.

### Quitar un permiso con `-`

Quita el permiso de lectura a los demás usuarios en el archivo
de notas, para que solo tú y tu grupo puedan leerlo:

```bash
chmod o-r datos/notas.txt
ls -l datos/notas.txt
```

Salida real:

```text
-rw-r----- 1 root root 126 Nov 10 15:49 notas.txt
```

Los demás usuarios ya no tienen ningún permiso sobre ese
archivo. Devuélvelo:

```bash
chmod o+r datos/notas.txt
ls -l datos/notas.txt
```

Salida real:

```text
-rw-r--r-- 1 root root 126 Nov 10 15:49 notas.txt
```

### Añadir y quitar el permiso de ejecución

El permiso de ejecución se maneja igual que los demás. Para el
script de la sección 5, quitarlo y devolverlo se ve así:

```bash
chmod u-x scripts/analisis.sh
ls -l scripts/analisis.sh
```

Salida real:

```text
-rw-r-xr-x 1 root root 119 Nov 10 15:49 scripts/analisis.sh
```

El propietario ya no tiene `x`, así que el archivo ya no se
puede ejecutar directamente. Devuelve el permiso:

```bash
chmod u+x scripts/analisis.sh
ls -l scripts/analisis.sh
```

Salida real:

```text
-rwxr-xr-x 1 root root 119 Nov 10 15:49 scripts/analisis.sh
```

Con `a` se cambia el permiso para todos a la vez. Por ejemplo,
quitar la ejecución a todos:

```bash
chmod a-x scripts/analisis.sh
ls -l scripts/analisis.sh
```

Salida real:

```text
-rw-r--r-- 1 root root 119 Nov 10 15:49 scripts/analisis.sh
```

Y devolverla solo al propietario, que es lo habitual para un
script propio:

```bash
chmod u+x scripts/analisis.sh
ls -l scripts/analisis.sh
```

Salida real:

```text
-rwxr-xr-x 1 root root 119 Nov 10 15:49 scripts/analisis.sh
```

### Fijar los permisos exactos con `=`

Con `=` se fijan los permisos exactos, sin importar los que
había antes. Por ejemplo, dejar `muestras.txt` con lectura y
escritura para el propietario, solo lectura para el grupo y nada
para los demás:

```bash
chmod u=rw,g=r,o= datos/muestras.txt
ls -l datos/muestras.txt
```

Salida real:

```text
-rw-r----- 1 root root 114 Nov 10 15:53 datos/muestras.txt
```

Y volver a los permisos habituales:

```bash
chmod u=rw,g=r,o=r datos/muestras.txt
ls -l datos/muestras.txt
```

Salida real:

```text
-rw-r--r-- 1 root root 114 Nov 10 15:53 datos/muestras.txt
```

Se pueden combinar varias partes en un solo comando, separadas
por comas. Por ejemplo, para una carpeta de scripts, dar todos
los permisos al propietario y lectura y ejecución al grupo y a
los demás:

```bash
chmod u=rwx,go=rx scripts
ls -ld scripts
```

Salida real:

```text
drwxr-xr-x 2 root root 40 Nov 10 15:53 scripts
```

## 4. Cambiar permisos con `chmod`: la forma numérica

Cada permiso tiene un valor numérico: lectura vale 4,
escritura vale 2 y ejecución vale 1. El permiso de cada grupo
es la suma de sus valores. Por ejemplo, `rw-` es 4 + 2 = 6, y
`r-x` es 4 + 1 = 5.

La forma numérica escribe tres dígitos seguidos: el primero es
el permiso del propietario, el segundo el del grupo y el tercero
el de los demás usuarios. Las combinaciones más usadas son:

| Número | Permisos | Significado |
|---|---|---|
| `777` | `rwxrwxrwx` | Todos pueden hacer todo. Se usa poco, porque es lo más abierto que hay. |
| `755` | `rwxr-xr-x` | El propietario hace todo; los demás leen y ejecutan, pero no escriben. Es lo habitual para carpetas y para scripts. |
| `700` | `rwx------` | Solo el propietario puede hacer algo. Es lo habitual para una carpeta privada. |
| `644` | `rw-r--r--` | El propietario lee y escribe; los demás solo leen. Es lo habitual para archivos de datos. |
| `640` | `rw-r-----` | El propietario lee y escribe, el grupo solo lee y los demás no tienen nada. |
| `600` | `rw-------` | Solo el propietario lee y escribe. Es lo habitual para un archivo privado. |
| `000` | `---------` | Nadie puede hacer nada, ni siquiera leerlo. |

### Proteger un archivo privado con `chmod 600`

Crea un archivo de notas privadas y protégelo, para que solo
tú puedas leerlo y escribir en él:

```bash
touch notas-privadas.txt
chmod 600 notas-privadas.txt
ls -l notas-privadas.txt
```

Salida real:

```text
-rw------- 1 root root 0 Nov 10 15:49 notas-privadas.txt
```

### Compartir con el grupo, pero no con los demás, con `chmod 640`

El archivo de notas del experimento se comparte con el grupo,
pero no con los demás usuarios:

```bash
chmod 640 datos/notas.txt
ls -l datos/notas.txt
```

Salida real:

```text
-rw-r----- 1 root root 126 Nov 10 15:49 datos/notas.txt
```

Devuelve el archivo a los permisos habituales:

```bash
chmod 644 datos/notas.txt
```

### Cerrar una carpeta con `chmod 700`

La carpeta `scripts` solo la usas tú. Con `700`, solo el
propietario puede entrar, listar y escribir dentro de ella:

```bash
chmod 700 scripts
ls -ld scripts
```

Salida real:

```text
drwx------ 2 root root 60 Nov 10 15:49 scripts
```

Y para volver a los permisos habituales de una carpeta:

```bash
chmod 755 scripts
ls -ld scripts
```

Salida real:

```text
drwxr-xr-x 2 root root 60 Nov 10 15:49 scripts
```

### Ver el permiso en número con `stat`

`stat` muestra el permiso de un archivo como número, que es
útil para comprobar el resultado de un `chmod` numérico sin
tener que traducir las letras. En Linux se usa así:

```bash
stat -c %a datos/muestras.txt
stat -c %a scripts
```

Salida real:

```text
644
755
```

En Mac, el comando equivalente es `stat -f %Lp archivo`: da el
mismo número, pero la opción se escribe distinto.

### Cambiar los permisos de una carpeta y todo lo que hay dentro

La opción `-R` (de *recursive*, "recursivo") aplica el cambio a
una carpeta y a todo lo que hay dentro de ella, carpeta por
carpeta:

```bash
mkdir carpeta-r
touch carpeta-r/a.txt carpeta-r/b.txt
chmod -R 700 carpeta-r
ls -ld carpeta-r
ls -l carpeta-r
```

Salida real:

```text
drwx------ 3 root root 100 Nov 10 15:53 carpeta-r
total 0
-rwx------ 1 root root  0 Nov 10 15:53 a.txt
-rwx------ 1 root root  0 Nov 10 15:53 b.txt
```

Fíjate en un detalle: los archivos `a.txt` y `b.txt` quedaron
con `rwx`, es decir, también recibieron permiso de ejecución,
porque el `700` se aplicó igual a carpetas y a archivos. Para
archivos de datos, eso no es lo que se quiere: un archivo de
datos no necesita permiso de ejecución. Por eso, `chmod -R` se
usa con cuidado y, cuando se quieren permisos distintos para
carpetas y para archivos, se hacen dos comandos separados.

Borra la carpeta de prueba:

```bash
rm -r carpeta-r
```

## 5. El permiso de ejecución y los scripts

Un script es un archivo de texto con comandos. Para correrlo
directamente, como `./script.sh`, necesita permiso de ejecución.
Sin ese permiso, la shell se niega a correrlo.

Crea el script `scripts/analisis.sh`, que cuenta las líneas del
archivo de muestras. Al crearlo con `cat`, el archivo nace sin
permiso de ejecución, como cualquier archivo de texto:

```bash
cat > scripts/analisis.sh << 'EOF'
#!/bin/bash
# Cuenta las lineas del archivo datos/muestras.txt
echo "Lineas en muestras.txt:"
wc -l datos/muestras.txt
EOF
ls -l scripts/analisis.sh
```

Salida real:

```text
-rw-r--r-- 1 root root 119 Nov 10 15:49 scripts/analisis.sh
```

El archivo tiene `rw-r--r--`: nadie tiene permiso de
ejecución. Intenta correrlo directamente:

```bash
./scripts/analisis.sh
```

Salida real:

```text
bash: ./scripts/analisis.sh: Permission denied
```

El texto exacto del mensaje puede variar un poco según el
sistema. El comando termina con código 126, que significa que
el archivo existe pero no se puede ejecutar. Compruébalo:

```bash
echo $?
```

Salida real:

```text
126
```

`$?` guarda el código de salida del último comando. Un código
distinto de cero significa que algo salió mal; en este caso, el
126 indica que el archivo no tenía permiso de ejecución.

Da el permiso de ejecución con `chmod +x` y vuelve a
intentarlo:

```bash
chmod +x scripts/analisis.sh
ls -l scripts/analisis.sh
./scripts/analisis.sh
```

Salida real:

```text
-rwxr-xr-x 1 root root 119 Nov 10 15:49 scripts/analisis.sh
Lineas en muestras.txt:
6 datos/muestras.txt
```

Ahora el archivo tiene `rwxr-xr-x` y se ejecuta. El `6` es el
número de líneas de `muestras.txt`: el encabezado más las 5
muestras.

Hay otra forma de correr un script, sin darle permiso de
ejecución: pasárselo a `bash`, como se explicó en el README:

```bash
bash scripts/analisis.sh
```

Salida real:

```text
Lineas en muestras.txt:
6 datos/muestras.txt
```

Con `bash`, es la shell la que lee el archivo y ejecuta sus
comandos, así que no hace falta el permiso de ejecución. Con
`./`, es el sistema el que ejecuta el archivo directamente, y
para eso sí hace falta el permiso. Por eso, cuando se comparte
un script con otras personas, se le da permiso de ejecución con
`chmod +x` para que lo puedan correr como `./script.sh`.

## 6. Cerrar un archivo por completo con `chmod 000`

`chmod 000` quita todos los permisos: nadie puede leer, escribir
ni ejecutar el archivo. Ni siquiera el propietario puede leerlo
mientras tenga ese permiso:

```bash
chmod 000 datos/muestras.txt
ls -l datos/muestras.txt
cat datos/muestras.txt
```

Salida real:

```text
---------- 1 root root 114 Nov 10 15:49 datos/muestras.txt
cat: datos/muestras.txt: Permission denied
```

El texto exacto del mensaje puede variar un poco según el
sistema. Como el archivo sigue siendo tuyo, siempre puedes
devolverle los permisos con `chmod`, aunque no puedas leerlo:

```bash
chmod 644 datos/muestras.txt
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

El archivo vuelve a leerse. `chmod 000` sirve para cerrar un
archivo por un rato, por ejemplo mientras se decide con quién
compartirlo, pero no es una forma de borrarlo ni de protegerlo
de alguien que tenga permisos de administrador.

## 7. Cambiar el propietario y el grupo: `chown` y `chgrp`

`ls -l` muestra dos nombres por archivo: el propietario y el
grupo. En los ejemplos de esta lección, los dos son `root`,
porque así está configurada la computadora donde se preparó;
en tu computadora verás tu propio nombre de usuario y tu
propio grupo.

### Cambiar el grupo con `chgrp`

`chgrp` cambia el grupo de un archivo. Su nombre viene de
*change group*, "cambiar el grupo" en inglés. Solo se puede
cambiar al grupo al que se pertenece: no se puede poner un
archivo en un grupo del que no se forma parte.

Para saber a qué grupo perteneces, usa `id -gn`:

```bash
id -gn
```

Salida real:

```text
root
```

En tu computadora verás tu propio grupo, por ejemplo `staff` en
Mac. Cambiar el grupo de un archivo a tu propio grupo siempre
funciona:

```bash
chgrp "$(id -gn)" datos/muestras.txt
ls -l datos/muestras.txt
```

Salida real:

```text
-rw-r--r-- 1 root root 114 Nov 10 15:49 datos/muestras.txt
```

El grupo no cambia en la salida porque ya era ese mismo grupo,
pero el comando terminó sin error: el código de salida fue 0.
En cambio, intentar poner el archivo en un grupo al que no
perteneces se rechaza:

```bash
chgrp root datos/muestras.txt
```

Salida real (para un usuario que no pertenece al grupo `root`):

```text
chgrp: changing group of 'datos/muestras.txt': Operation not permitted
```

El texto exacto del mensaje puede variar un poco según el
sistema. En un laboratorio, el grupo sirve para compartir: si
los archivos de un experimento pertenecen al grupo del
laboratorio y tienen permiso de lectura para el grupo, todos
los integrantes pueden leerlos, y los demás usuarios no.

### Cambiar el propietario con `chown`

`chown` cambia el propietario de un archivo. Su nombre viene de
*change owner*, "cambiar el propietario" en inglés. Cambiar el
propietario es una acción de administrador: un usuario normal no
puede darle sus archivos a otra persona. Si lo intentas, el
sistema se niega:

```bash
chown otro-usuario datos/muestras.txt
```

Salida real:

```text
chown: changing ownership of 'datos/muestras.txt': Operation not permitted
```

El texto exacto del mensaje puede variar un poco según el
sistema. Con permisos de administrador, el cambio se hace con
`sudo`:

```bash
sudo chown otro-usuario datos/muestras.txt
```

Como se advierte en el README, `sudo` ejecuta un comando con
permisos de administrador y solo se usa cuando se sabe qué hace
el comando. En la práctica de este curso no hace falta cambiar
el propietario de ningún archivo: el propietario de tus archivos
eres tú, y lo que se comparte con otras personas es el grupo y
los permisos, no la propiedad.

## 8. El `umask`: con qué permisos nacen los archivos nuevos

Cada vez que se crea un archivo o una carpeta, la shell le da
unos permisos iniciales. Esos permisos no se eligen archivo por
archivo: los decide el `umask`, un ajuste de la shell que quita
permisos a los valores máximos.

Los valores máximos son `666` para archivos (`rw-rw-rw-`, leer
y escribir para todos, sin ejecución) y `777` para carpetas
(`rwxrwxrwx`, todo para todos). El `umask` resta permisos de
esos máximos. Con el `umask` habitual, `022`, la resta es:

- Archivo nuevo: `666` menos `022` = `644` (`rw-r--r--`).
- Carpeta nueva: `777` menos `022` = `755` (`rwxr-xr-x`).

Compruébalo. Primero mira tu `umask`:

```bash
umask
```

Salida real:

```text
0022
```

Crea un archivo y una carpeta nuevos y mira sus permisos:

```bash
touch archivo-umask-022.txt
ls -l archivo-umask-022.txt
mkdir carpeta-umask-022
ls -ld carpeta-umask-022
```

Salida real:

```text
-rw-r--r-- 1 root root 0 Nov 10 15:49 archivo-umask-022.txt
drwxr-xr-x 2 root root 40 Nov 10 15:49 carpeta-umask-022
```

El archivo nació con `644` y la carpeta con `755`, como dice la
resta. Ahora cambia el `umask` a `077`, que es más cerrado, y
crea otro archivo y otra carpeta:

```bash
umask 077
touch archivo-umask-077.txt
ls -l archivo-umask-077.txt
mkdir carpeta-umask-077
ls -ld carpeta-umask-077
```

Salida real:

```text
-rw------- 1 root root 0 Nov 10 15:49 archivo-umask-077.txt
drwx------ 2 root root 40 Nov 10 15:49 carpeta-umask-077
```

Con `077`, la resta es `666` menos `077` = `600` para el
archivo y `777` menos `077` = `700` para la carpeta: solo el
propietario puede hacer algo con ellos. Es el ajuste adecuado
cuando se trabaja con datos que no se quieren compartir por
accidente.

Devuelve el `umask` a su valor habitual:

```bash
umask 022
```

Dos cosas conviene recordar sobre el `umask`:

- Cambiar el `umask` no cambia los permisos de los archivos que
  ya existen. Solo afecta a los archivos y carpetas que se creen
  después del cambio.
- El cambio dura solo en la terminal actual. Al cerrar la
  terminal y abrir otra, el `umask` vuelve a su valor inicial.
  Para que un valor se cargue siempre, se guarda en el archivo
  de configuración de la shell, `.bashrc` o `.zshrc`, que se
  explica en la lección 07.

## 9. El script `practica-permisos.sh`

El archivo `practica-permisos.sh`, que acompaña a esta lección,
reúne todo lo aprendido en un solo script: crea la estructura
de carpetas, genera los archivos de ejemplo con datos del
experimento con Chlorella vulgaris, crea el script
`scripts/analisis.sh`, le da permiso de ejecución con
`chmod +x`, lo ejecuta, protege un archivo privado con
`chmod 600`, comparte las notas con el grupo con `chmod 640` y
muestra los permisos de todo lo creado.

Para ejecutarlo, entra a la carpeta donde guardaste el script y
ejecútalo con `bash` (el script entra solo a tu carpeta de
usuario, así que funciona sin importar desde dónde lo llames):

```bash
bash practica-permisos.sh
```

El script solo trabaja dentro de la carpeta de práctica de tu
carpeta de usuario, `~/practica-batch`, la misma de esta
lección. No toca ningún otro archivo de la computadora. Además,
se puede ejecutar dos veces seguidas: vuelve a generar sus
archivos de ejemplo sin borrar el trabajo que tú hayas guardado
dentro de `practica-batch`.

Salida real de `bash practica-permisos.sh`:

```text
Permisos de analisis.sh al crearlo:
-rw-r--r-- 1 root root 119 Nov 10 15:52 practica-batch/scripts/analisis.sh
Permisos de analisis.sh despues de chmod +x:
-rwxr-xr-x 1 root root 119 Nov 10 15:52 practica-batch/scripts/analisis.sh
Lineas en muestras.txt:
6 datos/muestras.txt
Permisos de notas-privadas.txt:
-rw------- 1 root root 49 Nov 10 15:52 notas-privadas.txt
Permisos de datos/notas.txt:
-rw-r----- 1 root root 126 Nov 10 15:52 datos/notas.txt
Umask actual:
0022
Permisos de archivo-nuevo.txt:
-rw-r--r-- 1 root root 0 Nov 10 15:52 archivo-nuevo.txt
Contenido de practica-batch:
total 4
-rw-r--r-- 1 root root   0 Nov 10 15:52 archivo-nuevo.txt
drwxr-xr-x 2 root root 120 Nov 10 15:52 datos
-rw------- 1 root root  49 Nov 10 15:52 notas-privadas.txt
drwxr-xr-x 3 root root  80 Nov 10 15:52 resultados
drwxr-xr-x 2 root root  60 Nov 10 15:52 scripts
Contenido de practica-batch/datos:
total 12
-rw-r--r-- 1 root root 150 Nov 10 15:52 lecturas.txt
-rw-r--r-- 1 root root 114 Nov 10 15:52 muestras.txt
-rw-r----- 1 root root 126 Nov 10 15:52 notas.txt
-rw-r--r-- 1 root root   0 Nov 10 15:52 registro.txt
Contenido de practica-batch/scripts:
total 4
-rwxr-xr-x 1 root root 119 Nov 10 15:52 analisis.sh
```

El script también funciona con `sh`:

```bash
sh practica-permisos.sh
```

La salida es idéntica con `bash` y con `sh`, y es idéntica cada
vez que se ejecuta. Eso se comprobó ejecutando el script varias
veces seguidas con los dos intérpretes.

Lee el script línea por línea y fíjate en los comentarios: cada
paso explica directamente lo que hace el comando que sigue.

## 10. Ejercicios

Haz estos ejercicios dentro de `practica-batch`, después de
haber ejecutado el script de la sección 9. Primero entra a la
carpeta de práctica:

```bash
cd ~/practica-batch
```

### Ejercicio 1: crear un archivo privado

Crea un archivo con una nota del experimento y protégelo para
que solo tú puedas leerlo y escribir en él. Comprueba el
resultado con `ls -l`:

```bash
echo "Resultados preliminares, no compartir." > notas-experimento.txt
chmod 600 notas-experimento.txt
ls -l notas-experimento.txt
```

Resultado esperado:

```text
-rw------- 1 root root 39 Nov 10 15:55 notas-experimento.txt
```

En tu computadora verás tu propio nombre de usuario en lugar
de `root`, tu propio grupo y tu propia fecha y hora. Lo
importante es que los permisos sean `-rw-------`.

### Ejercicio 2: quitar y devolver el permiso de ejecución

Quita el permiso de ejecución a `analisis.sh`, intenta correrlo
y comprueba que el sistema se niega. Después, devuelve el
permiso y corre el script de nuevo:

```bash
chmod a-x scripts/analisis.sh
./scripts/analisis.sh
echo $?
chmod +x scripts/analisis.sh
./scripts/analisis.sh
```

Resultado esperado:

```text
bash: ./scripts/analisis.sh: Permission denied
126
Lineas en muestras.txt:
6 datos/muestras.txt
```

El texto exacto del mensaje de error puede variar un poco según
el sistema. El código `126` confirma que el archivo no tenía
permiso de ejecución, y al devolverlo el script vuelve a correr
y a contar las 6 líneas.

### Ejercicio 3: cambiar el `umask` y ver cómo nacen los archivos

Cambia el `umask` a `077`, crea un archivo y mira con qué
permisos nace. Después, devuelve el `umask` a `022`, crea otro
archivo y compara:

```bash
umask 077
touch archivo-privado.txt
ls -l archivo-privado.txt
umask 022
touch archivo-normal.txt
ls -l archivo-normal.txt
```

Resultado esperado:

```text
-rw------- 1 root root 0 Nov 10 15:55 archivo-privado.txt
-rw-r--r-- 1 root root 0 Nov 10 15:55 archivo-normal.txt
```

El primer archivo nació con `600` y el segundo con `644`.
Recuerda que el cambio de `umask` dura solo en esta terminal:
al abrir otra terminal, el `umask` vuelve a ser `022`.

## Ayuda de los comandos

Cada comando trae su propia ayuda con la opción `--help`. Por
ejemplo, `chmod --help` muestra cómo se usa `chmod` y qué
opciones tiene. Sus primeras líneas son:

```text
Usage: chmod [OPTION]... MODE[,MODE]... FILE...
  or:  chmod [OPTION]... OCTAL-MODE FILE...
```

El texto exacto de la ayuda puede variar un poco según el
sistema. En la computadora donde se preparó esta lección, el
comando `man` no está instalado, así que `--help` es la forma
de consultar la ayuda de cada comando.

## Qué aprendimos

- `ls -l` muestra los permisos de un archivo: el tipo, los
  permisos del propietario, los del grupo y los de los demás
  usuarios, además del propietario, el grupo, el tamaño y la
  fecha. `ls -ld` muestra los permisos de una carpeta.
- Los permisos son lectura (`r`), escritura (`w`) y ejecución
  (`x`). En un archivo, `x` permite correrlo como programa; en
  una carpeta, `x` permite entrar en ella, `r` permite listar
  su contenido y `w` permite crear y borrar archivos dentro.
- `chmod` cambia los permisos. En forma simbólica se escribe
  con quién (`u`, `g`, `o`, `a`), qué hacer (`+`, `-`, `=`) y
  qué permiso (`r`, `w`, `x`); por ejemplo, `chmod g+w` añade
  escritura al grupo y `chmod u=rw,g=r,o=` fija los permisos
  exactos. En forma numérica se escribe con tres dígitos, donde
  lectura vale 4, escritura 2 y ejecución 1; por ejemplo, `644`
  es lo habitual para archivos de datos, `755` para carpetas y
  scripts, `600` para un archivo privado y `700` para una
  carpeta privada.
- `stat -c %a archivo` muestra el permiso de un archivo como
  número en Linux; en Mac se usa `stat -f %Lp archivo`.
- `chmod -R` cambia los permisos de una carpeta y de todo lo
  que hay dentro, y se usa con cuidado porque aplica el mismo
  permiso a carpetas y a archivos.
- Un script necesita permiso de ejecución para correrse como
  `./script.sh`. Sin ese permiso, la shell responde
  `Permission denied` y el comando termina con código 126.
  Con `bash script.sh` no hace falta el permiso, porque es la
  shell la que lee el archivo. `chmod +x` da el permiso de
  ejecución.
- `chmod 000` quita todos los permisos de un archivo. El
  propietario siempre puede devolverle los permisos con
  `chmod`, aunque no pueda leerlo.
- `chgrp` cambia el grupo de un archivo, solo a un grupo al que
  se pertenece. `chown` cambia el propietario y es una acción
  de administrador: un usuario normal recibe
  `Operation not permitted` al intentarlo.
- El `umask` decide con qué permisos nacen los archivos y las
  carpetas nuevas. Con `022`, los archivos nacen con `644` y
  las carpetas con `755`; con `077`, nacen con `600` y `700`.
  Cambiar el `umask` no cambia los permisos de los archivos
  que ya existen y dura solo en la terminal actual.
- El script `practica-permisos.sh` reúne todo esto: crea la
  estructura, genera los archivos de ejemplo con datos del
  experimento con Chlorella vulgaris, crea `analisis.sh`, le da
  permiso de ejecución con `chmod +x`, lo ejecuta, protege un
  archivo privado con `chmod 600` y comparte las notas con el
  grupo con `chmod 640`.
