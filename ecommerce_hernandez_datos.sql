USE ecommerce_db;

-- ESTADOS

INSERT INTO estados_pedido (nombre, descripcion, es_final) VALUES
('carrito',    'Pedido en armado (carrito)', FALSE),
('confirmado', 'Pedido confirmado por el usuario', FALSE),
('pagado',     'Pago acreditado', FALSE),
('enviado',    'Pedido despachado', FALSE),
('cancelado',  'Pedido cancelado', TRUE);

-- LOGÍSTICA

INSERT INTO operadores_logisticos (nombre, descripcion, activo) VALUES
('correo1', 'Operador logístico genérico 1', TRUE),
('correo2', 'Operador logístico genérico 2', TRUE),
('correo3', 'Operador logístico genérico 3', TRUE);

INSERT INTO metodos_envio (nombre, costo, dias_estimados, descripcion) VALUES
('Sucursal',   1200, 4,  'Entrega en sucursal'),
('Domicilio',  2000, 5,  'Entrega a domicilio'),
('Express',    3500, 2,  'Entrega rápida'),
('Aéreo',      5000, 7,  'Envío aéreo / internacional');

INSERT INTO operador_metodo_envio (id_operador, id_metodo_envio, costo_extra, dias_estimados_override) VALUES
(1,1,0,NULL),(1,2,0,NULL),(1,3,500,2),(1,4,800,6),
(2,1,0,3), (2,2,200,4),(2,3,0,NULL),(2,4,1000,7),
(3,1,0,NULL),(3,2,0,NULL),(3,3,700,2),(3,4,500,6);


-- MAESTRAS

INSERT INTO categorias (nombre, descripcion) VALUES
('Tecnología','Electrónica y computación'),
('Hogar','Artículos para el hogar'),
('Electrodomésticos','Línea blanca y pequeños electrodomésticos'),
('Gaming','Accesorios y periféricos gamer'),
('Audio','Sonido y accesorios'),
('Video','TV y video'),
('Oficina','Oficina y estudio'),
('Celulares','Smartphones y accesorios'),
('Fotografía','Cámaras y lentes'),
('Deportes','Artículos deportivos'),
('Moda','Indumentaria'),
('Accesorios','Accesorios varios');

INSERT INTO promociones (nombre, descripcion, tipo, valor, fecha_inicio, fecha_fin, activa) VALUES
('Black Friday','Descuento general',        'PORCENTAJE',20, '2025-01-01','2025-12-31', TRUE),
('Cyber Week',  'Promo online',             'PORCENTAJE',15, '2025-05-01','2025-05-07', TRUE),
('Descuento Fijo','Monto fijo por compra',  'FIJO',     5000,'2025-01-01','2025-12-31', TRUE),
('Liquidación', 'Fin de temporada',         'PORCENTAJE',30, '2025-02-01','2025-02-15', TRUE),
('Promo Bancaria','Beneficio bancario',     'FIJO',     3000,'2025-03-01','2025-03-31', FALSE);

INSERT INTO medios_pago (nombre, descripcion) VALUES
('Tarjeta', 'Crédito / Débito'),
('Transferencia', 'Transferencia bancaria'),
('Efectivo', 'Pago en efectivo'),
('Billetera Virtual', 'Billetera virtual (MP y similares)');

-- USUARIOS

INSERT INTO usuarios (nombre, apellido, email, password_hash) VALUES
('Juan','Pérez','juan1@mail.com','hash'),
('Ana','Gómez','ana@mail.com','hash'),
('Luis','Martínez','luis@mail.com','hash'),
('Carla','Díaz','carla@mail.com','hash'),
('Pedro','López','pedro@mail.com','hash'),
('Lucía','Fernández','lucia@mail.com','hash'),
('Marcos','Suárez','marcos@mail.com','hash'),
('Sofía','Romero','sofia@mail.com','hash'),
('Diego','Torres','diego@mail.com','hash'),
('Laura','Vega','laura@mail.com','hash'),
('Nicolás','Ríos','nico@mail.com','hash'),
('Florencia','Méndez','flor@mail.com','hash'),
('Jorge','Castro','jorge@mail.com','hash'),
('Micaela','Paz','mica@mail.com','hash'),
('Matías','Herrera','mati@mail.com','hash'),
('Valeria','Silva','vale@mail.com','hash'),
('Gonzalo','Acosta','gonza@mail.com','hash'),
('Paula','Navarro','paula@mail.com','hash'),
('Ramiro','Luna','ramiro@mail.com','hash'),
('Camila','Benítez','cami@mail.com','hash'),
('Esteban','Morales','esteban@mail.com','hash'),
('Agustina','Peralta','agus@mail.com','hash'),
('Federico','Cano','fede@mail.com','hash'),
('Julieta','Sosa','juli@mail.com','hash'),
('Hernán','Ortiz','hernan@mail.com','hash');

-- DIRECCIONES

INSERT INTO direcciones (id_usuario, calle, ciudad, provincia, codigo_postal, pais) VALUES
(1,'Av Siempre Viva 123','Buenos Aires','BA','1000','Argentina'),
(1,'Calle Secundaria 456','Buenos Aires','BA','1001','Argentina'),
(2,'San Martín 789','Córdoba','CBA','5000','Argentina'),
(3,'Belgrano 101','Rosario','SF','2000','Argentina'),
(4,'Mitre 222','Mendoza','MZA','5500','Argentina'),
(5,'Sarmiento 333','La Plata','BA','1900','Argentina'),
(6,'Rivadavia 444','Salta','SAL','4400','Argentina'),
(7,'Independencia 555','Tucumán','TUC','4000','Argentina'),
(8,'9 de Julio 666','Neuquén','NQN','8300','Argentina'),
(9,'Italia 777','Mar del Plata','BA','7600','Argentina'),
(10,'España 888','San Juan','SJ','5400','Argentina'),
(11,'Chile 999','San Luis','SL','5700','Argentina'),
(12,'Uruguay 111','Santa Fe','SF','3000','Argentina'),
(13,'Perú 222','Corrientes','CRR','3400','Argentina'),
(14,'Paraguay 333','Posadas','MIS','3300','Argentina'),
(15,'Brasil 444','Resistencia','CHA','3500','Argentina'),
(16,'Bolivia 555','Formosa','FOR','3600','Argentina'),
(17,'Ecuador 666','Jujuy','JUJ','4600','Argentina'),
(18,'Colombia 777','La Rioja','LR','5300','Argentina'),
(19,'Venezuela 888','Catamarca','CAT','4700','Argentina'),
(20,'México 999','San Rafael','MZA','5600','Argentina'),
(21,'Panamá 111','Villa María','CBA','5900','Argentina'),
(22,'Honduras 222','Río Cuarto','CBA','5800','Argentina'),
(23,'Costa Rica 333','Pergamino','BA','2700','Argentina'),
(24,'Guatemala 444','Chivilcoy','BA','6620','Argentina'),
(25,'Nicaragua 555','Junín','BA','6000','Argentina'),
(5,'Ruta 8 KM 50','Pilar','BA','1629','Argentina'),
(10,'Av Libertador 1234','CABA','BA','1425','Argentina'),
(15,'Diagonal Norte 432','CABA','BA','1008','Argentina'),
(20,'Av Colón 987','Córdoba','CBA','5001','Argentina');

-- PRODUCTOS

INSERT INTO productos (nombre, descripcion, precio, stock, sku, id_categoria) VALUES
('Notebook i5','Notebook 16GB RAM',650000,15,'NB01',1),
('Notebook i7','Notebook 32GB RAM',850000,10,'NB02',1),
('Mouse Gamer','RGB',12000,50,'MS01',4),
('Teclado Mecánico','Switch Blue',35000,30,'TK01',4),
('Auriculares BT','Bluetooth',22000,40,'AU01',5),
('Smart TV 55','4K UHD',550000,12,'TV01',6),
('Heladera','No Frost',780000,8,'HL01',3),
('Lavarropas','Carga frontal',690000,6,'LV01',3),
('Silla Oficina','Ergonómica',95000,25,'SO01',7),
('Escritorio','Madera',130000,18,'ES01',7),
('Celular Gama Media','128GB',320000,20,'CE01',8),
('Celular Gama Alta','256GB',620000,10,'CE02',8),
('Cámara Reflex','24MP',900000,5,'CA01',9),
('Lente 50mm','f1.8',180000,7,'LE01',9),
('Zapatillas','Running',110000,35,'ZA01',10),
('Pelota','Fútbol',25000,60,'PE01',10),
('Campera','Invierno',140000,22,'MO01',11),
('Remera','Algodón',35000,40,'MO02',11),
('Mochila','Urbana',75000,28,'AC01',12),
('Reloj','Digital',68000,15,'AC02',12),
('Tablet','10 pulgadas',210000,14,'TA01',1),
('Impresora','WiFi',175000,9,'IM01',7),
('Parlante','Portátil',89000,20,'PA01',5),
('Microondas','Digital',160000,11,'MI01',3),
('Freidora','Sin aceite',190000,13,'FR01',3),
('Joystick','Consola',85000,17,'JO01',4),
('Monitor 27','144Hz',310000,10,'MN01',1),
('Router','WiFi 6',125000,16,'RO01',1),
('Cargador USB-C','Carga rápida',18000,70,'CG01',12),
('Power Bank','20000mAh',45000,25,'PB01',12);

-- PRODUCTO_PROMOCION

INSERT INTO producto_promocion (id_producto, id_promocion, prioridad, combinable) VALUES
(1,1,1,FALSE),
(2,1,1,FALSE),
(3,2,1,TRUE),
(5,3,1,FALSE),
(11,4,1,FALSE),
(15,5,1,FALSE),
(18,2,1,TRUE),
(20,3,1,FALSE);

-- CREACIÓN DE PEDIDOS

CALL sp_crear_pedido(1,  1, 1, 2);
CALL sp_crear_pedido(2,  3, 2, 1);
CALL sp_crear_pedido(3,  4, 1, 3);
CALL sp_crear_pedido(4,  5, 3, 2);
CALL sp_crear_pedido(5,  6, 1, 4);
CALL sp_crear_pedido(6,  7, 2, 2);
CALL sp_crear_pedido(7,  8, 1, 1);
CALL sp_crear_pedido(8,  9, 4, 3);
CALL sp_crear_pedido(9, 10, 1, 2);
CALL sp_crear_pedido(10,11, 2, 1);
CALL sp_crear_pedido(11,12, 1, 2);
CALL sp_crear_pedido(12,13, 3, 3);
CALL sp_crear_pedido(13,14, 1, 2);
CALL sp_crear_pedido(14,15, 2, 1);
CALL sp_crear_pedido(15,16, 4, 4);

-- ÍTEMS

CALL sp_agregar_item_pedido(1, 1, 1);
CALL sp_agregar_item_pedido(1, 3, 2);

CALL sp_agregar_item_pedido(2, 5, 1);

CALL sp_agregar_item_pedido(3, 7, 1);
CALL sp_agregar_item_pedido(3, 23, 1);

CALL sp_agregar_item_pedido(4, 10, 1);

CALL sp_agregar_item_pedido(5, 12, 1);

CALL sp_agregar_item_pedido(6, 15, 2);

CALL sp_agregar_item_pedido(7, 18, 1);
CALL sp_agregar_item_pedido(7, 20, 1);

CALL sp_agregar_item_pedido(8, 21, 1);

CALL sp_agregar_item_pedido(9, 22, 1);

CALL sp_agregar_item_pedido(10, 24, 1);

CALL sp_agregar_item_pedido(11, 26, 1);

CALL sp_agregar_item_pedido(12, 28, 1);

CALL sp_agregar_item_pedido(13, 30, 2);

CALL sp_agregar_item_pedido(14, 2, 1);

CALL sp_agregar_item_pedido(15, 4, 1);


-- CAMBIO DE ESTADOS 

CALL sp_confirmar_pedido(1);
CALL sp_confirmar_pedido(2);
CALL sp_confirmar_pedido(4);
CALL sp_confirmar_pedido(6);
CALL sp_confirmar_pedido(10);
CALL sp_confirmar_pedido(12);

CALL sp_enviar_pedido(3, 1);
CALL sp_enviar_pedido(6, 2);
CALL sp_enviar_pedido(9, 3);
CALL sp_enviar_pedido(15,1);

UPDATE pedidos
SET id_estado = (SELECT 
    id_estado
FROM
    estados_pedido WHERE nombre='pagado')
WHERE id_pedido IN (2,5,8,11,14);

-- PAGOS 

INSERT INTO pagos (id_pedido, monto, estado) VALUES
(2,  fn_total_pedido_con_envio(2),  'pagado'),
(5,  fn_total_pedido_con_envio(5),  'pagado'),
(8,  fn_total_pedido_con_envio(8),  'pagado'),
(11, fn_total_pedido_con_envio(11), 'pagado'),
(14, fn_total_pedido_con_envio(14), 'pagado'),
(1,  fn_total_pedido_con_envio(1),  'pendiente'),
(3,  fn_total_pedido_con_envio(3),  'pagado'),
(6,  fn_total_pedido_con_envio(6),  'pagado'),
(9,  fn_total_pedido_con_envio(9),  'pagado'),
(12, fn_total_pedido_con_envio(12), 'rechazado');

-- DEVOLUCIONES 

CALL sp_registrar_devolucion(3, 'Producto defectuoso');
CALL sp_registrar_devolucion(6, 'Arrepentimiento de compra');
CALL sp_registrar_devolucion(10,'Error en el envío / pago rechazado');


-- EJECUCIONES

SELECT 'VISTA: ventas por usuario' AS info;
SELECT * FROM vw_ventas_por_usuario;

SELECT 'VISTA: productos con stock bajo' AS info;
SELECT * FROM vw_productos_stock_bajo;

SELECT 'VISTA: detalle de pedidos' AS info;
SELECT * FROM vw_detalle_pedidos;

SELECT 'VISTA: promociones activas' AS info;
SELECT * FROM vw_promociones_activas;

SELECT 'VISTA: envíos' AS info;
SELECT * FROM vw_envios;

SELECT 'FACT: total registros fact_ventas' AS info;
SELECT COUNT(*) AS cant_fact_ventas FROM fact_ventas;

SELECT 'DEVOLUCIONES' AS info;
SELECT d.id_devolucion, d.id_pago, p.id_pedido, p.estado AS estado_pago, d.motivo, d.fecha
FROM devoluciones d
JOIN pagos p ON p.id_pago = d.id_pago
ORDER BY d.id_devolucion;