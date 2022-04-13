{7. Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}

program ejer7;
const
    valor_fin = 500000;
type
    ave = record
        cod: LongInt;
        nombre: string;
        familia_ave: string;
        descripcion: string;
        zona_geografica: string;
    end;

    archivo_aves = file of ave;

procedure leer_ave(var a: ave);
begin
    with a do begin
        write('Ingresar codigo de especie: ');
        readln(cod);
        if(cod <> -1)then begin
            write('Ingresar nombre de especie: ');
            readln(nombre);
            write('Ingresar familia de ave: ');
            readln(familia_ave);
            write('Ingresar descripcion del ave: ');
            readln(descripcion);
            write('Ingresar zona geografica de la especie: ');
            readln(zona_geografica);
        end;
    end;
end;

procedure crear_archivo_aves(var a: archivo_aves);
var
    r: ave;
begin
    rewrite(a);
    leer_ave(r);
    while(r.cod <> -1)do begin
        write(a, r);    
        leer_ave(r);
    end;
    close(a);
end;


procedure eliminar_aves(var a: archivo_aves);
var
    r: ave;
    cod: LongInt;
    ok: boolean;
begin
    reset(a);
    write('Ingresar codigo de ave a eliminar: ');
    readln(cod);
    while(cod <> valor_fin) do begin
        ok := false;
        while(not eof(a)) and (not ok)do begin
            read(a, r);
            if(r.cod = cod)then begin
                r.nombre := '@'+r.nombre;
                seek(a, filepos(a)-1);
                write(a, r);
                ok := true;
            end;
        end;

        if(ok)then
            writeln('Se borro el ave de codigo ', cod,' correctamente.')
        else
            writeln('No se encontro el ave de codigo ', cod,'. ');

        seek(a, 0);
        write('Ingresar codigo de ave a eliminar: ');
        readln(cod);
    end;

    close(a); 
end;

procedure compactar(var mae: archivo_aves; pos: integer; var cont: integer);
var
    regm : ave;
    last_pos: integer;
begin
    last_pos := filesize(mae)-1;
    seek(mae, (last_pos - cont)); 
    read(mae, regm);               
    seek(mae, pos);
    write(mae, regm);
    cont := cont + 1;    
end;

procedure compactar_archivo(var a:archivo_aves);
var
    cont: integer;
    regm: ave;
begin
    cont:= 0; // contador de borrados
    reset(a); // abro el archivo
    while(filepos(a) <> (filesize(a)-cont))do begin 
    // mientras la posicion actual sea distinta del tamaño menos los borrados logicamente
        read(a, regm); // leo registro
        if(pos('@', regm.nombre) <> 0) then begin // si esta borrado logicamente
            compactar(a, (filepos(a)-1) ,cont); 
            // lo compacto, mandando el contador que se va a aumentar en 1, y la posicion donde lei ese dato
            // una vez que el compactar reemplazo el ultimo dato con el borrado y aumento el contador
            seek(a, filepos(a)-1); // vuelvo atras, para ver que el dato que acabo de escribir no fue borrado logicamente
            // es decir nos traemos el ultimo registro pero no sabemos si esta borrado asique volvemos a procesar esa posicion
            //si se borra de nuevo el contador va aumentando y nos vamos trayendo datos mas lejanos al filesize fisico
            // al hacer truncate del filesize - los borrados, se hace correctamente las bajas sin perder datos no borrados
        end;
    end;
    seek(a, (filesize(a)-cont));
    // nos paramos en la posicion fisica - los borrados logicamente, es decir si tenemos:
    // filesize = 5, 3 borrados
    // nos paramos en la 2 una vez q acomodamos los no borrados al inicio
    truncate(a);
    //hacemos el truncate para poner la marca de fin
    close(a);
end;

procedure imprimir(var archivo: archivo_aves);
var
    regm: ave;
begin
    reset(archivo);
    while(not eof(archivo))do begin
        read(archivo, regm);
        writeln('codigo ', regm.cod, ' nombre ', regm.nombre);
    end;
    close(archivo);
end;

var
    m : archivo_aves;
begin
    assign(m, 'archivo_aves');
    crear_archivo_aves(m);

    eliminar_aves(m);
    compactar_archivo(m);

    imprimir(m);

end.