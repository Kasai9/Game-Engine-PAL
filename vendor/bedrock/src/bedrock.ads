--  bedrock: the types every GAP desktop project would otherwise define
--  twice and convert between. Pure, SPARK, no bodies worth arguing
--  about, no dependencies, frozen at 1.0.
--
--     Bedrock          Scalar, Degrees, Vector2, Rectangle       world geometry, floats
--     Bedrock.Screen   Pixels, Point, Size, Rect, Window_Id      window geometry, integers
--     Bedrock.Colors   Channel, Color, palette, Blend, Modulate
--     Bedrock.Buffers  Pixel_Array, Image                        RGBA, row-major, top-down
--     Bedrock.Input    Key, Modifiers, Mouse_Button, Gamepad_*, Event, Event_Queue
--     Bedrock.Names    bounded Name, To_Name, Image
--
--  Who uses it: portal (Screen, Colors, Buffers, Input), yarlib (all),
--  boxflex (Scalar, Rectangle), the editors. What is deliberately not
--  here: anything with a design in it. forge's Long_Float Vec3,
--  framewise's Time in ticks, boxflex's layout boxes, the batch, the
--  rasterizer: those are the projects.
--
--  The rule: this crate changes only through the GAP coordinator, by
--  pull request, with every dependent's CI green. Its value is that
--  nobody needs to touch it. If your project needs something added
--  here, that is a design conversation, and the usual answer is that
--  it belongs in your crate.

package Bedrock with SPARK_Mode, Pure is

   type Scalar is new Float;
   --  World and screen coordinates in floating point. Pixels at zoom 1.

   type Degrees is new Float;
   --  Every rotation is Degrees, clockwise with y down. No radians in
   --  any API a user sees; convert inside the one place that needs to.

   type Vector2 is record
      X, Y : Scalar := 0.0;
   end record;

   Zero : constant Vector2 := (0.0, 0.0);

   function "+" (A, B : Vector2) return Vector2 is (A.X + B.X, A.Y + B.Y);
   function "-" (A, B : Vector2) return Vector2 is (A.X - B.X, A.Y - B.Y);
   function "-" (A : Vector2) return Vector2 is (-A.X, -A.Y);
   function "*" (A : Vector2; S : Scalar) return Vector2 is (A.X * S, A.Y * S);
   function "*" (S : Scalar; A : Vector2) return Vector2 is (A.X * S, A.Y * S);
   function "/" (A : Vector2; S : Scalar) return Vector2 is (A.X / S, A.Y / S)
     with Pre => S /= 0.0;
   function Dot (A, B : Vector2) return Scalar is (A.X * B.X + A.Y * B.Y);
   function Length_Squared (A : Vector2) return Scalar is (Dot (A, A));
   function Length (A : Vector2) return Scalar;
   function Normalized (A : Vector2) return Vector2
     with Pre => Length_Squared (A) > 0.0;
   function Perpendicular (A : Vector2) return Vector2 is (-A.Y, A.X);
   --  Rotated 90 degrees clockwise on a y-down screen.
   function Lerp (A, B : Vector2; T : Scalar) return Vector2 is (A + (B - A) * T);

   type Rectangle is record
      X, Y, Width, Height : Scalar := 0.0;
   end record;

   function Position (R : Rectangle) return Vector2 is (R.X, R.Y);
   function Dimensions (R : Rectangle) return Vector2 is (R.Width, R.Height);
   function Center (R : Rectangle) return Vector2 is
     (R.X + R.Width / 2.0, R.Y + R.Height / 2.0);
   function Contains (R : Rectangle; P : Vector2) return Boolean is
     (P.X >= R.X and then P.X < R.X + R.Width and then P.Y >= R.Y and then P.Y < R.Y + R.Height);
   function Overlaps (A, B : Rectangle) return Boolean is
     (A.X < B.X + B.Width and then B.X < A.X + A.Width
      and then A.Y < B.Y + B.Height and then B.Y < A.Y + A.Height);

   function Clamp (V, Lo, Hi : Scalar) return Scalar is (Scalar'Max (Lo, Scalar'Min (Hi, V)))
     with Pre => Lo <= Hi;

end Bedrock;
