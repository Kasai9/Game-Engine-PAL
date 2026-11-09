--  Vectors at a precision of your choosing. The root package's Vector2
--  is Float and is what screens and 2D games want; forge wants Long_Float
--  and a third axis. Instantiate once per project:
--
--     package Geometry is new Bedrock.Generic_Vectors (Long_Float);
--     use Geometry;   --  Vector3, Dot, Cross, ...
--
--  Pure functions on plain records. Length and Normalized need Sqrt
--  and are in the body, off SPARK; everything else is provable.

generic
   type Real is digits <>;
package Bedrock.Generic_Vectors with SPARK_Mode, Pure is

   type Vector2 is record
      X, Y : Real := 0.0;
   end record;

   type Vector3 is record
      X, Y, Z : Real := 0.0;
   end record;

   Zero2 : constant Vector2 := (0.0, 0.0);
   Zero3 : constant Vector3 := (0.0, 0.0, 0.0);

   function "+" (A, B : Vector2) return Vector2 is (A.X + B.X, A.Y + B.Y);
   function "-" (A, B : Vector2) return Vector2 is (A.X - B.X, A.Y - B.Y);
   function "-" (A : Vector2) return Vector2 is (-A.X, -A.Y);
   function "*" (A : Vector2; S : Real) return Vector2 is (A.X * S, A.Y * S);
   function "*" (S : Real; A : Vector2) return Vector2 is (A.X * S, A.Y * S);
   function Dot (A, B : Vector2) return Real is (A.X * B.X + A.Y * B.Y);
   function Length_Squared (A : Vector2) return Real is (Dot (A, A));
   function Length (A : Vector2) return Real;
   function Normalized (A : Vector2) return Vector2
     with Pre => Length_Squared (A) > 0.0;

   function "+" (A, B : Vector3) return Vector3 is (A.X + B.X, A.Y + B.Y, A.Z + B.Z);
   function "-" (A, B : Vector3) return Vector3 is (A.X - B.X, A.Y - B.Y, A.Z - B.Z);
   function "-" (A : Vector3) return Vector3 is (-A.X, -A.Y, -A.Z);
   function "*" (A : Vector3; S : Real) return Vector3 is (A.X * S, A.Y * S, A.Z * S);
   function "*" (S : Real; A : Vector3) return Vector3 is (A.X * S, A.Y * S, A.Z * S);
   function Dot (A, B : Vector3) return Real is (A.X * B.X + A.Y * B.Y + A.Z * B.Z);
   function Cross (A, B : Vector3) return Vector3 is
     (A.Y * B.Z - A.Z * B.Y, A.Z * B.X - A.X * B.Z, A.X * B.Y - A.Y * B.X);
   function Length_Squared (A : Vector3) return Real is (Dot (A, A));
   function Length (A : Vector3) return Real;
   function Normalized (A : Vector3) return Vector3
     with Pre => Length_Squared (A) > 0.0;

   type Axis is (X, Y, Z);

end Bedrock.Generic_Vectors;
