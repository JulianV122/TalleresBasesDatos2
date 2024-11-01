--PRIMERA PREGUNTA--

CREATE TYPE estados_usuario AS ENUM ('ACTIVO', 'INACTIVO');
CREATE TYPE tarjetas_tipo AS ENUM ('VISA', 'MASTERCARD');
CREATE TYPE categoria_productos AS ENUM ('CELULAR', 'PC','TELEVISOR');
CREATE TYPE estados_pago AS ENUM ('EXITOSO', 'FALLIDO');

CREATE TABLE "Parcial2doCorte".usuarios (
	id varchar NOT NULL PRIMARY KEY,
	nombre varchar,
	direccion varchar,
	email varchar,
	fecha_registro date,
	estado estados_usuario
);


CREATE TABLE "Parcial2doCorte".tarjetas (
	id varchar NOT NULL PRIMARY KEY,
	numero_tarjeta varchar,
	fecha_expiracion date,
	cvv varchar ,
	tipo_tarjeta tarjetas_tipo
);

CREATE TABLE "Parcial2doCorte".productos (
	id varchar NOT NULL PRIMARY KEY,
	codigo_producto varchar,
	nombre varchar,
	categoria categoria_productos ,
	porcentaje_impuesto int,
	precio float
);

CREATE TABLE "Parcial2doCorte".pagos(
	id varchar NOT NULL PRIMARY KEY,
	codigo_pago varchar,
	fecha date,
	estado estados_pago,
	monto float,
	producto_id varchar,
	tarjeta_id varchar,
	usuario_id varchar,
	FOREIGN KEY (producto_id) REFERENCES productos(id),
	FOREIGN KEY (tarjeta_id) REFERENCES tarjetas(id),
	FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE "Parcial2doCorte".comprobantes_pago (
	id varchar NOT NULL PRIMARY KEY,
	detalle_xml XML,
	detalle_json JSON
);


CREATE OR REPLACE FUNCTION obtener_pagos_usuario(p_usuario_id varchar, p_fecha date)
RETURNS TABLE (
	codigo_pago varchar,
	nombre_producto varchar,
	monto float,
	estado varchar
) AS $$
BEGIN
	RETURN QUERY SELECT p.codigo_pago, pr.nombre_producto, p.monto, p.estado FROM "Parcial2doCorte".pagos p JOIN "Parcial2doCorte".productos pr ON p.usuario_id = p_usuario_id AND p.fecha = p_fecha;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_tarjetas_usuario(p_usuario_id varchar)
RETURNS TABLE (
	nombre_usuario varchar,
	email varchar,
	numero_tarjeta varchar,
	cvv varchar,
	tipo_tarjeta tarjetas_tipo
) AS $$
BEGIN
	RETURN QUERY SELECT u.nombre, u.email, t.numero_tarjeta, t.cvv, t.tipo_tarjeta FROM "Parcial2doCorte".pagos p JOIN "Parcial2doCorte".tarjetas t JOIN "Parcial2doCorte".usuarios u ON p.usuario_id = p_usuario_id AND p.monto > 1000;
END;
$$ LANGUAGE plpgsql;

--SEGUNDA PREGUNTA--

CREATE OR REPLACE FUNCTION obtener_tarjetas_detalle(p_usuario_id varchar)
RETURNS VARCHAR
AS $$
DECLARE
	v_cursor CURSOR FOR SELECT tarjeta_id, usuario_id FROM "Parcial2doCorte".pagos;
	v_cursor2 CURSOR FOR SELECT numero_tarjeta, fecha_expiracion FROM "Parcial2doCorte".tarjetas;
	v_cursor3 CURSOR FOR SELECT nombre, email FROM "Parcial2doCorte".usuarios;
	v_usuario_id varchar;
	v_tarjeta_id varchar;
	v_numero_tarjeta varchar;
	v_fecha_expiracion date;
	v_nombre varchar;
	v_email varchar;
BEGIN
	OPEN v_cursor;
	open v_cursor2;
	open v_cursor3;
	LOOP 
		FETCH v_cursor INTO v_tarjeta_id, v_usuario_id;
		EXIT WHEN NOT FOUND;
		IF v_usuario_id = p_usuario_id THEN
			FETCH v_cursor2 INTO v_tarjeta_id, v_numero_tarjeta WHERE v_tarjeta_id = tarjeta_id;
			FETCH v_cursor3 INTO v_nombre, v_email WHERE v_usuario_id = usuario_id;
		END IF;
	RETURN v_numero_tarjeta, v_fecha_expiracion, v_nombre, v_email;
	END LOOP;
	CLOSE v_cursor;
	CLOSE v_cursor2;
	CLOSE v_cursor3;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_pagos(p_fecha date)
RETURNS VARCHAR
AS $$
DECLARE
	v_cursor CURSOR FOR SELECT id, numero_tarjeta, fecha_expiracion FROM "Parcial2doCorte".pagos;
	v_monto float;
	v_estado estados_pago;
	v_nombre_producto varchar;
	v_porcentaje_impuesto int;
	v_usuario_direccion varchar;
	v_email varchar;
BEGIN
	OPEN v_cursor;
	LOOP 
		FETCH v_cursor INTO ;
		EXIT WHEN NOT FOUND;

		RETURN varchar:= 
		
	END LOOP;
	CLOSE v_cursos;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE guardar_xml()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO "Parcial2doCorte".comprobantes_pago (id,detalle_xml,detalle_json) VALUES ('1', '<pago> <codigo-Pago> </codigo-Pago> <nombreUsuario></nombreUsuario> <numeroTarjeta> </numeroTarjeta> <nombreProducto> </nombreProducto> <montoPago> </montoPago> </pago>','');
END;
$$;

CREATE OR REPLACE PROCEDURE guardar_json()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO "Parcial2doCorte".comprobantes_pago (id,detalle_xml,detalle_json) VALUES ('2', '','
	{
		"emailUsuario" : "",
		"numeroTarjeta" :"",
		"tipoTarjeta" : "",
		"codigoProducto": "",
		"codigoPago":"",
		"montoPago":""
	}		
');
END;
$$;

--Tercera Pregunta--

CREATE OR REPLACE FUNCTION validacion_producto()
RETURNS TRIGGER AS 
$$ 
DECLARE 
	v_precio float;
	v_porcentaje int;
BEGIN 
	SELECT precio, porcentaje INTO v_precio, v_porcentaje FROM "Parcial2doCorte".productos WHERE id = NEW.id;
	IF v_precio > 0 AND v_precio < 20000 THEN 
		IF v_porcentaje > 1 AND v_porcentaje <= 20 THEN 
			RETURN NEW;
		ELSE
			RAISE EXCEPTION 'Error en el porcentaje'
	RAISE EXCEPTION 'Error en el precio'
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER validaciones_producto 
BEFORE INSERT ON "Parcial2doCorte".productos
FOR EACH ROW
EXECUTE FUNCTION validacion_producto();









