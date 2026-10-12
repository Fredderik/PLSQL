-- Lee un archivo de texto del servidor y muestra sus lineas.
-- Ejecutar primero 01_crear_archivo.sql o proporcionar un archivo existente.
-- Requisitos y permisos: consultar README.md en este directorio.
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    -- Deben coincidir con el directorio y archivo que se desean leer.
    c_directorio CONSTANT VARCHAR2(128) := 'DIR_UTILIDADES';
    c_nombre     CONSTANT VARCHAR2(255) := 'ejemplo_utl_file.txt';
    l_archivo    UTL_FILE.FILE_TYPE;
    l_linea      VARCHAR2(32767);
    l_total      PLS_INTEGER := 0;
BEGIN
    l_archivo := UTL_FILE.FOPEN(c_directorio, c_nombre, 'r', 32767);

    LOOP
        BEGIN
            UTL_FILE.GET_LINE(l_archivo, l_linea);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                EXIT; -- Fin del archivo, incluso si esta vacio.
        END;

        DBMS_OUTPUT.PUT_LINE(l_linea);
        l_total := l_total + 1;
    END LOOP;

    UTL_FILE.FCLOSE(l_archivo);
    DBMS_OUTPUT.PUT_LINE('Lineas leidas: ' || l_total);
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
