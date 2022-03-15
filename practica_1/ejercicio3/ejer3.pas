{3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
única vez.}

program ejer3;
type
    empleado = record
        num: integer;
        ape: string[15];
        nom: string[15];
        edad: integer;
        dni: string[8];
    end;

    fe = file of empleado;



procedure leer_empleado(var e: empleado);
begin
    write('Ingrese apellido del empleado: ');
    readln(e.ape);
    if(e.ape <> 'fin')then begin
        write('Ingrese nombre del empleado: ');
        readln(e.nom);
        write('Ingrese numero del empleado: ');
        readln(e.num);
        write('Ingrese edad del empleado: ');
        readln(e.edad);
        write('Ingrese dni del empleado: ');
        readln(e.dni);
    end;
end;

procedure listar_empleado(emp: empleado);
begin
    writeln(#9+'Apellido: '+ emp.ape + ' Nombre: '+ emp.nom+ ' Numero de empleado: ', emp.num ,' Edad: ',emp.edad,' Dni: '+ emp.dni);
end;

procedure crear_archivo_empleados(var file_emp:fe);
var
    file_name : string;
    emp : empleado;
begin
    write(#10+'Ingresar el nombre que tendra el archivo: ');
    readln(file_name);
    Assign(file_emp, file_name);
    rewrite(file_emp);
    leer_empleado(emp);
    while(emp.ape <> 'fin')do begin
        write(file_emp, emp);
        leer_empleado(emp);
    end;
    close(file_emp);
    readln();
end;


procedure listar_nombre_ape(var file_emp: fe);
var
    emp : empleado;
    name : string;
    file_name : string;
begin
    write(#10+'Ingresar nombre del archivo que desea abrir: ');
    readln(file_name);
    Assign(file_emp, file_name);
    write('Ingrese nombre o apellido a buscar: ');
    readln(name);
    writeln('Empleados que coinciden con el nombre o apellido ingresado: '+ #10);
    reset(file_emp);
    while(not eof(file_emp))do begin
        read(file_emp, emp);
        if(emp.nom = name)or(emp.ape = name) then
            listar_empleado(emp);
    end;
    close(file_emp);
    readln();
end;

procedure listar_todos(var file_emp:fe);
var
    emp: empleado;
    file_name : string;
begin
    write(#10+'Ingresar nombre del archivo que desea abrir: ');
    readln(file_name);
    Assign(file_emp, file_name);
    writeln('Listado de todos los empleados: '+ #10);
    reset(file_emp);
    while(not eof(file_emp))do begin
        read(file_emp, emp);
        listar_empleado(emp);
    end;
    close(file_emp);
    readln();
end;

procedure listar_mayores(var file_emp:fe);
var
    emp: empleado;
    file_name : string;
begin
    write(#10+'Ingresar nombre del archivo que desea abrir: ');
    readln(file_name);
    Assign(file_emp, file_name);
    writeln('Listado de empleados con mas de 70 años:'+ #10);
    reset(file_emp);
    while(not eof(file_emp))do begin
        read(file_emp, emp);
        if(emp.edad > 70)then
          listar_empleado(emp);
    end;
    close(file_emp);
    readln();
end;

procedure show_menu(var file_emp: fe);
var
    option : string;
begin
    writeln(#10+'================== MENU ==================');
    writeln('1. Crear un archivo de empleados.');
    writeln('2. Listar nombre o apellido de empleado determinado.');
    writeln('3. Listar todos los empleados.');
    writeln('4. Listar empleados mayores a 70 años.');
    writeln('5. Salir.');
    write('Ingrese una opcion: ');
    readln(option);
    case option of
        '1': crear_archivo_empleados(file_emp);
        '2': listar_nombre_ape(file_emp);
        '3': listar_todos(file_emp);
        '4': listar_mayores(file_emp);
        '5': halt;
        else begin
            writeln('Ingreso una opcion invalida.'+#10);
        end;
    end;
    show_menu(file_emp);
end;

var
    file_emp : fe;
begin
    show_menu(file_emp);
end.