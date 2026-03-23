extends Node

const FILENAME := "user://user_settings.cfg"

@export var game_directory: String = "res://sample_games"
@export var game_last_played: String = ""

@export var layout_menu_position: Vector2 = Vector2(280, 511)
@export var layout_dpad_position: Vector2 = Vector2(38, 507)
@export var layout_face_position: Vector2 = Vector2(423, 675)
@export var layout_miis_position: Vector2 = Vector2(232, 818)
@export var layout_meta_position: Vector2 = Vector2(296, 0)


func _ready() -> void:
	if FileAccess.file_exists(FILENAME):
		_load_settings()
	else:
		_save_settings()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_settings()


func _load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(FILENAME)
	if err != OK:
		push_error(error_string(err))
		return
	game_directory = config.get_value("games", "dir", ".")
	game_last_played = config.get_value("games", "last_played", "")
	
	layout_menu_position.x = config.get_value("layout.menu", "x", 0)
	layout_menu_position.y = config.get_value("layout.menu", "y", 0)
	layout_dpad_position.x = config.get_value("layout.dpad", "x", 0)
	layout_dpad_position.y = config.get_value("layout.dpad", "y", 0)
	layout_face_position.x = config.get_value("layout.face", "x", 0)
	layout_face_position.y = config.get_value("layout.face", "y", 0)
	layout_miis_position.x = config.get_value("layout.miis", "x", 0)
	layout_miis_position.y = config.get_value("layout.miis", "y", 0)
	layout_meta_position.x = config.get_value("layout.meta", "x", 0)
	layout_meta_position.y = config.get_value("layout.meta", "y", 0)
	print_debug("Settings loaded.")


func _save_settings() -> void:
	var config := ConfigFile.new()
	
	config.set_value("games", "dir", game_directory)
	config.set_value("games", "last_played", game_last_played)
	
	config.set_value("layout.menu", "x", layout_menu_position.x)
	config.set_value("layout.menu", "y", layout_menu_position.y)
	config.set_value("layout.dpad", "x", layout_dpad_position.x)
	config.set_value("layout.dpad", "y", layout_dpad_position.y)
	config.set_value("layout.face", "x", layout_face_position.x)
	config.set_value("layout.face", "y", layout_face_position.y)
	config.set_value("layout.miis", "x", layout_miis_position.x)
	config.set_value("layout.miis", "y", layout_miis_position.y)
	config.set_value("layout.meta", "x", layout_meta_position.x)
	config.set_value("layout.meta", "y", layout_meta_position.y)
	
	config.save(FILENAME)
	print_debug("Settings saved.")
