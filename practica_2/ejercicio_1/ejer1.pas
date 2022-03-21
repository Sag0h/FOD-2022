// 1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
// empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
// nombre y monto de la comisión. La información del archivo se encuentra ordenada por
// código de empleado y cada empleado puede aparecer más de una vez en el archivo de
// comisiones.
// Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
// consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
// única vez con el valor total de sus comisiones.
// NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
// recorrido una única vez.

 program ejer1;
 const
    valoralto = 9999;
 type
    empleado = record
        cod: integer;
        nombre: string;
        monto: real;
    end;

    comisiones = file of empleado;

procedure leerEmpleado(var arch: comisiones; var e: empleado);
begin
    if(not eof(arch))then
        read(arch, e)
    else
        e.cod := valoralto;
end;

procedure crearArchivoComisiones(var arch: comisiones);
    procedure leerComision(var c: empleado);
    begin
        write('Ingresar codigo de empleado: ');
        readln(c.cod);
        if(c.cod <> -1)then begin
            write('Ingresar nombre del empleado: ');
            readln(c.nombre);
            write('Ingresar monto de la comision: ');
            readln(c.monto);
        end;
    end;
var
    c: empleado;
begin
    rewrite(arch);
    leerComision(c);
    while(c.cod <> -1)do begin
        write(arch, c);
        leerComision(c);
    end;
    close(arch);
end;

procedure verArchivoComisiones(var arch: comisiones);
var
    c: empleado;
begin
    reset(arch);
    while(not eof(arch))do begin
        read(arch, c);
        writeln('codigo: ',c.cod, ' nombre: ', c.nombre, ' monto: $', c.monto:2:2);
    end;
    close(arch);
end;

var
    arch: comisiones;
    e: empleado;
    arch_compacto: comisiones;
    e2: empleado;
begin
    assign(arch, 'archivo_comisiones');
    assign(arch_compacto, 'archivo_compacto_comisiones');
    // crearArchivoComisiones(arch);
    reset(arch);
    rewrite(arch_compacto);
    leerEmpleado(arch, e);
    while(e.cod <> valoralto)do begin
        e2.cod := e.cod;
        e2.monto := 0;
        e2.nombre := e.nombre;
        while(e.cod = e2.cod)do begin
            e2.monto := e2.monto + e.monto; 
            leerEmpleado(arch, e);        
        end;
        write(arch_compacto, e2);
    end;
    close(arch);
    close(arch_compacto);
    writeln('Archivo no compactado: ');
    verArchivoComisiones(arch);
    writeln('Archivo compactado: ');
    verArchivoComisiones(arch_compacto);
end.