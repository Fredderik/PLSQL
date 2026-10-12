-- Crea un archivo de texto en el servidor de la base de datos.
-- Requisitos y permisos: consultar README.md en este directorio.
-- ATENCION: el modo 'w' sobrescribe el archivo si ya existe.
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    -- Ajustar el objeto DIRECTORY y el nombre del archivo.
    c_directorio CONSTANT VARCHAR2(128) := 'DIR_UTILIDADES';
    c_nombre     CONSTANT VARCHAR2(255) := 'ejemplo_utl_file.txt';
    l_archivo    UTL_FILE.FILE_TYPE;
BEGIN
    l_archivo := UTL_FILE.FOPEN(c_directorio, c_nombre, 'w', 32767);

    UTL_FILE.PUT_LINE(l_archivo, 'Archivo de ejemplo generado desde PL/SQL.');
    UTL_FILE.PUT_LINE(l_archivo, 'Primera linea de contenido.');
    UTL_FILE.PUT_LINE(l_archivo, 'Segunda linea de contenido.');

    UTL_FILE.FCLOSE(l_archivo);
    DBMS_OUTPUT.PUT_LINE('Archivo escrito: ' || c_nombre);
EXCEPTION
    WHEN OTHERS THEN
        -- Intentar cerrar solo este archivo sin ocultar el error original.
        BEGIN
            IF UTL_FILE.IS_OPEN(l_archivo) THEN
                UTL_FILE.FCLOSE(l_archivo);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                NULL; -- El RAISE siguiente conserva el error de la operacion.
        END;
        RAISE;
END;
/
