class_name GameContainer
extends Node

const FPS := 30

var _frame_timer := 0.0
var cartridge: Cartridge
var lua_environment: LuaAPI
var _has_loaded: bool = false

@onready var display := $Display as Display2D
@onready var input := $Input as Inputs


func setup(config: ConfigFile) -> void:
	lua_environment = LuaAPI.new()
	# All builtin libraries are available to bind with. Use Debug, OS and IO at your own risk.
	lua_environment.bind_libraries(["base", "table", "string", "math"])
	
	# NOTE: Can't push a variant that is a key of a table (eg `math.tau`)
	lua_environment.do_string("math.tau = 2 * math.pi")
	lua_environment.do_string("math.round = function(n) return math.floor(n + 0.5) end")

	lua_environment.push_variant("print", print)
	lua_environment.push_variant("input_is_pressed", input.is_pressed)
	lua_environment.push_variant("input_get_axis_1d", input.get_axis_1d)
	lua_environment.push_variant("input_UP", input.UP)
	lua_environment.push_variant("input_DOWN", input.DOWN)
	lua_environment.push_variant("input_LEFT", input.LEFT)
	lua_environment.push_variant("input_RIGHT", input.RIGHT)
	lua_environment.push_variant("input_WHEEL", input.WHEEL)
	lua_environment.push_variant("display_WIDTH", display.WIDTH)
	lua_environment.push_variant("display_HEIGHT", display.HEIGHT)
	lua_environment.push_variant("display_set_text_tilesheet", display.set_text_tilesheet)
	lua_environment.push_variant("display_set_text", display.set_text)
	lua_environment.push_variant("display_draw_sprite", display.draw_sprite)
	lua_environment.push_variant("display_draw_text", display.draw_text)
	
	_has_loaded = false
	var file_path := Emulator.game_path + "/cartridge.lua"
	var err: LuaError = lua_environment.do_file(file_path)
	if err:
		push_error(err.message)
		return
	_has_loaded = true
	var palettes: Array[Texture2D]
	var tilesheets: Array[Texture2D]
	for tilesheet in config.get_section_keys("tilesheets"):
		var path := Emulator.game_path + "/" + str(config.get_value("tilesheets", tilesheet))
		var texture := load(path) as Texture2D
		tilesheets.append(texture)
	display.setup(palettes, tilesheets)
	input.setup()
	# TODO: Load palettes
	# TODO: Load Mii input and update emulator inputs


func start() -> void:
	if not _has_loaded:
		return
	if lua_environment.function_exists("load"):
		lua_environment.call_function("load", [])


func _process(delta: float) -> void:
	_frame_timer += delta
	if _frame_timer > 1.0 / FPS:
		input.clear()
		if lua_environment.function_exists("update"):
			lua_environment.call_function("update", [])
		display.clear()
		if lua_environment.function_exists("draw"):
			lua_environment.call_function("draw", [])
		display.queue_redraw()
