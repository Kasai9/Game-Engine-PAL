# bedrock

The GNAT Academic Program foundation crate: the types every GAP
desktop project would otherwise declare twice and convert between.
Pure, SPARK, no dependencies, about 500 lines, frozen at 1.0.

```
Bedrock          Scalar, Degrees, Vector2, Rectangle; Dot, Length, Lerp, Contains, Overlaps
Bedrock.Screen   Pixels, Point, Size, Rect (integers, for windows); Ticks; Window_Id
Bedrock.Colors   Channel, Color (RGBA8888, explicit layout); a palette; Blend, Modulate, Fade
Bedrock.Buffers  Pixel_Array, Image (row-major, top-down, Data (Y, X)); Make, Get, Set, Fill, Blit
Bedrock.Input    Key, Modifiers, Mouse_Button, Gamepad_*; Event (closed variant); Event_Queue
Bedrock.Names    Name (bounded, 32), Path (bounded, 256); To_Name, To_Path, Image
Bedrock.Responses        generic (Max): Response, Set, Append, Ok, Err: the "ok / err" line protocol reply
Bedrock.Generic_Vectors        generic (Real digits <>): Vector2, Vector3, Dot, Cross, Length, Normalized
Bedrock.Generic_Fixed_Vectors  generic (Fixed delta <>): the same, provable, no square root
```

## Why it exists

In Ada the type is the contract. If portal and yarlib each declare a
`Key`, the port between them is a 60-line case statement and every
rename in one breaks the other. If they share one `Key`, the port is
a pass-through. If they share one `Color` and one `Image`, a frame
drawn by yarlib's software rasterizer goes into portal's window with
no copy and no conversion, and the editor's adi2 texture view takes
the same bytes. The 500 lines saved are not the point; the absence of
seams is.

## Who uses it

- [portal](https://github.com/GNAT-Academic-Program/portal): Screen,
  Colors, Buffers, Input. `Portal.Input` and `Portal.Events` are
  renamings of `Bedrock.Input`.
- [yarlib](https://github.com/GNAT-Academic-Program/yarlib): all of it.
- [forge](https://github.com/GNAT-Academic-Program/forge): Names,
  Responses, and `Generic_Vectors (Long_Float)` for its `Vec3`.
- [framewise](https://github.com/GNAT-Academic-Program/framewise):
  Names (Name, Path), Responses.
- boxflex: Scalar, Rectangle (when next touched).
- The editors, and adi2 if its author wants to (his call; a
  conversion at that one seam is fine).

Not used by escape (no geometry), beacon, ledger. framewise's `Time`
in ticks and forge's meshes stay theirs: those are designs, not
vocabulary.

## The rule

bedrock changes only through the GAP coordinator, by pull request,
with every dependent's CI green. Its value is that nobody needs to
touch it. If a project needs something added here, that is a design
conversation, and the usual answer is that it belongs in the
project's own crate.

What is deliberately not here: anything with a design in it. No
matrices, no fixed point, no time type, no layout boxes, no
rasterizer, no file format. adi2 keeps its own float `Point` and
normalized `Color`; a conversion at that one seam is fine and is the
author's call.

## Use

```toml
[[depends-on]]
bedrock = "*"

[[pins]]
bedrock = { url = "https://github.com/GNAT-Academic-Program/bedrock.git" }
```

```ada
with Bedrock;         use Bedrock;          --  Scalar, Vector2, ...
with Bedrock.Colors;  use Bedrock.Colors;   --  Color, Red, Blend
with Bedrock.Input;   use Bedrock.Input;    --  Key_A, Key_Event, Event
```

A library built on bedrock puts those use clauses in its root
package so its own children see the types; it does not re-declare
them as subtypes (a subtype with the same name hides the original
once a client uses both packages, and renamed operators lose the
preference rule for literals; both were tried).

## Build

```
alr build
cd tests && alr build && ./bin/tests
alr with gnatprove && alr exec -- gnatprove -P bedrock.gpr --mode=flow
```

## License

Apache-2.0.
