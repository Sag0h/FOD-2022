{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.
AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
se quiere agregar ya exista se debe informar “ya existe la distribución”.
BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”.}

program ejer8;
type
    distro = record
        nombre: string;
        anio: integer;
        version: string;
        cant_desarrolladores: integer;
        descripcion: string;
    end;

    archivo = file of distro;

procedure leer_distro(var d:distro);
begin
    with d do begin
        write('Ingresar nombre de la distribucion: ');
        readln(nombre);
        if(nombre <> 'fin')then begin
            write('Ingresar anio de lanzamiento: ');
            readln(anio);
            write('Ingresar version de kernel: ');
            readln(version);
            write('Ingresar cantidad de desarrolladores: ');
            readln(cant_desarrolladores);
            write('Ingresar descripcion: ');
            readln(descripcion);
        end;
    end;
end;

procedure crear_archivo(var m: archivo);
var
    d: distro;
begin
    rewrite(m);
    d.cant_desarrolladores := 0;
    write(m, d);
    leer_distro(d);
    while(d.nombre <> 'fin')do begin
        write(m, d);
        leer_distro(d);
    end;
    close(m);
end;

function existe_distribucion(var m:archivo; nombre:string):boolean;
var
    regm: distro;
    ok: boolean;
begin
    ok:= false;
    reset(m);
    read(m, regm); // no es necesario creo pero leo el registro head xd
    while(not eof(m))and(not ok)do begin
        read(m, regm);
        if(regm.nombre = nombre)and(regm.cant_desarrolladores > 0)then begin
            ok:= true;
        end;
    end;
    close(m);
    existe_distribucion := ok;
end;

procedure alta_distribucion(var m:archivo);
var
    d: distro;
    aux: distro;
begin
    leer_distro(d);
    if(not existe_distribucion(m, d.nombre))then begin
        reset(m);
        read(m, aux);
        if(aux.cant_desarrolladores < 0)then begin
            seek(m, Abs(aux.cant_desarrolladores));
            read(m, aux);
            seek(m, filepos(m)-1);
            write(m, d);
            seek(m, 0);
            write(m, aux);
        end
        else begin
            seek(m, filesize(m));
            write(m, d);                
        end;
        close(m);
        writeln('Se agrego la distribucion correctamente.');
    end
    else
        writeln('Ya existe la distribucion.');
end;

procedure baja_distribucion(var m: archivo);
var
    dist: string;
    head: integer;
    aux: distro;

begin

    write('Ingresar nombre de la dist: ');
    readln(dist);
    if(existe_distribucion(m, dist))then begin
        reset(m);
        read(m, aux);
        head := aux.cant_desarrolladores;
        read(m, aux);
        while(aux.nombre <> dist)do
            read(m, aux);
        aux.cant_desarrolladores := head;
        head := ((filepos(m)-1) * -1);
        seek(m, filepos(m)-1);
        write(m, aux);
        aux.cant_desarrolladores := head;
        seek(m, 0);
        write(m, aux);
        close(m);
        writeln('Se borro la distribucion correctamente.');
    end
    else
        writeln('Distribucion no existente.');
end;

procedure imprimir(var archivo: archivo);
var
    regm: distro;
begin
    reset(archivo);
    while(not eof(archivo))do begin
        read(archivo, regm);
        if(regm.cant_desarrolladores > 0)then
            writeln('nombre ', regm.nombre, ' cant_desarrolladores ', regm.cant_desarrolladores);
    end;
    close(archivo);
end;

var
    m: archivo;
begin
    assign(m, 'maestro');
    crear_archivo(m);
    alta_distribucion(m);
    baja_distribucion(m);
    imprimir(m);
end.