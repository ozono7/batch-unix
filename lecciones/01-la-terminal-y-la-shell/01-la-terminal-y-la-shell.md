# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Lección 01: La terminal y la shell

# La terminal y la shell

En esta lección vas a abrir la terminal por primera vez, vas a entender qué es
la terminal y qué es la shell, y vas a escribir tus primeros comandos. Al
terminar sabrás qué significa el texto que aparece antes de cada comando, cómo
saber la fecha, quién eres dentro del sistema y en qué carpeta estás, y cómo
pedir ayuda cuando no recuerdes cómo se usa un comando.

Todos los comandos de esta lección se ejecutaron y se verificaron en una
computadora con bash 5.2 antes de escribirlos aquí. Las salidas que se muestran
son salidas reales de esa sesión. Donde la salida depende de la computadora
(nombre de usuario, nombre de la computadora, fecha y hora, carpeta), en tu
computadora verás tus propios datos en lugar de los que se muestran aquí.

## 1. Qué es la terminal

La **terminal** es la ventana en la que escribes comandos con el teclado y en
la que la computadora te responde con texto. No tiene botones ni menús: todo se
hace escribiendo. También se le llama **consola** o **línea de comandos**.

Piensa en la terminal como una conversación escrita con la computadora: tú
escribes una orden en una línea, presionas la tecla Enter y la computadora
responde en las líneas siguientes.

En la terminal no se usa el ratón para trabajar: se escribe. Esto parece más
lento al principio, pero permite hacer tareas repetitivas con rapidez y con
precisión, por ejemplo procesar muchos archivos de datos de un experimento con
una sola orden.

## 2. Qué es la shell

La **shell** es el programa que vive dentro de la terminal y que interpreta
los comandos que escribes. Cuando escribes `date` y presionas Enter, es la
shell la que entiende esa palabra, busca el programa que muestra la fecha, lo
ejecuta y te muestra el resultado.

La diferencia es sencilla:

- La **terminal** es la ventana: lo que ves en la pantalla.
- La **shell** es el programa que interpreta lo que escribes dentro de esa
  ventana.

Una misma terminal puede usar distintas shells, igual que un mismo cuaderno
puede usarse para escribir en distintos idiomas. En este curso las dos shells
que te van a interesar son **bash** y **zsh**.

## 3. bash y zsh

**bash** (Bourne Again Shell) es una shell. Es la shell que viene por defecto
en la mayoría de las computadoras con Linux, por ejemplo en Ubuntu. Su nombre
viene de que es una versión mejorada de una shell anterior llamada Bourne
shell (`sh`).

**zsh** (Z shell) es otra shell. Es la shell que viene por defecto en las Mac
actuales. Es parecida a bash y entiende los mismos comandos básicos.

Qué shell usa cada sistema:

| Sistema | Shell por defecto |
|---------|-------------------|
| Mac (macOS) | zsh |
| Ubuntu (Linux) | bash |

En ambos sistemas se pueden usar las dos: en una Mac se puede usar bash y en
Ubuntu se puede usar zsh. Los comandos de este curso funcionan igual en bash
y en zsh, así que no necesitas cambiar nada: usa la shell que ya trae tu
computadora.

Para saber qué shell estás usando, escribe:

```bash
echo $SHELL
```

`$SHELL` es una **variable**: un nombre que guarda un valor. En este caso
guarda la ruta del programa de tu shell. La salida real en la sesión de
verificación de esta lección fue:

```text
/bin/bash
```

`/bin/bash` es la ruta del programa bash dentro del sistema. En una Mac, la
salida sería `/bin/zsh`, porque ahí la shell por defecto es zsh.

Para saber la versión de bash, escribe:

```bash
echo $BASH_VERSION
```

La salida real fue:

```text
5.2.21(1)-release
```

Y para saber la versión de zsh, escribe:

```bash
zsh --version
```

La salida real en la sesión de verificación fue:

```text
zsh 5.9 (x86_64-ubuntu-linux-gnu)
```

## 4. Cómo abrir la terminal

### En Mac

1. Presiona `Cmd + Espacio` para abrir Spotlight. **Spotlight** es el
   buscador de la Mac: escribes el nombre de lo que buscas y te lo muestra.
2. Escribe `Terminal`.
3. Presiona Enter. Se abre la aplicación **Terminal.app**, que es la terminal
   que viene con la Mac.

También puedes abrirla desde el **Launchpad**: el Launchpad es la pantalla
que muestra todas las aplicaciones instaladas, y ahí buscas Terminal.

En Mac la shell por defecto es **zsh**. El símbolo del prompt es `%` (se
explica en la siguiente sección).

### En Ubuntu

1. Presiona `Ctrl + Alt + T`. Es el atajo de teclado que abre la terminal.
2. Si el atajo no funciona, abre el menú de aplicaciones y busca `Terminal`.

En Ubuntu la shell por defecto es **bash**. El símbolo del prompt es `$`.

## 5. El prompt

El **prompt** es el texto que la shell muestra antes de cada comando, para
indicarte que está lista y esperando que escribas. La palabra prompt significa
"indicador": te indica que puedes escribir.

Un prompt típico en bash tiene esta forma:

```text
usuario@computadora:carpeta$
```

Cada parte significa algo:

- **usuario**: tu nombre de usuario dentro del sistema. Es el nombre con el
  que inicias sesión.
- **@**: separa el usuario del nombre de la computadora.
- **computadora**: el nombre de la computadora (se llama **nombre de host**).
- **:** (dos puntos): separa el nombre de la computadora de la carpeta.
- **carpeta**: la carpeta en la que estás trabajando en ese momento. Se llama
  **carpeta actual** o **directorio de trabajo**.
- **$**: el símbolo que marca el final del prompt en bash. En zsh el símbolo
  es **`%`** en lugar de `$`.

Con los datos reales de la sesión de verificación de esta lección (usuario
`root`, computadora `htch-runtime`, carpeta
`/tmp/batch-unix-scratch/leccion01`), el prompt se vería así:

```text
root@htch-runtime:/tmp/batch-unix-scratch/leccion01$
```

En tu computadora verás tu propio nombre de usuario, el nombre de tu
computadora y tu carpeta actual. El símbolo `$` al final te dice que la shell
está esperando: escribes el comando justo después de ese símbolo y presionas
Enter.

Cuando la carpeta actual es tu carpeta de usuario, el prompt la muestra con el
símbolo `~`. El símbolo `~` significa "mi carpeta de usuario" (se llama
**carpeta home**). Por ejemplo, `juan@mac:~$` significa: usuario `juan`, en su
carpeta home.

## 6. Primeros comandos

Un **comando** es una palabra (a veces acompañada de opciones) que le ordena
a la shell hacer algo. Se escribe después del prompt y se ejecuta al presionar
Enter. Cada comando que escribas en esta sección ejecútalo tú también en tu
terminal, para comprobar que obtienes el mismo tipo de respuesta.

### echo: mostrar un texto

El comando `echo` muestra en la pantalla el texto que escribas después de él.
**echo** significa "repetir": la shell repite lo que le diste.

```bash
echo "Hola, soy estudiante de Ciencias Químicas"
```

Salida real:

```text
Hola, soy estudiante de Ciencias Químicas
```

Las comillas indican que todo lo que hay dentro es un solo texto. Prueba
también con un saludo corto:

```bash
echo "Hola, mundo"
```

Salida real:

```text
Hola, mundo
```

### date: mostrar la fecha y la hora

El comando `date` muestra la fecha y la hora actuales del sistema.

```bash
date
```

Salida real:

```text
Tue Nov 10 05:27:57 UTC 2026
```

La salida se lee así: `Tue` es el día de la semana (Tuesday, martes), `Nov`
es el mes (November, noviembre), `10` es el día del mes, `05:27:57` es la
hora (5 de la mañana, 27 minutos, 57 segundos), `UTC` es la zona horaria del
sistema y `2026` es el año.

En tu computadora la fecha y la hora serán las de tu momento actual, y si tu
sistema está en español verás los nombres del día y del mes en español (por
ejemplo `mar 10 nov 2026`). El formato cambia con el idioma del sistema, pero
el comando es el mismo.

### whoami: mostrar tu nombre de usuario

El comando `whoami` muestra tu nombre de usuario dentro del sistema. El
nombre viene de la pregunta en inglés "who am I?", que significa "¿quién
soy yo?".

```bash
whoami
```

Salida real en la sesión de verificación:

```text
root
```

En la sesión de verificación el usuario era `root`, que es el usuario
administrador de ese entorno de pruebas. En tu computadora verás tu propio
nombre de usuario, por ejemplo `juan`. El comando es el mismo y la idea es la
misma: te dice con qué usuario estás trabajando.

### pwd: mostrar en qué carpeta estás

El comando `pwd` muestra la ruta completa de la carpeta en la que estás
trabajando en ese momento. Las siglas `pwd` vienen de "print working
directory", que significa "muestra la carpeta de trabajo".

```bash
pwd
```

Salida real en la sesión de verificación:

```text
/tmp/batch-unix-scratch/leccion01
```

Esa fue la carpeta de pruebas usada para verificar los comandos de esta
lección. En tu computadora verás la ruta de tu carpeta actual, por ejemplo
`/home/juan` en Ubuntu o `/Users/juan` en Mac.

Los cuatro comandos juntos, ejecutados uno tras otro en la misma sesión, se
vieron así:

```bash
echo "Hola, soy estudiante de Ciencias Químicas"
date
whoami
pwd
```

```text
Hola, soy estudiante de Ciencias Químicas
Tue Nov 10 05:27:57 UTC 2026
root
/tmp/batch-unix-scratch/leccion01
```

## 7. Cómo pedir ayuda

Nadie recuerda de memoria todos los comandos ni todas sus opciones. La shell
trae tres formas de pedir ayuda, y las tres se usan dentro de la misma
terminal.

### `comando --help`: la ayuda rápida

La mayoría de los comandos aceptan la opción `--help`. Una **opción** es una
palabra que empieza con guiones y que se escribe después del comando para
cambiar su comportamiento o pedir información. Con `--help`, el comando
muestra una descripción corta y la lista de sus opciones.

```bash
ls --help
```

`ls` es el comando que lista (muestra) los archivos de una carpeta. Su ayuda
empieza así (fragmento real de la salida; la salida completa tiene 139 líneas):

```text
Usage: ls [OPTION]... [FILE]...
List information about the FILEs (the current directory by default).
Sort entries alphabetically if none of -cftuvSUX nor --sort is specified.

Mandatory arguments to long options are mandatory for short options too.
  -a, --all                  do not ignore entries starting with .
  -A, --almost-all           do not list implied . and ..
      --author               with -l, print the author of each file
  -b, --escape               print C-style escapes for nongraphic characters
      --block-size=SIZE      with -l, scale sizes by SIZE when printing them;
                             e.g., '--block-size=M'; see SIZE format below

  -B, --ignore-backups       do not list implied entries ending with ~
  -c                         with -lt: sort by, and show, ctime (time of last
                             change of file status information);
                             with -l: show ctime and sort by name;
                             otherwise: sort by ctime, newest first

  -C                         list entries by columns
      --color[=WHEN]         color the output WHEN; more info below
```

La primera línea, `Usage: ls [OPTION]... [FILE]...`, dice cómo se usa el
comando: `ls` seguido de opciones y de archivos. Las líneas siguientes
explican cada opción.

Otro ejemplo, con el comando `cp`, que copia archivos:

```bash
cp --help
```

Fragmento real de la salida (la salida completa tiene 94 líneas):

```text
Usage: cp [OPTION]... [-T] SOURCE DEST
  or:  cp [OPTION]... SOURCE... DIRECTORY
  or:  cp [OPTION]... -t DIRECTORY SOURCE...
Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY.

Mandatory arguments to long options are mandatory for short options too.
  -a, --archive                same as -dR --preserve=all
      --attributes-only        don't copy the file data, just the attributes
      --backup[=CONTROL]       make a backup of each existing destination file
  -b                           like --backup but does not accept an argument
      --copy-contents          copy contents of special files when recursive
  -d                           same as --no-dereference --preserve=links
      --debug                  explain how a file is copied.  Implies -v
  -f, --force                  if an existing destination file cannot be
                                 opened, remove it and try again (this option
                                 is ignored when the -n option is also used)
  -i, --interactive            prompt before overwrite (overrides a previous -n
                                  option)
```

La ayuda de `--help` está en inglés en la mayoría de los sistemas. No
necesitas entender cada línea: busca la opción que necesitas y lee su
descripción corta.

### `help`: la ayuda de los comandos internos

Algunos comandos no son programas externos, sino que forman parte de la
propia shell. Se llaman **comandos internos** (en inglés, *builtins*). `echo`,
`pwd` y `cd` son comandos internos de bash. Para saber si un comando es
interno, se usa `type`:

```bash
type echo pwd cd ls
```

Salida real:

```text
echo is a shell builtin
pwd is a shell builtin
cd is a shell builtin
ls is /usr/bin/ls
```

`echo is a shell builtin` significa "echo es un comando interno de la shell".
En cambio, `ls is /usr/bin/ls` significa que `ls` es un programa guardado en
la ruta `/usr/bin/ls`.

Para los comandos internos, la ayuda se pide con `help` seguido del nombre
del comando:

```bash
help echo
```

Salida real completa:

```text
echo: echo [-neE] [arg ...]
    Write arguments to the standard output.
    
    Display the ARGs, separated by a single space character and followed by a
    newline, on the standard output.
    
    Options:
      -n	do not append a newline
      -e	enable interpretation of the following backslash escapes
      -E	explicitly suppress interpretation of backslash escapes
    
    `echo' interprets the following backslash-escaped characters:
      \a	alert (bell)
      \b	backspace
      \c	suppress further output
      \e	escape character
      \E	escape character
      \f	form feed
      \n	new line
      \r	carriage return
      \t	horizontal tab
      \v	vertical tab
      \\	backslash
      \0nnn	the character whose ASCII code is NNN (octal).  NNN can be
        		0 to 3 octal digits
      \xHH	the eight-bit character whose value is HH (hexadecimal).  HH
        		can be one or two hex digits
      \uHHHH	the Unicode character whose value is the hexadecimal value HHHH.
        		HHHH can be one to four hex digits.
      \UHHHHHHHH the Unicode character whose value is the hexadecimal value
        		HHHHHHHH. HHHHHHHH can be one to eight hex digits.
    
    Exit Status:
    Returns success unless a write error occurs.
```

Si escribes `help` sin ningún nombre, bash muestra la lista de todos sus
comandos internos. La salida real empieza así (fragmento real):

```text
GNU bash, version 5.2.21(1)-release (x86_64-pc-linux-gnu)
These shell commands are defined internally.  Type `help' to see this list.
Type `help name' to find out more about the function `name'.
Use `info bash' to find out more about the shell in general.
Use `man -k' or `info' to find out more about commands not in this list.

A star (*) next to a name means that the command is disabled.

 job_spec [&]                            history [-c] [-d offset] [n] or hist>
 (( expression ))                        if COMMANDS; then COMMANDS; [ elif C>
 . filename [arguments]                  jobs [-lnprs] [jobspec ...] or jobs >
 :                                       kill [-s sigspec | -n signum | -sigs>
 [ arg... ]                              let arg [arg ...]
 [[ expression ]]                        local [option] name[=value] ...
 alias [-p] [name[=value] ... ]          logout [n]
```

`help` solo existe dentro de bash. En zsh, la ayuda de los comandos internos
se consulta de otra forma, pero `--help` funciona igual en ambas shells.

### `man`: el manual completo

El comando `man` abre el **manual** de un comando: un documento con su
descripción completa, sus opciones y ejemplos. La palabra `man` viene de
"manual". Se usa así:

```bash
man ls
```

Esto abre el manual del comando `ls` en un visor de texto. Dentro del
manual:

- Para salir, presiona la tecla `q` (de *quit*, salir).
- Para buscar una palabra dentro del manual, escribe `/` seguido de la palabra
  y presiona Enter. Por ejemplo, `/--all` busca la opción `--all`.
- Para avanzar una página, presiona la barra espaciadora.
- Para moverte con las flechas del teclado, usa `↑` y `↓`.

En Mac y en Ubuntu el comando `man` viene instalado de fábrica, así que
`man ls` funciona directamente. En el entorno de pruebas donde se verificaron
los comandos de esta lección, `man` no estaba instalado: al comprobarlo con
`command -v man` no se obtuvo ninguna ruta, lo que confirma que el programa
no estaba presente ahí. Por eso en esta lección no se muestra una salida de
`man ls`: la salida exacta la verás al probarlo en tu propia computadora, con
`man ls`, y será el manual completo de `ls` en tu sistema.

El comando `info` es otra forma de consultar documentación, parecida a `man`,
pero tampoco estaba instalado en el entorno de verificación (`command -v info`
no devolvió ninguna ruta). En Mac y en Ubuntu, `man` es la forma habitual de
consultar el manual.

Resumen de las tres formas de pedir ayuda:

| Forma | Para qué sirve | Ejemplo |
|-------|----------------|---------|
| `comando --help` | Ayuda rápida del comando | `ls --help` |
| `help comando` | Ayuda de comandos internos de bash | `help echo` |
| `man comando` | Manual completo del comando | `man ls` |

## 8. Salir de la terminal, limpiar la pantalla y cancelar

### Salir de la terminal

Para cerrar la sesión de la shell, escribe:

```bash
exit
```

La shell se cierra y la ventana de la terminal también se cierra (o queda
vacía, según el sistema). También puedes cerrar la ventana con el botón de
cerrar, igual que cualquier otra ventana.

### Limpiar la pantalla

Cuando la pantalla se llena de texto, el comando `clear` la limpia:

```bash
clear
```

`clear` no borra nada: solo deja la pantalla vacía y el prompt arriba, para
que puedas seguir trabajando con comodidad. El atajo de teclado `Ctrl + L`
hace lo mismo: mantén presionada la tecla `Ctrl` y presiona la tecla `L`.

### Cancelar un comando

Si escribes un comando y te arrepientes antes de que termine, o si un comando
tarda demasiado, presiona `Ctrl + C`: mantén presionada la tecla `Ctrl` y
presiona la tecla `C`. La shell cancela el comando y te devuelve el prompt
para que puedas escribir otro.

Estos atajos se escriben con el símbolo `+` entre las teclas, pero no se
presiona el símbolo `+`: `Ctrl + C` significa presionar `Ctrl` y `C` al mismo
tiempo.

## 9. Ejercicios

Haz estos ejercicios en tu terminal. Comprueba tu resultado con el resultado
esperado que se indica en cada uno.

**Ejercicio 1. Muestra la fecha y la hora.**

Escribe el comando que muestra la fecha y la hora actuales. Resultado
esperado: una línea con el día de la semana, el mes, el día, la hora y el año,
con tus datos actuales. Por ejemplo, en la sesión de verificación la salida
fue `Tue Nov 10 05:27:57 UTC 2026`; en tu computadora verás tu fecha y tu
hora.

**Ejercicio 2. Muestra tu nombre de usuario.**

Escribe el comando que muestra tu nombre de usuario dentro del sistema.
Resultado esperado: una sola línea con tu nombre de usuario. En la sesión de
verificación la salida fue `root`; en tu computadora verás tu propio nombre
de usuario.

**Ejercicio 3. Muestra en qué carpeta estás.**

Escribe el comando que muestra la ruta de tu carpeta actual. Resultado
esperado: una línea con la ruta completa de tu carpeta. En la sesión de
verificación la salida fue `/tmp/batch-unix-scratch/leccion01`; en tu
computadora verás tu carpeta actual, por ejemplo tu carpeta home.

## Qué aprendimos

- La **terminal** es la ventana donde se escriben comandos con el teclado.
- La **shell** es el programa dentro de la terminal que interpreta los
  comandos. La terminal es la ventana; la shell es quien entiende lo que
  escribes.
- **bash** es la shell por defecto en Ubuntu y **zsh** es la shell por
  defecto en Mac. Los comandos de este curso funcionan igual en las dos.
- El **prompt** es el texto que muestra la shell antes de cada comando. Indica
  el usuario, el nombre de la computadora, la carpeta actual y termina en `$`
  en bash o en `%` en zsh.
- `echo` muestra un texto en la pantalla, `date` muestra la fecha y la hora,
  `whoami` muestra tu nombre de usuario y `pwd` muestra la carpeta en la que
  estás.
- Para pedir ayuda: `comando --help` muestra la ayuda rápida,
  `help comando` muestra la ayuda de los comandos internos de bash y
  `man comando` abre el manual completo (se sale con `q` y se busca con `/`).
- Para cerrar la sesión se usa `exit`, para limpiar la pantalla se usa `clear`
  o `Ctrl + L`, y para cancelar un comando se usa `Ctrl + C`.

En la Lección 03 crearás tu carpeta de práctica, `~/practica-batch`, en tu
carpeta de usuario. Ahí guardarás los archivos y los ejercicios de las
lecciones siguientes.
