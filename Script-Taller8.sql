CREATE TABLE "Taller8".usuarios (
	identificacion varchar NOT NULL,
	nombre varchar NULL,
	edad integer NULL,
	correo varchar NULL,
	CONSTRAINT usuarios_unique UNIQUE (identificacion)
);



CREATE OR REPLACE PROCEDURE poblar_usuarios()
LANGUAGE plpgsql
AS $$
DECLARE 
	 nombres_array text[] := ARRAY['Juan', 'Pedro', 'Carlos', 'Valeria', 'Juana', 'Alex', 'Valeria', 'Ignacio', 'Aleja', 'Diana', 'Monica'];
	 v_nombre text;
	 v_usuario INTEGER := 1;
	 random_email text;
	 v_edad int := 0;
BEGIN
	WHILE v_usuario <= 50 LOOP
		v_edad := 18 + floor(random() * (90 - 18 + 1))::int;
		v_nombre := nombres_array[1 + floor(random() * array_length(nombres_array, 1))::int];
		random_email := v_nombre || '@gmail.com';
		insert into "Taller8".usuarios( identificacion, nombre, edad, correo) values (v_usuario,v_nombre, v_edad, random_email);
		v_usuario := v_usuario +1;
	END LOOP;
END;
$$;

CALL poblar_usuarios();

CREATE TABLE "Taller8".facturas (
	id varchar NOT NULL,
	producto varchar NOT NULL,
	cantidad integer NULL,
	valor_unitario integer NULL,
	valor_total integer NULL,
	usuario_id varchar NOT NULL,
	foreign key(usuario_id) references usuarios(identificacion),
	CONSTRAINT facturas_unique UNIQUE (id)
);


CREATE OR REPLACE PROCEDURE poblar_facturas()
LANGUAGE plpgsql
AS $$
DECLARE 
	 productos_array text[] := ARRAY['Agua', 'Fruta', 'Dulces', 'Gaseosa', 'Hamburguesa', 'Pizza'];
	 v_producto text;
	 v_factura INTEGER := 1;
	 v_cantidad int := 0;
	 v_valor_unitario int := 0;
	 v_valor_total int := 0;
BEGIN
	WHILE v_factura <= 25 LOOP
		v_cantidad := 1 + floor(random() * (50 - 1 + 1))::int;
		v_valor_unitario := 1000 + floor(random() * (10000 - 1000 + 1))::int;
		v_producto := productos_array[1 + floor(random() * array_length(productos_array, 1))::int];
		v_valor_total := v_cantidad * v_valor_unitario;
		insert into "Taller8".facturas( id, producto, cantidad,valor_unitario, valor_total, usuario_id) values (v_factura,v_producto, v_cantidad, v_valor_unitario, v_valor_total,v_factura);
		v_factura := v_factura +1;
	END LOOP;
END;
$$;

CALL poblar_facturas();

CREATE OR REPLACE PROCEDURE prueba_identificacion_unica()
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO "Taller8".usuarios(identificacion, nombre, edad, correo) values ('1','Carlos', 22, 'carlos@gmail.com');
EXCEPTION
	WHEN unique_violation THEN
	ROLLBACK;
	RAISE EXCEPTION 'El id del usuario ya existe %', SQLERRM;
END;
$$;

CALL prueba_identificacion_unica();

CREATE OR REPLACE PROCEDURE prueba_cliente_debe_existir()
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO "Taller8".facturas(id, producto, cantidad,valor_unitario, valor_total, usuario_id) values ('30','Tomate', 5, 1000, 5000, '1');
EXCEPTION
	WHEN OTHERS THEN
	ROLLBACK;
	RAISE EXCEPTION 'El id del usuario ya existe %', SQLERRM;
END;
$$;

CREATE OR REPLACE PROCEDURE prueba_producto_vacio()
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO "Taller8".facturas(id, producto, cantidad,valor_unitario, valor_total, usuario_id) values ('30','Tomate', 5, 1000, 5000, '1');
	INSERT INTO "Taller8".facturas(id, producto, cantidad,valor_unitario, valor_total, usuario_id) values ('31',NULL , 5, 1000, 5000, '1');
EXCEPTION
	WHEN null_value_not_allowed THEN
	ROLLBACK;
	RAISE EXCEPTION 'EL producto no puede ser nulo %', SQLERRM;
END;
$$;

CALL prueba_producto_vacio();

CREATE OR REPLACE PROCEDURE restriccion_valor_producto()
LANGUAGE plpgsql
AS $$
DECLARE
	cantidad_productos INTEGER;
BEGIN 
	INSERT INTO "Taller8".facturas(id, producto, cantidad,valor_unitario, valor_total, usuario_id) values ('30','Tomate', 5, 1000, 5000, '1');
	INSERT INTO "Taller8".facturas(id, producto, cantidad,valor_unitario, valor_total, usuario_id) values ('31','Cebolla', 5, 1000, 5000, '1');
	cantidad_productos := 12;
	IF cantidad_productos > 10 THEN
            RAISE EXCEPTION 'Error: No se puede facturar más de 10 productos';
        ELSE
			INSERT INTO "Taller8".facturas(id, producto, cantidad,valor_unitario, valor_total, usuario_id) values ('32','Lechuga', 5, 1000, 5000, '1');
        END IF;
EXCEPTION
	WHEN OTHERS THEN
	ROLLBACK;
	RAISE EXCEPTION 'Error en la transaccion %', SQLERRM;
END;
$$;

CALL restriccion_valor_producto();

CREATE OR REPLACE PROCEDURE restriccion_numero_compras()
LANGUAGE plpgsql
AS $$
DECLARE
	total_compras_usuario NUMERIC;
    cliente_id INTEGER;
BEGIN 
	INSERT INTO "Taller8".facturas(id, producto, cantidad,valor_unitario, valor_total, usuario_id) values ('30','Tomate', 5, 50, 250, '1');
	INSERT INTO "Taller8".facturas(id, producto, cantidad,valor_unitario, valor_total, usuario_id) values ('31','Cebolla', 5, 10, 50, '2');
	INSERT INTO "Taller8".facturas(id, producto, cantidad,valor_unitario, valor_total, usuario_id) values ('32','Lechuga', 5, 4, 20, '3');
	INSERT INTO "Taller8".facturas(id, producto, cantidad,valor_unitario, valor_total, usuario_id) values ('33','Maracuya', 5, 1, 5, '4');
	INSERT INTO "Taller8".facturas(id, producto, cantidad,valor_unitario, valor_total, usuario_id) values ('34','Lulo', 5, 101, 505, '5');
	cliente_id := 1;
	WHILE cliente_id <= 5 LOOP
		SELECT valor_total INTO total_compras_usuario FROM facturas WHERE cliente_id::varchar = usuario_id;
		IF total_compras_usuario > 500 THEN
            RAISE EXCEPTION 'Error: No se puede superar los 500 dolares por persona';
        END IF;
		cliente_id := cliente_id + 1;
	END LOOP;
EXCEPTION
	WHEN OTHERS THEN
	ROLLBACK;
	RAISE EXCEPTION 'Error en la transaccion %', SQLERRM;
END;
$$;

CALL restriccion_numero_compras();