program ejer11;
const
    valor_alto = '9999';
    cant_archivos = 2;
type
    datos = record
        provincia: string[20];
        cant_alfa: integer;
        cant_encuestados: integer;
    end;

    datos_detalle = record
        info: datos;
        cod_localidad: integer;
    end;

    archivo_maestro = file of datos;
    archivo_detalle = file of datos_detalle;

    archivos = array[1..cant_archivos] of archivo_detalle;
    minimos = array[1..cant_archivos] of datos_detalle;

procedure leer_datos(var d:datos);
begin
    with d do begin
        write('Ingresar nombre de la provincia: ');
        readln(provincia);
        if(provincia <> '')then begin
            write('Ingresar cantidad de alfabetizados: ');
            readln(cant_alfa);
            write('Ingresar cantidad de encuestados: ');
            readln(cant_encuestados);
            
        end;        
    end;
end;

procedure leer_datos_detalle(var d: datos_detalle);
begin
    with d do begin
        leer_datos(info);
        if(info.provincia <> '')then begin
            write('Ingresar codigo de localidad: ');
            readln(cod_localidad);
        end;
    end;
end;


procedure crear_maestro(var m: maestro);
var
    d: datos;
begin
    writeln('Creacion de archivo maestro: ');
    rewrite(m);
    leer_datos(d);
    while(d.provincia <> '')do begin
        write(m, d);
        leer_datos(d);
    end;
    close(m);
end;

procedure crear_detalles(var v:archivos);
var
    i: integer;
    d: datos_detalle;
    str_i: string;
begin
    writeln('Creacion de archivo detalle: ');
    for i:=1 to cant_archivos do begin
        Str(i, str_i);
        assign(v[i], 'd'+str_i);
        rewrite(v[i]);
        leer_datos_detalle(d);
        while(d.provincia <> '')do begin
            write(v[i], d);
            leer_datos_detalle(d);
        end;
        close(v[i]);    
    end;
end;

procedure actualizar_maestro(var m: archivo_maestro; var v:archivos);
var
    i: integer;
    v_min: minimos;
    min: datos_detalle;
begin
    reset(m);
    for i:= 1 to cant_archivos do begin
        reset(v[i]);
        leer_datos_detalle_archivo(v, vmin);
    end;

    minimo(v, vmin, min);
    while(min.provincia <> valor_alto)do begin
        
    end;

    for i:= 1 to cant_archivos do begin
        close(v[i]);
    end;
end;

var 
    maestro: archivo;
    vector: archivos;
begin
    assign(maestro, 'maestro');
    crear_maestro(maestro);
    crear_detalles(vector);
    actualizar_maestro(maestro, vector);
end.