package body Player_Logic is

   procedure Move
     (Player : in out Player_State;
      Delta_X : Integer) is
   begin
      if Player.X + Delta_X > Left_Wall and
         Player.X + Delta_X < Right_Wall then

         Player.X := Player.X + Delta_X;

      end if;
   end Move;

end Player_Logic;