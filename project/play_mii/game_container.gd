class_name GameContainer
extends Node

const FPS := 30

var _frame_timer := 0.0
var cartridge: Cartridge

@onready var display := $Display as Display2D
@onready var input := $Input as Inputs


func start(config: ConfigFile) -> void:
	print("Loading game...")
	var script_path := Emulator.game_path + "/cartridge.gd"
	var game_script := load(script_path) as Script
	if not game_script:
		push_error("No cartridge found for game")
		return
	var palettes: Array[Texture2D]
	var tilesheets: Array[Texture2D]
	for tilesheet in config.get_section_keys("tilesheets"):
		print(tilesheet, " = ", config.get_value("tilesheets", tilesheet))
		var path := Emulator.game_path + "/" + str(config.get_value("tilesheets", tilesheet))
		var texture := load(path) as Texture2D
		print(texture)
		tilesheets.append(texture)
	# TODO: Load palettes
	# TODO: Load Mii input and update emulator inputs
	display.setup(palettes, tilesheets)
	input.setup()
	cartridge = game_script.new() as Cartridge
	cartridge.display = display
	cartridge.input = input
	add_child(cartridge)
	cartridge.setup()


func _process(delta: float) -> void:
	_frame_timer += delta
	if _frame_timer > 1.0 / FPS:
		input.clear()
		cartridge.update()
		display.clear()
		cartridge.draw()
		display.queue_redraw()
