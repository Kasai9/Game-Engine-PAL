package body Bedrock.Responses with SPARK_Mode is

   procedure Set (R : out Response; Ok : Boolean; Msg : String) is
      L : constant Natural := Natural'Min (Msg'Length, Max);
   begin
      R.Ok := Ok;
      R.Length := L;
      R.Text := [others => ' '];
      R.Text (1 .. L) := Msg (Msg'First .. Msg'First + L - 1);
   end Set;

   procedure Append (R : in out Response; Msg : String) is
      L : constant Natural := Natural'Min (Msg'Length, Max - R.Length);
   begin
      R.Text (R.Length + 1 .. R.Length + L) := Msg (Msg'First .. Msg'First + L - 1);
      R.Length := R.Length + L;
   end Append;

   procedure Ok (R : out Response; Info : String := "") is
   begin
      if Info'Length = 0 then
         Set (R, True, "ok");
      else
         Set (R, True, "ok " & Info);
      end if;
   end Ok;

   procedure Err (R : out Response; Reason : String) is
   begin
      Set (R, False, "err " & Reason);
   end Err;

end Bedrock.Responses;
