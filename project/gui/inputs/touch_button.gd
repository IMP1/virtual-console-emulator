@tool
class_name TouchButton
extends Control

signal button_down
signal button_up
signal pressed

@export var disabled: bool
@export var toggle_mode: bool
@export var button_pressed: bool
# Action Mode?
@export var keep_pressed_outside: bool

@export_category("Theme")
@export var stylebox_normal: StyleBox
@export var stylebox_pressed: StyleBox
@export var stylebox_disabled: StyleBox

var _is_being_pressed: bool = false


func _ready() -> void:
	item_rect_changed.connect(queue_redraw)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		_is_being_pressed = false
		var bounds := Rect2(Vector2.ZERO, get_rect().size)
		if not (keep_pressed_outside or bounds.has_point(drag.position)):
			_release()
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			_press()
		else:
			_release()


func _press() -> void:
	_is_being_pressed = true
	button_pressed = true
	button_down.emit()
	modulate = Color.RED


func _release() -> void:
	button_up.emit()
	if _is_being_pressed:
		pressed.emit()
	_is_being_pressed = false
	modulate = Color.WHITE
	button_pressed = false


func _draw() -> void:
	# TODO: Take some scaling into account?
	if not stylebox_normal:
		return
	draw_style_box(stylebox_normal, Rect2(Vector2.ZERO, get_rect().size))
