/* ================================================
   SEGURIDAD
   Usuario: ADMIN
   - Crear usuarios
   - Crear roles
   - Privilegios
   ==================================================== */

-- Creación de usuarios de trabajo
CREATE USER PRY2205_USER1 IDENTIFIED BY pry2205_1;
CREATE USER PRY2205_USER2 IDENTIFIED BY pry2205_2;

-- Privilegios conexión
GRANT CONNECT, RESOURCE TO PRY2205_USER1;
GRANT CONNECT TO PRY2205_USER2;

-- Creación de roles según responsabilidades
CREATE ROLE PRY2205_ROL_D; -- Dueño de datos
CREATE ROLE PRY2205_ROL_P; -- Usuario consulta/procesos

-- Asignación de privilegios al rol dueño
GRANT CREATE TABLE, CREATE VIEW, CREATE INDEX,
      CREATE SYNONYM, CREATE PUBLIC SYNONYM
TO PRY2205_ROL_D;

-- Asignación de privilegios al rol consulta
GRANT CREATE TABLE, CREATE SEQUENCE
TO PRY2205_ROL_P;

-- Asignación de roles a usuarios
GRANT PRY2205_ROL_D TO PRY2205_USER1;
GRANT PRY2205_ROL_P TO PRY2205_USER2;


/* =================================================
   SINÓNIMOS
   Usuario: PRY2205_USER1
   - Permitir acceso controlado sin exponer esquema
   ========================================================= */

-- Sinónimos públicos para acceso transparente
CREATE PUBLIC SYNONYM libro     FOR PRY2205_USER1.libro;
CREATE PUBLIC SYNONYM ejemplar  FOR PRY2205_USER1.ejemplar;
CREATE PUBLIC SYNONYM prestamo  FOR PRY2205_USER1.prestamo;
CREATE PUBLIC SYNONYM alumno    FOR PRY2205_USER1.alumno;
CREATE PUBLIC SYNONYM carrera   FOR PRY2205_USER1.carrera;
CREATE PUBLIC SYNONYM empleado  FOR PRY2205_USER1.empleado;


/* =========================================================
   CASO 2 – CONTROL DE STOCK
   Usuario: PRY2205_USER2
   - Crear secuencia
   - Generar reporte histórico (2 años atrás)
   =================================================*/

-- Secuencia para identificador correlativo
CREATE SEQUENCE SEQ_CONTROL_STOCK
START WITH 1
INCREMENT BY 1;

-- Tabla de control de stock bibliográfico
CREATE TABLE CONTROL_STOCK_LIBROS AS
SELECT
    SEQ_CONTROL_STOCK.NEXTVAL          AS correlativo,
    l.libroid                          AS id_libro,
    l.titulo                           AS nombre_libro,

    COUNT(e.ejemplarid)               AS total_ejemplares,

    COUNT(p.prestamoid)               AS ejemplares_prestados,

    COUNT(e.ejemplarid)
    - COUNT(p.prestamoid)             AS ejemplares_disponibles,

    -- Porcentaje de préstamos redondeado
    ROUND(
        (COUNT(p.prestamoid) /
         COUNT(e.ejemplarid)) * 100
    )                                 AS porcentaje_prestamo,

    -- Indicador de stock crítico
    CASE
        WHEN (COUNT(e.ejemplarid)
             - COUNT(p.prestamoid)) > 2
        THEN 'S'
        ELSE 'N'
    END                               AS stock_critico

FROM libro l
JOIN ejemplar e
  ON l.libroid = e.libroid

LEFT JOIN prestamo p
  ON e.libroid = p.libroid
 AND e.ejemplarid = p.ejemplarid
 AND EXTRACT(YEAR FROM p.fecha_prestamo) =
     EXTRACT(YEAR FROM SYSDATE) - 2
 AND p.empleadoid IN (150, 180, 190)

GROUP BY l.libroid, l.titulo
ORDER BY l.libroid;


/* ===============================================
   CASO 3 – VISTA DE MULTAS
   Usuario: PRY2205_USER1
   - Detectar atrasos
   - Calcular multa
   - Optimizar consultas
   ========================================================= */

CREATE OR REPLACE VIEW VW_DETALLE_MULTAS AS
SELECT
    p.prestamoid                       AS id_prestamo,

    a.nombre || ' ' ||
    a.ap_paterno || ' ' ||
    a.ap_materno                       AS nombre_alumno,

    c.nombre                           AS carrera,

    l.libroid                          AS codigo_libro,
    l.precio                           AS precio_libro,

    p.fecha_termino                    AS fecha_teorica,
    p.fecha_entrega                    AS fecha_real,

    -- Cálculo de días de atraso
    (p.fecha_entrega - p.fecha_termino)
                                       AS dias_atraso,

    -- Multa base (3% por día)
    ROUND(
        (p.fecha_entrega - p.fecha_termino)
        * l.precio * 0.03
    )                                  AS multa_calculada

FROM prestamo p
JOIN alumno a   ON p.alumnoid  = a.alumnoid
JOIN carrera c  ON a.carreraid = c.carreraid
JOIN libro l    ON p.libroid   = l.libroid

WHERE p.fecha_entrega > p.fecha_termino
AND EXTRACT(YEAR FROM p.fecha_termino) =
    EXTRACT(YEAR FROM SYSDATE) - 2

ORDER BY p.fecha_entrega DESC;


/* =========================================================
    ÍNDICES
    - Mejorar rendimiento 
   ========================================================= */

CREATE INDEX IDX_PRESTAMO_FECHAS
ON prestamo (fecha_termino, fecha_entrega);

CREATE INDEX IDX_PRESTAMO_ALUMNO
ON prestamo (alumnoid);

CREATE INDEX IDX_PRESTAMO_LIBRO
ON prestamo (libroid);




