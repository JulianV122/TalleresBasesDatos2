CREATE TABLE "taller6".clientes (
	id varchar NOT NULL,
	nombre varchar NOT NULL,
	email varchar NOT NULL,
	direccion varchar NULL,
	telefono varchar NULL,
	CONSTRAINT cliente_pk PRIMARY KEY (id)
);

CREATE TYPE estados AS ENUM ('PAGO','NO PAGO','PENDIENTE PAGO');

CREATE TABLE "taller6".servicios (
	id varchar NOT NULL,
	tipo varchar NULL,
	monto numeric NULL,
	cuota numeric NULL,
	intereses numeric NULL,
	valor_total numeric NULL,
	estado estados NULL,
	cliente_id varchar NOT NULL,
	CONSTRAINT servicios_pk PRIMARY KEY (id),
	foreign key(cliente_id) references "taller6".clientes(id)
);

CREATE TABLE "taller6".pagos (
	id varchar NOT NULL,
	codigo_transaccion varchar NULL,
	fecha_pago date NULL,
	total numeric NULL,
	servicio_id varchar NOT NULL,
	CONSTRAINT pagos_pk PRIMARY KEY (id),
	foreign key(servicio_id) references "taller6".servicios(id)

);

-- Procedimiento almacenado poblar clientes

CREATE OR REPLACE PROCEDURE "taller6".poblar_clientes()
LANGUAGE plpgsql
AS $$
DECLARE 
	 strings_array text[] := ARRAY['Juan', 'Pedro', 'Carlos', 'Valeria', 'Juana', 'Alex', 'Valeria', 'Ignacio', 'Aleja', 'Diana', 'Monica'];
	 random_value text;
	 v_cliente INTEGER := 1;
	 random_number int;
	 random_email text;
	 telefono text;
	 random_direccion text;
BEGIN
	WHILE v_cliente <= 50 LOOP
		random_number := 18 + floor(random() * (90 - 18 + 1))::int;
		random_value := strings_array[1 + floor(random() * array_length(strings_array, 1))::int];
		random_email := random_value || '@gmail.com';
		telefono := (floor(1000000000 + random() * 9000000000))::text;
		random_direccion := lpad((floor(random() * 100000))::text, 5, '0');
		insert into "taller6".clientes ( id, nombre, email, direccion, telefono) values (v_cliente, random_value, random_email, random_direccion, telefono);
		v_cliente := v_cliente +1;
	END LOOP;
END;
$$;

-- Procedimiento almacenado poblar servicios

CREATE OR REPLACE PROCEDURE "taller6".poblar_servicios()
LANGUAGE plpgsql
AS $$
DECLARE 
	 strings_array text[] := ARRAY['Electricidad', 'Agua', 'Gas', 'Internet'];
	 estados_array estados[] := ARRAY['PAGO','NO PAGO','PENDIENTE PAGO'];
	 v_tipo text;
	 v_estado estados;
	 v_servicio INTEGER := 1;
	 v_monto int;
	 v_cuota int;
	 v_intereses int;
	 v_valor_total int;
	 v_cliente_id varchar;
	 v_servicio_id integer := 1;
BEGIN
	FOR v_cliente_id IN SELECT id FROM "taller6".clientes
	LOOP 
		v_servicio := 1;
		WHILE v_servicio <= 3 LOOP 
			v_monto := 20000 + floor(random() * (300000 - 20000+ 1))::int;
			v_tipo := strings_array[1 + floor(random() * array_length(strings_array, 1))::int];
			v_estado := estados_array[1 + floor(random() * array_length(strings_array, 1))::int];
		 	v_cuota := 1 + floor(random() * (48 - 1 + 1))::int;
			v_intereses := 1 + floor(random() * (15 - 1 + 1))::int;
			v_valor_total := v_monto * v_intereses;
			insert into "taller6".servicios ( id, tipo, monto, cuota, intereses, valor_total, estado, cliente_id) values (v_servicio_id, v_tipo, v_monto, v_cuota, v_intereses, v_valor_total, v_estado, v_cliente_id);
			v_servicio := v_servicio +1;
			v_servicio_id := v_servicio_id + 1;
		END LOOP;
	END LOOP;
END;
$$;

-- Procedimiento almacenado poblar pagos

CREATE OR REPLACE PROCEDURE "taller6".poblar_pagos()
LANGUAGE plpgsql
AS $$
DECLARE 
	dates_array date[] := ARRAY['2024-01-01', '2024-02-01', '2024-03-01', '2024-04-01', '2024-05-01','2024-06-01', '2024-07-01', '2024-08-01', '2024-09-01', '2024-10-01', '2024-11-01', '2024-12-01'];
	v_pago_id int;
	v_codigo int;
	v_fecha date;	
	v_total int;
	v_servicio_id varchar;
	v_pago int;
	v_estado estados;
BEGIN
	v_pago := 1;
	FOR v_servicio_id, v_total, v_estado IN SELECT id, valor_total, estado FROM "taller6".servicios
	LOOP
		IF v_pago <= 50 THEN
			v_fecha := dates_array[1 + floor(random() * array_length(dates_array, 1))::int];
			v_codigo := 111111 + floor(random() * (999999 - 1 + 1))::int;
			INSERT INTO "taller6".pagos (id,codigo_transaccion, fecha_pago, total, servicio_id) VALUES (v_pago, v_codigo, v_fecha, v_total, v_servicio_id);
			v_pago := v_pago +1;
		END IF;
	END LOOP;
END;
$$;


CREATE OR REPLACE PROCEDURE "taller6".poblar_bd()
LANGUAGE plpgsql
AS $$
BEGIN
	CALL poblar_clientes();

	CALL poblar_servicios();

	CALL poblar_pagos();
END;
$$;

CALL poblar_bd()

-- Crear funcion almacenada total mes

CREATE OR REPLACE FUNCTION "taller6".total_mes(p_mes int, p_cliente_id varchar)
RETURNS NUMERIC AS 
$$
DECLARE 
	v_mes date;
	v_sum_total NUMERIC := 0;
	v_id_servicio varchar;
	v_total NUMERIC;
BEGIN
	FOR v_id_servicio IN SELECT id FROM "taller6".servicios WHERE p_cliente_id = id
	LOOP
		FOR v_total IN SELECT total FROM "taller6".pagos WHERE EXTRACT(MONTH FROM fecha_pago) = p_mes AND servicio_id = v_id_servicio
		LOOP
			v_sum_total := v_sum_total + v_total;
		END LOOP;
	END LOOP;	
	RETURN v_sum_total;
END;
$$
LANGUAGE plpgsql;

SELECT total_mes(4,'1')