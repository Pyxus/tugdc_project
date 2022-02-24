extends KinematicBody

export var path_follow: NodePath

var velocity: Vector3
var jump_motion = Math.calc_jump_motion(10, .5, .4, true)

onready var _path_follow: PathFollow = get_node(path_follow)

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if _path_follow != null:
		var path: Path = _path_follow.get_parent()
		_path_follow.offset = path.curve.get_closest_offset(translation)
		
		if Input.is_action_pressed("ui_right"):
			_path_follow.offset  += .3
		elif Input.is_action_pressed("ui_left"):
			_path_follow.offset  += -.3
		
		var path_translation = (_path_follow.translation - translation) / delta
		rotation = _path_follow.rotation
		velocity.x = path_translation.x
		velocity.z = path_translation.z
		
		var gravity = jump_motion.fall_gravity if velocity.y > 0 else jump_motion.jump_gravity
		velocity.y += gravity * delta
		
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = jump_motion.jump_velocity
			
	velocity = move_and_slide(velocity)
