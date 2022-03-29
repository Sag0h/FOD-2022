program ejer6;
const
    cant_archivos = 2;
    valor_alto = 9999;
type
    informacion = record
        cod_localidad: integer;
        cod_cepa: integer;
        cant_activos: integer;
        cant_nuevos: integer;
        cant_recuperados: integer;
        cant_fallecidos: integer;
    end;

    detalle = file of informacion;

    detalles = array[1..cant_archivos]of detalle;
    v_info = array[1..cant_archivos]of informacion;

    informacion_ministerio = record
        cod_localidad: integer;
        cod_cepa: integer;
        nombre_cepa: string[20];
        cant_activos: integer;
        cant_nuevos: integer;
        cant_recuperados: integer;
        cant_fallecidos: integer;
    end;

    maestro = file of informacion_ministerio;


procedure leer(var d:detalle; var info:informacion);
begin
    if(not eof(d))then
        read(d, info)
    else
        info.cod_localidad := valor_alto;
end;

procedure minimo(var vd:detalles; var vpos:v_info; var min:informacion);
var
    i: integer;
    min_pos: integer;
begin
    min.cod_localidad := valor_alto;
    min.cod_cepa := valor_alto;
    for i:=1 to cant_archivos do begin
        if(vpos[i].cod_localidad < min.cod_localidad)then
            if(vpos[i].cod_cepa < min.cod_cepa)then begin
                min := vpos[i];
                min_pos := i;
            end;
    end;
    if(min.cod_localidad <> valor_alto)then
        leer(vd[min_pos], vpos[min_pos]);
end;

procedure actualizar_maestro(var m:maestro; var vd:detalles);
var
    vpos: v_info;
    i: integer;
    min: informacion;
    regm_aux: informacion_ministerio;
    regm: informacion_ministerio;
begin
    reset(m);
    for i:=1 to cant_archivos do begin
        reset(vd[i]);
        leer(vd[i], vpos[i]);
    end;

    minimo(vd, vpos, min);
    while(min.cod_localidad <> valor_alto)do begin
        regm_aux.cod_localidad := min.cod_localidad;
        regm_aux.cod_cepa := min.cod_cepa;
        while(regm_aux.cod_localidad = min.cod_localidad)and(regm_aux.cod_cepa = min.cod_cepa)do begin            
            regm_aux.cant_activos:= regm_aux.cant_activos + min.cant_activos;
            regm_aux.cant_nuevos:= regm_aux.cant_nuevos + min.cant_nuevos;
            regm_aux.cant_recuperados:= regm_aux.cant_recuperados + min.cant_recuperados;
            regm_aux.cant_fallecidos:= regm_aux.cant_fallecidos + min.cant_fallecidos;
            minimo(vd, vpos, min);            
        end;
        read(m, regm);
        while(not eof(m)) and (regm.cod_localidad <> regm_aux.cod_localidad)and(regm.cod_cepa <> regm_aux.cod_cepa)do begin
            read(m, regm);
        end;
        regm.cant_activos := regm.cant_activos + regm_aux.cant_activos;
        regm.cant_nuevos := regm.cant_nuevos + regm_aux.cant_nuevos;
        regm.cant_recuperados := regm.cant_recuperados + regm_aux.cant_recuperados;
        regm.cant_fallecidos := regm.cant_fallecidos + regm_aux.cant_fallecidos;
        seek(m, filepos(m)-1);
        write(m, regm);        
    end;

    for i:=1 to cant_archivos do begin
        close(vd[i]);
    end;
    close(m);
end;

procedure leer_informacion_maestro(var info: informacion_ministerio);
begin
    with info do begin
        write('Ingresar codigo de localidad: ');
        readln(cod_localidad);
        if(cod_localidad <> -1)then begin
            write('Ingresar codigo de cepa: ');
            readln(cod_cepa);
            write('Ingresar nombre de la cepa: ');
            readln(nombre_cepa);
            write('Ingresar cantidad de casos activos: ');
            readln(cant_activos);
            write('Ingresar cantidad de casos nuevos: ');
            readln(cant_nuevos);
            write('Ingresar cantidad de recuperados: ');
            readln(cant_recuperados);
            write('Ingresar cantidad de fallecidos: ');
            readln(cant_fallecidos);
        end;
    end;
end;

procedure crear_maestro(var m:maestro);
var
    info: informacion_ministerio;
begin  
    writeln('Creacion de archivo maestro: ');
    rewrite(m);
    leer_informacion_maestro(info);
    while(info.cod_localidad <> -1)do begin
        write(m, info);    
        leer_informacion_maestro(info);
    end;
    close(m);
end;

procedure leer_detalle(var info:informacion);
begin
    with info do begin
        write('Ingresar codigo de localidad: ');
        readln(cod_localidad);
        if(cod_localidad <> -1)then begin
            write('Ingresar codigo de cepa: ');
            readln(cod_cepa);
            write('Ingresar cantidad de casos activos: ');
            readln(cant_activos);
            write('Ingresar cantidad de casos nuevos: ');
            readln(cant_nuevos);
            write('Ingresar cantidad de recuperados: ');
            readln(cant_recuperados);
            write('Ingresar cantidad de fallecidos: ');
            readln(cant_fallecidos);
        end;
    end;
end;

procedure crear_detalles(var vd:detalles);
var
    i:integer;
    str_i: string;
    info: informacion;
begin
    for i:= 1 to cant_archivos do begin
        Str(i, str_i);
        assign(vd[i], 'det'+str_i);
        rewrite(vd[i]);
        writeln('Creacion de archivo detalle ', i, ': ');
        leer_detalle(info);
        while(info.cod_localidad <> -1)do begin
            write(vd[i], info);
            leer_detalle(info);
        end;
        close(vd[i]);
    end;
end;

procedure informar_localidades(var m: maestro);
var
    info: informacion_ministerio;
begin
    reset(m);
    while(not eof(m))do begin
        read(m, info);
        if(info.cant_activos > 50)then
            writeln('Localidad con mas de 50 casos activos: ', info.cod_localidad, ' de la cepa de codigo ', info.cod_cepa);   
    end;
    close(m);
end;

var
    m: maestro;
    vd:detalles;
    i: integer;
    str_i: string;
begin
    assign(m, 'maestro');
    //crear_maestro(m);
    //crear_detalles(vd);
    for i:= 1 to cant_archivos do begin
        Str(i, str_i);
        assign(vd[i], 'det'+str_i);
    end;
    actualizar_maestro(m, vd);
    informar_localidades(m);
end.