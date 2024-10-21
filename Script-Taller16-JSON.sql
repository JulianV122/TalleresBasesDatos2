
CREATE TABLE taller16json.facturas(
	codigo varchar PRIMARY KEY,
	descripcion jsonb
);

INSERT INTO taller16json.facturas(codigo, descripcion) 
VALUES ('1', 
'{
  "cliente": "Alberto", 
  "identificacion": "123", 
  "direccion": "Calle 123", 
  "codigo": "1234", 
  "total_descuento": 1000, 
  "total_factura": 2000, 
  "productos": [
    {
      "cantidad": 1, 
      "valor": 100, 
      "producto": { 
        "nombre": "PC", 
        "descripcion": "ryzen", 
        "precio": 1200, 
        "categorias": ["compu", "ryzen"]
      }
    }
  ]
}');

CREATE OR REPLACE PROCEDURE taller16json.guardar_factura(codigo varchar, descripcion jsonb)
LANGUAGE plpgsql
AS $$
BEGIN
    IF (descripcion->>'total_factura')::NUMERIC > 10000 THEN
        RAISE EXCEPTION 'Total factura no puede ser mayor de 10.000 dolares';
    END IF;

    IF (descripcion->>'total_descuento')::NUMERIC > 50 THEN
        RAISE EXCEPTION 'Total descuento no puede ser mayor de 50 dolares';
    END IF;

    INSERT INTO taller16json.facturas (codigo, descripcion) VALUES (codigo, descripcion);
END;
$$;

CALL taller16json.guardar_factura('2',
'{
  "cliente": "Pedro", 
  "identificacion": "1234", 
  "direccion": "Calle 123", 
  "codigo": "123456", 
  "total_descuento": 10, 
  "total_factura": 100, 
  "productos": [
    {
      "cantidad": 1, 
      "valor": 100, 
      "producto": { 
        "nombre": "PC", 
        "descripcion": "ryzen", 
        "precio": 1200, 
        "categorias": ["compu", "ryzen"]
      }
    }
  ]
}'
);

CREATE OR REPLACE PROCEDURE taller16json.actualizar_json_factura(p_codigo varchar, descripcion_nueva jsonb)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE taller16json.facturas SET descripcion = descripcion_nueva WHERE codigo = p_codigo;
END;
$$;

CALL taller16json.actualizar_json_factura('2',
'{
  "cliente": "Olmer", 
  "identificacion": "1234", 
  "direccion": "Calle 123", 
  "codigo": "123456", 
  "total_descuento": 5, 
  "total_factura": 1000, 
  "productos": [
    {
      "cantidad": 2, 
      "valor": 100, 
      "producto": { 
        "nombre": "PC", 
        "descripcion": "ryzen", 
        "precio": 1200, 
        "categorias": ["compu", "ryzen"]
      }
    }
  ]
}'
);

CREATE OR REPLACE FUNCTION taller16json.obtener_nombre_cliente(p_identificacion varchar)
RETURNS VARCHAR AS $$
DECLARE
    nombre_cliente VARCHAR;
BEGIN
    SELECT descripcion->>'cliente' INTO nombre_cliente FROM taller16json.facturas  WHERE descripcion->>'identificacion' = p_identificacion;
    RETURN nombre_cliente;
END;
$$ LANGUAGE plpgsql;

SELECT taller16json.obtener_nombre_cliente('123');

CREATE FUNCTION taller16json.obtener_facturas()
RETURNS TABLE (
    cliente TEXT, 
    identificacion TEXT, 
    codigo TEXT, 
    total_descuento TEXT, 
    total_factura TEXT
) 
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        descripcion->>'cliente' AS cliente,
        descripcion->>'identificacion' AS identificacion,
        descripcion->>'codigo' AS codigo,
        descripcion->>'total_descuento' AS total_descuento,
        descripcion->>'total_factura' AS total_factura
    FROM taller16json.facturas;
END;
$$ LANGUAGE plpgsql;

SELECT taller16json.obtener_facturas();

CREATE OR REPLACE FUNCTION taller16json.obtener_productos_factura(p_codigo varchar)
RETURNS TABLE (
    nombre_producto TEXT, 
    descripcion_producto TEXT, 
    precio_producto NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        productos->'producto'->>'nombre' AS nombre_producto,
        productos->'producto'->>'descripcion' AS descripcion_producto,
        (productos->'producto'->>'precio')::NUMERIC AS precio_producto
    FROM taller16json.facturas, jsonb_array_elements(descripcion->'productos') AS productos WHERE descripcion->>'codigo' = p_codigo;
END;
$$ LANGUAGE plpgsql;

SELECT taller16json.obtener_productos_factura('123456');

SELECT * FROM taller16json.facturas f;
