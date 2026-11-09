--  A bounded identifier: what every project rewrote for its named
--  things (solids in forge, clips in framewise, entities in yarlib).
--  ASCII, 32 characters, no heap, comparable with "=".

package Bedrock.Names with SPARK_Mode, Pure is

   Max_Name : constant := 32;

   type Name is record
      Length : Natural range 0 .. Max_Name := 0;
      Text   : String (1 .. Max_Name) := [others => ' '];
   end record;

   No_Name : constant Name := (0, [others => ' ']);

   function To_Name (S : String) return Name
     with Pre => S'Length <= Max_Name,
          Post => To_Name'Result.Length = S'Length;

   function Image (N : Name) return String is (N.Text (1 .. N.Length));

   function Is_Empty (N : Name) return Boolean is (N.Length = 0);

   ---------------------------------------------------------------------
   --  Paths: a file name, bounded, for commands like `save part.forge`
   --  and `import take1 take1.mp4`. Not validated; the file system
   --  decides.
   ---------------------------------------------------------------------

   Max_Path : constant := 256;

   type Path is record
      Length : Natural range 0 .. Max_Path := 0;
      Text   : String (1 .. Max_Path) := [others => ' '];
   end record;

   No_Path : constant Path := (0, [others => ' ']);

   function To_Path (S : String) return Path
     with Pre => S'Length <= Max_Path,
          Post => To_Path'Result.Length = S'Length;

   function Image (P : Path) return String is (P.Text (1 .. P.Length));

end Bedrock.Names;
