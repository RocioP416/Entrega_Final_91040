
-- 0. Limpieza previa por si ya existen
IF OBJECT_ID('ventas', 'U') IS NOT NULL DROP TABLE ventas;
IF OBJECT_ID('clientes', 'U') IS NOT NULL DROP TABLE clientes;
IF OBJECT_ID('productos', 'U') IS NOT NULL DROP TABLE productos;

-- 1. TABLA CLIENTES 
CREATE TABLE clientes (
    customer_id VARCHAR(50) PRIMARY KEY, 
    customer_name VARCHAR(100),
    segment VARCHAR(50));

INSERT INTO clientes (customer_id, customer_name, segment)
SELECT DISTINCT Customer_ID, Customer_Name, Segment
FROM superstore
WHERE Customer_ID IS NOT NULL AND Customer_Name IS NOT NULL;

-- 2. TABLA PRODUCTOS 
CREATE TABLE productos (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(50),
    sub_category VARCHAR(50));
INSERT INTO productos (product_id, product_name, category, sub_category)
SELECT 
    Product_ID, 
    MIN(Product_Name), 
    MIN(Category), 
    MIN(Sub_Category)
FROM superstore
WHERE Product_ID IS NOT NULL
GROUP BY Product_ID;

-- 3. TABLA VENTAS
CREATE TABLE ventas (
    venta_id INT PRIMARY KEY, 
    order_id VARCHAR(50),
    fecha_compra DATE,
    customer_id VARCHAR(50) FOREIGN KEY REFERENCES clientes(customer_id), 
    product_id VARCHAR(50) FOREIGN KEY REFERENCES productos(product_id),  
    total_venta DECIMAL(10,2));
INSERT INTO ventas (venta_id, order_id, fecha_compra, customer_id, product_id, total_venta)
SELECT 
    Row_ID, 
    Order_ID, 
    CAST(Order_Date AS DATE), 
    Customer_ID, 
    Product_ID, 
    Sales
FROM superstore
WHERE Order_Date IS NOT NULL AND Sales IS NOT NULL AND Customer_ID IS NOT NULL;

-- Ejercicio 1: Consulta SQL, ventas de los ultimos 30 días 
SELECT 
    c.customer_name,
    v.fecha_compra,
    v.total_venta
FROM ventas v
INNER JOIN clientes c ON v.customer_id = c.customer_id
WHERE v.fecha_compra >= DATEADD(day, -30, (SELECT MAX(fecha_compra) FROM ventas))
ORDER BY v.fecha_compra DESC;

SELECT * FROM ventas