// 2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
// cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
// (cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
// un archivo detalle con el código de alumno e información correspondiente a una materia
// (esta información indica si aprobó la cursada o aprobó el final).
// Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
// haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
// programa con opciones para:

// a. Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.

// b. Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.

// c. Listar el contenido del archivo maestro en un archivo de texto llamado
// “reporteAlumnos.txt”.

// d. Listar el contenido del archivo detalle en un archivo de texto llamado
// “reporteDetalle.txt”.

// e. Actualizar el archivo maestro de la siguiente manera:

// i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
// ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
// final.

// f. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
// con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
// f -> ?? donde guardamos la info de una materia, si solo tenemos dos contadores, la condicion tiene que ser que los contadores sean <> o qué
// sino como sabemos q de esas 4 aprobadas cursada no tienen el final tambien ? 
// NOTA: Para la actualización del inciso e) los archivos deben ser recorridos sólo una vez.

program ejer2;
const
    valor_alto = 9999;
type
    alumno = record
        cod: integer;
        ape: string[20];
        nom: string[20];
        cant_a: integer;
        cant_f: integer;
    end;

    info_materia = record
        nom_mat: string[30];
        estado: char;
    end;

    end;

    actualizacion = record
        cod: integer;
        info: info_materia;
    end;

    maestro = file of alumno;
    detalle = file of actualizacion;

procedure crear_maestro(var m:maestro; var t:Text);
var
    a: alumno;
begin
    rewrite(m);
    reset(t);
    while(not eof(t))do begin
        with a do begin
            read(t, cod, nom, ape, cant_a, cant_f);            
        end;
        write(m, a);
    end;
    close(m);
    close(t);
end;

procedure crear_detalle(var d:detalle; var t:Text);
var
    a: actualizacion;
begin
    rewrite(d);
    reset(t);
    while(not eof(t))do begin
        with a do begin
            read(t, cod, info.nom_mat, info.estado);            
        end;
        write(d, a);
    end;
    close(d);
    close(t);
end;

procedure listar_maestro_en_txt(var m:maestro);
var
    t: Text;
    a: alumno;
begin
    assign(t, 'reporteAlumnos.txt');
    rewrite(t);
    reset(m);
    while(not eof(m))do begin
        read(m, a);
        with a do begin
            writeln(t, cod, nom, ape, cant_a, cant_f);
        end;
    end;
    close(t);
    close(m);
end;

procedure listar_detalle_en_txt(var d: detalle);
var
    t: Text;
    a: actualizacion;
begin
    assign(t, 'reporteDetalle.txt');
    rewrite(t);
    reset(d);
    while(not eof(d))do begin
        read(d, a);
        with a do begin
            writeln(t, cod, info.nom_mat, info.estado);
        end;
    end;
    close(t);
    close(d);
end;

procedure actualizar_maestro(var m:maestro; var d:detalle);
    procedure leer(var d:detalle; var a:actualizacion);
    begin
        if(not eof(d))then
            read(d, a)
        else
            a.cod := valor_alto;
    end;

var
    a:actualizacion;
    al:alumno;
begin
    reset(m);
    reset(d);
    leer(d, a);
    while(a.cod <> valor_alto)do begin
        read(m, al);
        while(al.cod = a.cod)do begin            
            if(a.info.estado = 'f' OR a.info.estado = 'F')then
                al.cant_f := al.cant_f + 1
            else
                al.cant_a := al.cant_a + 1;
            leer(d, a);
        end;
        seek(m, filepos(m)-1);
        write(m, al);   
    end;
    close(m);
    close(d);
end;

procedure listar_en_txt_alumnos(var m:maestro);
var

begin
    
end;

var
    archivo_maestro: maestro;
    archivo_detalle: detalle;
    maestro_text: Text;
    detalle_text: Text;
begin
    assign(archivo_maestro, 'maestro');
    assign(archivo_detalle, 'detalle');
    assign(maestro_text, 'maestro.txt');
    assign(detalle_text, 'detalle.txt');

    crear_maestro(archivo_maestro, maestro_text); //A
    crear_detalle(archivo_detalle, detalle_text); //B

    listar_maestro_en_txt(archivo_maestro); //C
    listar_detalle_en_txt(archivo_detalle); //D

    actualizar_maestro(archivo_maestro, archivo_detalle); //E
    listar_en_txt_alumnos(archivo_maestro); //F ??? preguntar como se hace, no entiendo el enunciado
end.