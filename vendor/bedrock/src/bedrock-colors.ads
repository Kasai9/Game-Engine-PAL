--  Colour: RGBA, 8 bits per channel, straight (not premultiplied)
--  alpha, laid out R G B A in memory so a Color is a pixel a GPU or a
--  window system can take as is.

package Bedrock.Colors with SPARK_Mode, Pure is

   type Channel is mod 2 ** 8 with Size => 8;

   type Color is record
      R, G, B, A : Channel := 255;
   end record with Size => 32;
   for Color use record
      R at 0 range 0 .. 7;
      G at 1 range 0 .. 7;
      B at 2 range 0 .. 7;
      A at 3 range 0 .. 7;
   end record;

   Transparent : constant Color := (0, 0, 0, 0);
   Black       : constant Color := (0, 0, 0, 255);
   White       : constant Color := (255, 255, 255, 255);
   Ray_White   : constant Color := (245, 245, 245, 255);
   Light_Gray  : constant Color := (200, 200, 200, 255);
   Gray        : constant Color := (130, 130, 130, 255);
   Dark_Gray   : constant Color := (80, 80, 80, 255);
   Red         : constant Color := (230, 41, 55, 255);
   Maroon      : constant Color := (190, 33, 55, 255);
   Green       : constant Color := (0, 228, 48, 255);
   Lime        : constant Color := (0, 158, 47, 255);
   Blue        : constant Color := (0, 121, 241, 255);
   Dark_Blue   : constant Color := (0, 82, 172, 255);
   Sky_Blue    : constant Color := (102, 191, 255, 255);
   Yellow      : constant Color := (253, 249, 0, 255);
   Gold        : constant Color := (255, 203, 0, 255);
   Orange      : constant Color := (255, 161, 0, 255);
   Pink        : constant Color := (255, 109, 194, 255);
   Purple      : constant Color := (200, 122, 255, 255);
   Violet      : constant Color := (135, 60, 190, 255);
   Beige       : constant Color := (211, 176, 131, 255);
   Brown       : constant Color := (127, 106, 79, 255);
   Magenta     : constant Color := (255, 0, 255, 255);

   function Same_RGB (A, B : Color) return Boolean is
     (A.R = B.R and then A.G = B.G and then A.B = B.B);

   function Modulate (A, B : Color) return Color;
   --  Channel-wise A * B / 255, rounded.

   function Blend (Src, Dst : Color) return Color;
   --  Src over Dst by Src.A, straight alpha. Result alpha is Dst's.

   function Fade (C : Color; Alpha : Scalar) return Color
     with Pre => Alpha in 0.0 .. 1.0;
   --  Same colour, alpha scaled.

end Bedrock.Colors;
