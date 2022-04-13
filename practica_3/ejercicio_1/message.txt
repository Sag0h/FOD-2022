{4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir una o más empleados al final del archivo con sus datos ingresados por
teclado.
b. Modificar edad a una o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.}


program ejer1;
const
    valor_alto = 9999;
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
    writeln('Ingrese datos del empleado que quiere agregar: '+#10);
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

procedure add_empleados(var file_emp:fe);
var
    emp: empleado;
    file_name: string;
begin
    write(#10+'Ingresar nombre del archivo que desea abrir: ');
    readln(file_name);
    Assign(file_emp, file_name);
    reset(file_emp);
    seek(file_emp, FileSize(file_emp));
    leer_empleado(emp);
    while(emp.ape <> 'fin')do begin
        write(file_emp, emp);
        leer_empleado(emp);
    end;
    close(file_emp);
    readln();
end;

function mismo_num_emp(num: integer; empnum: integer):boolean;
begin
    mismo_num_emp := (num = empnum);
end;



procedure modificar_edad_empleados(var file_emp:fe);

    procedure input(var num: integer);
    begin
        write('Ingrese el numero de empleado al que quiere modificar la edad: ');
        readln(num);
    end;

    procedure show_menu_continue(var seguir:boolean; var num_emp: integer);
    var
        option: string;
    begin
        write('¿Quiere modificar la edad de otro empleado? (S / N): ');
        readln(option);
        case option of
            'N': seguir := false;
            'n': seguir := false;
            'S': input(num_emp);
            's': input(num_emp);
            else begin
                writeln('Ingreso una opcion incorrecta, vuelva a intentar.');
                show_menu_continue(seguir, num_emp);
            end;
        end;
    end;

var
    num_emp : integer;
    file_name: string;
    emp: empleado;
    encontre: boolean;
    seguir: boolean;
begin
    seguir:= true;
    encontre:= false;
    writeln('Modificar la edad de empleados en un archivo: ');
    write(#10+'Ingresar nombre del archivo que desea abrir: ');
    readln(file_name);
    Assign(file_emp, file_name);
    reset(file_emp);
    input(num_emp);
    while(num_emp <> -1)and(seguir)do begin
        while(not eof(file_emp) and not encontre) do begin
            read(file_emp, emp);
            if(mismo_num_emp(num_emp, emp.num))then
                encontre := true;
        end;
        if(encontre)then begin
            write('Empleado encontrado: ');
            listar_empleado(emp);
            write('Ingrese nueva edad: ');
            readln(emp.edad);
            seek(file_emp, FilePos(file_emp)-1);
            write(file_emp, emp);
            writeln('Se modifico la edad del empleado correctamente.');
        end
        else writeln('No se encontro el empleado con el numero de empleado ingresado.');
        
        seek(file_emp, 0);  
        encontre := false;
        show_menu_continue(seguir, num_emp);
    end;
    close(file_emp);
    readln();
end;

procedure export_to_txt(var file_emp:fe);
var
    txt: Text;
    pname: string;
    file_name: string;
    emp : empleado;
begin
    write('Ingresar el nombre del archivo de empleados que desea exportar a texto: ');
    readln(file_name);
    Assign(file_emp, file_name);
    reset(file_emp);
    write('Ingrese un nombre para el archivo de texto a crear: ');
    readln(pname);
    Assign(txt, pname);
    rewrite(txt);
    while(not eof(file_emp))do begin
        read(file_emp, emp);
        write(txt, 'Apellido: '+ emp.ape + ' Nombre: '+ emp.nom+ ' Numero de empleado: ', emp.num ,' Edad: ',emp.edad,' Dni: '+ emp.dni,' ', #10);
    end;
    close(file_emp);
    close(txt);
    writeln('Se creo el archivo "'+pname+ '" correctamente.');
    readln();
end;

procedure export_ndni_txt(var file_emp:fe);
var
    txt: Text;
    file_name: string;
    emp: empleado;
begin
    write('Ingresar el nombre del archivo de empleados: ');
    read(file_name);
    Assign(file_emp, file_name);
    reset(file_emp);

    Assign(txt, 'faltaDNIEmpleado.txt');
    rewrite(txt);
    while(not eof(file_emp))do begin
        read(file_emp, emp);
        if(emp.dni = '00')then
             write(txt, 'Apellido: '+ emp.ape + ' Nombre: '+ emp.nom+ ' Numero de empleado: ', emp.num ,' Edad: ',emp.edad,' '+#10);
    end;
    close(txt);
    close(file_emp);
    writeln('Se creo el archivo "faltaDNIEmpleado.txt" correctamente.');
    readln();
end;

procedure leer_empleado_archivo(var file_emp: fe; var rec: empleado);
begin
    if(not eof(file_emp))then
        read(file_emp, rec)
    else
        rec.num := valor_alto;
end;

procedure eliminar_empleado(var file_emp:fe);
var
    num_e: integer;
    last_rec: empleado;
    rec_del: empleado;
begin
    write('Ingresar numero del empleado a eliminar: ');
    readln(num_e);
    reset(file_emp);
    seek(file_emp, filesize(file_emp)-1); // tomo el ultimo registro
    read(file_emp,last_rec);
    if(last_rec.num <> num_e)then begin // si el ultimo es diferente del dato a eliminar
        seek(file_emp, 0); // nos paramos en el inicio del archivo
        leer_empleado_archivo(file_emp, rec_del); // leemos el primer record
        while((rec_del.num <> valor_alto) and (rec_del.num <> num_e))do
            leer_empleado_archivo(file_emp, rec_del);
        if(rec_del.num <> valor_alto)then begin
            seek(file_emp, filepos(file_emp)-1);
            write(file_emp, last_rec);  
            seek(file_emp, filesize(file_emp)-1);
            truncate(file_emp);
            writeln('Se elimino el empleado y se coloco el ultimo empleado en su lugar.');
        end
        else
            write('No se encontró el empleado ingresado.');
    end
    else begin
        seek(file_emp, filesize(file_emp)-1);
        truncate(file_emp);
        writeln('Se elimino el empleado.');     
    end;
    close(file_emp);
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
    writeln('5. Agregar empleados a un archivo de empleados.');
    writeln('6. Modificar la edad de uno o mas empleados.');
    writeln('7. Exportar archivo a un archivo de texto.');
    writeln('8. Exportar empleados sin dni a un archivo de texto.');
    writeln('9. Eliminar empleado.');
    writeln('10. Salir.');
    writeln('==========================================');
    write('Ingrese una opcion: ');
    readln(option);
    case option of
        '1': crear_archivo_empleados(file_emp);
        '2': listar_nombre_ape(file_emp);
        '3': listar_todos(file_emp);
        '4': listar_mayores(file_emp);
        '5': add_empleados(file_emp);
        '6': modificar_edad_empleados(file_emp);
        '7': export_to_txt(file_emp);
        '8': export_ndni_txt(file_emp);
        '9': eliminar_empleado(file_emp);
        '10': halt;
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