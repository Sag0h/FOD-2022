program ejer7;
const
    valor_alto = 9999;

type
    producto = record
        cod: integer;
        nombre: string;
        precio: real;
        stock_act: integer;
        stock_min: integer;
    end;

    archivo_maestro = file of producto;

    venta = record
        cod: integer;
        cant_vendidos: integer;
    end;

    archivo_detalle = file of venta;


procedure crear_maestro(var m: archivo_maestro);
    procedure leer_producto(var p: producto);
    begin
        with p do begin
            write('Ingresar codigo de producto: ');
            readln(cod);
            if(cod <> -1)then begin
                write('Ingresar nombre de producto: ');
                readln(nombre);
                write('Ingresar precio de producto: ');
                readln(precio);
                write('Ingresar stock actual del producto: ');
                readln(stock_act);
                write('Ingresar stock minimo del producto: ');
                readln(stock_min);             
            end;
        end;
    end;

var
    p: producto;
begin
    rewrite(m);
    writeln('Creacion de archivo maestro: ');
    leer_producto(p);
    while(p.cod <> -1)do begin
        write(m, p);
        leer_producto(p);
    end;
    close(m);
end;

procedure  crear_detalle(var d: archivo_detalle);
    procedure leer_venta(var v: venta);
    begin
        with v do begin
            write('Ingresar codigo de producto: ');
            read(cod);
            if(cod <> -1)then begin
                write('Ingresar cantidad de unidades vendidas: ');
                read(cant_vendidos);    
            end;
        end;
    end;
var 
    v: venta;
begin
    rewrite(d);
    writeln('Creacion de archivo detalle: ');
    leer_venta(v);
    while(v.cod <> -1)do begin
        write(d, v);
        leer_venta(v);
    end;
    close(d);
end;

procedure actualizar_maestro(var m:archivo_maestro; var d:archivo_detalle);
    procedure leer_venta_archivo(var d: archivo_detalle; var v:venta);
    begin
        if(not eof(d))then
            read(d, v)
        else
            v.cod := valor_alto;
    end;

var 
    p: producto;
    v: venta;
    v_act: venta;
begin
    reset(m);
    reset(d);

    leer_venta_archivo(d, v);
    while(v.cod <> valor_alto)do begin
        v_act.cod := v.cod;
        v_act.cant_vendidos := 0;
        while(v_act.cod = v.cod)do begin
            v_act.cant_vendidos := v_act.cant_vendidos + v.cant_vendidos;
            leer_venta_archivo(d, v);
        end;
        read(m, p);
        while(p.cod <> v_act.cod)do
            read(m, p);
        p.stock_act := p.stock_act - v_act.cant_vendidos;
        seek(m, filepos(m)-1);
        write(m, p);
    end;

    close(m);
    close(d);

end;

procedure listar_stock_min(var m: archivo_maestro; var txt: Text);
var
    p: producto;
begin
    reset(m);
    rewrite(txt);
    while(not eof(m))do begin
        read(m, p);
        if(p.stock_act < p.stock_min)then
            with p do
                writeln(txt, 'Codigo de producto: ', cod, 
                ' Nombre: ', nombre, ' Precio de venta: $',
                 precio:2:2, ' Stock actual: ', stock_act, ' Stock minimo: ', stock_min);
    end;
    close(txt);
    close(m);
end;

var
    maestro : archivo_maestro;
    detalle : archivo_detalle;
    txt: Text;

begin
    assign(detalle, 'detalle');
    assign(maestro, 'maestro');
    crear_maestro(maestro);
    crear_detalle(detalle);
    actualizar_maestro(maestro, detalle);
    assign(txt, 'stock_minimo.txt');
    listar_stock_min(maestro, txt);
end.