# Lectura y escritura de archivos con UTL_FILE

La carpeta se llama `UT_FILE`; el paquete de Oracle utilizado es `UTL_FILE`.
Estos ejemplos trabajan sobre archivos del **servidor de la base de datos**.

## Preparación

Un administrador debe crear previamente una carpeta física y dar al usuario del
sistema operativo que ejecuta Oracle permisos de lectura y escritura sobre ella.
Después debe crear el objeto DIRECTORY y conceder permisos al esquema que ejecutará
los scripts. Adaptar la ruta y reemplazar `USUARIO_EJECUTOR` por el esquema real:

```sql
-- Ejemplo de ruta Linux del servidor; debe existir previamente.
CREATE DIRECTORY DIR_UTILIDADES AS '/u01/app/archivos/utilidades';
GRANT READ, WRITE ON DIRECTORY DIR_UTILIDADES TO USUARIO_EJECUTOR;
-- Solo si el esquema no tiene acceso al paquete:
GRANT EXECUTE ON SYS.UTL_FILE TO USUARIO_EJECUTOR;
```

En un servidor Windows, usar una ruta real como `C:\archivos\utilidades`.
Crear el objeto DIRECTORY no crea la carpeta física. Si el objeto ya existe,
revisar su ruta antes de reutilizarlo:

```sql
SELECT directory_name, directory_path
FROM all_directories
WHERE directory_name = 'DIR_UTILIDADES';
```

## Ejecución

Usar SQL*Plus, SQLcl o SQL Developer en modo **Ejecutar script (F5)**.
Ajustar `c_directorio` y `c_nombre` en ambos archivos si es necesario.
Desde esta carpeta, ejecutar:

```sql
@01_crear_archivo.sql
@02_leer_archivo.sql
```

- `01_crear_archivo.sql`: escribe tres líneas en `ejemplo_utl_file.txt`.
  El modo `w` **sobrescribe** el contenido si el archivo ya existe.
- `02_leer_archivo.sql`: imprime cada línea mediante DBMS_OUTPUT y termina
  mostrando `Lineas leidas: 3` para el archivo de ejemplo. Un archivo vacío
  muestra cero líneas; las líneas en blanco también se cuentan.

Ambos scripts cierran su archivo al terminar e intentan cerrarlo si ocurre un
error, conservando la excepción original. Un error de escritura puede dejar un
archivo parcial: los cambios en archivos no se revierten con ROLLBACK.

Los ejemplos son para texto en el juego de caracteres de la base de datos,
con un máximo configurado de 32767 bytes por línea, incluido su terminador.
No son ejemplos para archivos binarios ni líneas que superen ese límite.
El archivo de lectura debe existir; los permisos SQL y del sistema operativo
deben estar configurados.

## Validación manual

1. Ejecutar escritura y luego lectura; comprobar las tres líneas y el contador.
2. Probar un archivo vacío y otro con líneas en blanco.
3. Probar un nombre inexistente: la lectura debe propagar el error de Oracle.

No se han ejecutado estos ejemplos contra una instancia Oracle.

Referencia: [documentación oficial de UTL_FILE (Oracle Database 19c)](https://docs.oracle.com/en/database/oracle/oracle-database/19/arpls/UTL_FILE.html).
