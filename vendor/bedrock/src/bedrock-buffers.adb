package body Bedrock.Buffers with SPARK_Mode is

   function Make (Width, Height : Positive; Fill : Color := Transparent) return Image is
     ((Height => Row (Height - 1), Width => Column (Width - 1),
       Data => [others => [others => Fill]]));

   procedure Set (I : in out Image; X, Y : Natural; C : Color) is
   begin
      I.Data (Row (Y), Column (X)) := C;
   end Set;

   procedure Fill (I : in out Image; C : Color) is
   begin
      I.Data := [others => [others => C]];
   end Fill;

   procedure Blit (Src : Image; Dst : in out Image; X, Y : Integer) is
      X0 : constant Integer := Integer'Max (0, X);
      Y0 : constant Integer := Integer'Max (0, Y);
      X1 : constant Integer := Integer'Min (Width (Dst) - 1, X + Width (Src) - 1);
      Y1 : constant Integer := Integer'Min (Height (Dst) - 1, Y + Height (Src) - 1);
   begin
      for DY in Y0 .. Y1 loop
         for DX in X0 .. X1 loop
            Dst.Data (Row (DY), Column (DX)) := Src.Data (Row (DY - Y), Column (DX - X));
         end loop;
      end loop;
   end Blit;

end Bedrock.Buffers;
