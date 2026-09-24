# ==============================================================================
# CLASE DE BUENAS PRÁCTICAS Y REPRODUCIBILIDAD EN R
# SCRIPT 0: ESTRUCTURA DE CARPETAS Y RUTAS RELATIVAS
# Paquetes: install.packages("pacman")
# ==============================================================================

# ------------------------------------------------------------------------------
# PARTE 0: ¿QUÉ SON LAS "BUENAS PRÁCTICAS" Y QUÉ ES LA REPRODUCIBILIDAD?
# ------------------------------------------------------------------------------
# En investigación ya manejan el concepto de reproducibilidad: que otra
# persona, con los mismos datos y el mismo código, llegue exactamente al
# mismo resultado que ustedes. En programación es la misma idea, pero
# aplicada a algo muy concreto: que CUALQUIER computadora —la de una
# compañera, o la de ustedes mismas dentro de seis meses, cuando ya no
# se acuerden de los detalles— pueda correr el proyecto de punta a punta
# sin tener que editar el código a mano.
#
# "Buenas prácticas" es el conjunto de hábitos que hacen eso posible.
# No son una cuestión de prolijidad estética: cada una resuelve un
# problema concreto que en algún momento les va a pasar (o ya les pasó):
# - Un script que corre en tu compu y no en la de tu compañera.
# - No saber cuál de varios archivos parecidos es la versión buena.
# - Subir sin querer una contraseña, un token o datos de pacientes a
#   un repositorio en internet.
#
# Vemos tres pilares, uno por script: cómo organizar las carpetas del
# proyecto y leer archivos sin rutas fijas (este script), cómo llevar
# un historial de cambios con Git y GitHub (Script 1), y cómo aplicar
# todo junto a un proyecto nuevo, de punta a punta (Script 2).


# ------------------------------------------------------------------------------
# PARTE 1: HARDCODING (¿POR QUÉ SE ROMPEN LOS SCRIPTS?)
# ------------------------------------------------------------------------------
# "Hardcodear" (del inglés hard-coding) es escribir valores fijos —rutas
# exactas, contraseñas— directamente adentro del código, en vez de dejar
# que el programa los resuelva según la computadora donde se ejecuta.
#
# Ejemplos de hardcoding que después traen problemas:
# ❌ setwd("C:/Users/Maria/Desktop/proyecto_mortalidad")
# ❌ token_github <- "ghp_123456789secreto"
#❌ tambienponer numeros fijos, en practicas sistematicas que tienen que actualizarse
# ¿Por qué evitarlo?
# 1. Rompe la reproducibilidad: si tu compañera clona el repo, su
#    computadora no tiene un usuario "Maria". El script tira error en
#    la línea 1, antes de llegar a lo importante.
# 2. Riesgo de seguridad: si el código llega a GitHub, ese token queda
#    visible para cualquiera que abra el repositorio.
#
# LA SOLUCIÓN:
# - Para contraseñas y tokens  -> archivo .Renviron (lo vemos en Script 1)
# - Para rutas de archivos     -> estructura de carpetas + paquete {here}


# ------------------------------------------------------------------------------
# PARTE 2: CÓMO ORGANIZAMOS LAS CARPETAS DEL PROYECTO
# ------------------------------------------------------------------------------
# Un proyecto reproducible no tiene archivos sueltos en la carpeta raíz:
# cada tipo de archivo va en su lugar, así cualquiera —incluida su
# versión de acá a seis meses— sabe dónde buscar sin tener que preguntar.
#
# 📁 mi_proyecto/
# ├── 📁 datos/
# │   ├── 📁 primarios/    (Bases originales, intocables. Ej: defunciones_2024.csv)
# │   └── 📁 procesados/   (Bases limpias generadas por sus scripts)
# ├── 📁 scripts/          (Solo archivos .R, ej: 01_limpieza.R)
# ├── 📁 docs/             (Reporte final .qmd / .html y gráficos exportados)
# └── 📄 mi_proyecto.Rproj
#
# Tip: se pueden crear estas carpetas de una desde R:
# dir.create("datos/primarios", recursive = TRUE) creo la carpeta anidada y la otra en caso de que no exista.
# dir.create("datos/procesados", recursive = TRUE)
# dir.create("scripts")
# dir.create("docs")


# ------------------------------------------------------------------------------
# PARTE 3: LEER Y ESCRIBIR DATOS SIN ROMPER EL CÓDIGO DE LAS DEMÁS ({here})
# ------------------------------------------------------------------------------
# La función here() encuentra automáticamente la raíz del proyecto en TU
# computadora (busca el .Rproj) y arma la ruta completa a partir de ahí.
#
#busca la raiz del proyecto, y en funcion de eso construye las carpetas, pero yo no lo veo lo hace automaticamente.
#
# ❌ MAL (hardcodeado — solo funciona en tu PC):
# defunciones <- fread("C:/Mis_Documentos/Hospital/datos/primarios/defunciones_2024.csv")
#
# ✅ BIEN (reproducible — funciona en cualquier PC que abra el .Rproj):
# defunciones <- fread(here("datos", "primarios", "defunciones_2024.csv"))
#
# Guardar un archivo limpio se hace igual, apuntando a /procesados:
# fwrite(defunciones_limpias, here("datos", "procesados", "defunciones_analisis.rds"))

# Ejemplo en vivo:
# 1ro: Verificamos si tenemos 'pacman'; si no, lo instalamos
if(!require(pacman)) install.packages("pacman")

# 2do: pacman carga o instala automáticamente los paquetes necesarios
pacman::p_load(here, data.table) #(pido here y dat.table, en vez de usar library)
here()
# Creamos la estructura real de carpetas del proyecto
dir.create(here("datos", "primarios"), recursive = TRUE, showWarnings = FALSE)
dir.create(here("datos", "procesados"), recursive = TRUE, showWarnings = FALSE)

# here() arma la ruta desde la raíz del proyecto, sin importar
# desde qué subcarpeta esté corriendo el script
here("datos", "primarios")

# "Base original" de prueba (usamos iris porque no depende de ningún
# archivo externo, pero es exactamente el mismo procedimiento que con
# una base real)
base_original <- as.data.table(iris) #iris esta presente en R
fwrite(base_original, here("datos", "primarios", "iris.csv"))

# "Procesamos" algo mínimo y guardamos el resultado en /procesados
base_procesada <- base_original[Species == "setosa"]
fwrite(base_procesada, here("datos", "procesados", "iris_setosa.csv"))

# Verificamos: los dos archivos quedaron cada uno en su carpeta
list.files(here("datos"), recursive = TRUE)
