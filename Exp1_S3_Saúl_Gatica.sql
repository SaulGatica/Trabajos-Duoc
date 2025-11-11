/* =============================================================
   ACTIVIDAD SUMATIVA S3 – APLICANDO FUNCIONES DE AGRUPACIÓN
   Módulo: PRY2205 – Experiencia 1
   Estudiante: Saúl Gatica
   Fecha: [coloca tu fecha actual]
   ============================================================= */


/* =============================================================
   CASO 1: LISTADO DE CLIENTES CON RANGO DE RENTA
   -------------------------------------------------------------
   Muestra los clientes con celular y dentro del rango de renta, clasificándolos por tramos.
   ============================================================= */

DEFINE renta_min = &Ingrese_renta_minima;
DEFINE renta_max = &Ingrese_renta_maxima;

SELECT 
    TO_CHAR(numrut_cli, '99G999G999') || '-' || dvrut_cli AS "RUT CLIENTE",
    INITCAP(nombre_cli || ' ' || appaterno_cli || ' ' || apmaterno_cli) AS "NOMBRE COMPLETO",
    direccion_cli AS "DIRECCIÓN",
    celular_cli AS "CELULAR",
    TO_CHAR(renta_cli, '$999G999') AS "RENTA",
    CASE 
        WHEN renta_cli > 500000 THEN 'TRAMO 1'
        WHEN renta_cli BETWEEN 400000 AND 500000 THEN 'TRAMO 2'
        WHEN renta_cli BETWEEN 200000 AND 399999 THEN 'TRAMO 3'
        ELSE 'TRAMO 4'
    END AS "CLASIFICACIÓN"
FROM cliente
WHERE celular_cli IS NOT NULL
  AND renta_cli BETWEEN &renta_min AND &renta_max
ORDER BY renta_cli DESC;


/* =============================================================
   CASO 2: SUELDO PROMEDIO POR CATEGORÍA DE EMPLEADO
   -------------------------------------------------------------
   Muestra la cantidad de empleados, sueldo promedio, 
   sueldo máximo y mínimo por categoría.
   ============================================================= */

SELECT
    "A1"."DESC_CATEGORIA_EMP_4" "CATEGORÍA DE EMPLEADO",
    COUNT("A1"."NUMRUT_EMP_0")  "CANTIDAD EMPLEADOS",
    to_char(
        avg("A1"."SUELDO_EMP_1"),
        '$999G999G990'
    )                           "SUELDO PROMEDIO",
    to_char(
        max("A1"."SUELDO_EMP_1"),
        '$999G999G990'
    )                           "SUELDO MÁXIMO",
    to_char(
        min("A1"."SUELDO_EMP_1"),
        '$999G999G990'
    )                           "SUELDO MÍNIMO"
FROM
    (
        SELECT
            "A3"."NUMRUT_EMP"         "NUMRUT_EMP_0",
            "A3"."SUELDO_EMP"         "SUELDO_EMP_1",
            "A3"."ID_CATEGORIA_EMP"   "QCSJ_C000000000300000",
            "A2"."ID_CATEGORIA_EMP"   "QCSJ_C000000000300001",
            "A2"."DESC_CATEGORIA_EMP" "DESC_CATEGORIA_EMP_4"
        FROM
            "ADMIN"."EMPLEADO"           "A3",
            "ADMIN"."CATEGORIA_EMPLEADO" "A2"
        WHERE
            "A3"."ID_CATEGORIA_EMP" = "A2"."ID_CATEGORIA_EMP"
    ) "A1"
GROUP BY
    "A1"."DESC_CATEGORIA_EMP_4", to_char( avg("A1"."SUELDO_EMP_1"), '$999G999G990' ), to_char( max("A1"."SUELDO_EMP_1"), '$999G999G990' ), to_char( min("A1"."SUELDO_EMP_1"), '$999G999G990' )
ORDER BY
    AVG("A1"."SUELDO_EMP_1") DESC;


/* =============================================================
   CASO 3: ARRIENDO PROMEDIO POR TIPO DE PROPIEDAD
   -------------------------------------------------------------
   Muestra el total de propiedades, cuántas están arrendadas, 
   cuántas disponibles, el valor promedio, así como máximo y mínimo 
   de arriendo por tipo de propiedad.
   ============================================================= */

SELECT
    "A1"."DESC_TIPO_PROPIEDAD_4"                                                  "TIPO DE PROPIEDAD",
    COUNT("A1"."QCSJ_C000000000500000_0")                                         "TOTAL PROPIEDADES",
    COUNT("A1"."QCSJ_C000000000500001_5")                                         "PROPIEDADES ARRENDADAS",
    COUNT("A1"."QCSJ_C000000000500000_0") - COUNT("A1"."QCSJ_C000000000500001_5") "PROPIEDADES DISPONIBLES",
    to_char(
        avg("A1"."VALOR_ARRIENDO_1"),
        '$999G999G990'
    )                                                                             "VALOR PROMEDIO ARRIENDO",
    to_char(
        max("A1"."VALOR_ARRIENDO_1"),
        '$999G999G990'
    )                                                                             "VALOR MÁXIMO ARRIENDO",
    to_char(
        min("A1"."VALOR_ARRIENDO_1"),
        '$999G999G990'
    )                                                                             "VALOR MÍNIMO ARRIENDO"
FROM
    (
        SELECT
            "A3"."NRO_PROPIEDAD_0"         "QCSJ_C000000000500000_0",
            "A3"."VALOR_ARRIENDO_1"        "VALOR_ARRIENDO_1",
            "A3"."QCSJ_C000000000300000_2" "QCSJ_C000000000300000",
            "A3"."QCSJ_C000000000300001_3" "QCSJ_C000000000300001",
            "A3"."DESC_TIPO_PROPIEDAD_4"   "DESC_TIPO_PROPIEDAD_4",
            "A2"."NRO_PROPIEDAD"           "QCSJ_C000000000500001_5"
        FROM
            (
                SELECT
                    "A5"."NRO_PROPIEDAD"       "NRO_PROPIEDAD_0",
                    "A5"."VALOR_ARRIENDO"      "VALOR_ARRIENDO_1",
                    "A5"."ID_TIPO_PROPIEDAD"   "QCSJ_C000000000300000_2",
                    "A4"."ID_TIPO_PROPIEDAD"   "QCSJ_C000000000300001_3",
                    "A4"."DESC_TIPO_PROPIEDAD" "DESC_TIPO_PROPIEDAD_4"
                FROM
                    "ADMIN"."PROPIEDAD"      "A5",
                    "ADMIN"."TIPO_PROPIEDAD" "A4"
                WHERE
                    "A5"."ID_TIPO_PROPIEDAD" = "A4"."ID_TIPO_PROPIEDAD"
            )                            "A3",
            "ADMIN"."ARRIENDO_PROPIEDAD" "A2"
        WHERE
            "A3"."NRO_PROPIEDAD_0" = "A2"."NRO_PROPIEDAD"
    ) "A1"
GROUP BY
    "A1"."DESC_TIPO_PROPIEDAD_4", to_char( avg("A1"."VALOR_ARRIENDO_1"), '$999G999G990' ), to_char( max("A1"."VALOR_ARRIENDO_1"), '$999G999G990' ), to_char( min("A1"."VALOR_ARRIENDO_1"), '$999G999G990' )
ORDER BY
    AVG("A1"."VALOR_ARRIENDO_1") DESC;
