/// @DnDAction : YoYo Games.Drawing.Set_Font
/// @DnDVersion : 1
/// @DnDHash : 0197CE25
/// @DnDArgument : "font" "font_consolas_b_40"
/// @DnDSaveInfo : "font" "620bc136-e336-4513-9d7c-9dc753f83766"

{
	draw_set_font(font_consolas_b_40);
}

/// @DnDAction : YoYo Games.Drawing.Set_Color
/// @DnDVersion : 1
/// @DnDHash : 59027A25
/// @DnDArgument : "color" "$FF000000"

{
	draw_set_colour($FF000000 & $ffffff);
	draw_set_alpha(($FF000000 >> 24) / $ff);
}

/// @DnDAction : YoYo Games.Drawing.Draw_Value
/// @DnDVersion : 1
/// @DnDHash : 29412C8A
/// @DnDArgument : "x" "20"
/// @DnDArgument : "y" "15"
/// @DnDArgument : "caption" ""W E A P O N G A M E""

{
	var l29412C8A_0 = 20;
	var l29412C8A_1 = 15;
	draw_text(l29412C8A_0, l29412C8A_1, string("W E A P O N G A M E") + "");
}

/// @DnDAction : YoYo Games.Drawing.Set_Font
/// @DnDVersion : 1
/// @DnDHash : 1E3CC0B8
/// @DnDArgument : "font" "font_consolas_r_13"
/// @DnDSaveInfo : "font" "8c662139-cbbd-429b-8da9-cc4a05b9e43b"

{
	draw_set_font(font_consolas_r_13);
}

/// @DnDAction : YoYo Games.Drawing.Draw_Value
/// @DnDVersion : 1
/// @DnDHash : 5D9EA76D
/// @DnDArgument : "x" "(window_get_width()/2) - 230"
/// @DnDArgument : "y" "window_get_height()/2"
/// @DnDArgument : "caption" ""Save loaded successfully. Press [space] to continue.""

{
	var l5D9EA76D_0 = (window_get_width()/2) - 230;
	var l5D9EA76D_1 = window_get_height()/2;
	draw_text(l5D9EA76D_0, l5D9EA76D_1, string("Save loaded successfully. Press [space] to continue.") + "");
}

