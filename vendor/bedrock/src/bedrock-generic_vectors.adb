with Ada.Numerics.Generic_Elementary_Functions;

package body Bedrock.Generic_Vectors with SPARK_Mode => Off is

   package Fn is new Ada.Numerics.Generic_Elementary_Functions (Real);

   function Length (A : Vector2) return Real is (Fn.Sqrt (Length_Squared (A)));
   function Normalized (A : Vector2) return Vector2 is (A * (1.0 / Length (A)));

   function Length (A : Vector3) return Real is (Fn.Sqrt (Length_Squared (A)));
   function Normalized (A : Vector3) return Vector3 is (A * (1.0 / Length (A)));

end Bedrock.Generic_Vectors;
