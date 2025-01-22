extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W) and position.y > 50:
		print(position.x)
		position.y -= 5
	if Input.is_key_pressed(KEY_S)and position.y <DisplayServer.window_get_size().y - 50:
		position.y += 5
	if Input.is_key_pressed(KEY_A) and position.x > 50:
		position.x-= 5
	if Input.is_key_pressed(KEY_D)and position.x <DisplayServer.window_get_size().x -50 :
		position.x += 5
	pass
