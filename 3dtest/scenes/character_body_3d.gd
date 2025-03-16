extends CharacterBody3D

const SPEED = 5.0
const ROLL_SPEED = 3.0
const BALL_RADIUS = 1.0


@onready var ball_mesh = $sphere
@onready var camera = $pivot

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	var moving : bool = false

	if Input.is_key_pressed(KEY_W):
		direction = -camera.transform.basis.z.normalized() * Vector3(1,0,1) #getting the normalized 'transformation' info (angle and position of camera) and set the forward direction to a 3D Vector representation 
		moving = true
	if Input.is_key_pressed(KEY_S):
		direction = camera.transform.basis.z.normalized()* Vector3(1,0,1)
		moving = true
	if Input.is_key_pressed(KEY_A):
		direction = -camera.transform.basis.x.normalized()
		moving = true
	if Input.is_key_pressed(KEY_D):
		direction = camera.transform.basis.x.normalized()
		moving = true
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor_only():
		velocity = Vector3(0,10,0)

		print("Space!")

	if not is_on_floor():
		if is_on_wall_only():
			var lastSlide = get_last_slide_collision().get_normal()
			if moving:
				velocity += Vector3(lastSlide.x,-abs(lastSlide.y),lastSlide.z) * delta * 5 #While traveling up a slope
				print(moving)
			else:
				velocity += Vector3(lastSlide.x,-abs(lastSlide.y),lastSlide.z) * delta * 30 #Accelerating down
				print("accelerating down")
			print(velocity)
		else:
			velocity += get_gravity() * delta * 3 # Apply gravity    

	direction = direction.normalized()

	
	velocity.x = lerp(velocity.x, direction.x * SPEED, 0.1)
	velocity.z = lerp(velocity.z, direction.z * SPEED, 0.1)

	move_and_slide()

	# Only rotate the ball mesh, not the entire character body
	var displacement = velocity * delta
	var distance = displacement.length()

	if distance > 0:
		var roll_angle = (distance / BALL_RADIUS)
		var roll_axis = Vector3(velocity.z, 0, -velocity.x).normalized()
		if roll_axis.length() > 0:
			ball_mesh.rotate(roll_axis, roll_angle)  # rotate the mesh
