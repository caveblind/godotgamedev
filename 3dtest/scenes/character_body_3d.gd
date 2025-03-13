extends CharacterBody3D

const SPEED = 5.0
const ROLL_SPEED = 3.0  # Adjusted for better physics-based rolling
const BALL_RADIUS = 1.0  # Set this to your actual ball's collision radius

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO  # Movement direction

	if not is_on_floor():
		velocity += get_gravity() * delta * 5 # Apply gravity

	if Input.is_key_pressed(KEY_W):
		direction.z -= .1
	if Input.is_key_pressed(KEY_S):
		direction.z += .1
	if Input.is_key_pressed(KEY_A):
		direction.x -= .1
	if Input.is_key_pressed(KEY_D):
		direction.x += .1
	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		direction.y = 5
		print("Space!")

	direction = direction.normalized()  # Prevent diagonal movement being faster
	
	# Apply acceleration instead of instant velocity override
	velocity.x = lerp(velocity.x, direction.x * SPEED, 0.1)
	velocity.z = lerp(velocity.z, direction.z * SPEED, 0.1)
	velocity.y = lerp(velocity.y, direction.y * SPEED*33, 0.1)

	move_and_slide()  # Apply movement

	# --- Rolling Motion ---
	var displacement = velocity * delta  # How far the ball moved this frame
	var distance = displacement.length()  # Total movement distance

	if distance > 0:
		var roll_angle = (distance / BALL_RADIUS)  # Angle in radians
		var roll_axis = Vector3(velocity.z, 0, -velocity.x).normalized()  # Perpendicular to movement
		rotate(roll_axis, roll_angle)  # Apply rotation
