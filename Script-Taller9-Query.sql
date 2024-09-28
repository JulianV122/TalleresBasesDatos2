CREATE TABLE "Taller9".tipo_contrato (
	descripcion varchar NULL,
	cargo varchar NULL,
	salario_total numeric NULL,
	id varchar NOT NULL,
	CONSTRAINT tipo_contrato_pk PRIMARY KEY (id)
);

CREATE TYPE nombres_conceptos AS ENUM ('SALARIO', 'HORAS EXTRAS', 'PRESTACIONES', 'IMPUESTOS');

CREATE TABLE "Taller9".conceptos (
	codigo varchar NOT NULL,
	nombre nombres_conceptos NULL,
	porcentaje float4 NULL,
	CONSTRAINT conceptos_pk PRIMARY KEY (codigo)
);

CREATE TABLE "Taller9".empleados (
	nombre varchar NULL,
	id varchar NOT NULL,
	tipo_contrato_id varchar NULL,
	CONSTRAINT empleados_unique UNIQUE (id),
	CONSTRAINT empleados_tipo_contrato_fk FOREIGN KEY (tipo_contrato_id) REFERENCES "Taller9".tipo_contrato(id)
);

CREATE TABLE "Taller9".nomina (
	mes integer NULL,
	año integer NULL,
	fecha_pago date NULL,
	total_devengado numeric NULL,
	total_deducciones numeric NULL,
	total numeric NULL,
	empleado_id varchar NULL,
	id varchar NOT NULL,
	CONSTRAINT nomina_pk PRIMARY KEY (id),
	CONSTRAINT nomina_empleados_fk FOREIGN KEY (empleado_id) REFERENCES "Taller9".empleados(id)
);

CREATE TABLE "Taller9".detalles_nomina (
	concepto_id varchar NULL,
	valor numeric NULL,
	nomina_id varchar NULL,
	id varchar NULL,
	CONSTRAINT detalles_nomina_nomina_fk FOREIGN KEY (nomina_id) REFERENCES "Taller9".nomina(id),
	CONSTRAINT detalles_nomina_conceptos_fk FOREIGN KEY (concepto_id) REFERENCES "Taller9".conceptos(codigo)
);

CREATE OR REPLACE PROCEDURE poblar_emp_cont()
LANGUAGE plpgsql
AS $$
BEGIN 
	FOR i IN 1..10 LOOP
		INSERT INTO "Taller9".tipo_contrato (descripcion, cargo, salario_total, id) VALUES ('Contrato Prestacion Servicios' || i, 'Cargo N' || i, i*1000, i);
		INSERT INTO "Taller9".empleados (nombre, id, tipo_contrato_id) VALUES ('Alejo' || i, i, i);
	END LOOP;
END;
$$;

CALL poblar_emp_cont();

CREATE OR REPLACE PROCEDURE poblar_nomina()
LANGUAGE plpgsql
AS $$
BEGIN
	FOR i IN 1..5 LOOP 
		INSERT INTO "Taller9".nomina (id,año, mes,fecha_pago, total_devengado, total_deducciones, total, empleado_id) VALUES (i,2024, i, '01-01-2024', i*1200, i*2000,i*1200+i*2000, i  );
	END LOOP;
END;
$$;

CALL poblar_nomina();

CREATE OR REPLACE PROCEDURE poblar_detalles_nomina_conceptos()
LANGUAGE plpgsql
AS $$
DECLARE 
	n numeric:=0;
BEGIN
	FOR i IN 1..5 LOOP
		FOR j IN 1..3 LOOP 
			n := n + 1;
			INSERT INTO "Taller9".conceptos (codigo,nombre,porcentaje) VALUES (n, 'SALARIO', n+3);
			INSERT INTO "Taller9".detalles_nomina (id,valor,nomina_id, concepto_id) VALUES (n, i*1000, i, n);
		END LOOP;
	END LOOP;
END;
$$;

CALL poblar_detalles_nomina_conceptos();

CREATE OR REPLACE FUNCTION obtener_nomina_empleado(p_id varchar, p_mes integer, p_año integer)
RETURNS TABLE (
	nombre varchar,
	total_devengado NUMERIC,
	total_deducciones NUMERIC,
	total NUMERIC
) AS $$
BEGIN 
	RETURN QUERY SELECT e.nombre, n.total_devengado, n.total_deducciones, n.total FROM "Taller9".empleados e JOIN "Taller9".nomina n ON e.id = p_id AND n.mes = p_mes AND n.año = p_año;
END;
$$ LANGUAGE plpgsql;

SELECT obtener_nomina_empleado('1',1,2024);

CREATE OR REPLACE FUNCTION total_por_contrato(p_id_tipo_contrato varchar)
RETURNS TABLE (
	nombre varchar,
	fecha_pago date,
	año integer,
	mes integer,
	total_devengado numeric,
	total_deducciones numeric,
	total numeric
) AS $$
BEGIN 
	RETURN QUERY SELECT e.nombre, n.fecha_pago, n.año, n.mes, n.total_devengado, n.total_deducciones, n.total FROM "Taller9".empleados e JOIN "Taller9".nomina n ON e.tipo_contrato_id = p_id_tipo_contrato AND n.empleado_id = e.id;
END;
$$ LANGUAGE plpgsql;

SELECT total_por_contrato('2');


