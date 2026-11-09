with Ada.Text_IO;
use Ada.Text_IO;
with Player_Logic;

procedure Test_Player_Logic is
 Hero : Player_Logic.Player_State; 
begin
   -- Right wall test
   Hero.X := 9;
   Player_Logic.Move (Hero, 1);
   Ada.Text_IO.Put_Line ("Right wall: " & Integer'Image (Hero.X));

   -- Left wall test
   Hero.X := 1;
   Player_Logic.Move (Hero, -1);
   Ada.Text_IO.Put_Line ("Left wall: " & Integer'Image (Hero.X));

   -- Normal movement test
   Hero.X := 5;
   Player_Logic.Move (Hero, 1);
   Ada.Text_IO.Put_Line ("Normal movement: " & Integer'Image (Hero.X));

end Test_Player_Logic;