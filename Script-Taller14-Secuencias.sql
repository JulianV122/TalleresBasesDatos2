CREATE TABLE taller14.factura(
	id serial PRIMARY KEY,
	codigo serial,
	cliente varchar,
	producto varchar,
	descuento integer,
	valor_total NUMERIC,
	numero_fe integer
);

CREATE SEQUENCE taller14.id_factura_seq
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE taller14.codigo_factura_seq
	START WITH 100
	INCREMENT BY 100;

CREATE OR REPLACE PROCEDURE poblar_facturas()
LANGUAGE plpgsql
AS $$
	BEGIN 
		FOR i IN 1..10 LOOP 
			INSERT INTO taller14.factura (id, codigo, cliente, producto, descuento, valor_total, numero_fe) VALUES (nextval('taller14.id_factura_seq'), nextval('taller14.codigo_factura_seq'), 'Juan', 'papa',10,100,123);
		END LOOP;
	END;
$$;

CALL poblar_facturas();
