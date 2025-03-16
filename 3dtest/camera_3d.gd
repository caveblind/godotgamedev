extends Camera3D

@onready var player = %ballocks

func _physics_process(delta: float) -> void:
        # Example: Follow player and maintain a fixed offset
	var target_position = player.position + Vector3(0, 2.5, 0) # Adjust offset values as needed
	position = position.lerp(target_position, 0.1)  # Adjust 0.1 for smoother/faster follow

	if Input.is_key_pressed(KEY_UP):
		rotation.x -= .1
	if Input.is_key_pressed(KEY_DOWN):
		rotation.x += .1
	if Input.is_key_pressed(KEY_LEFT):
		rotation.y += .1
	if Input.is_key_pressed(KEY_RIGHT):
		rotation.y -= .1
	pass
