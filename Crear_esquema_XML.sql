SET LONG 1000000
SET LINESIZE 200
SET PAGESIZE 0
SET LONGCHUNKSIZE 1000000
SET TRIMSPOOL ON

SPOOL departamentos.xml

SELECT XMLSERIALIZE(DOCUMENT
         XMLELEMENT("departamentos",
           XMLAGG(t.xml_dep ORDER BY t.department_id))
         AS CLOB INDENT SIZE = 2) AS xml_departamentos
FROM (
  SELECT d.department_id,
         XMLELEMENT("departamento",
           XMLATTRIBUTES(d.department_id   AS "id",
                         d.department_name AS "nombre"),
           XMLELEMENT("empleados",
             XMLAGG(
               XMLELEMENT("empleado",
                 XMLATTRIBUTES(e.employee_id AS "id"),
                 XMLFOREST(e.first_name AS "nombre",
                           e.last_name  AS "apellido",
                           e.email      AS "email",
                           e.salary     AS "salario",
                           TO_CHAR(e.hire_date, 'YYYY-MM-DD') AS "fecha_contratacion"))
               ORDER BY e.employee_id))) AS xml_dep
  FROM departments d
  JOIN employees e ON e.department_id = d.department_id
  GROUP BY d.department_id, d.department_name
) t;

SPOOL OFF
