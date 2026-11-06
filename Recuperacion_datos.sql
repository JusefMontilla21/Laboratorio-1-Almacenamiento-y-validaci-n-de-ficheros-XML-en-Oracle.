SET SERVEROUTPUT ON

BEGIN EXECUTE IMMEDIATE 'DROP TABLE departamentos_xml PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN DBMS_XMLSCHEMA.deleteSchema('http://localhost/hr/departamentos.xsd', DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE); EXCEPTION WHEN OTHERS THEN NULL; END;
/

BEGIN
  DBMS_XMLSCHEMA.registerSchema(
    schemaurl => 'http://localhost/hr/departamentos.xsd',
    schemadoc => XMLTYPE('<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified">
  <xs:element name="departamentos">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="departamento" type="tipoDepartamento" minOccurs="1" maxOccurs="unbounded"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
  <xs:complexType name="tipoDepartamento">
    <xs:sequence>
      <xs:element name="empleados" type="tipoEmpleados"/>
    </xs:sequence>
    <xs:attribute name="id" type="xs:positiveInteger" use="required"/>
    <xs:attribute name="nombre" type="xs:string" use="required"/>
  </xs:complexType>
  <xs:complexType name="tipoEmpleados">
    <xs:sequence>
      <xs:element name="empleado" type="tipoEmpleado" minOccurs="1" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>
  <xs:complexType name="tipoEmpleado">
    <xs:sequence>
      <xs:element name="nombre" type="xs:string" minOccurs="0"/>
      <xs:element name="apellido" type="xs:string"/>
      <xs:element name="email" type="xs:string"/>
      <xs:element name="salario" type="tipoSalario"/>
      <xs:element name="fecha_contratacion" type="xs:date"/>
    </xs:sequence>
    <xs:attribute name="id" type="xs:positiveInteger" use="required"/>
  </xs:complexType>
  <xs:simpleType name="tipoSalario">
    <xs:restriction base="xs:decimal">
      <xs:minExclusive value="0"/>
    </xs:restriction>
  </xs:simpleType>
</xs:schema>'),
    local   => TRUE,
    gentypes => FALSE,
    gentables => FALSE,
    force   => FALSE,
    owner   => USER,
    options => DBMS_XMLSCHEMA.REGISTER_BINARYXML);  -- necesario para STORE AS BINARY XML
  DBMS_OUTPUT.PUT_LINE('Esquema registrado.');
END;
/

CREATE TABLE departamentos_xml (
  id  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  doc XMLTYPE
)
XMLTYPE COLUMN doc STORE AS BINARY XML
XMLSCHEMA "http://localhost/hr/departamentos.xsd" ELEMENT "departamentos";

CREATE OR REPLACE TRIGGER trg_valida_departamentos
BEFORE INSERT OR UPDATE ON departamentos_xml
FOR EACH ROW
DECLARE
  v_doc XMLTYPE;
BEGIN
  v_doc := :NEW.doc;
  v_doc.schemaValidate();   
END;
/


SELECT schema_url, local FROM user_xml_schemas;