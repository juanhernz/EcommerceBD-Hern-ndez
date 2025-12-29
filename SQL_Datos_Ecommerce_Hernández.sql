INSERT INTO categorias(nombre) VALUES ('Tecnología'), ('Hogar');

INSERT INTO usuarios(nombre, apellido, email, password_hash)
VALUES ('Juan','Perez','juan@mail.com','hash');

INSERT INTO direcciones(id_usuario, calle, ciudad, pais)
VALUES (1,'Calle Falsa 123','Buenos Aires','Argentina');

INSERT INTO productos(nombre, precio, stock_actual, id_categoria)
VALUES ('Notebook',1200,10,1),
       ('Silla',300,5,2);

CALL sp_crear_pedido(1,1);
CALL sp_agregar_item_pedido(1,1,2);