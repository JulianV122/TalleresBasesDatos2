--SCRIPT SQL TALLER 4--
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
)

--Datos Iniciales--
insert into "Taller 4".clientes (identificacion, nombre, edad, correo) values ('1', 'Santi', 20, 'santi@example');
insert into "Taller 4".clientes (identificacion, nombre, edad, correo) values ('2', 'Manuel', 22, 'manuel@example');
insert into "Taller 4".productos (codigo, nombre, stock, valor_unitario) values ('1', 'Chocolate', 4, 4000);
insert into "Taller 4".productos (codigo, nombre, stock, valor_unitario) values ('2', 'Manzana', 10, 500);
insert into "Taller 4".facturas (id, fecha, cantidad, valor_total,pedido_estado, producto_id, cliente_id) values ('1', '2024/04/04', 10, 48000, 'PENDIENTE', '1', '1');
insert into "Taller 4".facturas (id, fecha, cantidad, valor_total,pedido_estado, producto_id, cliente_id) values ('2', '2024/04/04', 12, 48000, 'PENDIENTE', '2', '2');


--Procedimiento almacenado Verificar stock--
CREATE OR REPLACE PROCEDURE verificar_stock(
	p_producto_id VARCHAR,
	p_cantidad_compra INTEGER
	)
LANGUAGE plpgsql
AS $$
DECLARE 
	p_stock INTEGER;
BEGIN
	--Obtener el stock del producto
	SELECT stock INTO p_stock FROM productos WHERE codigo = p_producto_id;
	--Verificar que si haya stock
	IF p_cantidad_compra > p_stock THEN
		RAISE NOTICE 'No hay suficiente stock de este producto';
	ELSE 
		RAISE NOTICE 'Si hay stock suficiente';
	END IF;
END;
$$;

CALL verificar_stock('1',10);

--Procedimiento almacenado actualizar estado pedido--
CREATE OR REPLACE PROCEDURE actualizar_estado_pedido(
	p_factura_id VARCHAR,
	p_nuevo_estado estados
	)
LANGUAGE plpgsql
AS $$
DECLARE 
	p_estado_actual estados;
BEGIN
	--Obtener la el estado de la factura--
	SELECT pedido_estado INTO p_estado_actual FROM facturas WHERE p_factura_id = id;
	--Verificar que el estado sea entregado 
	IF p_estado_actual = 'ENTREGADO' THEN
		RAISE NOTICE 'EL PEDIDO YA FUE ENTREGADO';
	ELSE 
		UPDATE facturas SET pedido_estado = p_nuevo_estado WHERE p_factura_id = id;
		RAISE NOTICE 'EL ESTADO DEL PEDIDO FUE ACTUALIZADO';
	END IF;
END;
$$;

CALL actualizar_estado_pedido('1', 'ENTREGADO');





