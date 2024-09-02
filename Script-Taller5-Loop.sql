--SCRIPT SQL TALLER 5--
--Crear las tablas--
CREATE TABLE clientes(
	identificacion varchar (30) primary key,
	nombre varchar (30) not null,
	edad int,
	correo varchar(30)not null
	);

CREATE TABLE productos(
	codigo varchar (30) primary key,
	nombre varchar (30) not null,
	stock int,
	valor_unitario float
);

CREATE TYPE estados AS ENUM ('PENDIENTE','BLOQUEADO','ENTREGADO');

CREATE TABLE facturas(
	id varchar(30) primary key,
	fecha date not null,
	cantidad int,
	valor_total float,
	pedido_estado estados NULL,
	producto_id varchar (30) not null,
	cliente_id varchar (30) not null,
	foreign key(producto_id) references productos(codigo),
	foreign key(cliente_id) references clientes(identificacion)	
);

CREATE TABLE auditorias (
	id serial NOT NULL,
	fecha_inicio DATE,
	fecha_final DATE,
	factura_id VARCHAR,
	pedido_estado estados
);

--Datos Iniciales--
insert into "Taller5".clientes (identificacion, nombre, edad, correo) values ('1', 'Santi', 20, 'santi@example');
insert into "Taller5".clientes (identificacion, nombre, edad, correo) values ('2', 'Manuel', 22, 'manuel@example');
insert into "Taller5".productos (codigo, nombre, stock, valor_unitario) values ('1', 'Chocolate', 4, 4000);
insert into "Taller5".productos (codigo, nombre, stock, valor_unitario) values ('2', 'Manzana', 10, 500);
insert into "Taller5".facturas (id, fecha, cantidad, valor_total,pedido_estado, producto_id, cliente_id) values ('1', '2024/04/04', 10, 48000, 'PENDIENTE', '1', '1');
insert into "Taller5".facturas (id, fecha, cantidad, valor_total,pedido_estado, producto_id, cliente_id) values ('2', '2024/04/04', 12, 48000, 'PENDIENTE', '2', '2');

-- Procedimiento almacenado Calcular stock total
CREATE OR REPLACE PROCEDURE calcular_stock_total()
LANGUAGE plpgsql
AS $$
DECLARE
	v_total_stock INTEGER := 0;
	v_stock_actual INTEGER;
	v_nombre_producto VARCHAR;
BEGIN
	FOR v_nombre_producto, v_stock_actual IN SELECT  nombre, stock FROM productos
	LOOP
		RAISE NOTICE 'El nombre del producto es: %', v_nombre_producto;
		RAISE NOTICE 'El stock actual del producto es de: %', v_stock_actual;
		v_total_stock := v_total_stock + v_stock_actual;
	END LOOP;
	RAISE NOTICE 'El stock total es de: %', v_total_stock;
END;
$$;

CALL calcular_stock_total();


-- Procedimiento almacenado generar_auditoria
CREATE OR REPLACE PROCEDURE generar_auditoria(
	p_fecha_inicio DATE,
	p_fecha_final DATE
)
LANGUAGE plpgsql
AS $$
DECLARE 
	v_fecha_factura DATE;
	v_id_factura VARCHAR;
	v_pedido_estado_factura estados;
BEGIN
	FOR v_fecha_factura, v_id_factura, v_pedido_estado_factura IN SELECT fecha, id, pedido_estado FROM facturas
	LOOP
		IF v_fecha_factura BETWEEN p_fecha_inicio AND p_fecha_final THEN 
			insert into "Taller5".auditorias (fecha_inicio, fecha_final, factura_id, pedido_estado) values (p_fecha_inicio, p_fecha_final, v_id_factura, v_pedido_estado_factura);
		END IF;	
	END LOOP;
END;
$$;

CALL generar_auditoria('2024-03-03','2024-05-05'); 	 

-- Procedimiento almacenado simular ventas mes
CREATE OR REPLACE PROCEDURE simular_ventas_mes()
LANGUAGE plpgsql
AS $$
DECLARE 
	v_dia INTEGER := 1;
	v_identificacion VARCHAR;
	v_id INTEGER := 5;
	v_cantidad INTEGER := 1;
BEGIN 
	WHILE v_dia <= 30 LOOP
		FOR v_identificacion IN SELECT identificacion FROM clientes 
		LOOP 
			v_cantidad= random()* (30 - 1) + 1;
			INSERT INTO "Taller5".facturas (id, fecha, cantidad, valor_total,pedido_estado, producto_id, cliente_id) values (CAST(v_id AS varchar), '2024-09-02', v_cantidad, 1000, 'PENDIENTE', '1', v_identificacion );
			v_id := v_id+1;
		END LOOP;
		v_dia := v_dia +1;
	END LOOP;
END;
$$;

CALL simular_ventas_mes();


