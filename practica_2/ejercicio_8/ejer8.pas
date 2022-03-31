program ejer8;
const
    valor_alto = 9999;
    ano_fin = 2050;
type
    cliente = record
        cod: integer;
        nombre: string[20];
        apellido: string[20];
    end;

    venta = record
        c: cliente;
        ano: 2000..ano_fin;
        mes: 1..12;
        dia: 1..31;
        monto_venta: real;
    end;

    archivo_maestro = file of venta;

procedure crear_maestro(var m: archivo_maestro);
    procedure leer_venta(var v: venta);
    begin
        with v do begin
            write('Ingresar codigo de cliente: ');
            readln(c.cod);
            if(c.cod <> -1)then begin
                write('Ingresar nombre del cliente: ');
                readln(c.nombre);
                write('Ingresar apellido del cliente: ');
                readln(c.apellido);

                write('Ingresar ano de la venta: ');
                readln(ano);
                write('Ingresar mes de la venta: ');
                readln(mes);             
                write('Ingresar dia de la venta: ');
                readln(dia);
                write('Ingresar monto de la venta: ');
                readln(monto_venta);             
             
            end;
        end;
    end;

var
    v: venta;
begin
    rewrite(m);
    writeln('Creacion de archivo maestro: ');
    leer_venta(v);
    while(v.c.cod <> -1)do begin
        write(m, v);
        leer_venta(v);
    end;
    close(m);
end;

procedure reporte_maestro(var m: archivo_maestro);
    procedure leer_venta_archivo(var m: archivo_maestro; var v: venta);
    begin
        if(not eof(m))then
            read(m, v)
        else
            v.c.cod := valor_alto;
    end;

procedure imprimir_cliente(c:cliente);
begin
    with c do 
        writeln('Cliente codigo: ', cod, 
        ' Nombre ', nombre, ' Apellido ', apellido);
end;

var
    v: venta;
    total_empresa: real;
    total_mes: real;
    total_ano: real;
    c: cliente;
    mes_act : 1..12;
    ano_act : 2000..ano_fin;
    total_cliente: real;
begin
    reset(m);
    total_empresa := 0;
    leer_venta_archivo(m, v);
    while(v.c.cod <> valor_alto)do begin
        c := v.c;
        writeln('=================================================');
        imprimir_cliente(c);
        writeln('=================================================');
        total_cliente := 0;
        while(v.c.cod = c.cod)do begin
            total_ano := 0;
            ano_act := v.ano;
            while(v.ano = ano_act)and(v.c.cod = c.cod)do begin
                mes_act := v.mes;
                total_mes := 0;
                while(v.c.cod = c.cod)and(v.ano = ano_act)and(v.mes = mes_act)do begin
                    total_mes := total_mes + v.monto_venta;
                    leer_venta_archivo(m, v);
                end;
                writeln('Total del mes ', mes_act, ' = $', total_mes:2:2);
                total_ano := total_ano + total_mes;
            end;
            writeln('=================================================');
            writeln('Total del ano ', ano_act, ' = $', total_ano:2:2);
            total_cliente := total_cliente + total_ano;
        end;
        writeln('=================================================');
        writeln('Total del cliente $', total_cliente:2:2);
        total_empresa := total_empresa + total_cliente;
    end;
    writeln('=================================================');   
    writeln('Total Empresa $', total_empresa:2:2);
    close(m);    
end;

var
    maestro : archivo_maestro;
begin
    assign(maestro, 'maestro');
    //crear_maestro(maestro);
    reporte_maestro(maestro);
end.