class_name GameScene
extends Control

@onready var _game_background := %GameBackground as Control
@onready var _game := %GameContainer as GameContainer
@onready var _modal_background := %Modal as Button
@onready var _menu_open_btn := %EmulatorMenu as Button
@onready var _menu_resume_btn := %Resume as Button
@onready var _menu_settings_btn := %Settings as Button
@onready var _menu_reset_btn := %Reset as Button
@onready var _menu_close_btn := %Close as Button
@onready var _menu_exit_btn := %Exit as Button

#region InputMappingHack
@onready var _input_manager := $Contents/ScreenArea/SubViewportContainer/GameContainer/Input as Inputs
@onready var _up_btn := $Contents/InputGroups/DirectionPad/Up as TouchButton
@onready var _down_btn := $Contents/InputGroups/DirectionPad/Down as TouchButton
@onready var _left_btn := $Contents/InputGroups/DirectionPad/Left as TouchButton
@onready var _right_btn := $Contents/InputGroups/DirectionPad/Right as TouchButton
@onready var _a_btn := $Contents/InputGroups/FaceButtons/A as TouchButton
@onready var _b_btn := $Contents/InputGroups/FaceButtons/B as TouchButton
@onready var _menu_btn := $Contents/InputGroups/MenuButtons/Menu as TouchButton
@onready var _alt_btn := $Contents/InputGroups/MenuButtons/Alt as TouchButton
@onready var _wheel_dial := $Contents/InputGroups/MiiSlot/WheelDial as WheelDial
@onready var _up_debug := $DebugInfo/Inputs/Up as Label
@onready var _down_debug := $DebugInfo/Inputs/Down as Label
@onready var _left_debug := $DebugInfo/Inputs/Left as Label
@onready var _right_debug := $DebugInfo/Inputs/Right as Label
@onready var _a_debug := $DebugInfo/Inputs/A as Label
@onready var _b_debug := $DebugInfo/Inputs/B as Label
@onready var _menu_debug := $DebugInfo/Inputs/Menu as Label
@onready var _alt_debug := $DebugInfo/Inputs/Alt as Label
#endregion


func _ready() -> void:
	_modal_background.pressed.connect(_modal_background.hide)
	_menu_open_btn.pressed.connect(_modal_background.show)
	_menu_resume_btn.pressed.connect(_modal_background.hide)
	#_menu_settings_btn # TODO:
	#_menu_reset_btn # TODO:
	_menu_close_btn.pressed.connect(_close_game)
	_menu_exit_btn.pressed.connect(get_tree().notification.bind(NOTIFICATION_WM_CLOSE_REQUEST))
	_menu_exit_btn.pressed.connect(get_tree().quit)
	
	if not Emulator.game_path:
		var no_game := Label.new()
		no_game.text = "No Game"
		no_game.add_theme_color_override(&"font_color", Color.BLACK)
		no_game.add_theme_font_size_override(&"font_size", 32)
		no_game.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		_game_background.add_child(no_game)
		return
	var config := ConfigFile.new()
	var err := config.load(Emulator.game_path + "/game.cfg")
	if err != OK:
		push_error("Couldn't load game %s.\n" % Emulator.game_path, error_string(err))
		return
	_game.setup(config)
	# Input Mapping Hack BEGIN # TODO: Remove
	var buttons: Array[TouchButton] = [_up_btn, _down_btn, _left_btn, _right_btn, _a_btn, _b_btn, _menu_btn, _alt_btn]
	var keys: Array[int] = [Inputs.UP, Inputs.DOWN, Inputs.LEFT, Inputs.RIGHT, Inputs.A, Inputs.B, Inputs.MENU, Inputs.ALT]
	var debug: Array[Label] = [_up_debug, _down_debug, _left_debug, _right_debug, _a_debug, _b_debug, _menu_debug, _alt_debug]
	for i in buttons.size():
		buttons[i].button_down.connect(func() -> void:
			_input_manager._last_frame_key_states[keys[i]] = true
			_input_manager._key_states[keys[i]] = true
			debug[i].modulate = Color.WHITE)
		buttons[i].button_up.connect(func() -> void:
			_input_manager._key_states[keys[i]] = false
			debug[i].modulate = Color.DARK_GRAY)
		debug[i].modulate = Color.DARK_GRAY
	_wheel_dial.value_changed.connect(func(delta: float) -> void:
		_input_manager._axis_1d_change[Inputs.WHEEL] = delta
		_input_manager._axis_1d_states[Inputs.WHEEL] = _wheel_dial.angle)
	# Input Mapping Hack END
	_game.start()


func _close_game() -> void:
	Emulator.game_path = ""
	get_tree().change_scene_to_packed(load("res://scenes/landing.tscn") as PackedScene)
