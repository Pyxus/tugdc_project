tool
extends Spatial
## docstring

#signals

#enums

#constants

#preloaded scripts and scenes

export var orientation: Vector3
export var zoom: float
export var target: NodePath setget set_target

var tracking_orientation: Vector3
var is_tracking: bool = true
var tween_duration: float = .15
var tween_delay: float = 0

var _camera: Camera
var _yaw_axis := Spatial.new()
var _roll_axis := Spatial.new()
var _camera_position := Spatial.new()
var _tween: Tween = Tween.new()

onready var _target: Spatial = get_node(target)

#optional built-in virtual _init method

func _ready() -> void:
	add_child(_tween)
	add_child(_yaw_axis)
	_yaw_axis.add_child(_roll_axis)
	_roll_axis.add_child(_camera_position)
	
	
	get_tree().connect("node_added", self, "_on_SceneTree_node_added")
	get_tree().connect("node_removed", self, "_on_SceneTree_node_removed")
	
	for child in get_children():
		if child is Camera:
			_camera = child
			break


func _process(_delta: float) -> void:
	_update()
	
	if _target != null and is_tracking:
		var orient_y := rad2deg(lerp_angle(deg2rad(orientation.y), deg2rad(_target.rotation_degrees.y - tracking_orientation.y), 1))
		var orient_x := rad2deg(lerp_angle(deg2rad(orientation.x), deg2rad(_target.rotation_degrees.x - tracking_orientation.x), 1))
		var orient_z := rad2deg(lerp_angle(deg2rad(orientation.z), deg2rad(_target.rotation_degrees.z - tracking_orientation.z), 1))
		
		_tween.interpolate_property(self, "orientation:y", orientation.y, orient_y, tween_duration, 0, 2, tween_delay)
		_tween.interpolate_property(self, "orientation:x", orientation.x, orient_x, tween_duration, 0, 2, tween_delay)
		_tween.interpolate_property(self, "orientation:z", orientation.z, orient_z, tween_duration, 0, 2, tween_delay)
		_tween.interpolate_property(self, "translation", translation, _target.translation, tween_duration, 0, 2, tween_delay)
		
		_tween.start()


func _get_property_list() -> Array:
	var properties: Array = []

	if not target.is_empty():
		properties.append({
			name = "target_tracking/is_tracking",
			type = TYPE_BOOL
		})
		
		properties.append({
			name = "target_tracking/track_orientation",
			type = TYPE_VECTOR3,
		})
		
		properties.append({
			name = "target_tracking/tween_duration",
			type = TYPE_REAL,
		})
	
		properties.append({
			name = "target_tracking//tween_delay",
			type = TYPE_REAL,
		})
		
	return properties


func _set(property: String, value) -> bool:
	match property:
		"target_tracking/is_tracking":
			is_tracking = value
		"target_tracking/track_orientation":
			tracking_orientation = value
		"target_tracking/tween_duration":
			tween_duration = value
		"target_tracking//tween_delay":
			tween_delay = value
		_:
			return false
	
	property_list_changed_notify()
	return true
	
	
func _get(property: String):
	match property:
		"target_tracking/is_tracking":
			return is_tracking
		"target_tracking/track_orientation":
			return tracking_orientation
		"target_tracking/tween_duration":
			return tween_duration
		"target_tracking//tween_delay":
			return tween_delay
	return null


func _get_configuration_warning() -> String:
	for child in get_children():
		if child is Camera:
			return ""

	return "No camera added as child."


func set_target(value: NodePath) -> void:
	target = value
	property_list_changed_notify()


func _update() -> void:
	rotation.y = deg2rad(orientation.y)
	
	if _roll_axis != null:
		_roll_axis.rotation.z = deg2rad(orientation.z)
	
	if _yaw_axis != null:
		_yaw_axis.rotation.x = deg2rad(orientation.x)
		
	if _camera_position != null:
		_camera_position.translation.z = zoom
	
		if _camera != null:
			if not _camera.is_set_as_toplevel():
				_camera.set_as_toplevel(true)
				
			_camera.global_transform = _camera_position.global_transform


func _on_SceneTree_node_added(node: Node) -> void:
	if node.get_parent() == self and node is Camera:
		_camera = node


func _on_SceneTree_node_removed(node: Node) -> void:
	if node.get_parent() == self and node == _camera:
		_camera = null
#inner classes
