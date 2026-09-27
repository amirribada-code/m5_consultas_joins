
-- Consulta 1 - Vista base del proyecto (INNER JOIN)

SELECT 
    v.fecha_venta AS fecha,
    v.id_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.ciudad AS region_cliente,
    p.id_producto,
    p.nombre_producto AS descripcion_producto,
    cat.nombre_categoria AS categoria_producto,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;
GO

-- Consulta 2 - Clientes sin ventas (LEFT JOIN)

SELECT
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
GO

-- Consulta 3 - Productos sin ventas (LEFT JOIN)

SELECT
    p.nombre_producto AS nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio AS precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;
GO

-- Consulta 4 - Consolidado por canal (UNION ALL)

SELECT 
    v.fecha_venta AS fecha,
    (v.cantidad * v.precio_unitario) AS total,
    'Online' AS canal
FROM ventas v
WHERE v.fecha_venta <= '2024-03-10'
UNION ALL
SELECT 
    v.fecha_venta AS fecha,
    (v.cantidad * v.precio_unitario) AS total,
    'Presencial' AS canal
FROM ventas v
WHERE v.fecha_venta > '2024-03-10';
GO

-- Total por canal con GROUP BY

SELECT canal, SUM(total) AS total_por_canal
FROM (
    SELECT (cantidad * precio_unitario) AS total, 'Online' AS canal FROM ventas WHERE fecha_venta <= '2024-03-10'
    UNION ALL
    SELECT (cantidad * precio_unitario) AS total, 'Presencial' AS canal FROM ventas WHERE fecha_venta > '2024-03-10'
) AS consolidado
GROUP BY canal;
