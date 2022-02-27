extends KinematicPathFollower

var velocity: Vector3
var jump_motion = Math.calc_jump_motion(10, .5, .4, true)

func _ready() -> void:
	#_path_follow.rotation_mode = PathFollow.ROTATION_ORIENTED
	#_path_follow.loop = false
	pass


func _physics_process(delta: float) -> void:
	if _path_follow != null:
		var offset_increment: float = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		var path_velocity := get_path_velocity(offset_increment * .3, delta)
		
		if sign(offset_increment) == 1:
			$CSGMesh.scale.x = 1
		elif sign(offset_increment) == -1:
			$CSGMesh.scale.x = -1
		velocity.x = path_velocity.x
		velocity.z = path_velocity.y
		
	var gravity = jump_motion.fall_gravity if velocity.y > 0 else jump_motion.jump_gravity
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_motion.jump_velocity
	
	rotation = _path_follow.rotation
	
	velocity = move_and_slide(velocity)
