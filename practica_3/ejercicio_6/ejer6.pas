{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas}

program ejer6;
type
    prenda = record
        cod_prenda: integer;
        descripcion: string[50];
        colores: string;
        tipo_prenda: string;
        stock: integer;
        precio_unitario: real;
    end;

    archivo_prendas = file of prenda;
    archivo_detalle = file of integer;


procedure leer_prenda(var a: prenda);
begin
    with a do begin
        write('Ingresar codigo de la prenda: ');
        readln(cod_prenda);
        if(cod_prenda <> 0)then begin
            write('Ingresar descripcion de la prenda: ');
            readln(descripcion);
            write('Ingresar colores de la prenda: ');
            readln(colores);
            write('Ingresar tipo de prenda: ');
            readln(tipo_prenda);
            write('Ingresar stock: ');
            readln(stock);
            write('Ingresar precio unitario: ');
            readln(precio_unitario);          
        end;
    end;
end;

procedure crear_maestro(var master:archivo_prendas);
var
    rec: prenda;
begin
    rewrite(master);
    leer_prenda(rec);
    while(rec.cod_prenda <> 0)do begin
        write(master, rec);
        leer_prenda(rec);
    end;
    close(master);
end;

procedure actualizar_maestro(var m: archivo_prendas; var d: archivo_detalle);
var
    cod: integer;
    reg_m: prenda;
begin
    reset(m);
    reset(d);
    while(not eof(d))do begin   
        read(d, cod);
        while(not eof(m))do begin
            read(m, reg_m);
            if(reg_m.cod_prenda = cod)then begin
                reg_m.stock := -1;
                seek(m, filepos(m)-1);
                write(m, reg_m);
            end;
        end;
        seek(m, 0); 
    end;
    close(d);
    close(m);
end;

procedure crear_detalle(var d:archivo_detalle);
var
    cod:integer;
begin
    rewrite(d);
    writeln('Ingresar el codigo de las prendas que seran obsoletas: (finaliza con 0)');
    write('Ingresar Codigo de prenda: ');
    readln(cod);
    while(cod <> 0)do begin
        write(d, cod);
        write('Ingresar Codigo de prenda: ');
        readln(cod);
    end;
    close(d);
end;

procedure compactacion(var new_file: archivo_prendas; var m: archivo_prendas);
var
    regm: prenda;
begin
    rewrite(new_file);
    reset(m);
    while(not eof(m))do begin
        read(m, regm);
        if(regm.stock >= 0)then 
            write(new_file, regm);
    end;
    close(new_file);
    close(m);
end;

procedure imprimir(var archivo: archivo_prendas);
var
    regm: prenda;
begin
    reset(archivo);
    while(not eof(archivo))do begin
        read(archivo, regm);
        writeln('codigo ', regm.cod_prenda, ' stock ', regm.stock);
    end;
    close(archivo);
end;

var
    maestro: archivo_prendas;
    detalle: archivo_detalle;
    nuevo: archivo_prendas;
begin
    assign(maestro, 'maestro');
    assign(detalle, 'detalle');
    //  CREACION DE ARCHIVOS
    
    //crear_maestro(maestro);
    //crear_detalle(detalle);
    actualizar_maestro(maestro, detalle); // 
    assign(nuevo, 'maestro_actualizado');
    compactacion(nuevo, maestro);

    // PRUEBAS
    
    // writeln('ARCHIVO MAESTRO: ');
    // imprimir(maestro);
    // writeln('ARCHIVO COMPACTADO: ');
    // imprimir(nuevo);
end.