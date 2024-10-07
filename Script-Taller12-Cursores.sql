
CREATE TYPE estados AS ENUM ('PENDIENTE','EN RUTA','ENTREGADO'); 

CREATE TABLE taller12.envios(
id varchar PRIMARY KEY,
fecha_envio date,
destino varchar,
observacion varchar,
estado estados
)

CREATE OR REPLACE PROCEDURE poblar_envios()
LANGUAGE plpgsql
AS $$
declare 
	v_estado estados;
BEGIN 
	FOR i IN 1..50 LOOP 
	IF i % 2 = 0 then 
		v_estado := 'PENDIENTE';
	ELSE 
		v_estado := 'ENTREGADO';
	END IF;	
	INSERT INTO taller12.envios (id,fecha_envio,destino,observacion,estado) VALUES (i,'2024-05-05','Manizales','Delicado',v_estado);
	END LOOP;
END;
$$;

CALL poblar_envios();

CREATE OR REPLACE PROCEDURE primera_fase_envio()
LANGUAGE plpgsql
AS $$
DECLARE
	v_cursor CURSOR FOR SELECT id,observacion,estado FROM taller12.envios;
	v_id varchar;
	v_observacion varchar;
	v_estado estados;
BEGIN
	OPEN v_cursor;
	LOOP
		FETCH v_cursor INTO v_id, v_observacion, v_estado;
		EXIT WHEN NOT FOUND;
		
		IF v_estado = 'PENDIENTE' THEN
			v_observacion := 'Primera etapa del envio';
			v_estado := 'EN RUTA';
			raise notice 'El envio: % se cambio la observacion a % y el estado a %', v_id, v_observacion, v_estado;
	
			UPDATE taller12.envios SET estado = v_estado, observacion = v_observacion WHERE id = v_id;
		END IF;
	END LOOP;
	CLOSE v_cursor;
END;
$$;

CALL primera_fase_envio();

CREATE OR REPLACE PROCEDURE ultima_fase_envio()
LANGUAGE plpgsql
AS $$
DECLARE
	v_cursor CURSOR FOR SELECT id,observacion,estado FROM taller12.envios;
	v_id varchar;
	v_observacion varchar;
	v_estado estados;
BEGIN
	OPEN v_cursor;
	LOOP
		FETCH v_cursor INTO v_id, v_observacion, v_estado;
		EXIT WHEN NOT FOUND;
		
		IF v_estado = 'EN RUTA' THEN
			v_observacion := 'Envio realizado satisfactoriamente';
			v_estado := 'ENTREGADO';
			raise notice 'El envio: % se cambio la observacion a % y el estado a %', v_id, v_observacion, v_estado;
			UPDATE taller12.envios SET estado = v_estado, observacion = v_observacion WHERE id = v_id;
		END IF;
	END LOOP;
	CLOSE v_cursor;
END;
$$;

CALL ultima_fase_envio();








