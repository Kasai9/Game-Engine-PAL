with Ada.Numerics.Elementary_Functions;

package body Bedrock with SPARK_Mode => Off is
   --  Sqrt is not SPARK-provable; the two functions that need it live
   --  here, off, so everything else in the crate stays on.

   function Length (A : Vector2) return Scalar is
     (Scalar (Ada.Numerics.Elementary_Functions.Sqrt (Float (Length_Squared (A)))));

   function Normalized (A : Vector2) return Vector2 is (A / Length (A));

end Bedrock;
