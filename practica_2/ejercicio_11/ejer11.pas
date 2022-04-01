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


procedure crear_maestro(var m: archivo_maestro);
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
        while(d.info.provincia <> '')do begin
            write(v[i], d);
            leer_datos_detalle(d);
        end;
        close(v[i]);    
    end;
end;

procedure leer_datos_detalle_archivo(var a: archivo_detalle; var v: datos_detalle);
begin
    if(not eof(a))then
        read(a, v)
    else
        v.info.provincia := valor_alto;
end;

procedure minimo(var v:archivos; var vm:minimos; var min: datos_detalle);
var
    i: integer;
    pos_i: integer;
begin
    min.info.provincia := valor_alto;
    for i:=1 to cant_archivos do begin
        if(vm[i].info.provincia < min.info.provincia)then begin
            min:= vm[i];
            pos_i:= i;
        end;
    end;
    if(min.info.provincia <> valor_alto)then
        leer_datos_detalle_archivo(v[pos_i], vm[pos_i]);
end;

procedure actualizar_maestro(var m: archivo_maestro; var v:archivos);
var
    i: integer;
    v_min: minimos;
    min: datos_detalle;
    regm: datos;
begin
    reset(m);
    for i:= 1 to cant_archivos do begin
        reset(v[i]);
        leer_datos_detalle_archivo(v[i], v_min[i]);
    end;

    minimo(v, v_min, min);
    while(min.info.provincia <> valor_alto)do begin
        read(m, regm);
        while(regm.provincia <> min.info.provincia)do
            read(m, regm);
        while(min.info.provincia = regm.provincia)do begin
            regm.cant_alfa := regm.cant_alfa + min.info.cant_alfa;
            regm.cant_encuestados := regm.cant_encuestados + min.info.cant_encuestados;
            minimo(v, v_min, min);
        end;
        seek(m, filepos(m)-1);
        write(m, regm);
    end;

    for i:= 1 to cant_archivos do begin
        close(v[i]);
    end;
end;

var 
    d:datos;
    maestro: archivo_maestro;
    vector: archivos;
begin
    assign(maestro, 'maestro');
    crear_maestro(maestro);
    crear_detalles(vector);
    actualizar_maestro(maestro, vector);
    
    //print de maestro para ver si funciona:
    // reset(maestro);
    // while(not eof(maestro))do begin
    //     read(maestro, d);
    //     writeln(d.provincia, ' ', d.cant_alfa, ' ', d.cant_encuestados);  
    // end;
    // close(maestro);
end.