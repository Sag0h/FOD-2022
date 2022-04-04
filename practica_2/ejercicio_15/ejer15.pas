{
    Se desea modelar la información de una ONG dedicada a la asistencia de personas con
    carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
    como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
    de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
    agua,# viviendas sin sanitarios. 
    Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
    de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
    de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
    construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
    Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
    recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
    provincia y código de localidad. 
    Para la actualización se debe proceder de la siguiente manera: 
    
    1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
    2. Idem para viviendas con agua, gas y entrega de sanitarios.
    3. A las viviendas de chapa se le resta el valor recibido de viviendas construidas
    La misma combinación de  provincia y localidad aparecen a lo sumo una única vez.
    Realice las declaraciones necesarias, el programa principal y los procedimientos que
    requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
    chapa (las localidades pueden o no haber sido actualizadas).
}


program ejer15;
const
    valor_alto = 9999;
    cant_detalles = 2;
type 

info_maestro = record
	cod_prov:integer;
	nom_prov:string;
	cod_loc:integer;
	nom_loc:string;
	n_sin_luz:integer;
	n_sin_gas:integer;
	n_sin_agua:integer;
	n_sin_sanitario:integer;
	n_vivienda_de_chapa:integer;
end;

info_detalle = record
	cod_prov:integer;
	cod_loc:integer;
	n_con_luz:integer;
	n_con_gas:integer;
	n_con_agua:integer;
	entrega_sanitarios:integer;
	construidas:integer;
end;

archivo_m = file of info_maestro;
archivo_d = file of info_detalle;

vector_detalles = array [1 .. cant_detalles]  of archivo_d;
vector_registro_detalle = array [1 .. cant_detalles]  of info_detalle;

procedure crear_archivo_maestro(var m:archivo_m);
    procedure leer_info_maestro(var d: info_maestro); 
    begin
        with d do begin
            write('Ingresar codigo de provincia: ');
            readln(cod_prov);
            if(cod_prov <> -1)then begin
                write('Ingresar nombre de la provincia: ');
                readln(nom_prov);
                write('Ingresar codigo de localidad: ');
                readln(cod_loc);
                write('Ingresar nombre de localidad: ');
                readln(nom_loc);
                write('Ingresar numero de viviendas sin luz: ');
                readln(n_sin_luz);
                write('Ingresar numero de viviendas sin gas: ');
                readln(n_sin_gas);
                write('Ingresar numero de viviendas sin agua: ');
                readln(n_sin_agua);
                write('Ingresar numero de viviendas sin sanitario: ');
                readln(n_sin_sanitario);
                write('Ingresar numero de viviendas de chapa: ');
                readln(n_vivienda_de_chapa);
            end;
        end;
    end;

var
    d: info_maestro;
begin
    writeln('LECTURA DE DATOS DEL ARCHIVO MAESTRO:');
    rewrite(m);
    leer_info_maestro(d);
    while(d.cod_prov <> -1)do begin
        write(m, d);
        leer_info_maestro(d);
    end;
    close(m);
end;


procedure leer_vivienda_detalle(var r:info_detalle);
begin
    with r do begin
        write('Ingresar codigo de provincia: ');
        readln(cod_prov);
        if(cod_prov <> -1)then begin
            write('Ingresar codigo de localidad: ');
            readln(cod_loc);
            write('Ingresar numero de viviendas con luz: ');
            readln(n_con_luz);
            write('Ingresar numero de viviendas con gas: ');
            readln(n_con_gas);
            write('Ingresar numero de viviendas con agua: ');
            readln(n_con_agua);
            write('Ingresar numero de viviendas con sanitario: ');
            readln(entrega_sanitarios);
            write('Ingresar numero de viviendas construidas: ');
            readln(construidas);
        end;
    end;
end;

procedure crear_archivos_detalle(var d:vector_detalles);
var
    i:integer;
    i_str:string;
    r:info_detalle;
begin
    writeln('CREACION DE ARCHIVOS DETALLES: ');
    for i:= 1 to cant_detalles do begin
        Str(i,i_str);
        assign(d[i],'detalle '+i_str);
        rewrite(d[i]);
        writeln('ARCHIVO DETALLE '+i_str,': ');
        leer_vivienda_detalle(r);
        while(r.cod_prov <> -1 ) do begin
            write(d[i],r);
            leer_vivienda_detalle(r);
        end;
        close(d[i]);
    end;
end;

procedure leer(var a:archivo_d; var r:info_detalle);
begin
    if (not eof(a))then
        read(a, r)
    else    
        r.cod_prov := valor_alto;
end;

procedure minimo (var d: vector_detalles; var vec_aux: vector_registro_detalle; var min:info_detalle);
var
    i:integer;
    pos:integer;
begin
    min.cod_prov := valor_alto;
    min.cod_loc := valor_alto;
    for i:= 1 to cant_detalles do begin
        if (vec_aux[i].cod_prov < min.cod_prov) and (vec_aux[i].cod_loc < min.cod_loc) then begin
            min := vec_aux[i];
            pos:= i;
        end;
    end;
    if(min.cod_prov <> valor_alto)then
        leer(d[pos], vec_aux[pos]);
end;
procedure actualizar (var m:archivo_m; var d: vector_detalles);
var
    i:integer;
    reg_m:info_maestro;
    vec_aux:vector_registro_detalle;
    min:info_detalle;
begin
    reset(m);
    for i:= 1 to cant_detalles do begin
        reset(d[i]);
        leer(d[i],vec_aux[i]);
    end;
    minimo(d,vec_aux,min);{vector 1, vecto aux, minimo (registro detalle)}
    while (min.cod_prov <> valor_alto) do begin
        read(m, reg_m);
        while (min.cod_prov <> reg_m.cod_prov) and (reg_m.cod_loc <> min.cod_loc) do 
            read(m, reg_m);
        while (reg_m.cod_prov = min.cod_prov) and (reg_m.cod_loc = min.cod_loc) do begin
            reg_m.n_sin_luz := reg_m.n_sin_luz - min.n_con_luz;
            reg_m.n_sin_agua := reg_m.n_sin_agua - min.n_con_agua;
            reg_m.n_sin_sanitario := reg_m.n_sin_sanitario - min.entrega_sanitarios;
            reg_m.n_sin_gas := reg_m.n_sin_gas - min.n_con_gas;
            reg_m.n_vivienda_de_chapa := reg_m.n_vivienda_de_chapa - min.construidas;
            minimo(d,vec_aux,min);
        end;
        seek(m,filepos(m)-1);
        write(m,reg_m);
    end;

    for i:= 1 to cant_detalles do
        close(d[i]);
    close(m);
end;

procedure informar_chapa (var m:archivo_m);
var
    aux:info_maestro;
begin
    writeln('LOCALIDADES SIN CASAS DE CHAPA: ');
    reset(m);
    while (not eof (m)) do begin
        read(m,aux);
        if (aux.n_vivienda_de_chapa < 1) then
            write('Provincia: ', aux.cod_prov ,' Localidad: ', aux.cod_loc);
    end;
    close(m);
end;

var
    m:archivo_m;
    d:vector_detalles;
begin
    assign(m,'maestro');
    //crear_archivo_maestro(m);
    crear_archivos_detalle(d);
    actualizar(m,d);
    informar_chapa(m);
end.

