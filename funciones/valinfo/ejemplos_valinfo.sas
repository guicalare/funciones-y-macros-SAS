options cmplib=work.valinfo.utils;

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
Y6693025Q
;
run;

data ejemplo_dni_nif;

    set ejemplo_dni_nif;

    dni_valido = validar_dni(dni);

run;

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

data ejemplo_cif2;
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

data ejemplo_cif2;

    set ejemplo_cif2;

    cif_descripcion = descripcion_cif(dni);

run;

Data ejemplo_cif3;
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

data ejemplo_cif3;

    set ejemplo_cif3;

    cif_provincia = provincia_registro_cif(dni);

run;