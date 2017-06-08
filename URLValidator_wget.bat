@Echo off

rem Validador de URLs
rem David Pavón 19/05/2017

set FICHERO_LOG=.\URL_VALIDATOR_%1_%date:~6,4%%date:~3,2%%date:~0,2%%time:~0,2%%time:~3,2%%time:~6,2%.log
echo Inicio Ejecución: %date% %time% > "%FICHERO_LOG%"

IF [%1]==[] GOTO FALTA_PARAMETRO 

Echo ******************************
ECHO *** VALIDANDO FICHERO DE URLS: %1
Echo *** Inicio Ejecución: %date% %time%
Echo ******************************

REM Read each line in txt file and call the wget with the line as parameter:
REM for /F "delims=" %%a in (URLsEjemploAValidar.txt) do (
for /F "tokens=1,2 delims=;" %%a in (%1) do (
    echo *** Validando URL %%a: %%b
    rem wget -t 1 -nv --delete-after "%%b"
    wget -t 1 --delete-after --output-file=tempLogValURL "%%b"
    grep -i "error" tempLogValURL
    grep -i "failed" tempLogValURL
    grep -i "ok" tempLogValURL
    type tempLogValURL >> "%FICHERO_LOG%"
    echo +++ Fin validacion URL %%a
    echo +++
)

DEL tempLogValURL

Echo ******************************
ECHO *** Resumen Errores (si HAY lineas debajo en esta seccion es que HAY URLs con fallo A REVISAR)
grep -i "error" "%FICHERO_LOG%"
grep -i "failed" "%FICHERO_LOG%"

GOTO FIN

:FALTA_PARAMETRO
ECHO Se debe indicar como parámetro el fichero de URLs a validar, formato del fichero "descripcion;url a validar".
ECHO Ejemplo de una línea del fichero de URLs a validar: Balanceadora_GOT_SECTOR_PRO_MANAGER;https://got.agbar.net
Echo Se debe indicar como parámetro el fichero de URLs a validar, formato del fichero "descripcion;url a validar" >> "%FICHERO_LOG%"

:FIN
Echo ******************************
ECHO *** FIN SCRIPT VALIDACION URLS. Fichero log: %FICHERO_LOG%
Echo ******************************
echo Fin Ejecución: %date% %time% >> "%FICHERO_LOG%"