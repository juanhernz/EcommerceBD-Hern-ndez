DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- TABLAS MAESTRAS

CREATE TABLE categorias (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE,
  descripcion TEXT
);

CREATE TABLE promociones (
  id_promocion INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  tipo ENUM('PORCENTAJE','FIJO') NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  fecha_inicio DATE NULL,
  fecha_fin DATE NULL,
  activa BOOLEAN DEFAULT TRUE
);

CREATE TABLE medios_pago (
  id_medio_pago INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE,
  descripcion TEXT
);

-- LOGÍSTICA

CREATE TABLE operadores_logisticos (
  id_operador INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL UNIQUE,
  descripcion TEXT,
  activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE metodos_envio (
  id_metodo_envio INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE,
  costo DECIMAL(10,2) NOT NULL,
  dias_estimados INT NOT NULL,
  descripcion TEXT
);

CREATE TABLE operador_metodo_envio (
  id_operador INT NOT NULL,
  id_metodo_envio INT NOT NULL,
  costo_extra DECIMAL(10,2) DEFAULT 0,
  dias_estimados_override INT NULL,
  PRIMARY KEY (id_operador, id_metodo_envio),
  FOREIGN KEY (id_operador) REFERENCES operadores_logisticos(id_operador),
  FOREIGN KEY (id_metodo_envio) REFERENCES metodos_envio(id_metodo_envio)
);

-- USUARIOS Y DIRECCIONES

CREATE TABLE usuarios (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100),
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE direcciones (
  id_direccion INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  calle VARCHAR(150),
  ciudad VARCHAR(80),
  provincia VARCHAR(80),
  codigo_postal VARCHAR(20),
  pais VARCHAR(80),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
);

-- PRODUCTOS Y PROMOCIONES

CREATE TABLE productos (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT,
  precio DECIMAL(10,2) NOT NULL,
  stock INT NOT NULL,
  sku VARCHAR(50) UNIQUE,
  id_categoria INT,
  FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE producto_promocion (
  id_producto INT NOT NULL,
  id_promocion INT NOT NULL,
  prioridad INT DEFAULT 1,
  combinable BOOLEAN DEFAULT FALSE,
  PRIMARY KEY (id_producto, id_promocion),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
  FOREIGN KEY (id_promocion) REFERENCES promociones(id_promocion)
);

-- ESTADOS Y PEDIDOS 

CREATE TABLE estados_pedido (
  id_estado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(30) NOT NULL UNIQUE,
  descripcion VARCHAR(150) NULL,
  es_final BOOLEAN DEFAULT FALSE
);

CREATE TABLE pedidos (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  id_direccion INT NOT NULL,
  id_medio_pago INT NOT NULL,
  id_metodo_envio INT NOT NULL,
  id_operador INT NULL,       -- se asigna cuando se despacha
  id_estado INT NOT NULL,
  total DECIMAL(12,2) DEFAULT 0,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  fecha_envio DATETIME NULL,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_direccion) REFERENCES direcciones(id_direccion),
  FOREIGN KEY (id_medio_pago) REFERENCES medios_pago(id_medio_pago),
  FOREIGN KEY (id_metodo_envio) REFERENCES metodos_envio(id_metodo_envio),
  FOREIGN KEY (id_operador) REFERENCES operadores_logisticos(id_operador),
  FOREIGN KEY (id_estado) REFERENCES estados_pedido(id_estado)
);

CREATE TABLE item_pedido (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unit DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
  UNIQUE (id_pedido, id_producto)
);

-- PAGOS Y DEVOLUCIONES

CREATE TABLE pagos (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  monto DECIMAL(12,2) NOT NULL,
  estado ENUM('pendiente','pagado','rechazado','devuelto') DEFAULT 'pendiente',
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);

CREATE TABLE devoluciones (
  id_devolucion INT AUTO_INCREMENT PRIMARY KEY,
  id_pago INT NOT NULL,
  motivo TEXT,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_pago) REFERENCES pagos(id_pago)
);

-- AUDITORÍA

CREATE TABLE historial_estado_pedido (
  id_historial INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_estado_anterior INT NULL,
  id_estado_nuevo INT NULL,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
  FOREIGN KEY (id_estado_anterior) REFERENCES estados_pedido(id_estado),
  FOREIGN KEY (id_estado_nuevo) REFERENCES estados_pedido(id_estado)
);

-- TABLA DE HECHOS

CREATE TABLE fact_ventas (
  id_fact INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_item INT NOT NULL,
  id_usuario INT NOT NULL,
  id_producto INT NOT NULL,
  id_categoria INT NULL,
  fecha DATETIME NOT NULL,
  cantidad INT NOT NULL,
  precio_unit DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(12,2) NOT NULL,
  id_medio_pago INT NOT NULL,
  id_metodo_envio INT NOT NULL,
  id_operador INT NULL,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
  FOREIGN KEY (id_item) REFERENCES item_pedido(id_item),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
  FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
  FOREIGN KEY (id_medio_pago) REFERENCES medios_pago(id_medio_pago),
  FOREIGN KEY (id_metodo_envio) REFERENCES metodos_envio(id_metodo_envio),
  FOREIGN KEY (id_operador) REFERENCES operadores_logisticos(id_operador),
  UNIQUE (id_item)
);

-- FUNCIONES

DELIMITER //

CREATE FUNCTION fn_total_pedido(p_id_pedido INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  RETURN IFNULL((
    SELECT SUM(cantidad * precio_unit)
    FROM item_pedido
    WHERE id_pedido = p_id_pedido
  ), 0);
END //

CREATE FUNCTION fn_total_pedido_con_envio(p_id_pedido INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  DECLARE v_envio DECIMAL(10,2);

  SELECT m.costo INTO v_envio
  FROM pedidos p
  JOIN metodos_envio m ON p.id_metodo_envio = m.id_metodo_envio
  WHERE p.id_pedido = p_id_pedido;

  RETURN fn_total_pedido(p_id_pedido) + IFNULL(v_envio, 0);
END //

CREATE FUNCTION fn_stock_disponible(p_id_producto INT)
RETURNS INT
DETERMINISTIC
BEGIN
  RETURN IFNULL((SELECT stock FROM productos WHERE id_producto = p_id_producto), 0);
END //

CREATE FUNCTION fn_promocion_activa(p_id_promocion INT)
RETURNS BOOLEAN
NOT DETERMINISTIC
READS SQL DATA
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM promociones pr
    WHERE pr.id_promocion = p_id_promocion
      AND pr.activa = TRUE
      AND (pr.fecha_inicio IS NULL OR CURDATE() >= pr.fecha_inicio)
      AND (pr.fecha_fin IS NULL OR CURDATE() <= pr.fecha_fin)
  );
END //

CREATE FUNCTION fn_producto_en_promocion(p_id_producto INT)
RETURNS BOOLEAN
NOT DETERMINISTIC
READS SQL DATA
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM producto_promocion pp
    JOIN promociones pr ON pr.id_promocion = pp.id_promocion
    WHERE pp.id_producto = p_id_producto
      AND fn_promocion_activa(pr.id_promocion) = TRUE
  );
END //

CREATE FUNCTION fn_envio_estimado_pedido(p_id_pedido INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_dias INT;

  SELECT COALESCE(ome.dias_estimados_override, me.dias_estimados)
    INTO v_dias
  FROM pedidos p
  JOIN metodos_envio me ON me.id_metodo_envio = p.id_metodo_envio
  LEFT JOIN operador_metodo_envio ome
    ON ome.id_operador = p.id_operador
   AND ome.id_metodo_envio = p.id_metodo_envio
  WHERE p.id_pedido = p_id_pedido;

  RETURN IFNULL(v_dias, 0);
END //

DELIMITER ;

-- 10) TRIGGERS

DELIMITER //

CREATE TRIGGER trg_control_stock
BEFORE INSERT ON item_pedido
FOR EACH ROW
BEGIN
  IF fn_stock_disponible(NEW.id_producto) < NEW.cantidad THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Stock insuficiente';
  END IF;

  UPDATE productos
  SET stock = stock - NEW.cantidad
  WHERE id_producto = NEW.id_producto;
END //

CREATE TRIGGER trg_actualizar_total_ai
AFTER INSERT ON item_pedido
FOR EACH ROW
BEGIN
  UPDATE pedidos
  SET total = fn_total_pedido(NEW.id_pedido)
  WHERE id_pedido = NEW.id_pedido;
END //

CREATE TRIGGER trg_historial_estado
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
  IF OLD.id_estado <> NEW.id_estado THEN
    INSERT INTO historial_estado_pedido
      (id_pedido, id_estado_anterior, id_estado_nuevo)
    VALUES
      (NEW.id_pedido, OLD.id_estado, NEW.id_estado);
  END IF;
END //

CREATE TRIGGER trg_devolver_stock_ad
AFTER DELETE ON item_pedido
FOR EACH ROW
BEGIN
  UPDATE productos
  SET stock = stock + OLD.cantidad
  WHERE id_producto = OLD.id_producto;

  UPDATE pedidos
  SET total = fn_total_pedido(OLD.id_pedido)
  WHERE id_pedido = OLD.id_pedido;
END //

CREATE TRIGGER trg_fact_ventas_ai
AFTER INSERT ON item_pedido
FOR EACH ROW
BEGIN
  INSERT INTO fact_ventas
    (id_pedido, id_item, id_usuario, id_producto, id_categoria, fecha,
     cantidad, precio_unit, subtotal, id_medio_pago, id_metodo_envio, id_operador)
  SELECT
    p.id_pedido,
    NEW.id_item,
    p.id_usuario,
    pr.id_producto,
    pr.id_categoria,
    p.fecha,
    NEW.cantidad,
    NEW.precio_unit,
    (NEW.cantidad * NEW.precio_unit),
    p.id_medio_pago,
    p.id_metodo_envio,
    p.id_operador
  FROM pedidos p
  JOIN productos pr ON pr.id_producto = NEW.id_producto
  WHERE p.id_pedido = NEW.id_pedido;
END //

DELIMITER ;

-- STORED PROCEDURES

DELIMITER //

CREATE PROCEDURE sp_crear_pedido(
  IN p_id_usuario INT,
  IN p_id_direccion INT,
  IN p_id_medio_pago INT,
  IN p_id_metodo_envio INT
)
BEGIN
  DECLARE v_estado INT;

  SELECT id_estado INTO v_estado
  FROM estados_pedido
  WHERE nombre = 'carrito';

  IF v_estado IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Falta cargar estados_pedido (ej: carrito)';
  END IF;

  INSERT INTO pedidos
    (id_usuario, id_direccion, id_medio_pago, id_metodo_envio, id_estado)
  VALUES
    (p_id_usuario, p_id_direccion, p_id_medio_pago, p_id_metodo_envio, v_estado);

  SELECT LAST_INSERT_ID() AS id_pedido_creado;
END //

CREATE PROCEDURE sp_agregar_item_pedido(
  IN p_id_pedido INT,
  IN p_id_producto INT,
  IN p_cantidad INT
)
BEGIN
  DECLARE v_precio DECIMAL(10,2);

  SELECT precio INTO v_precio
  FROM productos
  WHERE id_producto = p_id_producto;

  IF v_precio IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Producto inexistente';
  END IF;

  INSERT INTO item_pedido
    (id_pedido, id_producto, cantidad, precio_unit)
  VALUES
    (p_id_pedido, p_id_producto, p_cantidad, v_precio);
END //

CREATE PROCEDURE sp_quitar_item_pedido(
  IN p_id_pedido INT,
  IN p_id_producto INT
)
BEGIN
  DELETE FROM item_pedido
  WHERE id_pedido = p_id_pedido
    AND id_producto = p_id_producto;
END //

CREATE PROCEDURE sp_confirmar_pedido(IN p_id_pedido INT)
BEGIN
  DECLARE v_estado INT;

  SELECT id_estado INTO v_estado
  FROM estados_pedido
  WHERE nombre = 'confirmado';

  IF v_estado IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Falta cargar estados_pedido (ej: confirmado)';
  END IF;

  UPDATE pedidos
  SET id_estado = v_estado
  WHERE id_pedido = p_id_pedido;
END //

CREATE PROCEDURE sp_enviar_pedido(
  IN p_id_pedido INT,
  IN p_id_operador INT
)
BEGIN
  DECLARE v_estado INT;

  SELECT id_estado INTO v_estado
  FROM estados_pedido
  WHERE nombre = 'enviado';

  IF v_estado IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Falta cargar estados_pedido (ej: enviado)';
  END IF;

  UPDATE pedidos
  SET id_estado = v_estado,
      id_operador = p_id_operador,
      fecha_envio = NOW()
  WHERE id_pedido = p_id_pedido;
END //

CREATE PROCEDURE sp_registrar_devolucion(
  IN p_id_pago INT,
  IN p_motivo TEXT
)
BEGIN
  INSERT INTO devoluciones (id_pago, motivo)
  VALUES (p_id_pago, p_motivo);

  UPDATE pagos
  SET estado = 'devuelto'
  WHERE id_pago = p_id_pago;
END //

DELIMITER ;

-- VISTAS

CREATE VIEW vw_ventas_por_usuario AS
SELECT
  u.id_usuario,
  u.nombre,
  u.apellido,
  COUNT(DISTINCT p.id_pedido) AS pedidos,
  SUM(p.total) AS total_gastado
FROM usuarios u
JOIN pedidos p ON p.id_usuario = u.id_usuario
GROUP BY u.id_usuario;

CREATE VIEW vw_productos_stock_bajo AS
SELECT
  id_producto,
  nombre,
  stock
FROM productos
WHERE stock < 10;

CREATE VIEW vw_detalle_pedidos AS
SELECT
  p.id_pedido,
  u.email,
  ep.nombre AS estado,
  pr.nombre AS producto,
  i.cantidad,
  i.precio_unit,
  (i.cantidad * i.precio_unit) AS subtotal
FROM pedidos p
JOIN usuarios u ON u.id_usuario = p.id_usuario
JOIN estados_pedido ep ON ep.id_estado = p.id_estado
JOIN item_pedido i ON i.id_pedido = p.id_pedido
JOIN productos pr ON pr.id_producto = i.id_producto;

CREATE VIEW vw_promociones_activas AS
SELECT
  id_promocion,
  nombre,
  tipo,
  valor
FROM promociones
WHERE activa = TRUE
  AND (fecha_inicio IS NULL OR CURDATE() >= fecha_inicio)
  AND (fecha_fin IS NULL OR CURDATE() <= fecha_fin);

CREATE VIEW vw_envios AS
SELECT
  p.id_pedido,
  me.nombre AS metodo_envio,
  me.costo,
  ol.nombre AS operador,
  fn_envio_estimado_pedido(p.id_pedido) AS dias_estimados
FROM pedidos p
JOIN metodos_envio me ON me.id_metodo_envio = p.id_metodo_envio
LEFT JOIN operadores_logisticos ol ON ol.id_operador = p.id_operador;