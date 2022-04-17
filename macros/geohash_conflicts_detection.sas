%macro geohash_conflict_detector(ddbb_input, id, longitude, latitude, precision_detection_level, ddbb_output);

	/*

	Valores recomendados para precision_detection_level [3, 4, 5]. Valores mas pequeños a eso detectaran simpre conflictos de fronteras
	y valores mayores a esos no casi nunca detectaran conflictos de fronteras

	*/

	data &ddbb_output ;

		set &ddbb_input ;

		array bounding_box[4] latmin latmax lonmin lonmax;
		array neighbours[8] $ N_neighbours S_neighbours O_neighbours E_neighbours NE_neighbours SE_neighbours NO_neighbours SO_neighbours;
		length geohash $ &precision_detection_level;
				
		call geohash_extended(&longitude, &latitude, &precision_detection_level , geohash, bounding_box);
		call geohash_neibours(bounding_box, neighbours, &precision_detection_level );

		GEOHASH_COPY = geohash;

		original = 1;

		output;

		do i=1 to 8;

			if different_root_regions(GEOHASH_COPY, neighbours[i]) then do;
				geohash = neighbours[i];
				original = 0;
				output;
			end;

		end;
	 
		keep &id &longitude &latitude geohash original;

	run;

	data &ddbb_output ;

		set &ddbb_output ;

		length root_level $ 1;

		by &id ;

		if first.&id and last.&id then conflictos = 0;
		else conflictos = 1;

		root_level = substr(geohash, 1, 1);

	run;

	proc sort data=&ddbb_output nodupkey;
		by &id root_level;
	run;

%mend;