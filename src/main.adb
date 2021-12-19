with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Randompackage; use Randompackage;

procedure main is

   task Buffor is
      entry pisz(value : in Integer);
      entry czytaj(value : out Integer);
      entry koniec;
   end Buffor;

   task body Buffor is
   size : Integer := 10;
   buf : array (0..size-1) of Integer;
   zajete: Integer;
   ile_wpisano: Integer;
   ile_odczytano: Integer;
   id_pisz: Integer;
   id_czyt: Integer;
   work :Boolean;
   begin
      work := True;
      zajete:= 0;
      id_pisz:= 0;
      id_czyt:= 0;
      ile_odczytano:= 0;
      ile_wpisano:= 0;
      for i in 0..size-1 loop
        buf(i):= 0 ;
      end loop;
      while work = True loop
         select
            when zajete < size =>
               accept pisz(value : in Integer) do
                  buf(id_pisz) := value;
                  ile_wpisano := ile_wpisano + 1 ;
                  id_pisz := ile_wpisano mod size;
                  zajete := zajete + 1;

                  Put(ile_wpisano,2);
                  Put(" Pisz:");
                  for i in 0..size-1 loop
                     Put(buf(i),2);
                  end loop;
                  New_Line;

               end pisz;

         or

            when zajete > 0 =>
               accept czytaj(value : out Integer) do
                  value := buf(id_czyt);
                  buf(id_czyt) := 0;
                  ile_odczytano := ile_odczytano + 1;
                  id_czyt := ile_odczytano mod size;
                  zajete := zajete - 1;

                  Put(ile_odczytano,2);
                  Put(" Czyt:");
                  for i in 0..size-1 loop
                     Put(buf(i),2);
                  end loop;
                  New_Line;

               end czytaj;
         or
            accept koniec do
               work := False;
               Put_Line("KONIEC");
            end koniec;
         end select;
      end loop;
   end Buffor;

   task type Pisarz;

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

   task type Czytelnik;

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

   TaskPisz : Pisarz;
   TaskCzyt1 : Czytelnik;

begin
   null;
end main;
