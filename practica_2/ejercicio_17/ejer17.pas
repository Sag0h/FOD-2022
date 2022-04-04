{

    Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con
    información de las motos que posee a la venta. De cada moto se registra: código, nombre,
    descripción, modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles
    con información de las ventas de cada uno de los 10 empleados que trabajan. De cada
    archivo detalle se dispone de la siguiente información: código de moto, precio y fecha de la
    venta. Se debe realizar un proceso que actualice el stock del archivo maestro desde los
    archivos detalles. Además se debe informar cuál fue la moto más vendida.
    NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
    ser recorrido sólo una vez y en forma simultánea con los detalles.

}

program ejer17;
const
    cant_detalles = 2; //10
    valor_alto = 9999;
type
    fechas = record
        anio: integer;
        mes: 1..12;
        dia: 1..31;
    end;

    moto = record
        cod:integer;
        nombre:string[25];
        modelo:string[15];
        marca:string[15];
        desc:string;
        stock_act:integer;
    end;

    venta = record
        cod:integer;
        precio: real;
        fecha_venta: fechas;
    end;

    archivo_maestro = file of moto;
    archivo_detalle = file of venta;

    detalles = array [ 1..cant_detalles ] of archivo_detalle;
    ventas = array [ 1..cant_detalles ] of venta;

procedure leer_moto(var m:moto);
begin
    with m do begin
        write('Ingresar codigo de moto: ');
        readln(cod);
        if (cod <> -1) then begin
            write('Ingresar nombre de la moto: ');
            readln(nombre);
            write('Ingresar modelo de la moto: ');
            readln(modelo);
            write('Ingresar marca de la moto: ');
            readln(marca);
            write('Ingresar la descripcion de la moto: ');
            readln(desc);
            write('Ingresar stock_act de moto: ');
            readln(stock_act);
        end;
    end;
end;


procedure crear_maestro(var m:archivo_maestro);
var
    d:moto;
begin
    writeln('CREACION DE ARCHIVO MAESTRO:');
    rewrite(m);
    leer_moto(d);
    while(d.cod <> -1)do begin
        write(m, d);
        leer_moto(d);
    end;
    close(m);
end;

procedure leer_venta(var v: venta);
begin
    with v do begin
        write('Ingresar codigo de moto: ');
        readln(cod);
        if(cod <> -1)then begin
            write('Ingresar precio de la moto: ');
            readln(precio);
            write('Ingresar anio de la venta: ');
            readln(fecha_venta.anio);
            write('Ingresar mes de la venta: ');
            readln(fecha_venta.mes);
            write('Ingresar dia de la venta: ');
            readln(fecha_venta.dia);
        end;
    end;
end;

procedure crear_detalles(var d:detalles);
var
    i: integer;
    str_i: string;
    v: venta;
begin
    writeln('CREANDO DETALLES: ');
    for i:=1 to cant_detalles do begin
        Str(i, str_i);
        assign(d[i], 'detalle'+str_i);
        rewrite(d[i]);
        writeln('LECTURA DE DETALLE '+ str_i, ': ');
        leer_venta(v);
        while(v.cod <> -1)do begin
            write(d[i], v);
            leer_venta(v);
        end;
        close(d[i]);
    end;
end;

procedure leer(var a:archivo_detalle; var d:venta);
begin
    if(not eof(a))then
        read(a, d)
    else
        d.cod := valor_alto;
end;


procedure minimo(var d:detalles ; var v: ventas  ; var reg_d: venta);
var
    pos: integer;
    i:integer;
begin
    pos:= 1;
    reg_d.cod := valor_alto;
    for i:= 1 to cant_detalles do begin
        if(v[i].cod < reg_d.cod) then begin
            reg_d := v[i];
            pos:= i;
        end;
    end;
    if(reg_d.cod <> valor_alto) then
        leer(d[pos],v[pos]);
end;


procedure actualizar_e_informar_mas_vendida(var m:archivo_maestro; var d:detalles);
var
    i: integer;
    v_aux: ventas;
    reg_m: moto;
    min: venta;
    moto_mas_vendida: moto;
    //i_str: string;
begin
    moto_mas_vendida.stock_act := valor_alto;
    reset(m);
    for i:=1 to cant_detalles do begin
        //Str(i,i_str);
        //assign(d[i], 'detalle'+i_str);
        reset(d[i]);
        leer(d[i], v_aux[i]);
    end;
    minimo(d, v_aux, min);
    while(min.cod <> valor_alto)do begin
        read(m, reg_m);
        while(reg_m.cod <> min.cod) do
            read(m, reg_m);
        while(reg_m.cod = min.cod) do begin
            reg_m.stock_act := reg_m.stock_act - 1;  
            minimo(d,v_aux,min);
        end;
        if(reg_m.stock_act < moto_mas_vendida.stock_act)then
            moto_mas_vendida := reg_m;
        seek(m, filepos(m)-1);
        write(m, reg_m);
    end;
    for i:=1 to cant_detalles do
        close(d[i]);
    close(m);
    writeln('La moto mas vendida es: ', moto_mas_vendida.cod);
end;

var
    m: archivo_maestro;
    d:detalles;
begin
    assign(m, 'maestro');
    crear_maestro(m);
    crear_detalles(d);
    actualizar_e_informar_mas_vendida(m, d);
end.