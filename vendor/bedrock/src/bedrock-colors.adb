package body Bedrock.Colors with SPARK_Mode is

   function M (X, Y : Channel) return Channel is
     (Channel ((Natural (X) * Natural (Y) + 127) / 255));

   function Modulate (A, B : Color) return Color is
     (M (A.R, B.R), M (A.G, B.G), M (A.B, B.B), M (A.A, B.A));

   function Blend (Src, Dst : Color) return Color is
      Al : constant Natural := Natural (Src.A);
      function L (S, D : Channel) return Channel is
        (Channel ((Natural (S) * Al + Natural (D) * (255 - Al) + 127) / 255));
   begin
      if Al = 255 then
         return (Src.R, Src.G, Src.B, Dst.A);
      elsif Al = 0 then
         return Dst;
      end if;
      return (L (Src.R, Dst.R), L (Src.G, Dst.G), L (Src.B, Dst.B), Dst.A);
   end Blend;

   function Fade (C : Color; Alpha : Scalar) return Color is
     (C.R, C.G, C.B, Channel (Scalar'Rounding (Scalar (C.A) * Alpha)));

end Bedrock.Colors;
