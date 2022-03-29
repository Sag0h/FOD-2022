{5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidasen la provincia,
 un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.
Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
deberá, además, listar en un archivo de texto la información recolectada de cada persona.
Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.}

program ejer5;
const
    cant_archivos = 2;    
    valor_alto = 9999;
type

    direccion = record
        calle : string;
        numero : string;
        piso : string;
        depto : string;
        ciudad : string;
    end;

    persona = record
        partida_nacimiento : integer;
        nombre : string;
        apellido : string;
        dir : direccion;    
    end;

    padre = record
        nombre : string;
        apellido : string;
        DNI : string;
    end;

    nacimiento = record
        datos_persona : persona;
        matricula_medico : integer;
        datos_madre : padre;
        datos_padre : padre;
    end;

    deceso = record
        matricula_medico : integer;
        fecha_y_hora : string;
        lugar_deceso : string;
    end;

    fallecimiento = record
        datos_persona : persona;
        info_fallecimiento : deceso;
    end;

    nacimientos = file of nacimiento;
    fallecimientos = file of fallecimiento;

    detalles_nacimientos = array[1..cant_archivos] of nacimientos;
    detalles_fallecimientos = array[1..cant_archivos] of fallecimientos;

    info_maestro = record
        info_nacimiento : nacimiento;
        info_fallecimiento : deceso;
    end;

    maestro = file of info_maestro;

    arreglo_nacimientos = array[1..cant_archivos] of nacimiento;
    arreglo_decesos = array[1..cant_archivos] of fallecimiento;

procedure leer_direccion(var d: direccion);
begin
    with d do begin
        write('Ingresar calle: ');
        readln(calle);
        write('Ingresar numero: ');
        readln(numero);
        write('Ingresar piso: ');
        readln(piso);
        write('Ingresar depto: ');
        readln(depto);
        write('Ingresar ciudad: ');
        readln(ciudad);
    end;
end;


procedure leer_datos_persona(var datos: persona);
begin
    with datos do begin
        write('Ingresar nro de partida de nacimiento: ');
        readln(partida_nacimiento);
        if(partida_nacimiento <> -1)then begin
            write('Ingresar nombre de persona: ');
            readln(nombre);
            write('Ingresar apellido de persona: ');
            readln(apellido);
            leer_direccion(dir);
        end;        
    end;
end;

procedure leer_deceso(var d:deceso);
begin
    with d do begin
        write('Ingresar numero de matricula del medico que firmo el deceso: ');
        readln(matricula_medico);
        write('Ingresar fecha y hora del deceso: ');
        readln(fecha_y_hora);
        write('Ingresar lugar de deceso: ');
        readln(lugar_deceso);
    end;
end;

procedure crear_detalle_fallecimientos(var d:detalles_fallecimientos);

    procedure leer_fallecimiento(var f: fallecimiento);
    begin
        with f do begin
            leer_datos_persona(datos_persona);
            if(datos_persona.partida_nacimiento <> -1)then begin
                leer_deceso(info_fallecimiento);
            end;
        end;
    end;

var
    datos: fallecimiento;
    i: integer;
    str_i: string;
begin
    for i:=1 to cant_archivos do begin
        Str(i, str_i);
        assign(d[i], 'detalle '+str_i);
        rewrite(d[i]);
        writeln('Archivo detalle de fallecimientos ', i, ': ');
        leer_fallecimiento(datos);
        while(datos.datos_persona.partida_nacimiento <> -1)do begin
            write(d[i], datos);
            leer_fallecimiento(datos);
        end;
        close(d[i]);
    end;
end;



procedure crear_detalle_nacimientos(var d:detalles_nacimientos);

    procedure leer_nacimiento(var n: nacimiento);
    begin
        with n do begin
            leer_datos_persona(datos_persona);
            if(datos_persona.partida_nacimiento <> -1)then begin
                write('Ingresar numero de matricula del medico: ');
                readln(n.matricula_medico);

                write('Ingresar nombre de la madre: ');
                readln(n.datos_madre.nombre);
                write('Ingresar apellido de la madre: ');
                readln(n.datos_madre.apellido);
                write('Ingresar DNI de la madre: ');
                readln(n.datos_madre.DNI);
                
                write('Ingresar nombre de la padre: ');
                readln(n.datos_padre.nombre);
                write('Ingresar apellido de la padre: ');
                readln(n.datos_padre.apellido);
                write('Ingresar DNI de la padre: ');
                readln(n.datos_padre.DNI);

            end;
        end;
    end;

var
    datos: nacimiento;
    i: integer;
    str_i: string;
begin
    for i:=1 to cant_archivos do begin
        Str(i, str_i);
        assign(d[i], 'detalle'+str_i);
        rewrite(d[i]);
        writeln('Archivo detalle de nacimientos ', i, ': ');
        leer_nacimiento(datos);
        while(datos.datos_persona.partida_nacimiento <> -1)do begin
            write(d[i], datos);
            leer_nacimiento(datos);
        end;
        close(d[i]);
    end;
end;

procedure leer_nacimiento_archivo(var fn: nacimientos; var n:nacimiento);
begin
    if(not eof(fn))then
        read(fn, n)
    else
        n.datos_persona.partida_nacimiento := valor_alto;
end;

procedure leer_deceso_archivo(var fd: fallecimientos; var d: fallecimiento);
begin
    if(not eof(fd))then
        read(fd, d)
    else
        d.datos_persona.partida_nacimiento := valor_alto;
end;


procedure minimo_nacimiento(var dn: detalles_nacimientos; var vn: arreglo_nacimientos; var min: nacimiento);
var
    i: integer;
    pos_min: integer;
begin
    min.datos_persona.partida_nacimiento := valor_alto;
    for i:= 1 to cant_archivos do begin
        if(vn[i].datos_persona.partida_nacimiento < min.datos_persona.partida_nacimiento)then begin
            min := vn[i];
            pos_min := i;
        end;
    end;

    if(min.datos_persona.partida_nacimiento <> valor_alto)then
        leer_nacimiento_archivo(dn[pos_min], vn[pos_min]);
end;

procedure minimo_fallecimiento(var df: detalles_fallecimientos; var vf: arreglo_decesos; var min: fallecimiento);
var
    i: integer;
    pos_min: integer;
begin
    min.datos_persona.partida_nacimiento := valor_alto;
    for i:= 1 to cant_archivos do begin
        if(vf[i].datos_persona.partida_nacimiento < min.datos_persona.partida_nacimiento)then begin
            min := vf[i];
            pos_min := i;
        end;
    end;

    if(min.datos_persona.partida_nacimiento <> valor_alto)then
        leer_deceso_archivo(df[pos_min], vf[pos_min]);
end;

procedure crear_maestro(var m:maestro; var mt:Text; var det_n:detalles_nacimientos; var det_d:detalles_fallecimientos);
var
    i: integer;
    vn: arreglo_nacimientos;
    vd: arreglo_decesos;

    min_n: nacimiento;
    min_d: fallecimiento;

    reg_maestro: info_maestro;
    fallecio: boolean;
begin
    rewrite(m);
    rewrite(mt);
    
    for i:= 1 to cant_archivos do begin
        reset(det_n[i]);
        leer_nacimiento_archivo(det_n[i], vn[i]);
        reset(det_d[i]);
        leer_deceso_archivo(det_d[i], vd[i]);
    end;

    minimo_nacimiento(det_n, vn, min_n);
    minimo_fallecimiento(det_d, vd, min_d);

    while(min_n.datos_persona.partida_nacimiento <> valor_alto)do begin
        fallecio := false;
        reg_maestro.info_nacimiento := min_n;
        if(min_d.datos_persona.partida_nacimiento = min_n.datos_persona.partida_nacimiento)then begin
            reg_maestro.info_fallecimiento := min_d.info_fallecimiento;
            fallecio := true;
            minimo_fallecimiento(det_d, vd, min_d);
        end;
        write(m, reg_maestro);
        with reg_maestro do begin    
            write(mt,' Partida numero: ',info_nacimiento.datos_persona.partida_nacimiento,' Nombre y apellido: ',info_nacimiento.datos_persona.nombre,' ',info_nacimiento.datos_persona.apellido,' Direccion ',
            info_nacimiento.datos_persona.dir.calle,' ',info_nacimiento.datos_persona.dir.numero, ' ', info_nacimiento.datos_persona.dir.piso
            ,' ', info_nacimiento.datos_persona.dir.depto, ' ', info_nacimiento.datos_persona.dir.ciudad, ' Nombre y apellido de la madre: ',info_nacimiento.datos_madre.nombre,' ', info_nacimiento.datos_madre.apellido,
            ' DNI de la madre: ', info_nacimiento.datos_madre.DNI,' Nombre y apellido del padre: ',info_nacimiento.datos_padre.nombre,' ', info_nacimiento.datos_padre.apellido,
            ' DNI del padre: ', info_nacimiento.datos_padre.DNI);
            if(fallecio)then
                write(mt, ' Informacion de deceso: Matricula del medico que firmo el deceso: ', info_fallecimiento.matricula_medico,' Fecha y hora: ', info_fallecimiento.fecha_y_hora, 
                ' lugar de deceso: ', info_fallecimiento.lugar_deceso);
            writeln(mt, ' ');
        end;
        minimo_nacimiento(det_n, vn, min_n);
    end;
    for i:= 1 to cant_archivos do begin
        close(det_n[i]);
        close(det_d[i]);
    end;
    close(m);
    close(mt);
end;


var
    archivos_de_nacimientos: detalles_nacimientos;
    archivos_de_fallecimientos: detalles_fallecimientos;
    archivo_maestro: maestro;
    archivo_maestro_text: Text;
begin
    assign(archivo_maestro, 'maestro');
    assign(archivo_maestro_text, 'maestro.txt');
    crear_detalle_nacimientos(archivos_de_nacimientos); // instancio los N detalles
    crear_detalle_fallecimientos(archivos_de_fallecimientos); // instancio los N detalles

    crear_maestro(archivo_maestro, archivo_maestro_text, archivos_de_nacimientos, archivos_de_fallecimientos);

end.
