tool
extends Spatial
## docstring

#signals

#enums

#constants

#preloaded scripts and scenes

export var zoom: float
export var target: NodePath
export var orientation: Vector3
export var tracking_orientation: Vector3

#private variables

onready var _inner_gimbal: Spatial = get_node("InnerGimbal")
onready var _camera: Camera = get_node("InnerGimbal/Camera")
onready var _target: Spatial = get_node(target)
onready var _tween: Tween = Tween.new()

#optional built-in virtual _init method

func _ready() -> void:
	add_child(_tween)


func _process(delta: float) -> void:
	_update()
	
	if _target != null:
		var orient_y := rad2deg(lerp_angle(deg2rad(orientation.y), deg2rad(_target.rotation_degrees.y - tracking_orientation.y), 1))
		var orient_x := rad2deg(lerp_angle(deg2rad(orientation.x), deg2rad(_target.rotation_degrees.x - tracking_orientation.x), 1))
		var orient_z := rad2deg(lerp_angle(deg2rad(orientation.z), deg2rad(_target.rotation_degrees.z - tracking_orientation.z), 1))
		
		_tween.interpolate_property(self, "orientation:y", orientation.y, orient_y, .15)
		_tween.interpolate_property(self, "orientation:x", orientation.x, orient_x, .15)
		_tween.interpolate_property(self, "orientation:z", orientation.z, orient_z, .15)
		_tween.interpolate_property(self, "translation", translation, _target.translation, .08)
		
		_tween.start()


func _update() -> void:
	rotation.y = wrapf(deg2rad(orientation.y), -360, 360)
	
	if _inner_gimbal != null:
		_inner_gimbal.rotation.x = wrapf(deg2rad(orientation.x), -360, 360)
		
	if _camera != null:
		_camera.rotation.z = wrapf(deg2rad(orientation.z), -360, 360)
		_camera.translation.z = zoom

#signal methods

#inner classes
