{
    Una compañía aérea dispone de un archivo maestro donde guarda información sobre
    sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida
    y la cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
    para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
    y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
    más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
    uno del maestro. Se pide realizar los módulos necesarios para:
    
    c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
    sin asiento disponible.
    d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
    tengan menos de una cantidad específica de asientos disponibles. La misma debe
    ser ingresada por teclado.
    NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}

program ejer14;
const
    valor_alto = 'ZZZZZZZ';
    cant_detalles = 2;
type
    fechas = record
        anio: integer;
        mes: 1..13;
        dia: 1..32;
    end;
    vuelo = record
        destino: string;
        fecha: fechas;
        hora_salida: integer;
        cant_disponibles: integer;
    end;

    maestro = file of vuelo;

    info_detalle = record
        destino: string;
        fecha: fechas;
        hora_salida: integer;
        cant_vendidos: integer;        
    end;

    detalle = file of info_detalle;
    
    vector_ventas = array [1..cant_detalles] of detalle;
    vector_auxiliar = array [1..cant_detalles] of info_detalle;

    procedure cargar_vuelo(var reg_m: vuelo);
    begin
        write('Ingrese destino: ');
        readln(reg_m.destino);
        if(reg_m.destino <> '') then begin
            write('Ingrese anio del vuelo: ');
            readln(reg_m.fecha.anio);
            write('Ingrese mes del vuelo: ');
            readln(reg_m.fecha.mes);
            write('Ingrese dia del vuelo: ');
            readln(reg_m.fecha.dia);
            write('Ingrese hora del vuelo: ');
            readln(reg_m.hora_salida);
            write('Ingrese cantidad de asientos disponibles: ');
            readln(reg_m.cant_disponibles);
        end;
    end;

    procedure crear_archivo_maestro(var arch: maestro);
    var
        reg_m: vuelo;
    begin
        rewrite(arch);
        cargar_vuelo(reg_m);
        while(reg_m.destino <> '') do begin
            write(arch,reg_m);
            cargar_vuelo(reg_m);
        end;
        close(arch);
    end;



    procedure cargar_info_detalles(var reg_d:info_detalle);
    begin
        write('Ingrese destino: ');
        readln(reg_d.destino);
        if(reg_d.destino <> '') then begin
            write('Ingrese anio del vuelo: ');
            readln(reg_d.fecha.anio);
            write('Ingrese mes del vuelo: ');
            readln(reg_d.fecha.mes);
            write('Ingrese dia del vuelo: ');
            readln(reg_d.fecha.dia);
            write('Ingrese hora del vuelo: ');
            readln(reg_d.hora_salida);
            write('Ingrese cantidad de asientos vendidos: ');
            readln(reg_d.cant_vendidos);
        end;
    end;


    procedure crear_archivos_detalle(var vector : vector_ventas);
    var
        reg_d: info_detalle;
        i: integer;
        i_str: string;
    begin
        for i:= 1 to cant_detalles do begin
            Str(i,i_str);
            assign(vector[i], 'detalle ' + i_str);
            rewrite(vector[i]);
            cargar_info_detalles(reg_d);
            while (reg_d.destino <> '') do begin
                write(vector[i],reg_d);
                cargar_info_detalles(reg_d);
            end;
            close(vector[I]);
        end;
    end;

    procedure leer(var arch: detalle; var info: info_detalle);
    begin
        if not eof(arch) then 
            read(arch, info)
        else
            info.destino := valor_alto;
    end;

    procedure minimo(var vector: vector_ventas; var vector_aux: vector_auxiliar ;  var min: info_detalle);
    var
        min_pos: integer;
        i: integer;
    begin
        min.destino := valor_alto;
        min.fecha.anio := 9999;
        min.fecha.mes := 13;
        min.fecha.dia := 32;
        for i:= 1 to cant_detalles do begin
            if (vector_aux[i].destino <  min.destino) and (vector_aux[i].fecha.anio < min.fecha.anio) 
            and (vector_aux[i].fecha.mes < min.fecha.mes) 
            and (vector_aux[i].fecha.dia <  min.fecha.dia) then  begin    
                min := vector_aux[i];
                min_pos:= i;
            end;
        end;
        if(min.destino <> valor_alto) then
            leer(vector[min_pos], vector_aux[min_pos]);
    end;
    
    procedure actualizar_maestro(var m: maestro; var v: vector_ventas);
    var
        reg_m: vuelo;
        min: info_detalle;
        i: integer;
        i_Str : string;
        vector_aux: vector_auxiliar;
    begin
        for i:= 1 to cant_detalles do begin
            Str(i,i_str);
            Assign(v[i],'detalle '+i_str);
            reset(v[i]);
            leer(v[i], vector_aux[i]);
        end;

        reset(m);
        minimo(v, vector_aux, min);
        while(min.destino <> valor_alto)do begin
            read(m, reg_m);
            while(reg_m.destino <> min.destino)do
                read(m, reg_m);
            while (min.destino = reg_m.destino) and (reg_m.fecha.anio = min.fecha.anio) 
            and (reg_m.fecha.mes = min.fecha.mes) 
            and (reg_m.fecha.dia =  min.fecha.dia) do begin
                reg_m.cant_disponibles := reg_m.cant_disponibles - min.cant_vendidos;
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


    procedure listar(var m: maestro ; cant : integer);
    var
        reg_m : vuelo;
    begin
        reset(m);

        while not eof(m) do begin
            read(m, reg_m);
            if(reg_m.cant_disponibles < cant) then
                writeln('Destino: ', reg_m.destino, ',  anio: ', 
                reg_m.fecha.anio,',  mes: ',reg_m.fecha.mes, ', dia: ', reg_m.fecha.dia, ' hora: ', reg_m.hora_salida );
        end;
            
        close(m);
    end;

    // procedure imprimir_registro_M(var reg_m: vuelo);
    // begin
    //     writeln(' ');
    //     writeln('Destino: ', reg_m.destino);
    //     writeln('Cantidad de asientos disponibles: ', reg_m.cant_disponibles);
    //     writeln(' ');
    // end;

    // procedure imprimir_m(var arch: maestro);
    // var
    //     reg_m: vuelo;
    // begin
    //     reset(arch);
    //     while not eof(arch) do begin
    //         read(arch, reg_m);
    //         imprimir_registro_M(reg_m);
    //     end;
    //     close(arch);
    
    // end;
    
var
    cant : integer;
    archivo_maestro : maestro;
    vector : vector_ventas;
begin
    assign(archivo_maestro, 'maestro');   
    //crear_archivo_maestro(archivo_maestro);
    //crear_archivos_detalle(vector);
    actualizar_maestro(archivo_maestro, vector);
    write('Ingresar cantidad de asientos para reportar: ');
    readln(cant); 
    listar(archivo_maestro, cant);
    //imprimir_m(archivo_maestro);
end.