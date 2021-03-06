class_name KinematicPathFollower
extends KinematicBody
## docstring

#signals

#enums

#constants

#preloaded scripts and scenes

export var path_to_follow: NodePath setget set_path_to_follow

#public variables

var _path_to_follow: Path
var _path_follow := PathFollow.new()

#onready variables


#optional built-in virtual _init method

func _ready() -> void:
	set_path_to_follow(path_to_follow)
	var curve := _path_to_follow.curve
	var last_point_idx := curve.get_point_count() - 1
	
	_path_follow.loop = curve.get_point_position(0).is_equal_approx(curve.get_point_position(last_point_idx))
	_path_follow.rotation_mode = PathFollow.ROTATION_ORIENTED

#remaining built-in virtual methods

func get_path_velocity(offset_increment: float, delta: float) -> Vector2:
	if _path_follow != null:
		_path_follow.offset = _path_to_follow.curve.get_closest_offset(translation)
		_path_follow.offset += offset_increment
		var path_translation = (_path_follow.translation - translation) / delta 
		return Vector2(path_translation.x, path_translation.z)
	else:
		push_warning("Failed to get path velocity. Travel path may not be set.")
	return Vector2.ZERO


func set_path_to_follow(value: NodePath) -> void:
	path_to_follow = value
	
	if is_inside_tree():
		var path_node = get_node(value)
		_path_to_follow = path_node
		
		if path_node != null:
			assert(path_node is Path, "Path to follow must be of type Path.")
			if is_instance_valid(_path_follow):
				_path_follow.queue_free()
				
			_path_follow = PathFollow.new()
			path_node.add_child(_path_follow)


#private methods

#signal methods

#inner classes
