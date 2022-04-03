{
    Suponga que usted es administrador de un servidor de correo electrónico. En los logs
    del mismo (información guardada acerca de los movimientos que ocurren en el server) que
    se encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
    nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
    servidor de correo genera un archivo con la siguiente información: nro_usuario,
    cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
    usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
    sabe que un usuario puede enviar cero, uno o más mails por día.
    
    a- Realice el procedimiento necesario para actualizar la información del log en
    un día particular. Defina las estructuras de datos que utilice su procedimiento.
    b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
    detalle de un día determinado:
    nro_usuarioX..............cantidadMensajesEnviados
    .............
    nro_usuarioX+n...........cantidadMensajesEnviados
    Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
    existen en el sistema.

}

program ejer13;
const
    valor_alto = 9999;
type

    log = record
        nro_usuario : integer;
        nombre_usuario : string[25];
        nombre : string[25];
        apellido : string[25];
        cantidad_enviados : integer;
    end;

    mails = record
        nro_usuario : integer;
        cuenta_destino : string[90];
        cuerpo_mensaje : string;
    end;
    
    maestro = file of log;

    detalle = file of mails;

    procedure cargar_log(var reg_m: log);
    begin
        write('Ingrese numero de usuario: ');
        readln(reg_m.nro_usuario);
        if(reg_m.nro_usuario <> -1) then begin
            write('Ingrese nombre de usuario: ');
            readln(reg_m.nombre_usuario);
            write('Ingrese nombre: ');
            readln(reg_m.nombre);
            write('Ingrese apellido: ');
            readln(reg_m.apellido);
            write('Ingrese cantidad de mails enviados: ');
            readln(reg_m.cantidad_enviados);
        end;
    end;

    procedure crear_archivo_maestro(var arch: maestro);
    var
        reg_m: log;
    begin
        rewrite(arch);
        cargar_log(reg_m);
        while(reg_m.nro_usuario <> -1) do begin
            write(arch,reg_m);
            cargar_log(reg_m);
        end;
        close(arch);
    end;

    procedure leer(var arch: detalle; var regs: mails);
    begin
        if not eof(arch) then 
            read(arch,regs)
        else
            regs.nro_usuario := valor_alto;
    end;

    procedure cargar_logs_diarios(var regs:mails);
    begin
        write('Ingrese numero de usuario: ');
        readln(regs.nro_usuario);
        if(regs.nro_usuario <> -1) then begin
            write('Ingrese cuenta destino: ');
            readln(regs.cuenta_destino);
            write('Ingrese cuerpo de mensaje: ');
            readln(regs.cuerpo_mensaje);
        end;
    end;

    procedure crear_archivo_detalle(var arch: detalle);
    var
        regs: mails;
    begin
        rewrite(arch);
        cargar_logs_diarios(regs);
        while(regs.nro_usuario <> -1) do begin
            write(arch,regs);
            cargar_logs_diarios(regs);
        end;
        close(arch);
    end;


    procedure actualizar_maestro(var arch: maestro ; var mails: detalle);
    var
        reg_m: log;
        reg_d: mails;
    begin
        reset(arch);
        reset(mails);
        leer(mails, reg_d);
        while(reg_d.nro_usuario <> valor_alto) do begin
            read(arch,reg_m);
            while (reg_d.nro_usuario <> reg_m.nro_usuario) do
                read(arch,reg_m);
                
            while(reg_d.nro_usuario = reg_m.nro_usuario) do begin
                reg_m.cantidad_enviados := reg_m.cantidad_enviados + 1;
                leer(mails, reg_d);
            end;
            
            seek(arch,filepos(arch)-1);
            write(arch,reg_m);
        end;
        close(arch);
        close(mails);
    end;

    procedure exportar_a_txt(var arch: maestro ; var archivo_txt: Text);
    var
        reg_m: log;
    begin
        reset(arch);
        rewrite(archivo_txt);
        while not eof(arch) do begin
            read(arch,reg_m);
            writeln(archivo_txt,'nro_usuario: ',reg_m.nro_usuario,'   Cantidad de mensajes enviados ', reg_m.cantidad_enviados);
        end;
        close(arch);
        close(archivo_txt);
    end;

var
    m: maestro;
    d: detalle;
    archivo_txt: Text;
begin
    assign(m, 'maestro');
    assign(d, 'detalle');
    assign(archivo_txt, 'informe.txt');
    crear_archivo_maestro(m);
    crear_archivo_detalle(d);
    actualizar_maestro(m, d);
    exportar_a_txt(m, archivo_txt);
end.