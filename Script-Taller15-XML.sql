CREATE TABLE taller15xml.libros (
    isbn VARCHAR PRIMARY KEY,
    descripcion XML
);


CREATE OR REPLACE PROCEDURE guardar_libro(isbn_libro VARCHAR, xml_descripcion XML)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "taller15xml".libros WHERE isbn = isbn_libro OR xpath('//titulo/text()', descripcion)::TEXT = xpath('//titulo/text()', xml_descripcion)::TEXT) THEN
        INSERT INTO "taller15xml".libros (isbn, descripcion) VALUES (isbn_libro, xml_descripcion);
    ELSE
        RAISE EXCEPTION 'El ISBN o el título ya existen.';
    END IF;
END;
$$;

CALL guardar_libro('2','<libro><titulo>Harry Potter</titulo><autor>Pablo</autor><anio>1900</anio></libro>')

CREATE OR REPLACE PROCEDURE actualizar_libro(isbn_libro VARCHAR, nueva_descripcion XML)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "taller15xml".libros SET descripcion = nueva_descripcion WHERE isbn = isbn_libro;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'El libro con ISBN % no existe.', isbn_libro;
    END IF;
END;
$$;

CALL actualizar_libro('2','<libro><titulo>Harry Potter</titulo><autor>Pablo</autor><anio>1999</anio></libro>')

CREATE OR REPLACE FUNCTION obtener_autor_libro_por_isbn(isbn_libro VARCHAR)
RETURNS TEXT AS $$
DECLARE
    autor TEXT;
BEGIN
    SELECT xpath('//autor/text()', descripcion)::TEXT INTO autor FROM "taller15xml".libros WHERE isbn = isbn_libro;
    RETURN autor;
END; 
$$ LANGUAGE plpgsql;

SELECT obtener_autor_libro_por_isbn('1');

CREATE OR REPLACE FUNCTION obtener_autor_libro_por_titulo(p_titulo TEXT)
RETURNS TEXT AS $$
DECLARE
    autor TEXT;
BEGIN
    SELECT xpath('//autor/text()', descripcion)::TEXT INTO autor FROM "taller15xml".libros WHERE xpath('//titulo/text()', descripcion)::TEXT[]  @> ARRAY[p_titulo];
    RETURN autor;
END;
$$ LANGUAGE plpgsql;

SELECT obtener_autor_libro_por_titulo('Don Quijote');

CREATE OR REPLACE FUNCTION obtener_libros_por_anio(anio_libro INT)
RETURNS TABLE(titulo TEXT, autor TEXT, anio INT) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        (xpath('string(//titulo)', descripcion))[1]::TEXT AS titulo,
        (xpath('string(//autor)', descripcion))[1]::TEXT AS autor,
        (xpath('string(//anio)', descripcion))[1]::TEXT::INT AS anio
    FROM "taller15xml".libros
    WHERE CAST((xpath('string(//anio)', descripcion))[1] AS TEXT)::INT = anio_libro;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM obtener_libros_por_anio(1605);

SELECT xpath('string(//titulo)', descripcion)::TEXT AS titulo, xpath('string(//autor)', descripcion)::TEXT AS autor, xpath('string(//anio)',descripcion)::TEXT AS anio FROM taller15xml.libros;	