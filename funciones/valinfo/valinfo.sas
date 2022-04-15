proc fcmp outlib=work.valinfo.utils;

	FUNCTION suma_digitos(numero);

		suma = 0;

		do while(numero > 0);
			suma = suma + mod(numero, 10);
			numero = floor(numero/10);
		end;

		return(suma);

	endsub;

	FUNCTION validar_telefono(telefono $, tipo $);

		tipo = upcase(tipo);

		telefono_valido = 0;

		if length(telefono) = 9 and countc(telefono, ,'d') = 9 then do;

			if tipo = "M" then do;

				if substr(telefono, 1, 1) = "6" or substr(telefono, 1, 1) = "7" then telefono_valido = 1;

			end;
			else if tipo = "F" then do;
				if substr(telefono, 1, 3) in (
					"945", "845", "967", "867", "965", "966", "865", "950", "850", "984", "985", "884", "920", "820",
					"924", "824", "947", "847", "927", "827", "956", "856", "942", "842", "964", "864",
					"926", "826", "957", "857", "981", "881", "969", "869", "972", "872", "958", "858", "949", "849",
					"943", "843", "959", "859", "974", "874", "971", "871", "953", "853", "987", "887", "973", "873",
					"982", "882", "951", "952", "851", "968", "868", "948", "848", "988", "888", "979", "879",
					"928", "828", "986", "886", "941", "841", "923", "823", "921", "821", "954", "955", "854", "975", "875",
					"977", "877", "922", "822", "978", "878", "925", "825", "960", "961", "962", "963", "860", "983", "883",
					"944", "946", "846", "980", "880", "976", "876 ") then telefono_valido = 1;
				else if substr(telefono, 1, 2) in ("93", "83", "91", "81") then telefono_valido = 1;
				else if substr(telefono, 1, 3) in ("900", "800", "901", "902", "905", "907", "803", "806", "807", "908", "909") then telefono_valido = 1;
			end;

		end;

		return(telefono_valido);

	endsub;

	FUNCTION validar_dni(dni $);

		dni = upcase(dni);

		array letras[23] $ ('T', 'R', 'W', 'A', 'G', 'M', 'Y', 'F', 'P', 'D', 'X', 'B', 'N', 'J', 'Z', 'S', 'Q', 'V', 'H', 'L', 'C', 'K', 'E');
	
		dni_valido = 0;

		if length(dni) = 9 then do;

			if substr(dni, 1, 1) = "X" then dni = catt("0", substr(dni, 2, 8));
			else if substr(dni, 1, 1) = "Y" then dni = catt("1", substr(dni, 2, 8));
			else if substr(dni, 1, 1) = "Z" then dni = catt("2", substr(dni, 2, 8));

			if countc(dni, ,'a') = 1 and countc(dni, ,'d') = 8 and countc(substr(dni,9,1), ,'a') = 1 then do;

				letra_valida = 0;

				do i=1 to 23;
					if substr(dni,9,1) = letras[i] then do;
						letra_valida = 1;
					end;
				end;

				if letra_valida then do;
					numero = input(compress(dni,,'kd'), 9.0);
					letra_mod = mod(numero, 23);
					letra_f = letras[letra_mod + 1];
					if letras[mod(numero, 23) + 1] = substr(dni,9,1) then dni_valido = 1;
				end;

			end;

		end;

		return(dni_valido);

	endsub;

	FUNCTION validar_cif(cif $);

		cif = upcase(cif);

		cif_valido = 0;

		if length(cif) = 9 then do;

			if length(compress(substr(cif,2,7),,'kd')) = 7 then do;

				numero_central = substr(cif,2,7);

				suma_pares = input(substr(numero_central, 2,1), 1.0) + input(substr(numero_central, 4,1), 1.0) + input(substr(numero_central,6,1), 1.0);
				sumas_impares = suma_digitos(input(substr(numero_central,1,1), 1.0)*2) + suma_digitos(input(substr(numero_central,3,1), 1.0)*2) + suma_digitos(input(substr(numero_central,5,1), 1.0)*2) + suma_digitos(input(substr(numero_central,7,1), 1.0)*2);

				suma_total = suma_pares + sumas_impares;

				if mod(suma_total, 10) ^= 0 then digito_control = 10 - mod(suma_total, 10);
				else digito_control = mod(suma_total, 10);

				if countc(substr(cif,9,1), ,'a') then do;

					array letras[10] $ ('J', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I');

					if substr(cif,9,1) = letras[digito_control + 1] then cif_valido = 1;
					
				end;
				else do;

					if input(substr(cif,9,1), 1.0) = digito_control then cif_valido = 1;

				end;

			end;

		end;

		return(cif_valido);

	endsub;

	FUNCTION descripcion_cif(cif $) $;

		cif = upcase(cif);

		select (substr(cif,1,1));
		   when ('A') descripcion = "Sociedad Anonima";
		   when ('B') descripcion = "Sociedad de Responsabilidad Limitada";
		   when ('C') descripcion = "Sociedad Colectiva";
		   when ('D') descripcion = "Sociedad Comanditarias";
		   when ('E') descripcion = "Sociedad de Bienes";
		   when ('F') descripcion = "Sociedad Cooperativas";
		   when ('G') descripcion = "Asociacion y/o Fundacion";
		   when ('H') descripcion = "Comunidad de Propietarios en Regimen de Propiedad Horizontal";
		   when ('J') descripcion = "Sociedad Civil";
		   when ('N') descripcion = "Entidad no Residente";
		   when ('P') descripcion = "Corporacion Local";
		   when ('Q') descripcion = "Organismo Autonomo, Estatal o no, y Asimilado, y Congregacion e Institucion Religios";
		   when ('R') descripcion = "Congregacion e Institucion Religiosa";
		   when ('S') descripcion = "Organo de la Administracion del Estado y Comunidad Autonoma";
		   when ('U') descripcion = "Union Temporal de Empresas";
		   when ('V') descripcion = "Sociedad Agraria de Transformacion";
		   when ('W') descripcion = "Establecimientos Permanentes de Entidades no Residentes en España";
		   otherwise descripcion="NS/POSIBLE CIF ERRONEO";
		end;	
		
		return(descripcion);

	endsub;

	FUNCTION provincia_registro_cif(cif $) $;

		cif = upcase(cif);

		id = substr(cif,2,2);
		
		select;
			when (id in ("00")) provincia = "NO RESIDENTE-00";
			when (id in ("01")) provincia = "ALAVA-01";
			when (id in ("02")) provincia = "ALBACETE-02";
			when (id in ("03", "53", "54")) provincia = "ALICANTE-03";
			when (id in ("04")) provincia = "ALMERIA-04";
			when (id in ("05")) provincia = "AVILA-05";
			when (id in ("06")) provincia = "BADAJOZ-06";
			when (id in ("07", "57")) provincia = "ISLAS BALEARES-07";
			when (id in ("08", "58", "59", "60", "61", "62", "63", "64", "65", "66", "68")) provincia = "BARCELONA-08";
			when (id in ("09")) provincia = "BURGOS-09";
			when (id in ("10")) provincia = "CACERES-10";
			when (id in ("11", "72")) provincia = "CADIZ-11";
			when (id in ("12")) provincia = "CASTELLON-12";
			when (id in ("13")) provincia = "CIUDAD REAL-13";
			when (id in ("14", "56")) provincia = "CORDOBA-14";
			when (id in ("15", "70")) provincia = "LA CORUÑA-15";
			when (id in ("16")) provincia = "CUENCA-16";
			when (id in ("17", "55", "67")) provincia = "GERONA-17";
			when (id in ("18")) provincia = "GRANADA-18";
			when (id in ("19")) provincia = "GUADALAJARA-19";
			when (id in ("20", "71")) provincia = "GUIPUZCOA-20";
			when (id in ("21")) provincia = "HUELVA-21";
			when (id in ("22")) provincia = "HUESCA-22";
			when (id in ("23")) provincia = "JAEN-23";
			when (id in ("24")) provincia = "LEON-24";
			when (id in ("25")) provincia = "LERIDA-25";
			when (id in ("26")) provincia = "LA RIOJA-26";
			when (id in ("27")) provincia = "LUGO-27";
			when (id in ("28", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88")) provincia = "MADRID-28";
			when (id in ("29", "92", "93")) provincia = "MALAGA-29";
			when (id in ("30", "73")) provincia = "MURCIA-30";
			when (id in ("31", "71")) provincia = "NAVARRA-31";
			when (id in ("32")) provincia = "ORENSE-32";
			when (id in ("33", "74")) provincia = "ASTURIAS-33";
			when (id in ("35", "75")) provincia = "LAS PALMAS-35";
			when (id in ("36", "37", "94")) provincia = "PONTEVEDRA-36";
			when (id in ("37")) provincia = "SALAMANCA-37";
			when (id in ("38", "76")) provincia = "SANTA CRUZ DE TENERIFE-38";
			when (id in ("39")) provincia = "CANTABRIA-39";
			when (id in ("40")) provincia = "SEGOVIA-40";
			when (id in ("41", "90", "91")) provincia = "SEVILLA-41";
			when (id in ("42")) provincia = "SORIA-42";
			when (id in ("43", "77")) provincia = "TARRAGONA-43";
			when (id in ("44")) provincia = "TERUEL-44";
			when (id in ("45")) provincia = "TOLEDO-45";
			when (id in ("46", "96", "97", "98")) provincia = "VALENCIA-46";
			when (id in ("47")) provincia = "VALLADOLID-47";
			when (id in ("48", "95")) provincia = "VIZCAYA-48";
			when (id in ("49")) provincia = "ZAMORA-49";
			when (id in ("50", "99")) provincia = "ZARAGOZA-50";
			when (id in ("51")) provincia = "CEUTA-51";
			when (id in ("52")) provincia = "MELILLA-52";
			otherwise provincia="NS-99";
		end;

		return(provincia);

	endsub;

run;