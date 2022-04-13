program ejer3;

type
    novel = record
        code : integer;
        genre : string[20];
        novel_name : string[30];
        duration : integer;
        director_name : string[50];
        sale_price : real;
    end;

    novel_file = file of novel;

procedure read_novel(var n:novel);
begin
    with n do begin
        write('Enter novel code: ');
        readln(code);
        if(n.code <> 0)then begin
            write('Enter novel genre: ');
            readln(genre);
            write('Enter novel name: ');
            readln(novel_name);
            write('Enter novel duration(minutes): ');
            readln(duration);
            write('Enter novel director'+Chr(39)+'s name: ');
            readln(director_name);
            write('Enter novel price: ');
            readln(sale_price);                
        end;
    end;
end;

procedure create_file(var f:novel_file);
var
    d:novel;
    str:string;
begin
    writeln('================== CREATING FILE ===================');
    write('ENTER FILE PATH AND FILE NAME: ');
    readln(str);
    assign(f, str);
    rewrite(f);
    d.code := 0;
    write(f, d);
    writeln();
    read_novel(d);
    while(d.code <> 0)do begin
        write(f, d);
        writeln();
        read_novel(d);
    end;
    close(f);
    writeln('THE NOVELS FILE WAS CREATED SUCCESSFULLY!');
end;

procedure show_maintenance_menu(var f:novel_file);
    procedure register_novel(var f:novel_file);
    var
        str:string;
        n:novel;
        aux_novel:novel;
    begin
        write('ENTER FILE PATH AND FILE NAME: ');
        readln(str);
        assign(f, str);

        read_novel(n);
        if(n.code > 0)then begin
            reset(f);
            read(f, aux_novel);
            if(aux_novel.code <> 0)then begin
                seek(f, Abs(aux_novel.code));
                read(f, aux_novel);
                seek(f, filepos(f)-1);
                write(f, n);
                seek(f, 0);
                write(f, aux_novel);             
            end
        else begin
            seek(f, filesize(f));
            write(f, n);
        end;            
            close(f);
            writeln('Novel successfully registered!')
        end
        else
            writeln('Invalid novel code.')
        
    end;

    procedure modify_novel(var f:novel_file);
        procedure modification_menu(var nov:novel);
            procedure modify_name(var novel_name:string);
            begin
                writeln('NAME MODIFICATION ->');
                write('Enter the new novel name: ');
                readln(novel_name);
            end;

            procedure modify_genre(var genre:string);
            begin
                writeln('GENRE MODIFICATION ->');
                write('Enter the new genre to the novel: ');
                readln(genre);
                writeln('Se modifico el genero de la novela!');
            end;

            procedure modify_price(var p:real);
            begin
                writeln('PRICE MODIFICATION ->');
                write('Enter a new value to novel price: ');
                readln(p);
            end;

            procedure modify_duration(var c:integer);
            begin
                writeln('DURATION MODIFICATION ->');
                write('Enter the new value to novel duration: ');
                readln(c);
            end;

            procedure modify_director_name(var director_name:string);
            begin
                writeln('DIRECTOR MODIFICATION ->');
                write('Enter the new director''s name: ');
                readln(director_name);
            end;

        var
            option:integer;
        begin
            writeln('================ MODIFICATION MENU  ==================');
            writeln('NOVEL CODE ', nov.code ,' - DATA: ');
            with nov do 
                writeln('(Novel name: ', novel_name, ' genre: ', genre, ' duration: ', duration , ' director''s name: ',
                director_name ,' price: ', sale_price:2:2);
            writeln('1. Modify Name.');
            writeln('2. Modify Genre.');
            writeln('3. Modify Price.');
            writeln('4. Modify Duration.');
            writeln('5. Modify Director''s name.');
            writeln('0. Return to Maintenance Menu.');
            write('Enter an option: ');
            readln(option);
            case option of
                1: modify_name(nov.novel_name);
                2: modify_genre(nov.genre);
                3: modify_price(nov.sale_price);
                4: modify_duration(nov.duration);
                5: modify_director_name(nov.director_name);
                0: exit;
                else begin 
                    writeln('option Incorrecta - Ingrese una correcta()');
                    modification_menu(nov);
                end;
            end;
            modification_menu(nov);
        end;

    var
        cod: integer;
        nov:novel;
        str:string;
    begin
        writeln();
        write('ENTER FILE PATH AND FILE NAME: ');
        readln(str);
        assign(f, str);
        write('Enter a novel code to modify: ');
        readln(cod);
        reset(f);
        read(f, nov);
        while(not eof(f))and(nov.code <> cod)do 
            read(f, nov);      
        if(not eof(f))then begin
            modification_menu(nov);
            seek(f, filepos(f)-1);
            write(f, nov);
            writeln('Novel successfully modified!');
        end
        else
            writeln('The code entered was not found.');
        close(f);
    end;

    procedure remove_novel(var f:novel_file);
    var
        cod: integer;
        head : integer;
        n : novel;
        str:string;
    begin
        writeln();
        write('ENTER FILE PATH AND FILE NAME: ');
        readln(str);
        assign(f, str);
        write('Enter a code of novel to remove from file: ');
        readln(cod);
        reset(f);
        read(f, n);
        head := n.code;
        while((not eof(f)) and (n.code <> cod))do begin
            read(f, n);
        end;
        if(not eof(f))then begin
            n.code := head;
            head := (-1 * filepos(f));
            seek(f, filepos(f)-1);
            write(f, n);
            seek(f, 0);
            n.code := head; {uso el mismo record para pasar el valor de head, a la head}
            {se ve raro pero es para no crear un auxiliar}
            write(f, n);
            writeln('The novel was succesfully removed!');
        end
        else
            writeln('The code entered was not found.');
        close(f);
    end;

var
    option:integer;
begin
    writeln('================ MAINTENANCE MENU ==================');
    writeln('   1. Register a new novel from keyboard.');
    writeln('   2. Modify data of a novel from keyboard.');
    writeln('   3. Remove a novel from keyboard.');
    writeln('   4. Return to Main Menu.');
    writeln();
    write('Enter an option: ');
    readln(option);
    writeln('====================================================');
    case option of
        1: register_novel(f);
        2: modify_novel(f);
        3: remove_novel(f);
        4: exit;
        else begin
            writeln('Enter a valid option!');
            readln();
            show_maintenance_menu(f);
        end;
    end;
    show_maintenance_menu(f);
end;

procedure list_txt(var f:novel_file; var txt:Text);
var
    data:novel;
begin
    reset(f);
    rewrite(txt);
    read(f, data);
    while(not eof(f))do begin
        read(f, data);
        writeln(txt,' Novel code: ',data.code, ' - Genre: ', data.genre, ' - Name ', data.novel_name, ' - Duration in minutes: ', data.duration, ' Director''s name: ' ,
         data.director_name, ' - Price: $', data.sale_price:2:2);
    end;
    close(txt);
    close(f);
    writeln('Exported successfully!');
    readln();
end;


procedure show_menu(var f:novel_file);
var
    option:integer;
    txt: Text;
begin
    writeln('======================= MENU =======================');
    writeln();
    writeln('   1. Create file from keyboard. ');
    writeln('   2. Open an existing novel file. ');
    writeln('   3. List novel file into a text file. ');
    writeln('   4. Exit.');
    writeln();
    write('Enter an option: ');
    readln(option);
    writeln('====================================================');
    case option of
        1:  begin
                create_file(f);
                readln();
            end;
        2:  begin
                show_maintenance_menu(f);        
            end;
        3:  begin
                assign(txt, 'novelas.txt');
                list_txt(f,txt);
            end;
        4: halt(0);
        else begin
            writeln('Enter a valid option!');
            readln();
            show_menu(f);
        end;
    end;
    show_menu(f);
end;


{main}

var
    f:novel_file;
begin
    show_menu(f);
end.