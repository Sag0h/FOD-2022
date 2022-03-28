program ejer3;
const
	SUCURSALES = 30;
	VALOR_ALTO = 9999;
type
	
	producto = record
		cod:integer;
		nombre:string[15];
		descripcion:string[30];
		stock:integer;
		stockMin:integer;
		precio:real;
	end;
	
	actualizacion = record
		cod:integer;
		cantV:integer;
	end;
	
	archivo_maestro = file of producto;
	
	archivo_detalle = file of actualizacion;
	
	arreglo_detalle = array [1..SUCURSALES] of archivo_detalle;
	
	arreglo_act = array [1..SUCURSALES] of actualizacion;
{==========================================================================================================================================}	

procedure leer_producto(var datos:producto);

begin
	with datos do begin
		write('Ingrese codigo de producto: ');
		readln(cod);
		if( cod <> 0) then begin
			write('Ingrese nombre de producto: ');
			readln(nombre);
			write('Ingrese descripcion de producto: ');
			readln(descripcion);
			write('Ingrese stock actual del producto: ');
			readln(stock);
			write('Ingrese stock minimo del producto: ');
			readln(stockMin);
			write('Ingrese precio del producto: ');
			readln(precio);
		end;
	end;
end;

{==========================================================================================================================================}	

procedure crearMaestro(var a:archivo_maestro);
var
	p:producto;
begin

	writeln('INGRESAR LA INFORMACION ORDENADA POR CODIGO DE PRODUCTO!! ');
	rewrite(a);
	leer_producto(p);
	while(p.cod <> 0)do begin
		write(a, p);
		leer_producto(p);
	end;
	close(a);
end;

{==========================================================================================================================================}

procedure leer_detalles(var v:arreglo_detalle);
var
	i: integer;
	datos: actualizacion;
	str_i: string;
begin
	writeln('- - - - - - - - LECTURA DE ARCHIVOS DETALLE - - - - - - - -');
	for i:= 1 to SUCURSALES do begin
		
		{abro el archivo de la posicion actual}
		
		Str(i, str_i);
		assign(v[i], 'detalle'+str_i);
		rewrite(v[i]);
		
		{lleno el archivo actual}
		
		writeln('Sucursal ', i, ':');
		writeln('INGRESAR LA INFORMACION ORDENADA POR CODIGO DE PRODUCTO!!');
		write('Ingrese codigo de producto: ');
		readln(datos.cod);
		while(datos.cod <> 0)do begin
			write('Ingrese cantidad vendida: ');
			readln(datos.cantV);
			write(v[i], datos);
			write('Ingrese codigo de producto: ');
			readln(datos.cod);
		end;
		close(v[i]); {cierro el actual}
	end;

end;

{==========================================================================================================================================}

procedure leer(var archivo:archivo_detalle; var dato:actualizacion);
begin
    if (not eof( archivo ))then 
		read (archivo, dato)
    else 
		dato.cod := VALOR_ALTO;
end;

{==========================================================================================================================================}

procedure minimo (var reg_det: arreglo_act; var min:actualizacion; var deta:arreglo_detalle);
var 
	i: integer;
	minCod:integer;
	minPos:integer;
begin
      { busco el mínimo elemento del 
        vector reg_det en el campo cod,
        supongamos que es el índice i }
    minPos := 1;
    minCod:=32767;
    for i:= 1 to SUCURSALES do begin    	
		if(reg_det[i].cod < minCod)then begin
			min := reg_det[i];
			minCod := reg_det[i].cod;
			minPos := i;
		end;
	end;
	leer(deta[minPos], reg_det[minPos]);
	
end;     

{==========================================================================================================================================}

procedure actualizar_maestro(var a:archivo_maestro; var detalles:arreglo_detalle);
var
	i:integer;
	min:actualizacion;
	regm:producto;
	reg_det: arreglo_act;
	totalvendido: integer;
	codact: integer;
begin
	for i:= 1 to SUCURSALES do begin
		reset( detalles[i] );
		leer( detalles[i], reg_det[i]);
	end;
	
	reset(a);
	minimo(reg_det, min, detalles); {busco el detalle minimo}
	while (min.cod <> VALOR_ALTO) do begin
		totalvendido := 0;
		codact := min.cod;
		while(codact = min.cod ) do begin
			totalvendido:= totalvendido + min.cantV;
			minimo (reg_det, min, detalles);
		end;
		
		read(a, regm);
		while(regm.cod <> codact)do 
			read(a, regm);
		regm.stock := regm.stock - totalvendido;
		
		seek(a, filepos(a)-1);
		write(a, regm);
	end;    
	for i:= 1 to SUCURSALES do begin
		close(detalles[i]);
	end;
	close(a);
end;

{==========================================================================================================================================}

procedure exportar_txt(var a:archivo_maestro; var txt:Text);
var
	regm:producto;
begin
	rewrite(txt);
	reset(a);
	while(not eof(a))do begin
		read(a,regm);
		if(regm.stock < regm.stockMin)then
			with regm do
				writeln(txt,'Producto: ', nombre,' ',descripcion,' - stock disponible: ', stock,' - $', precio:2:2,'.');  	
	end;
	close(a);
	close(txt);
end;

{==========================================================================================================================================}

{Programa Principal}

var
	maestro: archivo_maestro;
	arreglo: arreglo_detalle;
	txt: Text;
begin
	assign(maestro, 'maestro');
	crearMaestro(maestro); //creo el maestro
	leer_detalles(arreglo); //creo los N detalles
    assign(txt, 'noStock.txt');
	actualizar_maestro(maestro,arreglo);
	exportar_txt(maestro, txt);
	readln();
end.