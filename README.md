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

## Proces Pisarza

```
 task body Pisarz is
      delayTime : Integer;
      value : Integer;
      N : Integer;
      i : Integer;
   begin
      N := 20;
      i := 1;
      for i in 1..N loop
         -- sekcja lokalna BEG
         delayTime := RandomInt(1);
         Delay(Standard.Duration(delayTime));
         value := RandomInt(9);
         -- sekcja lokalna END

         -- sekcja krytyczna BEG
         Buffor.pisz(value);
         -- sekcja krytyczna END

      end loop;

   end Pisarz;

```

## Proces Czytelnika

```
task body Czytelnik is
      N : Integer;
      i : Integer;
      delayTime : Integer;
      value : Integer;
   begin
      N := 20;
      i := 1;
      for i in 1..N loop

         -- sekcja lokalna BEG
         delayTime := RandomInt(2);
         Delay(Standard.Duration(delayTime));
         -- sekcja lokalna END

         -- sekcja krytyczna BEG
         Buffor.czytaj(value);
         -- sekcja krytyczna END
      end loop;
      Buffor.koniec;
   end Czytelnik;
```
