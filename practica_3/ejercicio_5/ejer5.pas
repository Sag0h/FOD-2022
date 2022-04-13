program ejer5;

type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
    end;

    t_arch_flores = file of reg_flor;

procedure leer_flor(var flor:reg_flor);
begin
    with flor do begin
        write('Ingresar codigo de flor: ');
        readln(codigo);
        if(codigo <> -1)then begin
            write('Ingresar nombre de la flor: ');
            readln(nombre);
        end;
    end;
end;

procedure crear_archivo(var a: t_arch_flores);
var 
    regm: reg_flor;
begin
    rewrite(a);
    regm.codigo := 0;
    write(a, regm);
    leer_flor(regm);
    while(regm.codigo <> -1) do begin
        write(a, regm);
        leer_flor(regm);
    end;
    close(a);
end;

procedure agregarFlor (var a: t_arch_flores ; nombre: string; codigo:integer);
var
    flor: reg_flor;
    aux: reg_flor;
begin
    flor.codigo := codigo;
    flor.nombre := nombre;
    reset(a);
    read(a, aux);
    if(aux.codigo > 0)then begin
        seek(a, Abs(aux.codigo));
        read(a, aux);
        seek(a, filepos(a)-1);
        write(a, flor);
        seek(a, 0);
        write(a, aux);
    end
    else
    begin
        seek(a, filesize(a));
        write(a, flor);
    end;
    close(a);
end;

procedure listar_archivo(var a: t_arch_flores);
var
    regm: reg_flor;
begin
    reset(a);
    while(not eof(a))do begin
        read(a, regm);
        if(regm.codigo > 0)then
            writeln('Flor: ', regm.nombre, ' Codigo ', regm.codigo,'.');
    end;
    close(a);
end;

procedure eliminarFlor (var a: t_arch_flores; flor:reg_flor);
var
    head: integer;
    regm: reg_flor;
begin
    reset(a);
    read(a, regm);
    head := regm.codigo;
    while(not eof(a))and(regm.codigo <> flor.codigo)do begin
        read(a, regm);
    end;
    if(not eof(a))then begin
        regm.codigo := head;
        head := filepos(a) * -1;
        seek(a, filepos(a)-1);
        write(a, regm);
        regm.codigo := head;
        seek(a, 0);
        write(a, regm);
    end;
    close(a);
end;


var
    m: t_arch_flores;
    flor: reg_flor;
begin
    assign(m, 'maestro');
    //crear_archivo(m);
    // agregarFlor(m, 'Rosa', 1);
    // agregarFlor(m, 'Hortensia', 3);
    // agregarFlor(m, 'Azucena ', 2);
    // agregarFlor(m, 'Margarita', 4);
    listar_archivo(m);
    flor.codigo := 3;
    flor.nombre := 'Hortensia';
    eliminarFlor(m, flor);
    writeln('DESPUES DE BORRAR HORTENSIA.');
    listar_archivo(m);
end.