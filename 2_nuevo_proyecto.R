#para crear un PROYECTOD ESDE 0- OTRA OPCIÓN ES EMPEZAR DESDE GITHUB
# ==============================================================================
# SCRIPT 2: VINCULAR UN PROYECTO NUEVO A GITHUB (UNA VEZ POR PROYECTO)
# ==============================================================================
# REQUISITOS:
# - Estar dentro de un proyecto de RStudio (abrir el archivo .Rproj).
# - Haber completado el Script 1 en esta computadora.
#
# ¡Correr BLOQUE POR BLOQUE (Ctrl+Enter), no con "Source"!
# use_git() reinicia RStudio y corta la ejecución. Después del reinicio,
# retomar desde el PASO 3.
#
# Equivalencias con lo que ya conocemos de la terminal:
#   use_git_ignore()  ~  editar el .gitignore
#   use_git()         ~  git init  +  git add .  +  git commit -m "Initial commit"
#                        (pidiendo confirmación antes del commit)
#   use_github()      ~  crear el repo en GitHub (API)  +  git remote add origin
#                        +  git push -u origin main

# Cargar/instalar herramientas del proyecto
if(!require(pacman)) install.packages("pacman")

pacman::p_load(usethis, here, data.table, ggplot2)


# ------------------------------------------------------------------------------
# PASO 0: ¿DÓNDE ESTAMOS PARADAS?
# ------------------------------------------------------------------------------
# usethis escribe el .gitignore en la raíz del "proyecto activo". Esa
# carpeta tiene que ser la del proyecto nuevo (la que tiene el .Rproj).
# Estas dos rutas tienen que apuntar al mismo lugar (la barra / o \ puede
# variar, eso no importa; lo que importa es que sea la misma carpeta):
#### NUESTRA CARPETA ES DONDE ESTA NUESTRO R PROJECT??###

proj_get()
getwd()


# ------------------------------------------------------------------------------
# PASO 1: EL ESCUDO DE DATOS SENSIBLES (.gitignore)
# ------------------------------------------------------------------------------
### YO  O QUIERO QUE MI BASE DE DATOS SUBA A GITHUB### UN ARCHIVO DE GITIGNORE IGNORA LOS ARCHIVOS CONTENIDOS ALLI 
#BUENA PRÁCTICA CRÍTICA EN EPIDEMIOLOGÍA:
# Manejamos datos sensibles de pacientes (DEIS). Nunca deben subir a la nube.
# Creamos la regla de exclusión ANTES de encender Git para que las bases
# no queden guardadas en la historia del repositorio.
#
# Es seguro correr esto más de una vez: usethis no duplica líneas.

# file.remove(".gitignore") # Para mostrar cómo crearlo, QUE DEBE SER LO PRIMERO QUE SE DEBE CREAR

use_git_ignore(c(
  ".Renviron",        # Variables de entorno/credenciales locales
  ".Rproj.user/",     # Configuraciones personales de tu RStudio
  "datos/primarios/", # Carpeta de microdatos originales
  "*.csv",            # Archivos separados por comas
  "*.xlsx",           # Planillas de Excel
  "*.xls",
  "*.rds",            # Objetos de R (también pueden contener datos individuales)
  "*.RData",
  "*.dbf",            # Formatos habituales de bases de salud
  "*.sav",
  "*.dta",
  "*.parquet"
))

# Ojo: el .gitignore solo actúa sobre archivos que Git TODAVÍA NO sigue.
# Si un archivo ya fue commiteado alguna vez, agregarlo al .gitignore no
# alcanza (ver el bloque "SI YA SE COMMITEÓ" al final).


# ------------------------------------------------------------------------------
# PASO 2: ENCENDER GIT EN ESTE PROYECTO
# ------------------------------------------------------------------------------
# Le decimos a RStudio que esta carpeta se convierta en un repositorio Git.

use_git()
## COMMITEAR ES MANDAR A GIT?
# -> LA CONSOLA VA A PREGUNTAR: "There are N uncommitted files: ..."
#    Lean esa lista ANTES de contestar. Es la última barrera antes del commit.
#    - Tienen que aparecer: .gitignore, el .Rproj, sus scripts.
#    - NO tienen que aparecer: .Renviron, .csv, .xlsx, nada de datos/primarios.
#    Si aparece algo de eso, contesten "No", corrijan el PASO 1 y corran
#    use_git() de nuevo. Si la lista está bien, contesten "Yes".
#
# RStudio se va a reiniciar. Al volver, va a aparecer la pestaña "Git"
# arriba a la derecha.


# ------------------------------------------------------------------------------
# PASO 2b: VERIFICAR
# ------------------------------------------------------------------------------
# ¿Qué archivos está siguiendo Git? No debería estar .Renviron ni ninguna base.

system("git ls-files")


# ------------------------------------------------------------------------------
# PASO 3: CREAR EL REPOSITORIO EN GITHUB Y SUBIR EL PROYECTO
# ------------------------------------------------------------------------------
# ES UNA CARPETA, PUEDEN SER PUBLICAS O PRIVADOS. SI ES PUBLICO PUEDO ALOJAR UNA PAGINA WEB
#Como la computadora ya conoce el Token (gracias al Script 1), esto es
# automático.

use_github(private = FALSE)#PUBLICO

# ¿Por qué private = TRUE acá y no lo dejamos en el valor por defecto?
# use_github() crea el repositorio PÚBLICO si no le decimos lo contrario.
# Para practicar hoy, y para cualquier proyecto con datos propios de
# acceso restringido, arrancamos siempre en privado y lo hacemos público
# después, a propósito, si corresponde (GitHub -> Settings -> Danger Zone).
# (El trabajo final tiene su propio criterio sobre esto, que van a ver
# en la consigna: no siempre conviene dejarlo privado.)
#
# -> Si avisa de cambios sin commitear, revisen la lista antes de seguir.
# Se va a abrir el navegador mostrando el proyecto ya publicado en GitHub.

# Para conectarse a un repo ya existente:
# usethis::create_from_github(
#   "usuario/nombre_del_repo",
#   destdir = "C:/Ruta/A/Tus/Proyectos"
# )


# ------------------------------------------------------------------------------
# PASO 4 (OPCIONAL): UNA PLANTILLA DEL .Renviron PARA EL EQUIPO
# ------------------------------------------------------------------------------
# El .Renviron real NO se sube, pero una compañera que clone el proyecto
# necesita saber qué variables tiene que definir. Solución: un
# .Renviron.example, SIN valores, que sí se versiona (el nombre es
# distinto, así que el .gitignore no lo toca).

writeLines(
  c("# Copiá este archivo como .Renviron y completá tus valores",
    "USUARIO=",
    "E_MAIL="),
  here(".Renviron.example")
)

# Después: commit desde la pestaña Git de RStudio (o con git add / git commit).
#
# NOTA SOBRE .Renviron: al arrancar, R lee UN solo .Renviron. Si el
# proyecto tiene uno propio, ese tiene prioridad y el de la carpeta
# personal (~/.Renviron, el que armamos en el Script 1) NO se lee — no
# se combinan. Además se lee al iniciar la sesión: si lo editan, hay que
# reiniciar R o correr readRenviron(".Renviron"). Y ojo:
# usethis::edit_r_environ("project") crea/abre el archivo, pero no lo
# agrega solo al .gitignore — eso lo hace el PASO 1.


# ------------------------------------------------------------------------------
# SI YA SE COMMITEÓ: DEJAR DE SEGUIR UN ARCHIVO
# ------------------------------------------------------------------------------
# Síntoma: el .Renviron (o una base) aparece en la pestaña Git aunque esté
# en el .gitignore. Causa: Git ya lo tenía en su índice.
#
# 1) Sacarlo del índice SIN borrar el archivo local:
#    system("git rm --cached .Renviron")
#    system('git commit -m "Dejar de seguir .Renviron"')
#
# 2) Si ya se hizo push a GitHub, el archivo sigue en la historia del repo.
#    - Si tenía credenciales/tokens: revocarlos y generar nuevos (es lo
#      urgente).
#    - Si tenía datos de pacientes: avisar y limpiar la historia
#      (git filter-repo) o borrar y recrear el repositorio.


# ------------------------------------------------------------------------------
# BUENA PRÁCTICA DE COLABORACIÓN: NADA DE setwd()
# ------------------------------------------------------------------------------
# Usar setwd("C:/MisDocumentos/...") hace que el script falle cuando otra
# residente lo corra en su máquina — es el mismo problema de hardcoding
# que vimos en el Script 0, aplicado a rutas.
# Solución: la función here() del paquete {here}, que parte de la raíz
# del proyecto.
#
# Ejemplo de lectura reproducible:
# base_deis <- fread(here("datos", "primarios", "defunciones_2024.csv"))
