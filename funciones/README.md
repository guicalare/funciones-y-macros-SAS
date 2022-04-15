# Funciones 

## Cargar librerias

Para cargar las librerias y usarlas en SAS:

1. Ejecutar el código de la librería que se quiera. Esto generará una base de datos las cual puede ser guardada de forma persistente de forma que ya no sera necesario ejecutar el código cada vez. Para indicar la libreria en la que se guardaran las funciones se tendra qe cambiar la cabecera del proc fcmp.

		proc fcmp outlib=<tu librería>.valinfo.utils;
		...código..
		run;

2. Una vez se tiene guardado el código se ejecuta:

		options cmplib=<tu librería>.valinfo.utils;
		
**Nota**: por defecto todas las librería s de este codigo se guardan en la librería work (librería temporal)

## Listado librerias

* **VALINFO**: Librería con funciones diseñadas para validar información simple como pueden ser DNI/NIF/CIF, teléfonos, obtener información extra de ciertos campos, etc...
* **GEO**: Librería con funciones diseñadas para trabajar y facilitar el manejo de información geográfica como pueden ser códigos postales, códigos ine, coordenadas, etc...