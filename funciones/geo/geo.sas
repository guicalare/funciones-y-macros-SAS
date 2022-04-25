proc fcmp outlib=sasuser.userfuncs.geo;

	FUNCTION sector_matrix_to_index(geohash_matrix $, level) $;

		length position $ 25;

		array level_rows[12] (8, 32, 256, 1024, 8192, 32768, 262144, 1048576, 8388608, 33554432, 268435456, 1073741824);
		array level_cols[12] (4, 32, 128, 1024, 4096, 32768, 131072, 1048576, 4194304, 33554432, 134217728, 1073741824);

		row = 0;
		col = 0;

		do i=1 to level;
			
			temp_level = scan(geohash_matrix, i, '#');

			row_temp = input(scan(temp_level, 1, '-'), 16.0);
			col_temp = input(scan(temp_level, 2, '-'), 16.0);

			if i ^= level then do;	

				row = row + level_rows[level + 1 - i] * row_temp;
				col = col + level_cols[level + 1 - i] * col_temp;

			end;
			else do;

				row = row + row_temp;
				col = col + col_temp;

			end;

		end;

		position = catx("-", row, col);

		return(position);

	endsub;

	FUNCTION geohash_sector_matrix(longitude, latitude, level) $;

		latmin = -90;
		latmax = 90;
		lonmin = -180;
		lonmax = 180;

		length hash_bits $ 60 geohash_coor_mat $ 50 hash_chunck $ 5 hash_char $ 1;

		do i=1 to 5*level;

			if mod(i,2) ^= 1 then do;

				latmid = (latmin + latmax)/2;

				if latitude < latmid then do;
					bit = 0;
					latmax = latmid;
				end;
				else do;
					bit = 1;
					latmin = latmid;				
				end;

				hash_bits = catt(hash_bits, bit);

			end;
			else do;
					
				lonmid = (lonmin + lonmax)/2;

				if longitude < lonmid then do;
					bit = 0;
					lonmax = lonmid;
				end;
				else do;
					bit = 1;
					lonmin = lonmid;				
				end;

				hash_bits = catt(hash_bits, bit);

			end;

		end;

		cont = 1;

		do j=1 to 5*level by 5;
			
			hash_chunck = substr(hash_bits, j, j+5);
			binary_chunck_value = input(hash_chunck, binary5.);

			if mod(cont, 2) ^= 0 then do;

				select(binary_chunck_value + 1);

					when(11) matrix_pos = "0-0";
					when(12) matrix_pos = "0-1";
					when(15) matrix_pos = "0-2";
					when(16) matrix_pos = "0-3";
					when(27) matrix_pos = "0-4";
					when(28) matrix_pos = "0-5";
					when(31) matrix_pos = "0-6";
					when(32) matrix_pos = "0-7";

					when(9) matrix_pos = "1-0";
					when(10) matrix_pos = "1-1";
					when(13) matrix_pos = "1-2";
					when(14) matrix_pos = "1-3";
					when(25) matrix_pos = "1-4";
					when(26) matrix_pos = "1-5";
					when(29) matrix_pos = "1-6";
					when(30) matrix_pos = "1-7";

					when(3) matrix_pos = "2-0";
					when(4) matrix_pos = "2-1";
					when(7) matrix_pos = "2-2";
					when(8) matrix_pos = "2-3";
					when(19) matrix_pos = "2-4";
					when(20) matrix_pos = "2-5";
					when(23) matrix_pos = "2-6";
					when(24) matrix_pos = "2-7";

					when(1) matrix_pos = "3-0";
					when(2) matrix_pos = "3-1";
					when(5) matrix_pos = "3-2";
					when(6) matrix_pos = "3-3";
					when(17) matrix_pos = "3-4";
					when(18) matrix_pos = "3-5";
					when(21) matrix_pos = "3-6";
					when(22) matrix_pos = "3-7";

					otherwise matrix_pos = "@@@";

				end;

			end;
			else do;

				select(binary_chunck_value + 1);

					when(22) matrix_pos = "0-0";
					when(24) matrix_pos = "0-1";
					when(30) matrix_pos = "0-2";
					when(32) matrix_pos = "0-3";

					when(21) matrix_pos = "1-0";
					when(23) matrix_pos = "1-1";
					when(29) matrix_pos = "1-2";
					when(31) matrix_pos = "1-3";

					when(18) matrix_pos = "2-0";
					when(20) matrix_pos = "2-1";
					when(26) matrix_pos = "2-2";
					when(28) matrix_pos = "2-3";

					when(17) matrix_pos = "3-0";
					when(19) matrix_pos = "3-1";
					when(25) matrix_pos = "3-2";
					when(27) matrix_pos = "3-3";

					when(6) matrix_pos = "4-0";
					when(8) matrix_pos = "4-1";
					when(14) matrix_pos = "4-2";
					when(16) matrix_pos = "4-3";

					when(5) matrix_pos = "5-0";
					when(7) matrix_pos = "5-1";
					when(13) matrix_pos = "5-2";
					when(15) matrix_pos = "5-3";

					when(2) matrix_pos = "6-0";
					when(4) matrix_pos = "6-1";
					when(10) matrix_pos = "6-2";
					when(12) matrix_pos = "6-3";

					when(1) matrix_pos = "7-0";
					when(3) matrix_pos = "7-1";
					when(9) matrix_pos = "7-2";
					when(11) matrix_pos = "7-3";

					otherwise matrix_pos = "@@@";

				end;				

			end;

			geohash_coor_mat = catx("#", geohash_coor_mat, matrix_pos);
			cont = cont + 1;

		end;

		return(geohash_coor_mat);

	endsub;

	FUNCTION geohash(longitude, latitude, level) $;

		/*

		Descripcion:
		------------

		Funcion que dada unas coordenadas y un nivel de geohash retorna el correspondiente geohash

		Condicion:
		----------

			* Level solo puede tomar valores entre 1 y 12, ambos incluidos

		Input:
		------

			* [FLOAT]  longitude: longitud
			* [FLOAT]  latitude: latitud
			* [INT]    level: nivel de geohash deseado

		Retorna:
		--------
		
			* [STRING] geohash

		Ejemplo:
		--------

		data a;
		
			geohash_value = geohash(-103.415962, 20.644275, 12);

		run;

		*/

		latmin = -90;
		latmax = 90;
		lonmin = -180;
		lonmax = 180;

		length hash_bits $ 60 geohash $ 12 hash_chunck $ 5 hash_char $ 1;

		do i=1 to 5*level;

			if mod(i,2) ^= 1 then do;

				latmid = (latmin + latmax)/2;

				if latitude < latmid then do;
					bit = 0;
					latmax = latmid;
				end;
				else do;
					bit = 1;
					latmin = latmid;				
				end;

				hash_bits = catt(hash_bits, bit);

			end;
			else do;
					
				lonmid = (lonmin + lonmax)/2;

				if longitude < lonmid then do;
					bit = 0;
					lonmax = lonmid;
				end;
				else do;
					bit = 1;
					lonmin = lonmid;				
				end;

				hash_bits = catt(hash_bits, bit);

			end;

		end;

		do j=1 to 5*level by 5;
			
			hash_chunck = substr(hash_bits, j, j+5);
			binary_chunck_value = input(hash_chunck, binary5.);
			hash_char = char('0123456789bcdefghjkmnpqrstuvwxyz', binary_chunck_value + 1);
			geohash = catt(geohash , hash_char);

		end;

		return(geohash);

	endsub;

	SUBROUTINE geohash_extended(longitude, latitude, level, geohash $, bounding_box[*]);

		/*

		Descripcion:
		------------

		Funcion que dada unas coordenadas y un nivel de geohash retorna el correspondiente geohash
		asi como su bounding box mediante parametros por referencia.

		Condicion:
		----------

			* Level solo puede tomar valores entre 1 y 12, ambos incluidos

		Input:
		------

			* [FLOAT]       longitude: longitud
			* [FLOAT]       latitude: latitud
			* [INT]         level: nivel de geohash deseado
			* [STRING]      geohash: geohash resultante [PARAMETRO POR REFERENCIA]
			* [FLOAT ARRAY] bounding_box: bounding box del geohash [PARAMETRO POR REFERENCIA]

		Retorna por referencia:
		-----------------------
		
			* [STRING]      geohash
			* [FLOAT ARRAY] bounding_box: [latmin, latmax, lonmin, lonmax]

		Ejemplo:
		--------

		data a;
		
			array bounding_box[4] latmin latmax lonmin lonmax;
			length geohash $ 12;
			
			call geohash_extended(-103.415962, 20.644275, 12, geohash, bounding_box);

		run;

		*/

		outargs geohash, bounding_box;

		latmin = -90;
		latmax = 90;
		lonmin = -180;
		lonmax = 180;

		length hash_bits $ 60 geohash $ 12 hash_chunck $ 5 hash_char $ 1;

		do i=1 to 5*level;

			if mod(i,2) ^= 1 then do;

				latmid = (latmin + latmax)/2;

				if latitude < latmid then do;
					bit = 0;
					latmax = latmid;
				end;
				else do;
					bit = 1;
					latmin = latmid;				
				end;

				hash_bits = catt(hash_bits, bit);

			end;
			else do;
					
				lonmid = (lonmin + lonmax)/2;

				if longitude < lonmid then do;
					bit = 0;
					lonmax = lonmid;
				end;
				else do;
					bit = 1;
					lonmin = lonmid;				
				end;

				hash_bits = catt(hash_bits, bit);

			end;

		end;

		do j=1 to 5*level by 5;
			
			hash_chunck = substr(hash_bits, j, j+5);
			binary_chunck_value = input(hash_chunck, binary5.);
			hash_char = char('0123456789bcdefghjkmnpqrstuvwxyz', binary_chunck_value + 1);
			geohash = catt(geohash , hash_char);

		end;

		bounding_box[1] = latmin;
		bounding_box[2] = latmax;
		bounding_box[3] = lonmin;
		bounding_box[4] = lonmax;

	endsub;
	
	SUBROUTINE geohash_neibours(bounding_box[*], neighbours[*] $, level);

		/*

		Descripcion:
		------------

		Funcion que dado un bounding box de un geohash retorna todos los 8 vecinos del geohash

		Condicion:
		----------

			* Level solo puede tomar valores entre 1 y 12, ambos incluidos

		Input:
		------

			* [FLOAT ARRAY]  bounding_box: bounding box del geohash
			* [STRING ARRAY] neighbours: array donde de almacenaran los vecinos cercanos [PARAMETRO POR REFERENCIA]
			* [INT]          level: nivel de geohash deseado


		Retorna por referencia:
		-----------------------
		
			* [STRING ARRAY] neighbours [N_neighbours, S_neighbours, O_neighbours, E_neighbours, NE_neighbours, SE_neighbours, NO_neighbours, SO_neighbours]

		Ejemplo:
		--------

		data a;
		
			array bounding_box[4] latmin latmax lonmin lonmax;
			array neighbours[8] $ N_neighbours S_neighbours O_neighbours E_neighbours NE_neighbours SE_neighbours NO_neighbours SO_neighbours;
			length geohash $ 5;
			
			call geohash_extended(-103.415962, 20.644275, 5, geohash, bounding_box);
			call geohash_neibours(bounding_box, neighbours, 5);

		run;

		*/

		outargs neighbours;

		latmin = bounding_box[1];
		latmax = bounding_box[2];
		lonmin = bounding_box[3];
		lonmax = bounding_box[4];

		latdif = abs(abs(latmax) - abs(latmin));
		londif = abs(abs(lonmax) - abs(lonmin));

		latmid = (latmin + latmax)/2;
		lonmid = (lonmin + lonmax)/2;

		neighbours[1] = geohash(lonmid, latmid + latdif, level); 			
		neighbours[2] = geohash(lonmid, latmid - latdif, level); 			
		neighbours[3] = geohash(lonmid - londif, latmid, level); 			
		neighbours[4] = geohash(lonmid + londif, latmid, level); 			
		neighbours[5] = geohash(lonmid + londif, latmid + latdif, level); 
		neighbours[6] = geohash(lonmid - londif, latmid + latdif, level); 
		neighbours[7] = geohash(lonmid + londif, latmid - latdif, level); 
		neighbours[8] = geohash(lonmid - londif, latmid - latdif, level); 

	endsub;

	FUNCTION different_root_regions(geohash_1 $, geohash_2 $);

		/*

		Descripcion:
		------------

		Funcion que dados dos geohashs determina si estan o no en diferentes regiones de nivel 1

		Condicion:
		----------

			* geohash_1 y geohash_2 tienen que tener un valor distinto a vacio

		Input:
		------

			* [STRING] geohash_1: boundinggeohash 1 a comparar
			* [STRING] geohash_2: boundinggeohash 2 a comparar

		Retorna:
		--------
		
			* [INT] 0 si estan en diferentes regiones de nivel 1, 1 en caso contratio

		Ejemplo:
		--------

		data a;
		
			array bounding_box[4] latmin latmax lonmin lonmax;
			array neighbours[8] $ N_neighbours S_neighbours O_neighbours E_neighbours NE_neighbours SE_neighbours NO_neighbours SO_neighbours;
			length geohash $ 5;
			
			call geohash_extended(-103.415962, 20.644275, 5, geohash, bounding_box);
			call geohash_neibours(bounding_box, neighbours, 5);

			different_neibours = different_neibours(geohash , neighbours);

			different_regions = different_root_regions(N_neighbours, S_neighbours);

		run;

		*/

		return(substr(geohash_1, 1, 1) ^= substr(geohash_2, 1, 1));
	endsub;
	
	FUNCTION different_neibours(primary_hash $, neighbours[*] $);

		/*

		Descripcion:
		------------

		Funcion que dados los 8 vecinos de un geohash, detecta si existen vecinos en diferentes regiones de nivel 1

		Condicion:
		----------

			* Ninguna

		Input:
		------

			* [STRING]       primary_hash: geohash central
			* [STRING ARRAY] neighbours: array que contenga los 8 vecinos que rodean al primary_hash

		Retorna:
		--------
		
			* [INT] 0 si todos los vecinos estan en la misma region a nivel 1 que el primary_hash, 1 en caso contrario

		Ejemplo:
		--------

		data a;
		
			array bounding_box[4] latmin latmax lonmin lonmax;
			array neighbours[8] $ N_neighbours S_neighbours O_neighbours E_neighbours NE_neighbours SE_neighbours NO_neighbours SO_neighbours;
			length geohash $ 5;
			
			call geohash_extended(-103.415962, 20.644275, 5, geohash, bounding_box);
			call geohash_neibours(bounding_box, neighbours, 5);

			different_neibours = different_neibours(geohash , neighbours);

		run;

		*/

		distintos = 0;

		do i=1 to 8;
			if substr(neighbours[i], 1, 1) = substr(primary_hash, 1, 1) then distintos = 1;
		end;

		return(distintos);
	
	endsub;

	FUNCTION bounding_box_square_area(bounding_box [*]);

		/*

		Descripcion:
		------------

		Funcion que dado el bounding box de un geohash, retorna el area del mismo en kilometros cuadrados

		Condicion:
		----------

			* Ninguna

		Input:
		------

			* [FLOAT ARRAY] bounding_box: bounding box del geohash

		Retorna:
		--------
		
			* [FLOAT] area en kilometros cuadrados

		Ejemplo:
		--------

		data a;
		
			array bounding_box[4] latmin latmax lonmin lonmax;
			array neighbours[8] $ N_neighbours S_neighbours O_neighbours E_neighbours NE_neighbours SE_neighbours NO_neighbours SO_neighbours;
			length geohash $ 5;
			
			call geohash_extended(-103.415962, 20.644275, 5, geohash, bounding_box);
			call geohash_neibours(bounding_box, neighbours, 5);

			different_neibours = different_neibours(geohash , neighbours);

			area_K_2 = bounding_box_square_area(bounding_box);

		run;

		*/

		latmin = bounding_box[1];
		latmax = bounding_box[2];
		lonmin = bounding_box[3];
		lonmax = bounding_box[4];

		area = geodist(latmin, lonmax, latmax, lonmax, "K") * geodist(latmax, lonmin, latmax, lonmax, "K");

		return(area);

	endsub;

	FUNCTION geohash_match(geohash_1 $, geohash_2 $);

		/*

		Descripcion:
		------------

		Funcion que dados dos geohashs determina cuantos niveles tienen en comun

		Condicion:
		----------

			* geohash_1 y geohash_2 tienen que tener un valor distinto a vacio

		Input:
		------

			* [STRING] geohash_1: geohash 1 a comparar
			* [STRING] geohash_2: geohash 2 a comparar

		Retorna:
		--------
		
			* [INT] numero de niveles que tienen en comun

		Ejemplo:
		--------

		data a;
		
			array bounding_box[4] latmin latmax lonmin lonmax;
			array neighbours[8] $ N_neighbours S_neighbours O_neighbours E_neighbours NE_neighbours SE_neighbours NO_neighbours SO_neighbours;
			length geohash $ 5;
			
			call geohash_extended(-103.415962, 20.644275, 5, geohash, bounding_box);
			call geohash_neibours(bounding_box, neighbours, 5);

			common_levels = geohash_match(geohash , neighbours);

		run;

		*/

		iters = max(length(geohash_1), length(geohash_2));
		cont = 0;

		do i=0 to iters by 1;
			if substr(geohash_1, i, i) = substr(geohash_2, i, i) then cont = cont + 1;
			else do;
				goto break;
			end;
		end;

		break: ;

		return(cont-1);

	endsub;

run;
