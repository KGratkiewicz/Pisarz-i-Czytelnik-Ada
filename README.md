# Problem 1 pisarza i 1 czytelnika 
Program o zadaniach współbieżnych zaimplementowany w języku Ada przy pomocy mechanizmu spotkań.

## Spotkanie w czytelni

```
 task Buffor is
      entry pisz(value : in Integer);
      entry czytaj(value : out Integer);
      entry koniec;
   end Buffor;

   task body Buffor is
   size : Integer := 10;
   buf : array (0..size-1) of Integer;
   zajete: Integer;
   id_pisz: Integer;
   id_czyt: Integer;
   work :Boolean;
   begin
      work := True;
      zajete:= 0;
      id_pisz:= 0;
      id_czyt:= 0;
      
      while work = True loop
         select
            when zajete < size =>
               accept pisz(value : in Integer) do
                  buf(id_pisz) := value;
                  id_pisz := id_pisz + 1 ;
                  id_pisz := id_pisz mod size;
                  zajete := zajete + 1;
               end pisz;
         or
            when zajete > 0 =>
               accept czytaj(value : out Integer) do
                  value := buf(id_czyt);
                  buf(id_czyt) := 0;
                  id_czyt := id_czyt + 1;
                  id_czyt := id_czyt mod size;
                  zajete := zajete - 1;
               end czytaj;
         or
            accept koniec do
               work := False;
               Put_Line("KONIEC");
            end koniec;
         end select;
      end loop;
   end Buffor;
```
