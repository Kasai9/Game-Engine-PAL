
with Ada.Text_IO;
with Player_Logic;

procedure ASCII_Demo is
   use Ada.Text_IO;

   Hero    : Player_Logic.Player_State;
   Command : Character;

   procedure Draw is
   begin
      New_Line;

      for X in 0 .. 10 loop
         if X = Player_Logic.Left_Wall or
   X = Player_Logic.Right_Wall or
   X = 7 then
            Put ("#");
         elsif X = Hero.X then
            Put ("P");
         else
            Put (" ");
         end if;
      end loop;

      New_Line;
      Put_Line ("Position: " & Integer'Image (Hero.X));
      Put_Line ("A = Left | D = Right | Q = Quit");
   end Draw;

begin
   Hero.X := 5;

   loop
      Draw;

      Put ("Command: ");
      Get (Command);
      Skip_Line;

      case Command is
         when 'a' | 'A' =>
            Player_Logic.Move (Hero, -1);

         when 'd' | 'D' =>
            Player_Logic.Move (Hero, 1);

         when 'q' | 'Q' =>
            exit;

         when others =>
            Put_Line ("Invalid command.");
      end case;
   end loop;

   Put_Line ("Demo ended.");
end ASCII_Demo;
