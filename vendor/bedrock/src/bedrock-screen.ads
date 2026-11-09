--  Window geometry: integers, because a window is made of whole
--  pixels and the platform APIs (X11, Win32, SDL) all say so. Floats
--  are for the world (Bedrock); the conversion happens once, where a
--  world is drawn onto a screen.

package Bedrock.Screen with SPARK_Mode, Pure is

   type Pixels is range -2 ** 15 .. 2 ** 15 - 1;
   subtype Extent is Pixels range 0 .. Pixels'Last;

   type Point is record
      X, Y : Pixels := 0;
   end record;

   type Size is record
      Width, Height : Extent := 0;
   end record;

   type Rect is record
      Origin : Point;
      Extent : Size;
   end record;

   function Contains (R : Rect; P : Point) return Boolean is
     (P.X >= R.Origin.X and then P.X < R.Origin.X + R.Extent.Width
      and then P.Y >= R.Origin.Y and then P.Y < R.Origin.Y + R.Extent.Height);

   type Ticks is mod 2 ** 64;
   --  A platform timestamp; units are the platform's (portal: its
   --  clock), only differences mean anything.

   Max_Windows : constant := 8;
   type Window_Id is range 0 .. Max_Windows;
   No_Window : constant Window_Id := 0;
   subtype Valid_Window_Id is Window_Id range 1 .. Max_Windows;

   function To_Vector (P : Point) return Vector2 is (Scalar (P.X), Scalar (P.Y));
   function To_Point (V : Vector2) return Point
     with Pre => V.X in -32_768.0 .. 32_767.0 and then V.Y in -32_768.0 .. 32_767.0;
   --  Truncates toward zero.

end Bedrock.Screen;
