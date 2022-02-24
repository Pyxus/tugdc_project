class_name Math
extends Object

func _init() -> void:
	assert(true, "Math class is pseudo-abstract and should bnot be instanced.")
	

static func calc_jump_motion(apex: float, time_until_apex: float, time_until_land: float, is_3d: bool = false) -> Dictionary:
	var jump_veloicty := (-2.0 * apex) / time_until_apex
	var jump_gravity := (2.0 * apex) / (time_until_apex * time_until_apex)
	var fall_gravity := (2.0 * apex) / (time_until_land * time_until_land)
	
	if is_3d:
		jump_veloicty *= -1
		jump_gravity *= -1
		fall_gravity *= -1
	
	return {"jump_velocity" : jump_veloicty, "jump_gravity" : jump_gravity, "fall_gravity" : fall_gravity}
