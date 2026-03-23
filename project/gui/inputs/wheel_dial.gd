class_name WheelDial
extends Control

signal value_changed(delta: float)

const CLICK_ANGLE := 4

@export var angle: float

@onready var _handle := $Dial/Dimple as Control
@onready var _dial := $Dial as Control

# TODO: Remove the requirement for the origin being over the handle? And choose the quickest 
#       rotation to the current angle from the previous angle.


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		var origin := drag.position - drag.relative
		if _is_over_track(drag.position) and _is_over_handle(origin):
			var dial_centre := _dial.size / 2
			angle = dial_centre.angle_to_point(drag.position)
			# TODO: Have there be 'ticks' at certain intervals. How to know if an interval has been crossed?
			#var prev_deg := floori(rad_to_deg(dial.rotation))
			#var new_deg := floori(rad_to_deg(angle))
			#if absi(prev_deg - new_deg) > CLICK_ANGLE:
				#Input.vibrate_handheld(300, 0.4)
				##print("click")
			var change_amount = angle_difference(angle, _dial.rotation)
			_dial.rotation = angle # TODO: Wrap to 0-TAU
			value_changed.emit(change_amount)
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		# TODO: Make sure this wasn't a drag
		if _is_over_handle(touch.position) and not touch.pressed:
			pass
			#print("push")


func _is_over_handle(pos: Vector2) -> bool:
	var handle_radius := _handle.size.x / 2
	var handle_centre_distance := _handle.position.x + handle_radius - (_dial.size.x / 2)
	var handle_position := _dial.size / 2 + (Vector2.RIGHT * handle_centre_distance).rotated(_dial.rotation)
	# TODO: Handle rotation
	return pos.distance_squared_to(handle_position) < handle_radius * handle_radius


func _is_over_track(pos: Vector2) -> bool:
	var dial_centre := _dial.size / 2
	var min_track_radius := _handle.position.x - dial_centre.x
	var max_track_radius := _handle.position.x + _handle.size.x - dial_centre.x
	return pos.distance_squared_to(dial_centre) <= max_track_radius * max_track_radius \
			and pos.distance_squared_to(dial_centre) >= min_track_radius * min_track_radius
