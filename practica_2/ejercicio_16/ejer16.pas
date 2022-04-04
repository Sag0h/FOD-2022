{
    16. La editorial X, autora de diversos semanarios, posee un archivo maestro con la
    información correspondiente a las diferentes emisiones de los mismos. De cada emisión se
    registra: fecha, código de semanario, nombre del semanario, descripción, precio, total de
    ejemplares y total de ejemplares vendido.
    Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
    país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
    cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
    procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
    actualización del archivo maestro en función de las ventas registradas. Además deberá
    informar fecha y semanario que tuvo más ventas y la misma información del semanario con
    menos ventas.
    Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
    ventas de semanarios si no hay ejemplares para hacerlo
}

program ejer16;
const
    valor_alto = 9999;
    cant_detalles = 100;
type

    fechas = record
        anio: integer;
        mes: 1..13;
        dia: 1..32;
    end;
    
    emision = record
        fecha: fechas;
        codigo_semanario: integer;
        nombre_semanario: integer;
        descripcion: string[25];
        precio: real;
        total_ejemplares: integer;
        total_vendidos: integer;
    end;
    
    emision_detalle = record
        fecha: fechas;
        codigo_semanario : integer;
        cantidad_vendida: integer;
    end;

    maestro = file of emision;
    detalle = file of emision_detalle;

    arreglo_detalle = array [1..cant_detalles] of detalle;
    arreglo_aux = array [1..cant_detalles] of emision_detalle;
    
    
procedure cargar_emision(var reg_m: emision);
begin
    write('Ingrese anio de emision: ');
    readln(reg_m.fecha.anio);
    if(reg_m.fecha.anio <> -1) then begin
        write('Ingrese mes de emision: ');
        readln(reg_m.fecha.mes);
        write('Ingrese dia de emision: ');
        readln(reg_m.fecha.dia);
        write('Ingrese codigo de semanario: ');
        readln(reg_m.codigo_semanario);
        write('Ingrese nombre de semanario: ');
        readln(reg_m.nombre_semanario);
        write('Ingrese descripcion de semanario: ');
        readln(reg_m.descripcion);
        write('Ingrese precio de semanario: ');
        readln(reg_m.precio);
        write('Ingrese total de ejemplares: ');
        readln(reg_m.total_ejemplares);
        write('Ingrese total de ejemplares vendidoss: ');
        readln(reg_m.total_vendidos);
    end;
end;

procedure crear_archivo_maestro(var arch: maestro);
var
    reg_m: emision;
begin
    writeln('CREACION DE MAESTRO: ');
    rewrite(arch);
    cargar_emision(reg_m);
    while(reg_m.fecha.anio <> -1) do begin
        write(arch,reg_m);
        cargar_emision(reg_m);
    end;
    close(arch);
end;


procedure cargar_info_detalles(var reg_d:emision_detalle);
begin
    write('Ingrese anio de emision: ');
    readln(reg_d.fecha.anio);
    if(reg_d.fecha.anio <> -1) then begin
        write('Ingrese mes de emision: ');
        readln(reg_d.fecha.mes);
        write('Ingrese dia de emision: ');
        readln(reg_d.fecha.dia);
        write('Ingrese codigo de semanario: ');
        readln(reg_d.codigo_semanario);
        write('Ingrese cantidad vendida: ');
        readln(reg_d.cantidad_vendida);
    end;
end;


procedure crear_archivos_detalle(var vector : arreglo_detalle);
var
    reg_d: emision_detalle;
    i: integer;
    i_str: string;
begin
    for i:= 1 to cant_detalles do begin
        Str(i,i_str);
        writeln('CREACION DE DETALLE '+i_str);
        assign(vector[i], 'detalle ' + i_str);
        rewrite(vector[i]);
        cargar_info_detalles(reg_d);
        while (reg_d.fecha.anio <> -1) do begin
            write(vector[i],reg_d);
            cargar_info_detalles(reg_d);
        end;
        close(vector[I]);
    end;
end;

procedure leer(var arch: detalle; var info: emision_detalle);
begin
    if not eof(arch) then 
        read(arch, info)
    else
        info.fecha.anio := valor_alto;
end;

procedure minimo(var vector: arreglo_detalle; var vector_aux: arreglo_aux ;  var min: emision_detalle);
var
    min_pos: integer;
    i: integer;
begin
    min.codigo_semanario := valor_alto;
    min.fecha.anio := valor_alto;
    min.fecha.mes := 13;
    min.fecha.dia := 32;
    for i:= 1 to cant_detalles do begin
        if (vector_aux[i].fecha.anio < min.fecha.anio) and (vector_aux[i].fecha.mes < min.fecha.mes) 
        and (vector_aux[i].fecha.dia <  min.fecha.dia) and (vector_aux[i].codigo_semanario <  min.codigo_semanario)  then  begin    
            min := vector_aux[i];
            min_pos:= i;
        end;
    end;
    if(min.fecha.anio <> valor_alto) then
        leer(vector[min_pos], vector_aux[min_pos]);
end;

procedure actualizar_maestro(var m: maestro; var v: arreglo_detalle);
var
    reg_m: emision;
    min: emision_detalle;
    i: integer;
    i_Str : string;
    vector_aux: arreglo_aux;
begin
    for i:= 1 to cant_detalles do begin
        Str(i,i_str);
        Assign(v[i],'detalle '+i_str);
        reset(v[i]);
        leer(v[i], vector_aux[i]);
    end;

    reset(m);
    minimo(v, vector_aux, min);
    while(min.fecha.anio <> valor_alto)do begin
        read(m, reg_m);
        while(reg_m.fecha.anio <> min.fecha.anio)do
            read(m, reg_m);
        while (min.fecha.anio = reg_m.fecha.anio) and (reg_m.fecha.mes = min.fecha.mes) 
        and (reg_m.fecha.dia =  min.fecha.dia) and (min.codigo_semanario = reg_m.codigo_semanario) do begin
            reg_m.total_vendidos := reg_m.total_vendidos + min.cantidad_vendida;
            reg_m.total_ejemplares := reg_m.total_ejemplares - min.cantidad_vendida;
            minimo(v, vector_aux, min);
        end;
        seek(m, filepos(m)-1);
        write(m, reg_m);
    end;

    for i:= 1 to cant_detalles do begin
        close(v[i]);
    end;
    close(m);
end;

procedure informar_max_min(var m: maestro);
var
    reg_m: emision;
    max: emision;
    min: emision;
begin
    reset(m);
    if(not eof(m))then begin
        read(m, reg_m);
        max := reg_m;
        min := reg_m;
    end;
    while(not eof(m))do begin
        read(m,reg_m);
        if(reg_m.total_vendidos > max.total_vendidos) then
            max:= reg_m;
        if(reg_m.total_vendidos < min.total_vendidos) then
            min:= reg_m;
    end;
    close(m);
    writeln('La emision con menos ventas es: ',min.fecha.anio, '-', min.fecha.mes,'-', min.fecha.dia,' ','codigo de semanario: ', min.codigo_semanario,#10+'La emision con mas ventas es: ', max.fecha.anio,'-',max.fecha.mes, '-',max.fecha.dia,' codigo de semanario: ', max.codigo_semanario);
end;

var
    m: maestro;
    v: arreglo_detalle;
begin
    assign(m, 'maestro');
    crear_archivo_maestro(m);
    crear_archivos_detalle(v);
    actualizar_maestro(m,v);
    informar_max_min(m);
end.