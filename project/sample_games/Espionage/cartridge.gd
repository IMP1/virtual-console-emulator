extends Cartridge

# TODO: Make a li'l sample game of just walking around and interacting with one or two things.
# SEE: I downloaded this and it looks fine? CC0! https://pixel-boy.itch.io/ninja-adventure-asset-pack

var text_x := 64
var text_y := 64
var angle_display := 0


func setup() -> void:
	display.set_text_tilesheet(1)
	display.set_text("", Vector2i(8, 8))


func update() -> void:
	if input.is_pressed(Inputs.UP):
		text_y -= 1
		text_y = maxi(text_y, 0)
	if input.is_pressed(Inputs.DOWN):
		text_y += 1
		text_y = mini(text_y, display.HEIGHT - 2*16)
	if input.is_pressed(Inputs.LEFT):
		text_x -= 1
		text_x = maxi(text_x, 0)
	if input.is_pressed(Inputs.RIGHT):
		text_x += 1
		text_x = mini(text_x, display.WIDTH - 5*16)
	angle_display = roundi(rad_to_deg(input.get_axis_1d(Inputs.WHEEL)))


func draw() -> void:
	display.draw_sprite(Vector2i(text_x+16*0, text_y), Vector2i(128, 0))
	display.draw_sprite(Vector2i(text_x+16*1, text_y), Vector2i(80, 0))
	display.draw_sprite(Vector2i(text_x+16*2, text_y), Vector2i(192, 0))
	display.draw_sprite(Vector2i(text_x+16*3, text_y), Vector2i(192, 0))
	display.draw_sprite(Vector2i(text_x+16*4, text_y), Vector2i(240, 0))
	
	display.draw_sprite(Vector2i(text_x+16*0, text_y+16), Vector2i(112, 16))
	display.draw_sprite(Vector2i(text_x+16*1, text_y+16), Vector2i(240, 0))
	display.draw_sprite(Vector2i(text_x+16*2, text_y+16), Vector2i(32, 16))
	display.draw_sprite(Vector2i(text_x+16*3, text_y+16), Vector2i(192, 0))
	display.draw_sprite(Vector2i(text_x+16*4, text_y+16), Vector2i(64, 0))
	
	var angle_string := str(angle_display)
	display.draw_text(Vector2i(8, 8), angle_string)
