# **Funciones SAS**

## **Validación e info**

Librería con funciones diseñadas para validar información simple como pueden ser DNI/NIF/CIF, teléfonos, obtener información extra de ciertos campos, etc...

## **Listado**

* validar_telefono(teléfono, tipo)
* validad_dni(dni)
* validad_cif(cif)
* descripcion_cif(cif)
* provincia_registro_cif(cif)

## **validar_telefono(telefono, tipo)**

### **Descripción**

Función empleada para validar números de teléfonos móviles y fijos del territorio español.

### **Parámetros**

* **[STRING] teléfono ** : número de teléfono a validar.
* **[STRING] tipo** : tipo de teléfono que se proporciona para validar. Toma los valores m/M para teléfonos móviles y f/F para teléfonos fijos.

### **Condiciones**

1. El número proporcionada no tendrá que tener prefijos internacionales tipo +34 XXXXXXXXX

### **Retorna**

Retorna un valor entero 0 si el teléfono no es válido o 1 si lo es.

### **Filosofía**

Para validar si un teléfono es válido o no, primero se tiene que ver la longitud del mismo. Después toca hacer la distinción entre si es fijo o móvil, ya que en función de lo que sea, existirán diferentes formas de validarlo. Así pues encontramos dos casos:

* **Teléfono móvil**: los teléfonos móviles españoles empiezan siempre por 6 o 7
* **Teléfono fijo**: los teléfonos fijos tienen un prefijo de 2 o 3 dígitos que indican la provincia a la que pertenecen.

[Más información](https://blog.cnmc.es/2020/12/11/nuevos-prefijos-para-15-provincias/)

### **Ejemplo de uso**

**Nota**: los teléfonos de este ejemplo han sido generados aleatoriamente [web](https://ensaimeitor.apsl.net/).

```sas
data ejemplo_telefonos;
    input telefono $ 1-9;
cards;
885670215
823061483
76082805
738671231
641127378
767912342
661329176
65069561
846227220
817888709
;
run;

data ejemplo_telefonos;

    set ejemplo_telefonos;

    movil_valido = validar_telefono(telefono, "m");
    telefono_valido = validar_telefono(telefono, "f");

run;
```

**Output**
| Telefono     | movil_valido | telefono_valido |
|:------------:|:------------:|:---------------:|
| 885670215    | 0            | 0               |
| 823061483    | 0            | 1               |
| 76082805     | 0            | 0               |
| 738671231    | 1            | 0               |
| 641127378    | 1            | 0               |
| 767912342    | 1            | 0               |
| 661329176    | 1            | 0               |
| 65069561     | 0            | 0               |
| 846227220    | 0            | 1               |
| 817888709    | 0            | 1               |

## **validad_dni(dni)**

### **Descripción**

Función que valida un DNI/NIF/NIE.

### **Parámetros**

* **[STRING] dni ** : dni a validar.

### **Condiciones**

1. NINGUNA

### **Retorna**

Retorna un valor entero 0 si el dni no es válido o 1 si lo es.

### **Filosofía**

Para determinar si un DNI/NIF es válido a o no, se tiene que hacer el modulo del numero entre 23 y el resultado final indicara la letra que tendría que ir en ese DNI/NIF. Si la letra proporcionada coincide con la que tendría que salir, entonces el DNI/NIF es válido. En caso de ser un NIE, se cambia la primera letra tal que:

		X = 0, Y = 1, Z = 2

[Más información](https://es.wikipedia.org/wiki/Documento_nacional_de_identidad_(Espa%C3%B1a))

### **Ejemplo de uso**

**Nota**: los DNIs/NIFs de este ejemplo han sido generados aleatoriamente [web](https://ensaimeitor.apsl.net/).

```sas
data ejemplo_dni_nif;
    input dni $ 1-9;
cards;
7379302M
51061915Y
83216016S
20501742W
26049065R
25412518W
71862020S
54999130N
48364017P
61040254
;
run;

data ejemplo_dni_nif;

    set ejemplo_dni_nif;

    dni_valido = validar_dni(dni);

run;
```

**Output**

| Dni       | dni_valido |
|:---------:|:----------:|
| 7379302M  | 0          |
| 51061915Y | 1          |
| 83216016S | 1          |
| 20501742W | 1          |
| 26049065R | 1          |
| 25412518W | 1          |
| 71862020S | 1          |
| 54999130N | 1          |
| 48364017P | 1          |
| 61040254  | 0          |

## **validad_cif(cif)**

### **Descripción**

Función que valida un CIF.

### **Parámetros**

* **[STRING] cif ** : cif a validar.

### **Condiciones**

1. NINGUNA

### **Retorna**

Retorna un valor entero 0 si el cif no es válido o 1 si lo es.

### **Filosofía**

Para determinar si un DNI/NIF es válido o no, se tiene que seguir los siguientes pasos:

1. Sumar los dígitos de las posiciones pares. Suma = A
2. Para cada uno de los dígitos de las posiciones impares, multiplicarlo por 2 y sumar los dígitos del resultado.
3. Acumular el resultado. Suma = B
4. Sumar A + B = C
5. Tomar sólo el dígito de las unidades de C. Lo llamaremos dígito E.
6. Si el dígito E es distinto de 0 lo restaremos a 10. D = 10-E. Esta resta nos da D. Si no, si el dígito E es 0 entonces D = 0 y no hacemos resta.
7. A partir de D ya se obtiene el dígito de control. Si ha de ser numérico es directamente D y si se trata de una letra se corresponde con la relación:

        J = 0, A = 1, B = 2, C= 3, D = 4, E = 5, F = 6, G = 7, H = 8, I = 9

[Más información](https://es.wikipedia.org/wiki/C%C3%B3digo_de_identificaci%C3%B3n_fiscal)

### **Ejemplo de uso**

**Nota**: los CIFs de este ejemplo han sido generados aleatoriamente [web](https://ensaimeitor.apsl.net/).

```sas
data ejemplo_cif;
    input cif $ 1-9;
cards;
D6952270D
B84462324
B88691753
B97360622
G9772734
B72079486
B25220666
A35294990
A1851014
A93538205
;
run;

data ejemplo_cif;

    set ejemplo_cif;

    cif_valido = validar_cif(cif);

run;
```

**Output**

| Cif       | cif_valido |
|:---------:|:----------:|
| D6952270D | 1          |
| B84462324 | 1          |
| B88691753 | 1          |
| B97360622 | 1          |
| G9772734  | 0          |
| B72079486 | 1          |
| B25220666 | 1          |
| A35294990 | 1          |
| A1851014  | 0          |
| A93538205 | 1          |

## **descripcion_cif(cif)**

### **Descripción**

Función que dado un cif, retorna el tipo de empresa asociado a el.

### **Parámetros**

* **[STRING] cif ** : cif a describir.

### **Condiciones**

1. NINGUNA

### **Retorna**

Retorna una cadena de caracteres con la descripción asociada al cif.

### **Filosofía**

El tipo de empresa asociado al cif está estipulado por la letra que aparece al principio, de forma que podrá tomar los valores:

* **A**: Sociedades anónimas.
* **B**: Sociedades de responsabilidad limitada.
* **C**: Sociedades colectivas.
* **D**: Sociedades comanditarias.
* **E**: Comunidades de bienes.
* **F**: Sociedades cooperativas.
* **G**: Asociaciones y fundaciones.
* **H**: Comunidades de propietarios en régimen de propiedad horizontal.
* **J**: Sociedades civiles.
* **N**: Entidades no residentes.
* **P**: Corporaciones locales.
* **Q**: Organismos autónomos, estatales o no, y asimilados, y congregaciones e instituciones religiosas.
* **R**: Congregaciones e instituciones religiosas (desde 2008, ORDEN EHA/451/20084)
* **S**: Órganos de la Administración del Estado y comunidades autónomas
* **U**: Uniones Temporales de Empresas.
* **V**: Sociedad Agraria de Transformación.
* **W**: Establecimientos permanentes de entidades no residentes en España

[Más información](https://es.wikipedia.org/wiki/C%C3%B3digo_de_identificaci%C3%B3n_fiscal)

### **Ejemplo de uso**

**Nota**: los CIFs de este ejemplo han sido generados aleatoriamente [web](https://ensaimeitor.apsl.net/).

```sas
data ejemplo_cif;
    input dni $ 1-9;
cards;
D6952270D
B84462324
B88691753
B97360622
G9772734
B72079486
B25220666
A35294990
A1851014
A93538205
;
run;

data ejemplo_cif;

    set ejemplo_cif;

    cif_descripcion = descripcion_cif(dni);

run;
```

**Output**

| Cif       | cif_descripcion |
|:---------:|:----------:|
|D6952270D| Sociedad Comanditarias|
|B84462324| Sociedad de Responsabilidad Limitada|
|B88691753| Sociedad de Responsabilidad Limitada|
|B97360622| Sociedad de Responsabilidad Limitada|
|G9772734 |Asociacion y/o Fundacion|
|B72079486| Sociedad de Responsabilidad Limitada|
|B25220666| Sociedad de Responsabilidad Limitada|
|A35294990| Sociedad Anonima|
|A1851014 | Sociedad Anonima|
|A93538205| Sociedad Anonima|

## **provincia_registro_cif(cif)**

### **Descripción**

Función que dado un cif, retorna la provincia en la que está registrada la empresa.

### **Parámetros**

* **[STRING] cif ** : cif a identificar.

### **Condiciones**

1. NINGUNA

### **Retorna**

Retorna una cadena de caracteres con la provincia asociada al cif seguido del código de la provincia separado por un guion.

### **Filosofía**

La provincia en la que está registrada la empresa viene reflejado en los dos primeros dígitos del número cif, tal que:

* 00    No Residente
* 01    Álava
* 02    Albacete
* 03, 53, 54    Alicante
* 04    Almería
* 05    Ávila
* 06    Badajoz
* 07, 57    Islas Baleares
* 08, 58, 59, 60, 61, 62, 63, 64, 65, 66, 68    Barcelona
* 09    Burgos
* 10    Cáceres
* 11, 72    Cádiz
* 12    Castellón
* 13    Ciudad Real
* 14, 56    Córdoba
* 15, 70    La Coruña
* 16    Cuenca
* 17, 55, 67    Gerona
* 18    Granada
* 19    Guadalajara
* 20, 71    Guipúzcoa
* 21    Huelva
* 22    Huesca
* 23    Jaén
* 24    León
* 25    Lérida
* 26    La Rioja
* 27    Lugo
* 28, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88    Madrid
* 29, 92, 93    Málaga
* 30, 73    Murcia
* 31, 71    Navarra
* 32    Orense
* 33, 74    Asturias
* 34    Palencia
* 35, 75    Las Palmas
* 36, 37, 94    Pontevedra
* 37    Salamanca
* 38, 76    Santa Cruz de Tenerife
* 39    Cantabria
* 40    Segovia
* 41, 90, 91    Sevilla
* 42    Soria
* 43, 77    Tarragona
* 44    Teruel
* 45    Toledo
* 46, 96, 97, 98    Valencia
* 47    Valladolid
* 48, 95    Vizcaya
* 49    Zamora
* 50, 99    Zaragoza
* 51    Ceuta
* 52    Melilla

[Más información](https://es.wikipedia.org/wiki/C%C3%B3digo_de_identificaci%C3%B3n_fiscal)

### **Ejemplo de uso**

**Nota**: los CIFs de este ejemplo han sido generados aleatoriamente [web](https://ensaimeitor.apsl.net/).

```sas
Data ejemplo_cif;
    input dni $ 1-9;
cards;
D6952270D
B84462324
B88691753
B97360622
G9772734
B72079486
B25220666
A35294990
A1851014
A93538205
;
run;

data ejemplo_cif;

    set ejemplo_cif;

    cif_provincia = provincia_registro_cif(dni);

run;
```

**Output**

| Cif       | cif_provincia |
|:---------:|:----------:|
|D6952270D| NS-99|
|B84462324| MADRID-28|
|B88691753| MADRID-28|
|B97360622| VALENCIA-46|
|G9772734 | VALENCIA-46|
|B72079486| CADIZ-11|
|B25220666| LERIDA-25|
|A35294990| LAS PALMAS-35|
|A1851014 | GRANADA-18|
|A93538205| MALAGA-29|

