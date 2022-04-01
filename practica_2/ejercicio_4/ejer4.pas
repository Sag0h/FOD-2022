{4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo dia en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}

program ejer4;
const
    cant_detalles = 5;
    valor_alto = 9999;
type
    log = record
        cod_usuario : integer;
        fecha : string;
        tiempo : integer;
    end;

    logs = record
        cod_usuario : integer;
        //fecha : string; cual fecha???? si es un archivo maestro (ultima fecha? actual? cual)
        tiempo_total : integer;
    end;

    detalle = file of log;
    maestro = file of logs;

    detalles = array [1..cant_detalles] of detalle;
    vector_logs = array [1..cant_detalles] of log;

procedure crear_detalles(var det:detalles);
    procedure leer_detalle(var datos:log);
    begin
        with datos do begin
            write('Ingresar codigo de usuario: ');
            readln(cod_usuario);
            if(cod_usuario <> 0)then begin
                write('Ingresar fecha: ');
                readln(fecha);
                write('Ingresar tiempo de sesión: ');
                readln(tiempo);                
            end;
        end;
    end;
var
    i : integer;
    datos : log;
    str_i : string;
begin
    for i:=1 to cant_detalles do begin
        Str(i, str_i);
        assign(det[i], 'det'+str_i);
        rewrite(det[i]);
        writeln('Archivo detalle ', i, ': ');
        leer_detalle(datos);
        while(datos.cod_usuario <> 0) do begin
            write(det[i], datos);
            leer_detalle(datos);            
        end;
        close(det[i]);
    end;
end;

procedure ver_maestro(var m: maestro);
var
    reg:logs;
begin
    reset(m);
    while(not eof(m))do begin
        read(m, reg);
        writeln('cod ', reg.cod_usuario, ' tiempo total ', reg.tiempo_total);
    end;
    close(m);
end;

procedure crear_maestro(var det: detalles; var arch: maestro);
    procedure leer_log(var l:log; var arch:detalle);
    begin
        if(not eof(arch))then
            read(arch, l)
        else
            l.cod_usuario := valor_alto;
    end;

    procedure abrir_detalles(var det:detalles; var v:vector_logs);
    var i:integer;
    begin
        for i:=1 to cant_detalles do begin
            reset(det[i]);
            leer_log(v[i], det[i]);
        end;
    end;

    procedure minimo(var det: detalles; var v_logs:vector_logs; var min: log);
    var
        i:integer;
        pos_min:integer;
    begin
        min.cod_usuario := valor_alto;
        for i:=1 to cant_detalles do begin
            if(v_logs[i].cod_usuario < min.cod_usuario)then begin
                min := v_logs[i];
                pos_min := i;
            end;
        end;
        if(min.cod_usuario <> valor_alto)then
            leer_log(v_logs[pos_min], det[pos_min]);    
    end;

var
    v_act:vector_logs;
    min:log;
    reg_m:logs;
    reg:logs;
begin
    rewrite(arch);
    //Abro los detalle y lleno el vector con el primer dato de cada detalle
    abrir_detalles(det, v_act);
    //Busco el minimo entre los elementos del vector, actualizando el vector en esa posicion, leyendo del archivo nuevamente
    minimo(det, v_act, min);
    while(min.cod_usuario <> valor_alto)do begin
        reg_m.cod_usuario := min.cod_usuario;
        reg_m.tiempo_total := 0;
        while(reg_m.cod_usuario = min.cod_usuario)do begin
            reg_m.tiempo_total := reg_m.tiempo_total + min.tiempo; // sumo el tiempo total para ese codigo
            minimo(det, v_act, min); // busco el minimo de nuevo, si camia salgo del loop y escribo en maestro
        end;
        read(arch, reg);
        while(reg.cod_usuario <> reg_m.cod_usuario)do 
            read(arch, reg);
        seek(arch, filepos(arch)-1);
        write(arch, reg_m);
    end;
    close(arch);

    ver_maestro(arch);
end;

var
    archivo_maestro : maestro;
    archivos_detalle : detalles;
begin
    assign(archivo_maestro, 'maestro');
    crear_detalles(archivos_detalle);
    crear_maestro(archivos_detalle, archivo_maestro);    
end.