program main;
const
    cant_archivos = 5;
    valor_alto = '9999';
type
    carrera = record
        dni_corredor: string;
        apellido: string;
        nombre: string;
        km_corridos: real;
        gano: boolean;
    end;

    archivo_detalle = file of carrera;

    carreras = array[1..cant_archivos] of archivo_detalle;

    info_carrera = record
        dni_corredor: string;
        apellido: string;
        nombre: string;
        km_total: real;
        cant_ganadas: integer;
    end;

    archivo_maestro = file of info_carrera;

    minimos = array[1..cant_archivos] of carrera;

    procedure leer_datos_carrera(var c:carrera);
    var
        input_gano: string;
    begin
        with c do begin
            write('Ingresar dni del corredor: ');
            readln(dni_corredor);
            if(dni_corredor <> '')then begin
                write('Ingresar apellido del corredor: ');
                readln(apellido);
                write('Ingresar nombre del corredor: ');
                readln(nombre);
                write('Ingresar cantidad de kilometros recorridos en la carrera: ');
                readln(km_corridos);
                write('Ingresar si el corredor gano la carrera(si/no): ');
                readln(input_gano);
                gano := (input_gano = 'si');
            end;
        end;
    end;

    procedure crear_detalles(var detalles: carreras);
    var
        i: integer;
        c: carrera;
    begin
        for i:=1 to cant_archivos do begin
            rewrite(detalles[i]);
            writeln('Creacion de archivo detalle ', i ,': ');
            leer_datos_carrera(c);
            while(c.dni_corredor <> '')do begin
                write(detalles[i], c);
                leer_datos_carrera(c);
            end;
            close(detalles[i]);
        end;
    end;

    procedure leer(var arch: archivo_detalle; var reg: carrera);
    begin
        if(not eof(arch))then
            read(arch, reg)
        else
            reg.dni_corredor := valor_alto;
    end;

    procedure minimo(var detalles:carreras; var array_min: minimos; var min: carrera);
    var
        i: integer;
        pos: integer;
    begin
        pos:= 1;
        min.dni_corredor := valor_alto;
        for i:= 1 to cant_archivos do begin
            if(array_min[i].dni_corredor < min.dni_corredor)then begin
                min := array_min[i];
                pos:= i;
            end;
        end;
        leer(detalles[pos], array_min[pos]);
    end;

    procedure crear_maestro(var m: archivo_maestro; var detalles: carreras);
    var
        i: integer;
        min: carrera;
        array_min: minimos;

        corredor_act : info_carrera;

    begin
        for i:=1 to cant_archivos do begin
            reset(detalles[i]);
            leer(detalles[i], array_min[i]);
        end;

        rewrite(m);
        minimo(detalles, array_min, min);

        while(min.dni_corredor <> valor_alto)do begin
            corredor_act.dni_corredor := min.dni_corredor;
            corredor_act.cant_ganadas := 0;
            corredor_act.km_total := 0;
            corredor_act.apellido := min.apellido;
            corredor_act.nombre := min.nombre;
            while(min.dni_corredor = corredor_act.dni_corredor)do begin
                corredor_act.km_total := corredor_act.km_total + min.km_corridos;
                if(min.gano)then
                    corredor_act.cant_ganadas := corredor_act.cant_ganadas + 1;
                minimo(detalles, array_min, min);
            end;
            write(m, corredor_act);
        end;

        for i:= 1 to cant_archivos do
            close(detalles[i]);

        close(m);
    end;

    procedure imprimir_maestro(var m:archivo_maestro);
    var
        reg: info_carrera;
    begin
        reset(m);
        while(not eof(m))do begin
            read(m, reg);
            writeln('dni corredor:', reg.dni_corredor,' cant ganadas ', reg.cant_ganadas, ' km recorridos ', reg.km_total:2:2);
        end;
        close(m);
    end;

var
    detalles: carreras;
    maestro: archivo_maestro;
    Str_i: string;
    i: integer;
begin
    assign(maestro, 'archivo_maestro');
    for i:=1 to cant_archivos do begin
        Str(i, Str_i);
        assign(detalles[i], 'archivo'+Str_i);
    end;
    crear_detalles(detalles);
    crear_maestro(maestro, detalles);
    imprimir_maestro(maestro);
end.