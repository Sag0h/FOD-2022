{ 
    Definir un programa que genere un archivo con registros de longitud fija conteniendo
    información de asistentes a un congreso a partir de la información obtenida por
    teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
    nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
    archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
    asistente inferior a 1000.
    Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
    String a su elección. Ejemplo: ‘@Saldaño’.

}

program ejer2;
const
    valor_alto = 9999;
    cota_eliminados = 1000;
type
    asistentes = record
        nro: integer;
        apellido: string[25];
        nombre: string[25];
        email: string[25];
        telefono: string[15];
        dni: string[8];
    end;

    maestro = file of asistentes;

    procedure leer_asistente(var reg_m: asistentes);
    begin
        write ('Ingrese numero de asistente: ');
        readln(reg_m.nro);
        if reg_m.nro <> -1 then begin
            write ('Ingrese apellido del asistente: ');
            readln(reg_m.apellido);
            write ('Ingrese nombre del asistente: ');
            readln(reg_m.nombre);
            write ('Ingrese email del asistente: ');
            readln(reg_m.email);
            write ('Ingrese telefono del asistente: ');
            readln(reg_m.telefono);
            write ('Ingrese dni del asistente: ');
            readln(reg_m.dni);
        end;
    end;

    procedure crear_archivo_maestro (var arch: maestro);
    var
        reg_m: asistentes;
    begin
        rewrite(arch);
        leer_asistente(reg_m);
        while(reg_m.nro <> -1)do begin
            write(arch, reg_m);        
            leer_asistente(reg_m);
        end;
        close(arch);        
    end;

    procedure eliminar(var m:maestro);
    var
        reg_m: asistentes;
    begin
        reset(m);
        while(not eof(m))do begin
            read(m, reg_m);
            if(reg_m.nro < cota_eliminados)then
                reg_m.dni := '@'+reg_m.dni;
            seek(m, filepos(m)-1);
            write(m, reg_m);
        end;
        close(m);
    end;

    procedure imprimir_asistente(reg_m: asistentes);
    begin
        writeln('');
        writeln('Numero de asistente: ', reg_m.nro);
        writeln('Apellido de asistente: ', reg_m.apellido);
        writeln('Nombre de asistente: ', reg_m.nombre);
        writeln('Dni de asistente: ', reg_m.dni);
        writeln('Telefono del asistente: ', reg_m.telefono);
        writeln('Email del asistente: ', reg_m.email);
        writeln('');
    end;

    procedure imprimir_maestro(var m:maestro);
    var
        reg_m: asistentes;
    begin
        reset(m);
        while not eof(m) do begin
            read(m,reg_m);
            imprimir_asistente(reg_m);
        end;
        close(m);
    end;

    procedure imprimir_maestro_sin_eliminados(var m:maestro);
    var
        reg_m: asistentes;
    begin
        reset(m);
        while not eof(m) do begin
            read(m,reg_m);
            if (pos('@',reg_m.dni) = 0) then //El pos devuelve 0 si 
                imprimir_asistente(reg_m);
        end;
        close(m);
    end;

var    
    m:maestro;
begin
    assign(m, 'maestro');
    //crear_archivo_maestro(m);
    eliminar(m);
    writeln('Sin eliminar: ');
    imprimir_maestro_sin_eliminados(m);
    writeln('Con eliminados: ');
    imprimir_maestro(m);
end.