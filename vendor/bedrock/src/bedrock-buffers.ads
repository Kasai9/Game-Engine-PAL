--  Pixel buffers: a 2D array of Color, row-major, top-down, so
--  Data (Y, X) is the pixel at column X of row Y and the whole thing is
--  one contiguous RGBA block a GPU upload or a window blit can take by
--  address. This is the one image format inside every GAP project;
--  file formats (QOI, PNG, JPEG) decode into it and encode from it.

with Bedrock.Colors; use Bedrock.Colors;
with Bedrock.Screen; use Bedrock.Screen;

package Bedrock.Buffers with SPARK_Mode, Pure is

   Max_Width  : constant := 8192;
   Max_Height : constant := 8192;

   subtype Column is Extent range 0 .. Max_Width - 1;
   subtype Row    is Extent range 0 .. Max_Height - 1;

   type Pixel_Array is array (Row range <>, Column range <>) of Color
     with Component_Size => 32;

   type Image (Height : Row; Width : Column) is record
      Data : Pixel_Array (0 .. Height, 0 .. Width);
      --  Discriminants are the LAST index, so a 640 x 480 image is
      --  Image (479, 639). Use Make to say it in width and height.
   end record;

   function Make (Width, Height : Positive; Fill : Color := Transparent) return Image
     with Pre => Width <= Max_Width and then Height <= Max_Height;

   function Width (I : Image) return Positive is (Positive (I.Width) + 1);
   function Height (I : Image) return Positive is (Positive (I.Height) + 1);

   function Get (I : Image; X, Y : Natural) return Color is (I.Data (Row (Y), Column (X)))
     with Pre => X < Width (I) and then Y < Height (I);

   procedure Set (I : in out Image; X, Y : Natural; C : Color)
     with Pre => X < Width (I) and then Y < Height (I);

   procedure Fill (I : in out Image; C : Color);

   procedure Blit (Src : Image; Dst : in out Image; X, Y : Integer);
   --  Copies Src over Dst at (X, Y), clipped, no blending.

end Bedrock.Buffers;
