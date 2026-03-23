class_name Display2D
extends Control

const WIDTH := 320
const HEIGHT := 240

var _palettes: Array[Texture2D]
var _tilesheets: Array[Texture2D]

var _current_palette: int = 0
var _current_primary_tilesheet: int = 0
var _current_secondary_tilesheet: int = 1
var _text_tilesheet: int = 0
var _text_glyphs := "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}"
var _text_glyph_size := Vector2i(16, 16)

var _drawings: Array[DrawCall]

# TODO: Get palettes working. Set up a palette swap shader and options for changing palettes
# SEE: https://godotshaders.com/shader/palette-swap-no-recolor-recolor/
# SEE: https://lospec.com/palette-list/vinik24
# SEE: https://lospec.com/palette-list/sweet24


func _draw() -> void:
	for draw_call in _drawings:
		var texture := _tilesheets[draw_call.tilesheet]
		draw_texture_rect_region(texture, Rect2(draw_call.dest_coords, draw_call.src_size), Rect2(draw_call.src_coords, draw_call.src_size))


func setup(palettes: Array[Texture2D], tilesheets: Array[Texture2D]) -> void:
	# TODO: Cap size here just in case?
	_palettes = palettes
	_tilesheets = tilesheets
	if _tilesheets.size() < 2:
		_current_secondary_tilesheet = 0


func set_palette(id: int) -> void:
	_current_palette = id


func set_primary_tilesheet(id: int) -> void:
	_current_primary_tilesheet = id


func set_secondary_tilesheet(id: int) -> void:
	_current_secondary_tilesheet = id


func set_text_tilesheet(id: int) -> void:
	_text_tilesheet = id


func set_text(glyphs: String, glyph_size: Vector2i) -> void:
	if glyphs:
		_text_glyphs = glyphs
	if glyph_size:
		_text_glyph_size = glyph_size


func clear() -> void:
	_drawings.clear()


func draw_sprite(dest_coords: Vector2i, src_coords: Vector2i, src_size:=Vector2i(16, 16), use_secondary_tilesheet:=false) -> void:
	var draw_call := DrawCall.new()
	draw_call.dest_coords = dest_coords
	draw_call.src_coords = src_coords
	draw_call.src_size = src_size
	draw_call.tilesheet = _current_secondary_tilesheet if use_secondary_tilesheet else _current_primary_tilesheet
	_drawings.append(draw_call)


func draw_text(dest_coords: Vector2i, text: String) -> void:
	for i in text.length():
		var glyph := text[i]
		var draw_call := DrawCall.new()
		draw_call.dest_coords = dest_coords + Vector2i.RIGHT * _text_glyph_size.x * i
		var glyph_index := _text_glyphs.find(glyph.to_upper())
		if glyph_index == -1:
			push_error("Couldn't find '%s' in text glyphs\n%s" % [glyph, _text_glyphs])
			return
		var x := glyph_index % (256 / floori(_text_glyph_size.x))
		var y := glyph_index / (256 / floori(_text_glyph_size.x))
		draw_call.src_coords = Vector2i(x, y) * _text_glyph_size
		draw_call.src_size = _text_glyph_size
		draw_call.tilesheet = _text_tilesheet
		_drawings.append(draw_call)


class DrawCall:
	var tilesheet: int
	var dest_coords: Vector2i
	var src_coords: Vector2i
	var src_size: Vector2i
