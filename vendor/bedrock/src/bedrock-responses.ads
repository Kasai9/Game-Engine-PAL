--  The GAP line protocol's reply: every tool in the program (forge,
--  framewise, yarlib's console) takes one line and answers one
--  Response whose text starts with "ok" or "err". One type, one
--  Set/Append, so a front end or an agent parses every tool the same
--  way. Generic over the size because a CAD `info` fits in 1 KB and a
--  video `plan` does not.

generic
   Max : Positive := 1024;
package Bedrock.Responses with SPARK_Mode, Pure is

   type Response is record
      Ok     : Boolean := True;
      Length : Natural range 0 .. Max := 0;
      Text   : String (1 .. Max) := [others => ' '];
   end record;

   function Image (R : Response) return String is (R.Text (1 .. R.Length));

   procedure Set (R : out Response; Ok : Boolean; Msg : String)
     with Post => R.Ok = Ok and then R.Length = Natural'Min (Msg'Length, Max);
   --  Msg is the whole text, "ok ..." or "err ...", truncated to Max.

   procedure Append (R : in out Response; Msg : String)
     with Post => R.Length = Natural'Min (R.Length'Old + Msg'Length, Max);

   procedure Ok (R : out Response; Info : String := "")
     with Post => R.Ok;
   --  "ok" or "ok " & Info.

   procedure Err (R : out Response; Reason : String)
     with Post => not R.Ok;
   --  "err " & Reason.

end Bedrock.Responses;
