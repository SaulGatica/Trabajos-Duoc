
-- Oracle Cloud 

--------------------------------------------------
-- CREACIÓN DE USUARIOS
--------------------------------------------------

CREATE USER PRY2205_EFT IDENTIFIED BY "Duoc2025##EFT"
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA 10M ON USERS;

CREATE USER PRY2205_EFT_DES IDENTIFIED BY "Duoc2025##DES"
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA 5M ON USERS;

CREATE USER PRY2205_EFT_CON IDENTIFIED BY "Duoc2025##CON"
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA 5M ON USERS;

--------------------------------------------------
-- CREACIÓN DE ROLES
--------------------------------------------------

CREATE ROLE PRY2205_ROL_D;
CREATE ROLE PRY2205_ROL_C;

--------------------------------------------------
-- PRIVILEGIOS BÁSICOS (OBLIGATORIOS)
--------------------------------------------------

GRANT CREATE SESSION 
TO PRY2205_EFT, PRY2205_EFT_DES, PRY2205_EFT_CON;

--------------------------------------------------
-- PRIVILEGIOS DEL DUEÑO DEL ESQUEMA
--------------------------------------------------

GRANT CREATE TABLE,
      CREATE VIEW,
      CREATE SEQUENCE,
      CREATE SYNONYM
TO PRY2205_EFT;

--------------------------------------------------
-- PRIVILEGIOS POR ROL
--------------------------------------------------

-- Rol desarrollador
GRANT CREATE VIEW TO PRY2205_ROL_D;
GRANT PRY2205_ROL_D TO PRY2205_EFT_DES;

-- Rol consultor
GRANT PRY2205_ROL_C TO PRY2205_EFT_CON;

--------------------------------------------------
-- CONFIRMACIÓN
--------------------------------------------------


--------------------------------------------------
-- 02_OWNER_Casos2y3_PRY2205.sql
-- Ejecutar como usuario PRY2205_EFT

--------------------------------------------------

ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';

-- Sinónimos públicos
CREATE PUBLIC SYNONYM PROFESIONAL FOR PRY2205_EFT.PROFESIONAL;
CREATE PUBLIC SYNONYM EMPRESA FOR PRY2205_EFT.EMPRESA;
CREATE PUBLIC SYNONYM ASESORIA FOR PRY2205_EFT.ASESORIA;
CREATE PUBLIC SYNONYM CARTOLA_PROFESIONALES FOR PRY2205_EFT.CARTOLA_PROFESIONALES;



--------------------------------------------------
-- CASO 2 – CARTOLA PROFESIONALES
--------------------------------------------------
SHOW USER

ALTER SESSION DISABLE PARALLEL DML;
DELETE FROM CARTOLA_PROFESIONALES;
COMMIT;
INSERT INTO CARTOLA_PROFESIONALES
SELECT
 p.RUTPROF,
 p.NOMPRO || ' ' || p.APPPRO || ' ' || p.APMPRO,
 pr.NOMPROFESION,
 i.NOMISAPRE,
 p.SUELDO,
 NVL(p.COMISION,0),
 (p.SUELDO * NVL(p.COMISION,0) / 100),
 r.HONOR_PCT,
 t.INCENTIVO * 1000,
 (
   p.SUELDO
   + (p.SUELDO * NVL(p.COMISION,0) / 100)
   + (p.SUELDO * r.HONOR_PCT / 100)
   + (t.INCENTIVO * 1000)
 )
FROM PROFESIONAL p
JOIN PROFESION pr ON p.IDPROFESION = pr.IDPROFESION
JOIN ISAPRE i ON p.IDISAPRE = i.IDISAPRE
JOIN TIPO_CONTRATO t ON p.IDTCONTRATO = t.IDTCONTRATO
JOIN RANGOS_SUELDOS r ON p.SUELDO BETWEEN r.S_MIN AND r.S_MAX;

COMMIT;

SELECT
    "A1"."RUT_PROFESIONAL"    "RUT_PROFESIONAL",
    "A1"."NOMBRE_PROFESIONAL" "NOMBRE_PROFESIONAL",
    "A1"."PROFESION"          "PROFESION",
    "A1"."SUELDO_BASE"        "SUELDO_BASE",
    "A1"."TOTAL_PAGAR"        "TOTAL_PAGAR"
FROM
    "PRY2205_EFT"."CARTOLA_PROFESIONALES" "A1"
ORDER BY
    "A1"."PROFESION",
    "A1"."TOTAL_PAGAR" DESC;

--------------------------------------------------
-- CASO 3.1 – VISTA EMPRESAS ASESORADAS
--------------------------------------------------

CREATE OR REPLACE VIEW VW_EMPRESAS_ASESORADAS AS
SELECT
 e.RUT_EMPRESA || '-' || e.DV_EMPRESA               AS RUT_EMPRESA,
 e.NOMEMPRESA                                      AS NOMBRE_EMPRESA,
 TRUNC(MONTHS_BETWEEN(SYSDATE, e.FECHA_INICIACION_ACTIVIDADES)/12)
                                                    AS ANIOS_ANTIGUEDAD,
 e.IVA_DECLARADO                                   AS IVA_DECLARADO,
 COUNT(a.IDEMPRESA)/12                             AS PROM_ASESORIAS_ANUAL,
 (e.IVA_DECLARADO * COUNT(a.IDEMPRESA) / 12 / 100) AS BENEFICIO_ANUAL,
 CASE
   WHEN COUNT(a.IDEMPRESA)/12 > 5 THEN 'CLIENTE PREMIUM'
   WHEN COUNT(a.IDEMPRESA)/12 BETWEEN 3 AND 5 THEN 'CLIENTE'
   ELSE 'CLIENTE POCO CONCURRIDO'
 END                                               AS CLASIFICACION_CLIENTE,
 CASE
   WHEN COUNT(a.IDEMPRESA) >= 7 THEN '1 ASESORIA GRATIS'
   WHEN COUNT(a.IDEMPRESA) >= 5 THEN '30% DESCUENTO'
   ELSE 'CAPTAR CLIENTE'
 END                                               AS BENEFICIO_COMERCIAL
FROM EMPRESA e
JOIN ASESORIA a ON e.IDEMPRESA = a.IDEMPRESA
WHERE EXTRACT(YEAR FROM a.FIN) = EXTRACT(YEAR FROM SYSDATE) - 1
GROUP BY
 e.RUT_EMPRESA,
 e.DV_EMPRESA,
 e.NOMEMPRESA,
 e.FECHA_INICIACION_ACTIVIDADES,
 e.IVA_DECLARADO;

--------------------------------------------------
-- CASO 3.2 – ÍNDICES
--------------------------------------------------

CREATE INDEX IDX_ASESORIA_FECHA ON ASESORIA(FIN);
CREATE INDEX IDX_ASESORIA_EMPRESA ON ASESORIA(IDEMPRESA);


