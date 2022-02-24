extends KinematicBody
## docstring

#signals

#enums

#constants

#preloaded scripts and scenes

export var travel_path: NodePath setget set_travel_path

#public variables

var _velocity: Vector3
var _travel_path: Path
var _path_follow := PathFollow.new()

#onready variables


#optional built-in virtual _init method

#built-in virtual _ready method

#remaining built-in virtual methods

func move_along_path(increment: float, delta: float) -> void:
	if _path_follow.is_inside_tree():
		_path_follow.offset = _travel_path.curve.get_closest_offset(translation)
		_path_follow.offset += increment
		
	var path_translation = (_path_follow.translation - translation) / delta
	rotation = _path_follow.rotation
	_velocity.x = path_translation.x
	_velocity.z = path_translation.z


func set_travel_path(value: NodePath) -> void:
	var path_node = get_node_or_null(value)
	_travel_path = path_node
	
	if path_node != null:
		assert(path_node is Path, "Travel path must be of type Path.")
		if _path_follow.is_inside_tree():
			_path_follow.get_parent().remove_child(_path_follow)
		path_node.add_child(_path_follow)
		travel_path = value
		return


#private methods

#signal methods

#inner classes
