# Autor: Dr. José Juan Torres Martínez
# Docente de Ciencias Químicas
# Universidad Autónoma de San Luis Potosí (UASLP)
# México
#
# Material académico para estudiantes
# Repositorio batch-unix — Presentación y guía de uso (README)

# batch-unix

Clases de uso de la terminal y la shell de Unix, de inicio a intermedio, en español.

## Qué es este repositorio

Este repositorio reúne clases para aprender a trabajar con la terminal y la shell de Unix desde cero. "Batch" se usa aquí en el sentido de trabajo por lotes con la línea de comandos: escribir una serie de instrucciones en la terminal, o guardarlas en un script, para que la computadora las ejecute en orden, sin hacer clic en cada paso.

Cada lección explica un tema con definiciones, explicaciones y ejemplos. Los ejemplos se pueden seguir paso a paso en la propia terminal. El objetivo es que el alumno entienda qué hace cada comando antes de usarlo, y que pueda repetirlo después con sus propios datos.

El curso va de inicio a intermedio. Empieza por abrir la terminal y moverse entre carpetas, sigue por crear, copiar, mover y buscar archivos, y llega a escribir scripts, instalar herramientas de bioinformática con conda y programar tareas automáticas con cron.

### Para quién es

Para estudiantes de ciencias químicas, biología y bioinformática que quieren dejar de depender de la interfaz gráfica para manejar datos.

Es útil, por ejemplo, para quien necesita revisar muchos archivos de resultados, renombrar o mover archivos en lote, buscar una palabra dentro de varios archivos de texto, descargar datos de internet desde la terminal o repetir el mismo análisis sobre varias muestras sin hacerlo a mano una y otra vez.

No se necesita experiencia previa con la terminal. Se necesita una computadora con acceso a una shell Unix (ver la sección de requisitos) y disposición para practicar cada ejemplo escribiéndolo en la terminal.

## Requisitos por sistema operativo

La terminal y la shell no se instalan igual en todos los sistemas. La diferencia principal es esta: en Mac y en Linux ya vienen incluidas; en Windows hay que añadirlas, y hay que distinguir entre trabajar en la propia computadora y trabajar en otra computadora a través de internet.

### Mac

La Terminal ya viene instalada. Se encuentra como Terminal.app, en Aplicaciones y luego en Utilidades, o buscándola con Spotlight.

La shell por defecto es zsh. No hay que instalar nada para empezar el curso.

### Ubuntu y otras distribuciones Linux

La Terminal ya viene instalada. El nombre exacto de la aplicación varía según la distribución y el entorno de escritorio, y suele encontrarse como Terminal, Consola o con un nombre similar en el menú de aplicaciones.

La shell por defecto es bash. No hay que instalar nada para empezar el curso.

### Windows

En Windows hay tres herramientas distintas y no hacen lo mismo. Conviene distinguirlas antes de empezar.

**Termius es un cliente SSH.** Sirve para conectarse a una computadora remota que ya tiene Unix, por ejemplo un servidor de la universidad o de un laboratorio. Con Termius se escribe en la terminal de esa otra máquina y los archivos que se crean o se modifican están en esa otra máquina.

Termius NO es una shell local. No da una terminal Unix dentro de Windows ni instala Unix en la propia computadora.

**Git Bash es una terminal con herramientas Unix que viene con Git para Windows.** Se instala en la propia computadora y da una shell Unix local, con comandos como `ls`, `cd`, `cp`, `grep` y `bash`. Con Git Bash se trabaja en la propia computadora, sobre los archivos que están en ella.

**WSL es el Subsistema de Windows para Linux.** Instala un sistema Linux, por ejemplo Ubuntu, dentro de Windows. Con WSL se trabaja también en la propia computadora, dentro de ese sistema Linux, con su propia terminal y su propia shell bash.

La diferencia, en una frase: con Termius se trabaja en otra máquina; con Git Bash o con WSL se trabaja en la propia computadora.

Para seguir este curso en Windows se recomienda Git Bash o WSL, porque las lecciones se practican sobre los archivos de la propia computadora. Termius se usa cuando el trabajo está en un servidor remoto, y en ese caso las lecciones se aplican igual, pero sobre los archivos de ese servidor.

El procedimiento exacto para instalar Git Bash o WSL depende de la versión de Windows que tenga cada alumno y de los permisos de su computadora, por lo que no se describe aquí paso a paso. La documentación oficial de Git para Windows y la documentación oficial de Microsoft para WSL indican el procedimiento vigente para cada versión.

## Cómo usar las lecciones

### Orden recomendado

Las lecciones se siguen en orden, de la 01 a la 14, porque cada una usa lo aprendido en las anteriores. La ruta completa, lección por lección, está en [ROADMAP.md](ROADMAP.md).

### Organización de cada lección

Cada lección está en su propia carpeta dentro de `lecciones/`, por ejemplo `lecciones/01-la-terminal-y-la-shell/`. Dentro de cada carpeta hay:

- Un archivo `.md` con la lección: definiciones, explicaciones y ejemplos.
- Los scripts `.sh` de ejemplo que usa esa lección, cuando los hay.

El nombre de la carpeta indica el número y el tema de la lección, para encontrarla sin abrir el resto.

### Cómo ejecutar un script

Hay dos formas de ejecutar un script `.sh`. Las dos hacen lo mismo; la segunda deja el archivo listo para ejecutarlo directamente las veces que se quiera.

Con `bash`, sin cambiar permisos:

```bash
bash nombre-del-script.sh
```

Dándole permiso de ejecución y corriéndolo directamente:

```bash
chmod +x nombre-del-script.sh
./nombre-del-script.sh
```

El punto y la barra de `./nombre-del-script.sh` indican que el script está en la carpeta actual. Sin ellos, la shell busca el comando en las carpetas del `$PATH` y no lo encuentra.

Si el script necesita datos de entrada, la lección indica cuáles son y en qué formato. Los argumentos se pasan después del nombre del script, separados por espacios:

```bash
bash nombre-del-script.sh primer-argumento segundo-argumento
```

Dentro del script, el primer argumento se lee como `$1` y el segundo como `$2`. Esto se explica en la lección 08.

### La carpeta de práctica

En la lección 03 se crea la carpeta de práctica `~/practica-batch`, en la carpeta personal del usuario. Esa carpeta se usa en todo el curso: allí se crean los archivos de ejemplo, se practican los comandos de copiar y mover, y se guardan los scripts de las lecciones siguientes.

Si la carpeta se borra por accidente, se vuelve a crear con:

```bash
mkdir -p ~/practica-batch
```

Y se entra en ella con:

```bash
cd ~/practica-batch
```

### Cómo practicar

Cada ejemplo está pensado para escribirse en la terminal, no para copiarse y pegarse. Escribir el comando obliga a leerlo completo, y leerlo completo es lo que permite notar un error de escritura o un argumento cambiado antes de pulsar Enter.

Después de ejecutar un ejemplo, conviene comprobar el resultado con `ls` o con `cat`, según el caso, y comparar lo que muestra la terminal con lo que dice la lección. Si el resultado no coincide, se revisa el comando escrito antes de seguir adelante.

## Resumen de la ruta y cadencia

La ruta completa tiene 14 lecciones, de principiante a intermedio:

1. La terminal y la shell
2. Navegar por el sistema
3. Archivos y carpetas
4. Permisos
5. Buscar y filtrar
6. Redirecciones y archivos de registro
7. Variables y entorno
8. Primer script `.sh`
9. Bucles y condicionales
10. Procesar archivos de datos con `awk` y `cut`
11. Descargar y descomprimir datos
12. Conda: instalar Miniconda y crear ambientes
13. Conda para bioinformática
14. Automatizar con cron y crontab

El detalle de cada lección, qué enseña, qué sabrá hacer el alumno al terminarla y qué requisitos previos tiene cada bloque está en [ROADMAP.md](ROADMAP.md).

Se publica una lección nueva cada dos días. Las lecciones 01, 02 y 03 están listas; las demás están en preparación.

## Advertencias básicas de seguridad

Antes de practicar, conviene tener presentes tres reglas.

**`rm` no tiene papelera.** Cuando se borra un archivo o una carpeta con `rm`, no pasa a la papelera ni se puede recuperar desde la interfaz gráfica. Se borra de forma definitiva. Por eso, antes de pulsar Enter con un `rm`, se revisa el nombre del archivo o de la carpeta y, si se usa un comodín como `*`, se revisa primero con `ls` qué archivos coinciden con ese comodín.

**No ejecutar comandos que no se entiendan.** Si un comando aparece en internet o lo comparte otra persona y no se entiende qué hace cada parte, no se ejecuta. Se busca primero qué hace cada comando y cada opción, o se pregunta. Esto vale en especial para comandos largos que combinan varias partes con `|`, `;` o `&&`, y para cualquier comando que incluya `rm`.

**No usar `sudo` sin saber qué hace.** `sudo` ejecuta un comando con permisos de administrador. Con esos permisos, un error de escritura puede modificar o borrar archivos del sistema. `sudo` solo se usa cuando la lección lo indica de forma explícita y explica para qué, y nunca para ejecutar un comando que no se entiende.

La práctica de este curso se hace siempre dentro de `~/practica-batch` o en copias de los archivos, nunca sobre archivos originales sin copia de respaldo.
