package body Bedrock.Input with SPARK_Mode is

   procedure Push (Q : in out Event_Queue; E : Event) is
   begin
      if Q.Count < Max_Queue then
         Q.Count := Q.Count + 1;
         Q.Events (Q.Count) := E;
      end if;
   end Push;

   procedure Clear (Q : in out Event_Queue) is
   begin
      Q.Count := 0;
   end Clear;

end Bedrock.Input;
