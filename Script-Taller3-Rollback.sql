--Crear las tablas--
create table clientes(
	identificacion varchar (30) primary key,
	nombre varchar (30) not null,
	edad int,
	correo varchar(30)not null
	);

create table productos(
	codigo varchar (30) primary key,
	nombre varchar (30) not null,
	stock int,
	valor_unitario float
);

create table pedidos(
	id varchar(30) primary key,
	fecha date not null,
	cantidad int,
	valor_total float,
	producto_id varchar (30) not null,
	cliente_id varchar (30) not null,
	foreign key(producto_id) references productos(codigo),
	foreign key(cliente_id) references clientes(identificacion)
);

--Datos Iniciales--
insert into "Taller3".clientes (identificacion, nombre, edad, correo) values ('4', 'Santi', 20, 'santi@example');
insert into "Taller3".clientes (identificacion, nombre, edad, correo) values ('5', 'Manuel', 22, 'manuel@example');
insert into "Taller3".productos (codigo, nombre, stock, valor_unitario) values ('4', 'Chocolate', 4, 4000);
insert into "Taller3".productos (codigo, nombre, stock, valor_unitario) values ('5', 'Manzana', 10, 500);
insert into "Taller3".pedidos (id, fecha, cantidad, valor_total, producto_id, cliente_id) values ('4', '2024/04/04', 12, 48000, '4', '4');
insert into "Taller3".pedidos (id, fecha, cantidad, valor_total, producto_id, cliente_id) values ('5', '2024/05/05', 10, 5000, '5', '5');

--Inicio Transacción--

begin;
--Crear clientes--
insert into "Taller3".clientes (identificacion, nombre, edad, correo) values ('1', 'Jhon', 20, 'jhon@example');
insert into "Taller3".clientes (identificacion, nombre, edad, correo) values ('2', 'Agustin', 20, 'agustin@example');
insert into "Taller3".clientes (identificacion, nombre, edad, correo) values ('3', 'Carlos', 20, 'carlos@example');

--Crear Productos--
insert into "Taller3".productos (codigo, nombre, stock, valor_unitario) values ('1', 'Pan', 10, 2000);
insert into "Taller3".productos (codigo, nombre, stock, valor_unitario) values ('2', 'Agua', 40, 1000);
insert into "Taller3".productos (codigo, nombre, stock, valor_unitario) values ('3', 'Pastas', 15, 3000);

--Crear Pedidos--
insert into "Taller3".pedidos (id, fecha, cantidad, valor_total, producto_id, cliente_id) values ('1', '2024/01/01', 5, 5000, '2', '1');
insert into "Taller3".pedidos (id, fecha, cantidad, valor_total, producto_id, cliente_id) values ('2', '2024/01/02', 10, 20000, '1', '2');
insert into "Taller3".pedidos (id, fecha, cantidad, valor_total, producto_id, cliente_id) values ('3', '2024/01/03', 2, 6000, '3', '3');

--Actualizar clientes--
update "Taller3".clientes set nombre='Alejo', edad=30, correo='alejo@example' where identificacion = '1';
update "Taller3".clientes set nombre='Mateo', edad=22, correo='mateo@example' where identificacion = '2';

--Actualizar Productos--
update "Taller3".productos set nombre='Atún', stock=11, valor_unitario = 1200 where codigo = '1';
update "Taller3".productos set nombre='Gaseosa', stock=22, valor_unitario = 2000 where codigo = '2';

--Actulizar Pedidos--
update "Taller3".pedidos set fecha ='2024/02/02', cantidad=4, valor_total = 10000 where id = '1';
update "Taller3".pedidos set fecha ='2024/03/03', cantidad=5, valor_total = 6000 where id = '2';

--Eliminar Pedidos--
delete from "Taller3".pedidos where id='3';

--Eliminar Clientes--
delete from "Taller3".clientes where identificacion='3';

--Eliminar Productos--
delete from "Taller3".productos where codigo='3';


ROLLBACK;
