{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.
}

program ejer2;
type
    fi= file of integer;

function prom(sum:integer; cant:integer):real;
begin
    prom := (sum/cant);
end;


var
    f_int : fi;
    sum : integer;
    cant : integer;
    num: integer;
    nombre: string;
begin
    write( 'Ingresar nombre del archivo a procesar: ');
    readln(nombre);
    cant := 0;
    sum := 0;
    Assign(f_int, nombre);
    reset(f_int);
    while( not Eof(f_int)) do begin
        read(f_int, num);
        sum := sum + num;
        if(num < 1500)then
          cant := cant + 1;
    end;
    writeln('La cantidad de numeros menores a 1500 es de: ', cant);
    writeln('El promedio de numeros menores es de: ', prom(sum, FileSize(f_int)):2:2);
    close(f_int);
end.
