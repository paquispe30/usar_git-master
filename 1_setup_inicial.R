# ==============================================================================
# SCRIPT 1: CONFIGURACIÓN INICIAL DE GIT (UNA SOLA VEZ POR COMPUTADORA)
# ==============================================================================

# ------------------------------------------------------------------------------
# PARTE 0: INSTALACIÓN AUTOMATIZADA DE PAQUETES
# ------------------------------------------------------------------------------
# Para esta parte necesitamos las librerías usethis y gitcreds.
# Para no instalarlas a mano, y por la misma lógica de reproducibilidad de
# la que veníamos hablando, usamos un gestor de paquetes: pacman.

# 1ro: Verificamos si tenemos 'pacman'; si no, lo instalamos
if(!require(pacman)) install.packages("pacman")

# 2do: pacman carga o instala automáticamente los paquetes necesarios
pacman::p_load(usethis, gitcreds)

# Esta forma de trabajo es práctica para proyectos con muchas dependencias,
# o para scripts que van a correr en computadoras donde no sabemos de
# antemano qué está instalado. Ahora sí, vamos al tema de hoy.

# 3ro: chequeamos que Git esté instalado en el sistema operativo y que
# RStudio lo detecte:
if (Sys.which("git") == "") {
  message("Ojo, no se encuentra Git")
} else {
  message("Perfecto, Git está disponible")
}

# Si al correr
Sys.which("git")
# la consola devuelve una ruta, estilo "C:\\DIRECTORIO\\bla\\bla\\bla\\git.exe",
# está todo listo para seguir.
#
# Si la consola devuelve "", Git no está instalado o RStudio no lo encuentra.
# Hay que descargarlo de https://git-scm.com/downloads e instalarlo (dar
# 'Next' a todo). Luego reiniciar RStudio (cerrar y volver a abrir). Si
# sigue dando "", revisar en Tools -> Global Options -> Git/SVN que la
# ruta apunte al ejecutable git.exe.


# ------------------------------------------------------------------------------
# PARTE 1: ¿QUÉ SON GIT Y GITHUB?
# ------------------------------------------------------------------------------
# La idea de hoy es erradicar el pase de scripts por mail o pendrive,
# evitar borrar avances por error, y terminar con archivos llamados
# "analisis_deis_final_FINAL_v4_corregido.R".
#
# -> ¿Qué es Git?
# Un programa que corre en tu computadora. Es un sistema de control de
# versiones: registra y gestiona los cambios que hacen en sus scripts a
# lo largo del tiempo.
#
# ¿Para qué nos sirve en epidemiología?
# - Historial completo: qué cambió, cuándo y quién lo cambió.
# - Recuperación: permite volver a una versión anterior y estable si
#   algo se rompe.
# - Trabajo en equipo: varias personas pueden modificar el proyecto en
#   paralelo sin sobrescribir ni perder el trabajo de las demás.
#
# -> ¿Qué es GitHub?
# Una plataforma web donde alojamos los repositorios (carpetas) que
# gestiona Git. Funciona como una nube (parecida a Google Drive), pero
# pensada para respaldar código, publicar reportes y colaborar.


# ------------------------------------------------------------------------------
# PARTE 2: CREACIÓN DE CUENTA EN LA WEB
# ------------------------------------------------------------------------------
# Antes de seguir por código, necesitamos la cuenta en la nube:
# 1. Entrar a https://github.com/ y hacer clic en "Sign up".
# 2. Consejos:
#    - Nombre de usuario profesional (ej. 'jgomez-epidemio').
#    - Un mail al que siempre tengan acceso.


# ------------------------------------------------------------------------------
# PARTE 3: PRESENTARNOS ANTE GIT EN ESTA MÁQUINA
# ------------------------------------------------------------------------------
# Git necesita firmar cada cambio con nombre y correo. Como esto identifica
# a la persona en TODA la máquina —no es algo de un proyecto puntual—, lo
# guardamos en el .Renviron de USUARIO (vive en su carpeta personal), no
# en uno de un proyecto. Por eso no hace falta pensar en el .gitignore acá:
# este archivo no está adentro de ningún repositorio.
#
# ATENCIÓN: usen exactamente el mismo mail con el que se registraron en GitHub.

# Paso A: abrir (o crear) el .Renviron de usuario son cosas personales, contraseñas. Crea un ambiente.
edit_r_environ(scope = "user")

# -> Se abre un archivo de texto (vacío la primera vez). Ahí escriban,
#    cada variable en su propia línea y SIN espacios alrededor del "=":
#      USUARIO=Nombre Apellido
#      E_MAIL=tu.mail@ejemplo.com
#    Guarden (Ctrl+S) y cierren la pestaña.

# Paso B: cargar esas variables en esta sesión y usarlas para configurar Git
readRenviron("~/.Renviron")
use_git_config(
  user.name  = Sys.getenv("USUARIO"),
  user.email = Sys.getenv("E_MAIL"))

# Chequeo: tiene que devolver el nombre y el mail que acaban de escribir
Sys.getenv("USUARIO")
Sys.getenv("E_MAIL")


# ------------------------------------------------------------------------------
# PARTE 4: VINCULAR RSTUDIO CON GITHUB (EL TOKEN)
# ------------------------------------------------------------------------------
# GitHub pide un Token (una contraseña de acceso personal) para conectar
# RStudio con la cuenta.

# Paso A: generar el Token en la web
create_github_token()
# -> Se abre el navegador. Le ponen un nombre (ej: "Compu_Hospital"),
#    bajan al final y hacen clic en "Generate token".
# -> Copien el código largo que empieza con 'ghp_'. Si cierran la pestaña
#    sin copiarlo, se pierde y hay que generar uno nuevo.

# Paso B: guardar el Token en el sistema
gitcreds_set()
# -> Miren la Consola (abajo). Va a pedir pegar el Token. Lo pegan y Enter.

# Listo el setup general: la computadora ya está configurada para
# trabajar con Git. Esto no se repite: la próxima vez que abran un
# proyecto nuevo en esta misma máquina, arrancan directo en el Script 2.
