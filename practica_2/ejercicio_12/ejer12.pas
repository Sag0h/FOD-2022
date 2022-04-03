
program ejer12;
const
	
	valor_alto = 9999;

type
	fechas = record
		anio : integer;
		mes : 1..12;
		dia : 1..31;
	end;

	acceso = record
		fecha : fechas;
		idUsuario : integer;
		tiempo : integer;
	end;
	
	archivo_maestro = file of acceso;
	
{==========================================================================================================================================}		
	
procedure leer_info(var datos:acceso);
begin
	with datos do begin
		write('Ingrese Anio: ');
		readln(fecha.anio);
		if(fecha.anio <> 0) then begin
			write('Ingrese Mes: ');
			readln(fecha.mes);
			write('Ingrese Dia: ');
			readln(fecha.dia);
			write('Ingrese ID del usuario: ');
			readln(idUsuario);
			write('Ingrese Tiempo de acceso al sitio, en minutos: ');
			readln(tiempo);
		end;
	end;
end;

{==========================================================================================================================================}	

procedure crear_maestro(var a:archivo_maestro);
var
	p:acceso;
begin

	writeln('INGRESAR LA INFORMACION ORDENADA POR ANIO, MES, DIA E ID DE USUARIO! ');
	rewrite(a);
	leer_info(p);
	while(p.fecha.anio <> 0)do begin
		write(a, p);
		leer_info(p);
	end;
	close(a);
end;

{==========================================================================================================================================}

procedure generar_informe(var a:archivo_maestro);
var
	anio:integer;
	ok:boolean;
	regm:acceso;
	mes_act:integer;
	dia_act:integer;
	usuario_act:integer;
	tiempo_total_usuario:integer;
	
	tiempo_total_dia:integer;
	tiempo_total_mes:integer;
	tiempo_total_anio:integer;
begin
	ok:=false;
	write('Ingresar anio para el cual quiere generar un informe: ');
	readln(anio);
	reset(a);
	while(not eof(a))and(not ok)do begin
		read(a, regm);
		if(regm.fecha.anio = anio)then
			ok:=true;
	end;
	if(ok)then begin
		writeln('Año: ', anio);
		tiempo_total_anio:=0;
		while(regm.fecha.anio = anio)do begin
			tiempo_total_mes:=0;
			writeln('	Mes: ', regm.fecha.mes);
			
			mes_act:= regm.fecha.mes;
			
			while(regm.fecha.anio = anio)and(regm.fecha.mes = mes_act)do begin
				writeln('		dia: ', regm.fecha.dia);
				dia_act := regm.fecha.dia;
				
				
				tiempo_total_dia := 0;
				
				while(regm.fecha.anio = anio)and(regm.fecha.mes = mes_act)and(regm.fecha.dia = dia_act)do begin
					tiempo_total_usuario := 0;
					usuario_act := regm.idUsuario;
					
					while(regm.idUsuario = usuario_act)and(regm.fecha.anio = anio)and(regm.fecha.mes = mes_act)and(regm.fecha.dia = dia_act)do begin
						tiempo_total_usuario := tiempo_total_usuario + regm.tiempo;
						if(not eof(a))then
							read(a, regm)
						else
							regm.fecha.anio := 0;
					end;
					tiempo_total_dia:=tiempo_total_dia + tiempo_total_usuario;
					writeln('			 ', usuario_act,'   Tiempo Total de acceso en el dia ', dia_act, ' mes ', mes_act,': ', tiempo_total_usuario);
					
				end;
				writeln('		Tiempo total de acceso dia ',dia_act, ' mes ', mes_act,': ',tiempo_total_dia); 
				tiempo_total_mes:=tiempo_total_mes + tiempo_total_dia;
			end;
			tiempo_total_anio := tiempo_total_anio + tiempo_total_mes;
			writeln('	Total tiempo de acceso mes ', mes_act,': ', tiempo_total_mes); 
		end;
		writeln('Total tiempo de acceso año: ', tiempo_total_anio);
	end	
	else 
		writeln('Anio no encontrado.');
	close(a);
end;

{==========================================================================================================================================}

{Programa Principal}

var
	a:archivo_maestro;
	
begin
	assign(a, 'maestro');
	crear_maestro(a);
	generar_informe(a);
end.