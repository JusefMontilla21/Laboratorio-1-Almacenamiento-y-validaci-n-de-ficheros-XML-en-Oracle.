SET SERVEROUTPUT ON

INSERT INTO departamentos_xml (doc) VALUES (
  XMLTYPE('<departamentos>
  <departamento id="10" nombre="Administration">
    <empleados>
      <empleado id="200">
        <nombre>Jennifer</nombre>
        <apellido>Whalen</apellido>
        <email>JWHALEN</email>
        <salario>4400</salario>
        <fecha_contratacion>2003-09-17</fecha_contratacion>
      </empleado>
    </empleados>
  </departamento>
</departamentos>'));
COMMIT;

INSERT INTO departamentos_xml (doc) VALUES (
  XMLTYPE('<departamentos>
  <departamento id="10">
    <empleados>
      <empleado id="200">
        <nombre>Jennifer</nombre>
        <email>JWHALEN</email>
        <salario>abc</salario>
        <fecha_contratacion>2003-09-17</fecha_contratacion>
      </empleado>
    </empleados>
  </departamento>
</departamentos>'));

SELECT id, XMLSERIALIZE(DOCUMENT doc AS CLOB INDENT SIZE = 2) AS doc FROM departamentos_xml;
