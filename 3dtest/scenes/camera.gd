extends Camera3D

@onready var gimbal = get_parent()

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_UP):
		gimbal.rotation.x -= 0.1
	if Input.is_key_pressed(KEY_DOWN):
		gimbal.rotation.x += 0.1
	if Input.is_key_pressed(KEY_LEFT):
		gimbal.rotation.y += 0.1
	if Input.is_key_pressed(KEY_RIGHT):
		gimbal.rotation.y -= 0.1
		
 
	# Clamp vertical rotation (x-axis)
	if Input.is_key_pressed((KEY_Z)):
		position += Vector3(0,.05,.05)
	if Input.is_key_pressed((KEY_X)):
		position -= Vector3(0,.05,.05)
