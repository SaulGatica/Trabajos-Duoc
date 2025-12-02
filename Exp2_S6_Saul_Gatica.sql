
   ---CASO 1 
SELECT
       p.id_profesional                            AS "ID PROFESIONAL",
       INITCAP(p.apellido_paterno || ' ' ||
               p.apellido_materno || ' ' ||
               p.nombre)                            AS "NOMBRE_COMPLETO",
       COUNT(a.id_asesoria)                         AS "NRO_ASESORIA_BANCA",
       SUM(a.honorario)                             AS "MONTO_TOTAL_BANCA",
       0                                            AS "NRO_ASESORIA_RETAIL",
       0                                            AS "MONTO_TOTAL_RETAIL"
FROM profesional p
JOIN asesoria a
      ON p.id_profesional = a.id_profesional
WHERE a.id_sector = 3
GROUP BY p.id_profesional, p.apellido_paterno, p.apellido_materno, p.nombre, 0

UNION ALL

SELECT
       p.id_profesional                            AS "ID PROFESIONAL",
       INITCAP(p.apellido_paterno || ' ' ||
               p.apellido_materno || ' ' ||
               p.nombre)                            AS "NOMBRE_COMPLETO",
       0                                            AS "NRO_ASESORIA_BANCA",
       0                                            AS "MONTO_TOTAL_BANCA",
       COUNT(a.id_asesoria)                         AS "NRO_ASESORIA_RETAIL",
       SUM(a.honorario)                             AS "MONTO_TOTAL_RETAIL"
FROM profesional p
JOIN asesoria a
      ON p.id_profesional = a.id_profesional
WHERE a.id_sector = 4
GROUP BY p.id_profesional, p.apellido_paterno, p.apellido_materno, p.nombre, 0

GROUP BY "ID PROFESIONAL", "NOMBRE_COMPLETO"
HAVING SUM("NRO_ASESORIA_BANCA") > 0
   AND SUM("NRO_ASESORIA_RETAIL") > 0
ORDER BY "ID PROFESIONAL" ASC;


0=/* -------------------------------------------------------------
   CASO 1 – Reportería de Asesorías Banca (3) y Retail (4)
   Cumple: SET, subconsultas, funciones, JOINs, agrupaciones,
           ordenamiento y alias requeridos.
 ------------------------------------------------------------- */

/* Subconsulta A: Asesorías del sector BANCA (código 3)  */
SELECT
       p.id_profesional                            AS "ID PROFESIONAL",
       INITCAP(p.apellido_paterno || ' ' ||
               p.apellido_materno || ' ' ||
               p.nombre)                            AS "NOMBRE_COMPLETO",
       COUNT(a.id_asesoria)                         AS "NRO_ASESORIA_BANCA",
       SUM(a.honorario)                             AS "MONTO_TOTAL_BANCA",
       0                                            AS "NRO_ASESORIA_RETAIL",
       0                                            AS "MONTO_TOTAL_RETAIL"
FROM profesional p
JOIN asesorias a
      ON p.id_profesional = a.id_profesional
WHERE a.id_sector = 3
GROUP BY p.id_profesional,
         p.apellido_paterno,
         p.apellido_materno,
         p.nombre

UNION ALL

/* Subconsulta B: Asesorías del sector RETAIL (código 4) */
SELECT
       p.id_profesional                            AS "ID PROFESIONAL",
       INITCAP(p.apellido_paterno || ' ' ||
               p.apellido_materno || ' ' ||
               p.nombre)                            AS "NOMBRE_COMPLETO",
       0                                            AS "NRO_ASESORIA_BANCA",
       0                                            AS "MONTO_TOTAL_BANCA",
       COUNT(a.id_asesoria)                         AS "NRO_ASESORIA_RETAIL",
       SUM(a.honorario)                             AS "MONTO_TOTAL_RETAIL"
FROM profesional p
JOIN asesorias a
      ON p.id_profesional = a.id_profesional
WHERE a.id_sector = 4
GROUP BY p.id_profesional,
         p.apellido_paterno,
         p.apellido_materno,
         p.nombre


) tmp
GROUP BY "ID PROFESIONAL", "NOMBRE_COMPLETO"
HAVING SUM("NRO_ASESORIA_BANCA") > 0
   AND SUM("NRO_ASESORIA_RETAIL") > 0
ORDER BY "ID PROFESIONAL" ASC;
/* -------------------------------------------------------------
   CASO 1 – Reportería de Asesorías Banca (3) y Retail (4)
   Cumple: SET, subconsultas, funciones, JOINs, agrupaciones,
           ordenamiento y alias requeridos.
 ------------------------------------------------------------- */

/* Subconsulta A: Asesorías del sector BANCA (código 3)  */
SELECT
       p.id_profesional                            AS "ID PROFESIONAL",
       INITCAP(p.apellido_paterno || ' ' ||
               p.apellido_materno || ' ' ||
               p.nombre)                            AS "NOMBRE_COMPLETO",
       COUNT(a.id_asesoria)                         AS "NRO_ASESORIA_BANCA",
       SUM(a.honorario)                             AS "MONTO_TOTAL_BANCA",
       0                                            AS "NRO_ASESORIA_RETAIL",
       0                                            AS "MONTO_TOTAL_RETAIL"
FROM profesional p
JOIN asesorias a
      ON p.id_profesional = a.id_profesional
WHERE a.id_sector = 3
GROUP BY p.id_profesional,
         p.apellido_paterno,
         p.apellido_materno,
         p.nombre

UNION ALL

/* Subconsulta B: Asesorías del sector RETAIL (código 4) */
SELECT
       p.id_profesional                            AS "ID PROFESIONAL",
       INITCAP(p.apellido_paterno || ' ' ||
               p.apellido_materno || ' ' ||
               p.nombre)                            AS "NOMBRE_COMPLETO",
       0                                            AS "NRO_ASESORIA_BANCA",
       0                                            AS "MONTO_TOTAL_BANCA",
       COUNT(a.id_asesoria)                         AS "NRO_ASESORIA_RETAIL",
       SUM(a.honorario)                             AS "MONTO_TOTAL_RETAIL"
FROM profesional p
JOIN asesorias a
      ON p.id_profesional = a.id_profesional
WHERE a.id_sector = 4
GROUP BY p.id_profesional,
         p.apellido_paterno,
         p.apellido_materno,
         p.nombre

) tmp
GROUP BY "ID PROFESIONAL", "NOMBRE_COMPLETO"
HAVING SUM("NRO_ASESORIA_BANCA") > 0
   AND SUM("NRO_ASESORIA_RETAIL") > 0
ORDER BY "ID PROFESIONAL" ASC;

======================================================================


/* ================================================================
   CASO 2 – CREACIÓN DE TABLA REPORTE_MES (DDL)
   ================================================================ */

DROP TABLE REPORTE_MES PURGE;

CREATE TABLE REPORTE_MES (
    ID_PROF               NUMBER,
    NOMBRE_COMPLETO       VARCHAR2(150),
    NOMBRE_PROFESION      VARCHAR2(150),
    NOM_COMUNA            VARCHAR2(150),
    NRO_ASESORIAS         NUMBER,
    MONTO_TOTAL_HONORARIOS NUMBER,
    PROMEDIO_HONORARIO    NUMBER,
    HONORARIO_MINIMO      NUMBER,
    HONORARIO_MAXIMO      NUMBER
);

/* ================================================================
  -- CASO 2

/* Fecha paramétrica de abril del año pasado */
INSERT INTO REPORTE_MES (
    ID_PROF, NOMBRE_COMPLETO, NOMBRE_PROFESION, NOM_COMUNA,
    NRO_ASESORIAS, MONTO_TOTAL_HONORARIOS, PROMEDIO_HONORARIO,
    HONORARIO_MINIMO, HONORARIO_MAXIMO
)
SELECT
    p.id_profesional AS ID_PROF,

    /* Nombre completo */
    INITCAP(p.apellido_paterno || ' ' ||
            p.apellido_materno || ' ' ||
            p.nombre) AS NOMBRE_COMPLETO,

    pr.nom_profesion AS NOMBRE_PROFESION,
    c.nom_comuna     AS NOM_COMUNA,

    /* Cantidad de asesorías en abril del año pasado */
    COUNT(a.id_asesoria) AS NRO_ASESORIAS,

    /* Monto total, promedio, mínimo y máximo, con redondeo */
    ROUND(SUM(a.honorario),0)     AS MONTO_TOTAL_HONORARIOS,
    ROUND(AVG(a.honorario),0)     AS PROMEDIO_HONORARIO,
    ROUND(MIN(a.honorario),0)     AS HONORARIO_MINIMO,
    ROUND(MAX(a.honorario),0)     AS HONORARIO_MAXIMO

FROM profesional p
JOIN asesorias a
      ON a.id_profesional = p.id_profesional
JOIN profesion pr
      ON pr.id_profesion = p.id_profesion
JOIN comuna c
      ON c.id_comuna = p.id_comuna


WHERE a.fecha_fin >= ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 92
  AND a.fecha_fin <  ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 122

GROUP BY p.id_profesional,
         p.apellido_paterno,
         p.apellido_materno,
         p.nombre,
         pr.nom_profesion,
         c.nom_comuna

ORDER BY p.id_profesional ASC;

================================================

/* ================================================================
   CASO 3 – REPORTE ANTES DEL AUMENTO
   ================================================================ */

SELECT
    SUM(a.honorario) AS HONORARIO,
    p.id_profesional,
    p.numrun_prof,
    p.sueldo
FROM profesional p
LEFT JOIN asesorias a
       ON p.id_profesional = a.id_profesional
WHERE a.fecha_fin >= ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 59
  AND a.fecha_fin <  ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 90
GROUP BY p.id_profesional, p.numrun_prof, p.sueldo
ORDER BY p.id_profesional;

/* ================================================================
   CASO 3 – ACTUALIZACIÓN DEL SUELDO (DML)
   ================================================================ */

UPDATE profesional p
SET p.sueldo =
    CASE
       WHEN (SELECT SUM(a.honorario)
             FROM asesorias a
             WHERE a.id_profesional = p.id_profesional
               AND a.fecha_fin >= ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 59
               AND a.fecha_fin <  ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 90
            ) < 1000000
       THEN ROUND(p.sueldo * 1.10)

       WHEN (SELECT SUM(a.honorario)
             FROM asesorias a
             WHERE a.id_profesional = p.id_profesional
               AND a.fecha_fin >= ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 59
               AND a.fecha_fin <  ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 90
            ) >= 1000000
       THEN ROUND(p.sueldo * 1.15)
    END
WHERE EXISTS (
    SELECT 1
    FROM asesorias a
    WHERE a.id_profesional = p.id_profesional
      AND a.fecha_fin >= ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 59
      AND a.fecha_fin <  ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 90
);

/* ================================================================
   CASO 3 – REPORTE DESPUÉS DEL AUMENTO
   ================================================================ */

SELECT
    SUM(a.honorario) AS HONORARIO,
    p.id_profesional,
    p.numrun_prof,
    p.sueldo
FROM profesional p
LEFT JOIN asesorias a
       ON p.id_profesional = a.id_profesional
WHERE a.fecha_fin >= ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 59
  AND a.fecha_fin <  ADD_MONTHS(TRUNC(SYSDATE,'YYYY'), -12) + 90
GROUP BY p.id_profesional, p.numrun_prof, p.sueldo
ORDER BY p.id_profesional;
