--  Vectors over a fixed-point type. Ada has no generic formal that
--  covers both floating and fixed, so this is the delta <> twin of
--  Bedrock.Generic_Vectors:
--
--     type Milli is delta 0.001 range -1.0E6 .. 1.0E6;
--     package Fixed_Geometry is new Bedrock.Generic_Fixed_Vectors (Milli);
--
--  Why: fixed point is integers underneath, so SPARK can prove that a
--  chain of vector operations does not overflow, which it will not do
--  for floats. A bare-metal target with no FPU, a robust-geometry
--  kernel that snaps intersection points, an embedded layout engine:
--  those want this one. No Length or Normalized here: a square root
--  in fixed point is a design decision, not a foundation type.

generic
   type Fixed is delta <>;
package Bedrock.Generic_Fixed_Vectors with SPARK_Mode, Pure is

   type Vector2 is record
      X, Y : Fixed := 0.0;
   end record;

   type Vector3 is record
      X, Y, Z : Fixed := 0.0;
   end record;

   Zero2 : constant Vector2 := (0.0, 0.0);
   Zero3 : constant Vector3 := (0.0, 0.0, 0.0);

   function "+" (A, B : Vector2) return Vector2 is (A.X + B.X, A.Y + B.Y);
   function "-" (A, B : Vector2) return Vector2 is (A.X - B.X, A.Y - B.Y);
   function "-" (A : Vector2) return Vector2 is (-A.X, -A.Y);
   function "*" (A : Vector2; S : Fixed) return Vector2 is (A.X * S, A.Y * S);
   function "*" (A : Vector2; S : Integer) return Vector2 is (A.X * S, A.Y * S);
   function Dot (A, B : Vector2) return Fixed is (A.X * B.X + A.Y * B.Y);

   function "+" (A, B : Vector3) return Vector3 is (A.X + B.X, A.Y + B.Y, A.Z + B.Z);
   function "-" (A, B : Vector3) return Vector3 is (A.X - B.X, A.Y - B.Y, A.Z - B.Z);
   function "-" (A : Vector3) return Vector3 is (-A.X, -A.Y, -A.Z);
   function "*" (A : Vector3; S : Fixed) return Vector3 is (A.X * S, A.Y * S, A.Z * S);
   function "*" (A : Vector3; S : Integer) return Vector3 is (A.X * S, A.Y * S, A.Z * S);
   function Dot (A, B : Vector3) return Fixed is (A.X * B.X + A.Y * B.Y + A.Z * B.Z);
   function Cross (A, B : Vector3) return Vector3 is
     (A.Y * B.Z - A.Z * B.Y, A.Z * B.X - A.X * B.Z, A.X * B.Y - A.Y * B.X);

   type Axis is (X, Y, Z);

end Bedrock.Generic_Fixed_Vectors;
