class_name LandingScene
extends Control

@onready var _game_count := %GameCount as Label
@onready var _game_list := %GameList as Container


func _ready() -> void:
	_setup_game_list()


func _setup_game_list() -> void:
	var dir := UserSettings.game_directory
	for game in DirAccess.get_directories_at(dir):
		var path := dir + "/" + game
		var config_path := path + "/game.cfg"
		if not FileAccess.file_exists(config_path):
			push_error("Game %s missing a game.cfg" % path)
			continue
		var config := ConfigFile.new()
		var err := config.load(config_path)
		if err != OK:
			push_error("Couldn't load %s" % config_path)
			continue
		var button := Button.new()
		button.custom_minimum_size.y = 96
		button.text = config.get_value("game", "name", "Untitled")
		button.pressed.connect(_open_game.bind(path))
		_game_list.add_child(button)
	var count := _game_list.get_child_count()
	_game_count.text = ("%d game" % count) + ("s" if count != 1 else "")


func _open_game(path: String) -> void:
	var config_path := path + "/game.cfg"
	if not FileAccess.file_exists(config_path):
		push_error("Game %s missing a game.cfg" % path)
		return
	var config := ConfigFile.new()
	var err := config.load(config_path)
	if err != OK:
		push_error("Couldn't load %s" % config_path)
		return
	print("Opening %s..." % config.get_value("game", "name", "Untitled"))
	Emulator.game_path = path
	get_tree().change_scene_to_packed(load("res://scenes/game.tscn"))


func _open_settings() -> void:
	pass


func _close() -> void:
	get_tree().notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit(0)
