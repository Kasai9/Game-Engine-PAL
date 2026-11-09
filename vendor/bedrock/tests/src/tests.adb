with Ada.Command_Line;
with Ada.Text_IO;     use Ada.Text_IO;
with Bedrock;         use Bedrock;
with Bedrock.Buffers; use Bedrock.Buffers;
with Bedrock.Colors;  use Bedrock.Colors;
with Bedrock.Input;   use Bedrock.Input;
with Bedrock.Names;   use Bedrock.Names;
with Bedrock.Screen;  use Bedrock.Screen;
with Bedrock.Responses;
with Bedrock.Generic_Vectors;
with Bedrock.Generic_Fixed_Vectors;

procedure Tests is
   Failures : Natural := 0;
   procedure Check (Name : String; Cond : Boolean);
   procedure Check (Name : String; Cond : Boolean) is
   begin
      Put_Line ((if Cond then "PASS  " else "FAIL  ") & Name);
      if not Cond then
         Failures := Failures + 1;
      end if;
   end Check;
begin
   Check ("vector add", (1.0, 2.0) + (3.0, 4.0) = Vector2'(4.0, 6.0));
   Check ("dot", Dot ((1.0, 2.0), (3.0, 4.0)) = 11.0);
   Check ("length 3-4-5", Length ((3.0, 4.0)) = 5.0);
   Check ("normalized", abs (Length (Normalized ((3.0, 4.0))) - 1.0) < 1.0E-6);
   Check ("perpendicular", Perpendicular ((1.0, 0.0)) = Vector2'(0.0, 1.0));
   Check ("lerp", Lerp ((0.0, 0.0), (10.0, 0.0), 0.25) = Vector2'(2.5, 0.0));
   Check ("rect contains", Contains (Rectangle'(0.0, 0.0, 10.0, 10.0), (9.9, 0.0)));
   Check ("rect edge exclusive", not Contains (Rectangle'(0.0, 0.0, 10.0, 10.0), (10.0, 0.0)));
   Check ("rect overlap", Overlaps ((0.0, 0.0, 10.0, 10.0), (9.0, 9.0, 5.0, 5.0)));
   Check ("rect touching is not overlap",
          not Overlaps ((0.0, 0.0, 10.0, 10.0), (10.0, 0.0, 5.0, 5.0)));
   Check ("clamp", Clamp (15.0, 0.0, 10.0) = 10.0);

   Check ("point round trip", To_Point (To_Vector ((7, -3))) = Point'(7, -3));
   Check ("screen rect contains", Contains (Rect'((1, 1), (2, 2)), (2, 2)));

   Check ("color size", Color'Size = 32);
   Check ("modulate half", Modulate ((200, 100, 50, 255), (128, 128, 128, 255)).R in 99 .. 101);
   Check ("blend 50%", Blend ((255, 255, 255, 128), Black).R in 127 .. 129);
   Check ("blend opaque", Blend (Red, Black) = Color'(230, 41, 55, 255));
   Check ("fade", Fade (White, 0.5).A in 127 .. 128);

   declare
      I : Buffers.Image := Make (4, 3, Blue);
      J : constant Buffers.Image := Make (2, 2, Red);
   begin
      Check ("image dims", Width (I) = 4 and Height (I) = 3);
      Set (I, 3, 2, Green);
      Check ("image set/get", Get (I, 3, 2) = Green and Get (I, 0, 0) = Blue);
      Blit (J, I, 3, 2);
      Check ("blit clipped", Get (I, 3, 2) = Red and Get (I, 2, 2) = Blue);
      Check ("data is contiguous rows", I.Data (2, 3) = Red);
   end;

   declare
      Q : Event_Queue;
   begin
      Push (Q, Key_Event (Key_A, Down => True));
      Push (Q, Move_Event (10, 20));
      Push (Q, Quit_Event);
      Check ("queue count", Q.Count = 3);
      Check ("key event", Q.Events (1).Kind = Key_Down and Q.Events (1).Key = Key_A);
      Check ("move event", Q.Events (2).At_Pos = Point'(10, 20));
      Clear (Q);
      Check ("queue cleared", Q.Count = 0);
      for I in 1 .. 300 loop
         Push (Q, Quit_Event);
      end loop;
      Check ("queue bounded", Q.Count = Max_Queue);
   end;

   Check ("name round trip", Names.Image (To_Name ("ship")) = "ship");
   Check ("name equality", To_Name ("a") = To_Name ("a") and To_Name ("a") /= To_Name ("b"));
   Check ("no name", Is_Empty (No_Name));
   Check ("path round trip", Names.Image (To_Path ("a/b.forge")) = "a/b.forge");

   declare
      package Rs is new Bedrock.Responses (Max => 16);
      R : Rs.Response;
   begin
      Rs.Ok (R);
      Check ("ok", R.Ok and Rs.Image (R) = "ok");
      Rs.Ok (R, "saved");
      Check ("ok info", Rs.Image (R) = "ok saved");
      Rs.Err (R, "nope");
      Check ("err", not R.Ok and Rs.Image (R) = "err nope");
      Rs.Append (R, " and this is too long to fit");
      Check ("append truncates", R.Length = 16);
   end;

   declare
      package G is new Bedrock.Generic_Vectors (Long_Float);
      use G;
   begin
      Check ("cross", Cross ((1.0, 0.0, 0.0), (0.0, 1.0, 0.0)) = Vector3'(0.0, 0.0, 1.0));
      Check ("length3", Length (Vector3'(2.0, 3.0, 6.0)) = 7.0);
      Check ("normalized3", abs (Length (Normalized (Vector3'(2.0, 3.0, 6.0))) - 1.0) < 1.0E-12);
   end;

   declare
      type Milli is delta 0.001 range -1.0E6 .. 1.0E6;
      package F is new Bedrock.Generic_Fixed_Vectors (Milli);
      use type F.Vector2;
      use type F.Vector3;
      A : constant F.Vector2 := (1.5, 2.25);
      B : constant F.Vector2 := (0.5, 0.75);
      U : constant F.Vector3 := (1.0, 0.0, 0.0);
      V : constant F.Vector3 := (0.0, 1.0, 0.0);
   begin
      Check ("fixed add", A + B = F.Vector2'(2.0, 3.0));
      Check ("fixed dot", F.Dot (F.Vector2'(2.0, 3.0), F.Vector2'(4.0, 5.0)) = 23.0);
      Check ("fixed cross", F.Cross (U, V) = F.Vector3'(0.0, 0.0, 1.0));
      Check ("fixed scale by integer", F.Vector3'(1.5, 0.0, 0.0) * 4 = F.Vector3'(6.0, 0.0, 0.0));
   end;

   New_Line;
   if Failures = 0 then
      Put_Line ("all tests passed");
   else
      Put_Line (Failures'Image & " failure(s)");
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Tests;
