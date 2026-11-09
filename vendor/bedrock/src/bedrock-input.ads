--  Input vocabulary: keys, modifiers, mouse, gamepads, and the Event a
--  platform delivers. Taken from portal's design, which is the GAP
--  window library, so that yarlib, the editors and any tool on top of
--  portal speak the same Key without a translation table.
--
--  Events are plain values: they can be queued, recorded to a text
--  file, replayed, injected by a test, or made up by a script.

with Bedrock.Screen; use Bedrock.Screen;

package Bedrock.Input with SPARK_Mode, Pure is

   type Key is
     (Key_Unknown,
      Key_A, Key_B, Key_C, Key_D, Key_E, Key_F, Key_G, Key_H, Key_I, Key_J,
      Key_K, Key_L, Key_M, Key_N, Key_O, Key_P, Key_Q, Key_R, Key_S, Key_T,
      Key_U, Key_V, Key_W, Key_X, Key_Y, Key_Z,
      Key_0, Key_1, Key_2, Key_3, Key_4, Key_5, Key_6, Key_7, Key_8, Key_9,
      Key_Return, Key_Escape, Key_Backspace, Key_Tab, Key_Space,
      Key_Insert, Key_Delete, Key_Home, Key_End, Key_Page_Up, Key_Page_Down,
      Key_Left, Key_Right, Key_Up, Key_Down,
      Key_Minus, Key_Equals, Key_Left_Bracket, Key_Right_Bracket, Key_Backslash,
      Key_Semicolon, Key_Apostrophe, Key_Grave, Key_Comma, Key_Period, Key_Slash,
      Key_F1, Key_F2, Key_F3, Key_F4, Key_F5, Key_F6,
      Key_F7, Key_F8, Key_F9, Key_F10, Key_F11, Key_F12,
      Key_Left_Shift, Key_Right_Shift, Key_Left_Ctrl, Key_Right_Ctrl,
      Key_Left_Alt, Key_Right_Alt, Key_Left_Super, Key_Right_Super,
      Key_Caps_Lock,
      Key_KP_0, Key_KP_1, Key_KP_2, Key_KP_3, Key_KP_4,
      Key_KP_5, Key_KP_6, Key_KP_7, Key_KP_8, Key_KP_9,
      Key_KP_Divide, Key_KP_Multiply, Key_KP_Minus, Key_KP_Plus,
      Key_KP_Enter, Key_KP_Period,
      Key_Print_Screen, Key_Scroll_Lock, Key_Pause, Key_Menu);

   type Key_Set is array (Key) of Boolean with Pack;

   type Modifiers is record
      Shift, Ctrl, Alt, Super, Caps_Lock : Boolean := False;
   end record with Pack, Size => 8;

   No_Modifiers : constant Modifiers := (others => False);

   type Mouse_Button is (Left, Middle, Right, Back, Forward);

   type Button_State is array (Mouse_Button) of Boolean with Pack;

   type Gamepad_Button is
     (South, East, West, North,            --  A B X Y on an Xbox layout
      Left_Shoulder, Right_Shoulder,
      Back_Button, Start, Guide,
      Left_Stick, Right_Stick,
      DPad_Up, DPad_Down, DPad_Left, DPad_Right);

   type Gamepad_Axis is (Left_X, Left_Y, Right_X, Right_Y, Left_Trigger, Right_Trigger);

   type Axis_Value is range -32_768 .. 32_767;

   Max_Gamepads : constant := 4;
   type Gamepad_Id is range 0 .. Max_Gamepads;
   No_Gamepad : constant Gamepad_Id := 0;
   subtype Valid_Gamepad_Id is Gamepad_Id range 1 .. Max_Gamepads;

   type Gamepad_Buttons is array (Gamepad_Button) of Boolean with Pack;
   type Gamepad_Axes is array (Gamepad_Axis) of Axis_Value;

   type Gamepad_State is record
      Connected : Boolean := False;
      Buttons   : Gamepad_Buttons := [others => False];
      Axes      : Gamepad_Axes := [others => 0];
   end record;

   ---------------------------------------------------------------------
   --  Events
   ---------------------------------------------------------------------

   type Event_Kind is
     (None,               --  queue was empty
      Quit,               --  the platform wants the app to stop
      Window_Shown,
      Window_Hidden,
      Window_Resized,     --  Size is the new client size
      Window_Moved,       --  Position is the new origin
      Window_Focus_In,
      Window_Focus_Out,
      Window_Close,       --  user asked to close this window
      Window_Expose,      --  contents lost, present again
      Key_Down,
      Key_Up,
      Text_Input,
      Mouse_Move,
      Mouse_Down,
      Mouse_Up,
      Mouse_Wheel,
      Mouse_Enter,
      Mouse_Leave,
      Gamepad_Connected,
      Gamepad_Disconnected,
      Gamepad_Button_Down,
      Gamepad_Button_Up,
      Gamepad_Axis_Motion,
      Clipboard_Changed);

   subtype Text_Bytes is String (1 .. 4);

   type Event (Kind : Event_Kind := None) is record
      Time   : Ticks     := 0;
      Window : Window_Id := No_Window;
      case Kind is
         when Window_Resized =>
            Size : Screen.Size;
         when Window_Moved =>
            Position : Point;
         when Key_Down | Key_Up =>
            Key      : Input.Key := Key_Unknown;
            Mods     : Modifiers := No_Modifiers;
            Repeat   : Boolean   := False;
         when Text_Input =>
            Text     : Text_Bytes := "    ";
            Length   : Natural    := 0;
         when Mouse_Move =>
            At_Pos   : Point;
            Delta_X  : Pixels := 0;
            Delta_Y  : Pixels := 0;
            Held     : Button_State := [others => False];
         when Mouse_Down | Mouse_Up =>
            Button   : Mouse_Button := Left;
            Where    : Point;
            Clicks   : Positive := 1;
         when Mouse_Wheel =>
            Wheel_X  : Pixels := 0;
            Wheel_Y  : Pixels := 0;
            Wheel_At : Point;
         when Gamepad_Connected | Gamepad_Disconnected =>
            Gamepad  : Gamepad_Id := No_Gamepad;
         when Gamepad_Button_Down | Gamepad_Button_Up =>
            Pad        : Gamepad_Id := No_Gamepad;
            Pad_Button : Gamepad_Button := South;
         when Gamepad_Axis_Motion =>
            Axis_Pad : Gamepad_Id := No_Gamepad;
            Axis     : Gamepad_Axis := Left_X;
            Value    : Axis_Value := 0;
         when others =>
            null;
      end case;
   end record;

   --  Short constructors for the common cases; a port or a test writes
   --  Key_Event (Key_A, Down => True) instead of a six-field aggregate.
   function Key_Event (K : Key; Down : Boolean; Mods : Modifiers := No_Modifiers;
                       Repeat : Boolean := False) return Event is
     (if Down then (Kind => Key_Down, Time => 0, Window => No_Window,
                    Key => K, Mods => Mods, Repeat => Repeat)
      else (Kind => Key_Up, Time => 0, Window => No_Window,
            Key => K, Mods => Mods, Repeat => Repeat));
   function Move_Event (X, Y : Pixels) return Event is
     ((Kind => Mouse_Move, Time => 0, Window => No_Window, At_Pos => (X, Y),
       Delta_X => 0, Delta_Y => 0, Held => [others => False]));
   function Button_Event (B : Mouse_Button; Down : Boolean; X, Y : Pixels := 0) return Event is
     (if Down then (Kind => Mouse_Down, Time => 0, Window => No_Window,
                    Button => B, Where => (X, Y), Clicks => 1)
      else (Kind => Mouse_Up, Time => 0, Window => No_Window,
            Button => B, Where => (X, Y), Clicks => 1));
   function Resize_Event (W, H : Extent) return Event is
     ((Kind => Window_Resized, Time => 0, Window => No_Window, Size => (W, H)));
   Quit_Event : constant Event := (Kind => Quit, Time => 0, Window => No_Window);
   No_Event   : constant Event := (Kind => None, Time => 0, Window => No_Window);

   ---------------------------------------------------------------------
   --  A bounded queue of events
   ---------------------------------------------------------------------

   Max_Queue : constant := 256;
   type Queue_Index is range 0 .. Max_Queue;
   type Event_Array is array (Queue_Index range 1 .. Max_Queue) of Event;

   type Event_Queue is record
      Count  : Queue_Index := 0;
      Events : Event_Array;
   end record;

   procedure Push (Q : in out Event_Queue; E : Event)
     with Post => Q.Count = Queue_Index'Min (Q.Count'Old + 1, Max_Queue);
   --  Drops the event when full; 256 events in one frame is a bug elsewhere.

   procedure Clear (Q : in out Event_Queue)
     with Post => Q.Count = 0;

end Bedrock.Input;
