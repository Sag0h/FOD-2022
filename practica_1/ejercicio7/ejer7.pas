{
    7.Realizar un programa que permita:
        a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
        El nombre del archivo de texto es: “novelas.txt”
        b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
        una novela y modificar una existente. Las búsquedas se realizan por código de novela.
        NOTA: La información en el archivo de texto consiste en: código de novela,
        nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
        información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
        información: código novela, precio, y género, y la segunda línea almacenará el nombre
        de la novela.
}


program ejer7;
type
    novelas = record
        cod: integer;
        nombre: string[50];
        genero: string[20];
        precio: real;
    end;
    arch_novelas = file of novelas;

procedure crear_archivo(var arch: arch_novelas; var text : Text);
var
    n: novelas;
    crear: boolean;
begin
    rewrite(arch);
    reset(text);
    while(not eof(text))do begin
        readln(text, n.cod, n.precio, n.genero);
        readln(text, n.nombre);
        write(arch, n);
        crear:= true;
    end;
    if(crear) then
        writeln('Se creo el archivo binario correctamente!.')
    else    
        writeln('No se pudo crear correctamente.');
    close(text);
    close(arch);
end;


procedure leer_libro(var n: novelas);
begin
    write('Ingrese codigo de novela: ');
    readln(n.cod);
    write('Ingrese nombre de novela: ');
    readln(n.nombre);
    write('Ingrese genero de novela: ');
    readln(n.genero);
    write('Ingrese precio de novela: ');
    readln(n.precio);
end;

procedure agregar(var arch: arch_novelas);
var
    n: novelas;
begin
    reset(arch);
    seek(arch, FileSize(arch));
    leer_libro(n);
    write(arch, n);
    close(arch);
end;



procedure modify_menu(var arch: arch_novelas);
begin
    writeln('1. Modificar precio de novela.');
    writeln('2. Modificar nombre de novela.');
    writeln('3. Modificar genero de novela.');
    writeln('4. Volver Atras.');
end;

procedure write_novela(n:novelas);
begin
    writeln();
    writeln('Codigo: ', n.cod);
    writeln('Nombre: ', n.nombre);
    writeln('Genero: ', n.genero);
    writeln('Precio: ', n.precio:2:2);
    writeln();
end;

procedure precio(var n:novelas; var arch:arch_novelas);
var 
    precio:real;
begin
    write('Ingrese nuevo valor: ');
    readln(precio);
    seek(arch, FilePos(arch) - 1);
    n.precio := precio;
    write(arch, n); 
end;

procedure nombre(var n:novelas; var arch:arch_novelas);
var
    nombre: string;
begin
    write('Ingrese nuevo valor: ');
    readln(nombre);
    seek(arch, FilePos(arch) - 1);
    n.nombre := nombre;
    write(arch, n); 
end;

procedure genero(var n:novelas; var arch:arch_novelas);
var
    generos: string;
begin
    write('Ingrese nuevo valor: ');
    readln(generos);
    seek(arch, FilePos(arch) - 1);
    n.genero := generos;
    write(arch, n); 
end;


procedure modify_book (var arch: arch_novelas);
var
    n: novelas;
    cod: integer;
    encontro: boolean;
    seleccion: string;
begin
    encontro := false;
    write('Ingrese codigo de la novela: ');
    readln(cod);
    reset(arch);
    while(not eof(arch)and(not encontro)) do begin
        read(arch,n);
        if(n.cod = cod) then begin
            writeln('Se encontro el libro.');
            write_novela(n);
            modify_menu(arch);
            writeln('Ingrese opcion: ');
            readln(seleccion);
            case seleccion of
                '1': precio(n,arch);
                '2': nombre(n,arch);
                '3': genero(n,arch);
                '4': exit;
                else begin
                    writeln('Ingresaste un valor invalido, intente de nuevo.');
                    modify_menu(arch);
                end;
            end;
            encontro := True;
        end;
    end;
    if(not encontro)then
        writeln('No se encontro la novela con ese codigo.');
    close(arch);
end;


procedure main_menu(var arch: arch_novelas; var text: Text);
var
    seleccion: string;
begin
    writeln('-----MENU------');
    writeln('1. Crear archivo binario.');
    writeln('2. Editar un libro.');
    writeln('3. Agregar un libro.');
    writeln('4. Salir del programa.');
    writeln('---------------');
    write('Ingrese una opcion: ');
    readln(seleccion);
    case seleccion of
        '1': crear_archivo(arch, text);
        '2': modify_book(arch);
        '3': agregar(arch);
        '4': halt;
        else begin
            writeln('Ingreso una opcion invalida vuelva a intentar.');
            main_menu(arch, text);
        end;
    end;
    main_menu(arch, text);
end;


procedure update_library(var arch: arch_novelas);
var
    seleccion: string;
begin
    writeln('-----MENU------');
    writeln('1. Agregar novela.');
    writeln('2. Modificar una novela.');
    writeln('3. Volver atras.');
    writeln('---------------');
    write('Ingrese una opcion: ');
    readln(seleccion);
    case seleccion of
        '1': agregar(arch);
        '2': modify_book(arch);
        '3': exit;
        else begin
            writeln('Ingreso una opcion invalida vuelva a intentar.');
            update_library(arch);
        end;
    end;
end;

var
    archivo : arch_novelas;
    archivo_texto : Text;
begin
    Assign(archivo_texto, 'novelas.txt');
    Assign(archivo, 'novelas');
    main_menu(archivo, archivo_texto); 
end.