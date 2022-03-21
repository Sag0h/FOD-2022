{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripcion, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario
una única vez.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.}

program ejer5;
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


// Inciso A
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

//Inciso B

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

//Inciso C

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


//Inciso D 
procedure exportar_archivo(var p: phone_file);
var
    c: celular;
    archivo_guardar: Text;
begin
    reset(p);
    Assign(archivo_guardar,'celulares.txt');
    rewrite(archivo_guardar);
    while (not eof(p)) do begin
        read(p,c);
        writeln(archivo_guardar, c.codigo, c.precio, c.marca);
        writeln(archivo_guardar, c.stock_disponible, c.stock_minimo, c.descripcion);
        writeln(archivo_guardar, c.nombre);
    end;
    close(p);
    close(archivo_guardar);
    writeln('Se exporto el archivo binario a texto como "celulares.txt".');
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
    writeln('5. Salir.');
    writeln('======================');
    readln(option);
    case option of 
        '1': crear_archivo(pfile);
        '2': listar_minimo_stock(pfile);
        '3': listar_con_descripcion(pfile);
        '4': exportar_archivo(pfile);
        '5': halt;
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
