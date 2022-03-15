{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.
}

program ejer6;
type
    celular = record
        codigo: integer;
        nombre: string[30];
        descripcion: string;
        marca: string[20];
        precio: real;
        stock_minimo: integer;
        stock_disponible: integer;
    end;

    phone_file = file of celular;


// Inciso A5
procedure crear_archivo(var p: phone_file);
var
    txt: Text;
    c: celular;
begin
    Assign(txt, 'celulares.txt');
    reset(txt);
   
    rewrite(p);
    
    while(not eof(txt))do begin
        readln(txt, c.codigo, c.precio, c.marca);
        readln(txt, c.stock_disponible, c.stock_minimo, c.descripcion);
        readln(txt, c.nombre);        
        write(p, c);
    end;

    close(p);
    close(txt);

    writeln('Se creo el archivo binario correctamente.')
end;

//Inciso B5

procedure imprimir_celular(var c:celular);
begin
    writeln('Codigo: ', c.codigo);
    writeln('Nombre: ', c.nombre);
    writeln('Descripcion: ', c.descripcion);
    writeln('Marca: ', c.marca);
    writeln('Precio: $', c.precio:2:2);
    writeln('Stock minimo: ', c.stock_minimo);
    writeln('Stock disponible: ', c.stock_disponible);
    writeln();
end;


procedure listar_minimo_stock(var p: phone_file);
var
    c: celular;
begin
    reset(p);
    while(not eof(p))do begin
        read(p,c);
        if(c.stock_disponible < c.stock_minimo ) then 
            imprimir_celular(c);
    end;
    close(p);
end; 

//Inciso C5

procedure listar_con_descripcion(var p: phone_file);
var
    c: celular;
    cadena: string;
    encontro: boolean;
begin
    encontro:= false;
    write('Ingrese cadena de texto: ');
    readln(cadena);
    writeln('Resultados que coinciden: ');
    reset(p);
    while(not eof(p))do begin
        read(p,c);
        if( pos(cadena, c.descripcion) <> 0) then begin
            imprimir_celular(c);
            if(not encontro) then
                encontro:= true;
        end;
    end;
    if(not encontro)then
        writeln('La cadena que ingreso no coincide con ninguna descripcion.');
    close(p);
end; 


//Inciso D5 
procedure exportar_archivo(var p: phone_file);
var
    c: celular;
    archivo_guardar: Text;
    precio:string;
begin
    reset(p);
    Assign(archivo_guardar,'celulares.txt');
    rewrite(archivo_guardar);
    while (not eof(p)) do begin
        read(p,c);
        str(c.precio:2:2, precio);
        writeln(archivo_guardar, c.codigo,' ',precio, c.marca);
        writeln(archivo_guardar, c.stock_disponible,' ', c.stock_minimo, c.descripcion);
        writeln(archivo_guardar, c.nombre);
    end;
    close(p);
    close(archivo_guardar);
    writeln('Se exporto el archivo binario a texto como "celulares.txt".');
end;


// 6 Inciso A

procedure cargar_datos_celular(var c: celular);
begin
    write('Ingrese codigo de celular: ');
    readln(c.codigo);
    if(c.codigo <> -1) then begin
        write('Ingrese nombre del celular: ');
        readln(c.nombre);
        write('Ingrese descripcion del celular: ');
        readln(c.descripcion);
        write('Ingrese marca del celular: ');
        readln(c.marca);
        write('Ingrese precio del celular: ');
        readln(c.precio);
        write('Ingrese stock minimo del celular: ');
        readln(c.stock_minimo);
        write('Ingrese stock disponible: ');
        readln(c.stock_disponible);
    end;
end;


procedure add_celular(var p: phone_file);
var
    c: celular;
begin
    reset(p);
    cargar_datos_celular(c);
    seek(p, FileSize(p));
    while(c.codigo <> -1) do begin
        write(p,c);
        cargar_datos_celular(c);
    end;
    close(p);
end;

// Inciso 6 B

procedure modify_stock_celular(var p:phone_file);
var
    c: celular;
    nombre: string;
    encontro: boolean;
    stock: integer;
begin
    write('Ingrese nombre del celular: ');
    readln(nombre);
    reset(p);
    while not (eof(p)) do begin
        read(p,c);
        if(c.nombre = nombre) then begin
            write('Se encontro el celular: ');
            imprimir_celular(c);
            write('Ingrese stock disponible: ');
            readln(stock);
            seek(p,FilePos(p)-1);
            c.stock_disponible := stock;
            write(p,c);
            encontro:= True
        end;
    end;
    if (encontro) then
        writeln('Se modifico el stock correctamente.')
    else
        writeln('No se encontro el nombre del celular.');
    close(p);
end;

// 6 Inciso C

procedure exportar_no_stock(var pfile: phone_file);
var
    archivo_texto: Text;
    c: celular;
    precio: string;
begin
    reset(pfile);
    Assign(archivo_texto, 'SinStock.txt');
    Rewrite(archivo_texto);
    while(not eof(pfile)) do begin
        read(pfile,c);
        if(c.stock_disponible = 0) then begin
            str(c.precio:2:2, precio);
            writeln(archivo_texto, c.codigo,' ',precio, c.marca);
            writeln(archivo_texto, c.stock_disponible,' ',c.stock_minimo, c.descripcion);
            writeln(archivo_texto, c.nombre);
        end; 
    end;
    close(pfile);
    close(archivo_texto);
    writeln('Se exporto el archivo "SinStock.txt" correctamente.');
end;

procedure showMenu(var pfile: phone_file);
var
    option: string;
begin
    writeln('======== MENU ========');
    writeln('1. Crear archivo binario.');
    writeln('2. Listar celulares con stock menor al minimo.');
    writeln('3. Listar celulares con determinada descripcion.');
    writeln('4. Exportar archivo binario a texto.');
    writeln('5. Cargar celulares.');
    writeln('6. Modificar el stock de un celular.');
    writeln('7. Exportar la informacion de celulares sin stock a un archivo de texto.');
    writeln('8. Salir.');
    writeln('======================');
    write('Ingrese una opcion: ');
    readln(option);
    case option of 
        '1': crear_archivo(pfile);
        '2': listar_minimo_stock(pfile);
        '3': listar_con_descripcion(pfile);
        '4': exportar_archivo(pfile);
        '5': add_celular(pfile);
        '6': modify_stock_celular(pfile);
        '7': exportar_no_stock(pfile);
        '8': halt;
        else begin
            write('Ingreso una opcion invalida. Vuelva a intentar.');
            showMenu(pfile);
        end;
    end;
    showMenu(pfile);
end;

var
    pfile: phone_file;
    nombre_archivo: string;
begin
    write('Ingrese nombre para el archivo binario con el que va a trabajar: ');
    readln(nombre_archivo);
    Assign(pfile, nombre_archivo);
    showMenu(pfile);
end.