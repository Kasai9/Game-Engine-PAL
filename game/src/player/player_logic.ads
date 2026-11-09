--Andres Reyes
--02NOV2026


--create package for player logic
package Player_Logic is

Left_Wall  : constant Integer := 0;
Right_Wall : constant Integer := 10;

--stores the player postion on the game grid
--create a type called Player_State that holds multiple fields for player info aka a record
--record of two integers for position on grid. x and y
--end record, same as } 
type Player_State is record
   x: Integer := 0;
   y: Integer := 0;
end record;

--moves player to the right aka a void function taking in an argument as "Player" and getting and setting x to the right
--procedure Move_right (Player: in out Player_State);

--moves player by delta x
procedure Move
   (Player: in out Player_State;
   Delta_X: Integer);


--close package  
end Player_Logic;


