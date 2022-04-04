program ejer18;
const
    valor_alto = 9999;
type
    info_covid = record
        cod_localidad: integer;
        nombre_localidad: string[25];
        cod_municipio: integer;
        nombre_municipio: string[25];
        cod_hospital: integer;
        nombre_hospital: string[40];
        fecha: string;
        cant_positivos: integer;
    end;

    maestro = file of info_covid;

procedure leer_info_covid(var d: info_covid);
begin
    with d do begin
        write('Ingresar codigo de localidad: ');
        readln(cod_localidad);
        if(cod_localidad <> -1)then begin
            write('Ingresar nombre de la localidad: ');
            readln(nombre_localidad);
            
            write('Ingresar codigo de municipio: ');
            readln(cod_municipio);
            write('Ingresar nombre del municipio: ');
            readln(nombre_municipio);

            write('Ingresar codigo del hospital: ');
            readln(cod_hospital);
            write('Ingresar nombre del hospital: ');
            readln(nombre_hospital);

            write('Ingresar fecha: ');
            readln(fecha);
            
            write('Ingresar cantidad de casos positivos: ');
            readln(cant_positivos);
        end;
    end;
end;

procedure crear_maestro(var m: maestro);
var
    d: info_covid;
begin
    rewrite(m);
    leer_info_covid(d);
    while(d.cod_localidad <> -1)do begin
        write(m, d);
        leer_info_covid(d);
    end;
    close(m);
end;

procedure leer(var m:maestro; var d:info_covid);
begin
    if(not eof(m))then
        read(m, d)
    else
        d.cod_localidad := valor_alto;
end;

procedure imprimir_casos_y_exportar(var m: maestro; var txt: Text);
var
    regm: info_covid;
    loc_act: integer;
    mun_act: integer;
    hosp_act: integer;

    n_loc_act: string[25];
    n_mun_act: string[25];
    n_hos_act: string[40];

    cant_loc: integer;
    cant_mun: integer;
    cant_hosp: integer;
    cant_prov: integer;
begin
    reset(m);
    rewrite(txt);
    cant_prov := 0;
    leer(m, regm);
    while(regm.cod_localidad <> valor_alto)do begin
        loc_act := regm.cod_localidad;
        cant_loc := 0;
        n_loc_act:= regm.nombre_localidad;
        writeln('Localidad: ', n_loc_act);
        while(regm.cod_localidad = loc_act)do begin
            cant_mun := 0;
            mun_act := regm.cod_municipio;
            n_mun_act := regm.nombre_municipio;
            writeln('   Municipio ', n_mun_act);
            while(regm.cod_localidad = loc_act) and (regm.cod_municipio = mun_act)do begin
                hosp_act := regm.cod_hospital;
                n_hos_act := regm.nombre_hospital;
                cant_hosp := 0;
                while(regm.cod_localidad = loc_act) and (regm.cod_municipio = mun_act) and (regm.cod_hospital = hosp_act) do begin
                    cant_hosp := cant_hosp + regm.cant_positivos;
                    leer(m, regm);
                end;
                cant_mun := cant_mun + cant_hosp;
                writeln('       Hospital ', n_hos_act,'         Cantidad de casos ', cant_hosp);
            end;
                            
            if(cant_mun > 1500)then begin
                writeln(txt, n_loc_act);
                writeln(txt, cant_mun,' ',n_mun_act);
            end;

            cant_loc := cant_loc + cant_mun;
            writeln('   Cantidad de casos del municipio ', n_mun_act,' ', cant_mun);
        end;
        cant_prov := cant_prov + cant_loc;
        writeln('Cantidad casos de localidad ', n_loc_act,' ', cant_loc);
        writeln('-----------------------------------------------------');
    end;
    writeln('Cantidad de casos Totales en la provincia ', cant_prov);
    close(m);
    close(txt);    
end;

var
    m: maestro;
    txt: Text;
begin
    assign(m, 'maestro');
    assign(txt, 'muchos_casos.txt');
    crear_maestro(m);
    imprimir_casos_y_exportar(m, txt); 
end.