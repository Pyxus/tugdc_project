extends Camera
## docstring

#signals

#enums

#constants

#preloaded scripts and scenes

export var target: NodePath

#public variables

#private variables

onready var _target: Spatial = get_node(target)
onready var tween: Tween = Tween.new()


#optional built-in virtual _init method

func _ready() -> void:
	add_child(tween)

func _process(delta: float) -> void:
	if global_transform != _target.global_transform:
		tween.interpolate_property(self, "global_transform", global_transform, _target.global_transform, .08)
		tween.start()
	#global_transform = _target.global_transform

#public methods

#private methods

#signal methods

#inner classes
