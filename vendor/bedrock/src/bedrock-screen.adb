package body Bedrock.Screen with SPARK_Mode is
   function To_Point (V : Vector2) return Point is
     ((Pixels (Scalar'Truncation (V.X)), Pixels (Scalar'Truncation (V.Y))));
end Bedrock.Screen;
