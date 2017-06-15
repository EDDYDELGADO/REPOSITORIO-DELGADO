--procedimiento de ventas
CREATE PROCEDURE SP_venta
AS
BEGIN
select year(s.fecha) a�o,month(s.fecha) mes,d.nombreDepartamento departamento, m.nombreMunicipio municipio,
c.nombreCliente cliente,p.nombre producto, count(sd.idProducto)as recuento_producto,
sum(sd.cantidad * sd.costoTotal)as total_costo,
sum(sd.cantidad * sd.precio) as total_venta,
sum((sd.cantidad * sd.precio)-(sd.cantidad * sd.costoTotal)) as utilidad_total
from Salida s, SalidaDetalle sd, clientes c, Municipio m, Departamento d, productos p 
where s.idSalida=sd.idSalida and c.idCliente=s.idCliente
and c.idMunicipio=m.idMunicipio and m.idDepartamento=d.idDepartamento
and p.id= sd.idproducto
group by year(s.fecha),month(s.fecha),c.nombreCliente, P.nombre, m.nombreMunicipio, d.nombreDepartamento
END;
go


--procedimiento de recuento de ventas
CREATE PROCEDURE SP_RecuentoDeVentas
AS
BEGIN
SELECT t.fecha, t.A�o, t.semestre, t.trimestre, t.mes, t.semana, t.dia, t.diaNombre, p.nombre,
t.mesNombre1 + t.mesNombre2 AS mesNombre, s.idSalida,
count(sd.idProducto)as recuento_producto,
sum(sd.cantidad * sd.costoTotal)as total_costo,
sum(sd.cantidad * sd.precio) as total_venta,
sum((sd.cantidad * sd.precio)-(sd.cantidad * sd.costoTotal)) as utilidad_total
FROM     (SELECT        fecha, YEAR(fecha) AS A�o, CASE WHEN MONTH(fecha) BETWEEN 1 AND 6 THEN 1 ELSE 2 END AS semestre, DATEPART(qq, fecha) AS trimestre, 
                                                    MONTH(fecha) AS mes, DATEPART(wk, fecha) AS semana, DAY(fecha) AS dia, DATENAME(dw, fecha) AS diaNombre, CASE WHEN MONTH(fecha) 
                                                    = 1 THEN 'Enero' ELSE CASE WHEN MONTH(fecha) = 2 THEN 'Febrero' ELSE CASE WHEN MONTH(fecha) 
                                                    = 3 THEN 'Marzo' ELSE CASE WHEN MONTH(fecha) = 4 THEN 'Abril' ELSE CASE WHEN MONTH(fecha) 
                                                    = 5 THEN 'Mayo' ELSE CASE WHEN MONTH(fecha) = 6 THEN 'Junio' ELSE '' END END END END END END AS mesNombre1, CASE WHEN MONTH(fecha)
                                                    = 7 THEN 'Julio' ELSE CASE WHEN MONTH(fecha) = 8 THEN 'Agosto' ELSE CASE WHEN MONTH(fecha) 
                                                    = 9 THEN 'Septiembre' ELSE CASE WHEN MONTH(fecha) = 10 THEN 'Octubre' ELSE CASE WHEN MONTH(fecha) 
                                                    = 11 THEN 'Noviembre' ELSE CASE WHEN MONTH(fecha) = 12 THEN 'Diciembre' ELSE '' END END END END END END AS mesNombre2, idSalida
                          FROM            Salida) AS t, SalidaDetalle sd, Salida s, Productos p
						  group by t.fecha, t.A�o, t.semestre, t.trimestre, t.mes, t.semana, t.dia, t.diaNombre, t.mesNombre1, t.mesNombre2, s.idSalida, p.nombre
end;
 --------------------------------------------------------------------------------------------------------------