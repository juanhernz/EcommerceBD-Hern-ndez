-- VISTAS
CREATE OR REPLACE VIEW v_pedidos_usuario AS
SELECT u.id_usuario, u.nombre, u.apellido, p.id_pedido, p.estado, p.total, p.fecha
FROM usuarios u
JOIN pedidos p ON u.id_usuario = p.id_usuario;

CREATE OR REPLACE VIEW v_detalle_pedido AS
SELECT p.id_pedido, pr.nombre AS producto, ip.cantidad, ip.precio_unit
FROM pedidos p
JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
JOIN productos pr ON ip.id_producto = pr.id_producto;

-- FUNCIONES
DELIMITER //
CREATE FUNCTION fn_total_pedido(p_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(12,2);
  SELECT SUM(cantidad * precio_unit)
  INTO total
  FROM item_pedido
  WHERE id_pedido = p_id;
  RETURN IFNULL(total,0);
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_stock_disponible(p_prod INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE stock INT;
  SELECT stock_actual INTO stock
  FROM productos
  WHERE id_producto = p_prod;
  RETURN stock;
END//
DELIMITER ;

-- STORED PROCEDURES
DELIMITER //
CREATE PROCEDURE sp_crear_pedido(IN p_usuario INT, IN p_direccion INT)
BEGIN
  INSERT INTO pedidos(id_usuario, id_direccion)
  VALUES (p_usuario, p_direccion);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_agregar_item_pedido(
  IN p_pedido INT,
  IN p_producto INT,
  IN p_cantidad INT
)
BEGIN
  DECLARE stock INT;
  SELECT stock_actual INTO stock
  FROM productos
  WHERE id_producto = p_producto;

  IF stock >= p_cantidad THEN
    INSERT INTO item_pedido(id_pedido, id_producto, cantidad, precio_unit)
    SELECT p_pedido, id_producto, p_cantidad, precio
    FROM productos
    WHERE id_producto = p_producto;
  END IF;
END//
DELIMITER ;

-- TRIGGERS
DELIMITER //
CREATE TRIGGER trg_actualizar_stock
AFTER INSERT ON item_pedido
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock_actual = stock_actual - NEW.cantidad
  WHERE id_producto = NEW.id_producto;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_actualizar_total
AFTER INSERT ON item_pedido
FOR EACH ROW
BEGIN
  UPDATE pedidos
  SET total = fn_total_pedido(NEW.id_pedido)
  WHERE id_pedido = NEW.id_pedido;
END//
DELIMITER ;