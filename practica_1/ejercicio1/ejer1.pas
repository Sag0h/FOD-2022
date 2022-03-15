{ 1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo. }

program ejer1;

type
    fi = file of integer;
var
    a: fi;
    name: string;
    num: integer;
begin
    write('Ingrese el nombre del puto archivo de los cojones: ');
    readln(name);
    Assign(a, name);
    rewrite(a);
    write('Ingresar un numero: ');
    readln(num);
    while(num <> 30000)do begin
        write(a, num);
        write('Ingresar un numero: ');
        readln(num);      
    end;
    close(a);
end.