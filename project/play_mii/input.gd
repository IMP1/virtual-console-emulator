class_name Inputs
extends Node

enum {
	UP = 1,
	DOWN = 2,
	LEFT = 3,
	RIGHT = 4,
	A = 5,
	B = 6,
	MENU = 7,
	ALT = 8,
}

enum {
	WHEEL = 15,
}

var _key_states: Dictionary[int, bool]
var _axis_1d_states: Dictionary[int, float]
var _axis_2d_states: Dictionary[int, Vector2]
var _axis_3d_states: Dictionary[int, Vector3]

var _last_frame_key_states: Dictionary[int, bool]
var _axis_1d_change: Dictionary[int, float]
var _axis_2d_change: Dictionary[int, Vector2]
var _axis_3d_change: Dictionary[int, Vector3]

# TODO: Somehow connect emulator input groups to this.

# TODO: Think about how the wheel will work/be queried
# SEE: https://sdk.play.date/3.0.3/Inside%20Playdate.html#crank


func setup() -> void:
	pass


func clear() -> void:
	_last_frame_key_states.clear()
	_axis_1d_change.clear()
	_axis_2d_change.clear()
	_axis_3d_change.clear()


func is_pressed(key: int) -> bool:
	return _key_states.get(key, false)


func was_just_pressed(key: int) -> bool:
	return _last_frame_key_states.get(key, false)


func get_axis_1d(key: int) -> float:
	return _axis_1d_states.get(key, 0.0)


func get_axis_2d(key: int) -> float:
	return _axis_2d_states.get(key, Vector2.ZERO)


func get_axis_3d(key: int) -> float:
	return _axis_3d_states.get(key, Vector3.ZERO)
