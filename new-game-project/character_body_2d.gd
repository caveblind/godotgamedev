extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Ping pong physics variables
var bounce_cooldown = 0.0
var bounce_state = false
var bounce_direction = Vector2.ZERO
var bounce_force = 300.0
var MIN_BOUNCE_FORCE = 300.0
var MAX_BOUNCE_FORCE = 800.0
var ping_pong_targets = []
var last_hit_target = null
var combo_count = 0
var max_combo_time = 2.0
var combo_timer = 0.0

# Signals
signal hit_target(target, combo_count)

func _ready():
    # Get all ping pong targets in the scene
    ping_pong_targets = get_tree().get_nodes_in_group("ping_pong_target")

func _physics_process(delta: float) -> void:
    # Handle combo timer
    if combo_timer > 0:
        combo_timer -= delta
        if combo_timer <= 0:
            combo_count = 0
    
    # Handle bounce cooldown
    if bounce_cooldown > 0:
        bounce_cooldown -= delta
    
    # When in bounce state, override normal controls
    if bounce_state:
        velocity = bounce_direction * bounce_force
        bounce_force *= 0.98  # Gradually reduce bounce force
        
        # End bounce state if force gets too low
        if bounce_force < MIN_BOUNCE_FORCE * 0.5:
            bounce_state = false
    else:
        # Normal movement physics when not in bounce mode
        # Add the gravity.
        if not is_on_floor():
            velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity", 980.0) * delta
        
        # Handle jump.
        if Input.is_action_just_pressed("ui_accept") and is_on_floor():
            velocity.y = JUMP_VELOCITY
        
        # Get the input direction and handle the movement/deceleration.
        # As good practice, you should replace UI actions with custom gameplay actions.
        var direction := Input.get_axis("ui_left", "ui_right")
        if direction:
            velocity.x = direction * SPEED
        else:
            velocity.x = move_toward(velocity.x, 0, SPEED)
    
    # Check for collisions with ping pong targets
    check_ping_pong_collisions()
    
    # Handle screen boundaries
    var screen_size = DisplayServer.window_get_size()
    if position.x <= 0:
        position.x = 0
        if bounce_state:
            bounce_direction.x = abs(bounce_direction.x)
    elif position.x >= screen_size.x:
        position.x = screen_size.x
        if bounce_state:
            bounce_direction.x = -abs(bounce_direction.x)
    
    if position.y <= 0:
        position.y = 0
        if bounce_state:
            bounce_direction.y = abs(bounce_direction.y)
    elif position.y >= screen_size.y:
        position.y = screen_size.y
        if bounce_state:
            bounce_direction.y = -abs(bounce_direction.y)
    
    move_and_slide()
    
    # If we hit something during movement and we're in bounce state
    if get_slide_collision_count() > 0 and bounce_state:
        var collision_normal = get_slide_collision(0).get_normal()
        bounce_direction = bounce_direction.bounce(collision_normal)
        
        # Reduce bounce force slightly on each surface hit
        bounce_force *= 0.9

func check_ping_pong_collisions():
    if bounce_cooldown <= 0:
        for target in ping_pong_targets:
            # Simple distance check - replace with your preferred collision detection
            if global_position.distance_to(target.global_position) < 50:  # Adjust radius as needed
                # Don't hit the same target twice in a row
                if target != last_hit_target:
                    hit_ping_pong_target(target)
                    return

func hit_ping_pong_target(target):
    # Direction from target to player (for bounce)
    var dir = (global_position - target.global_position).normalized()
    
    # Start bounce mode
    bounce_state = true
    bounce_cooldown = 0.5  # Prevent multiple hits on same target
    
    # Calculate bounce direction and force
    bounce_direction = dir.rotated(randf_range(-0.5, 0.5))  # Add some randomness
    
    # Increase bounce force with each hit in a combo
    combo_count += 1
    combo_timer = max_combo_time
    bounce_force = min(MIN_BOUNCE_FORCE + (combo_count * 50), MAX_BOUNCE_FORCE)
    
    # Store last hit target
    last_hit_target = target
    
    # Trigger target hit effect - this method will be called on the target
    # but we don't require it to exist
    if target.has_method("hit"):
        target.hit(bounce_direction, combo_count)
    
    # Emit signal for game to handle scoring, etc.
    emit_signal("hit_target", target, combo_count)

# Call this function to manually trigger the ping pong mode (e.g., from powerups)
func trigger_ping_pong_mode(direction: Vector2, force: float):
    bounce_state = true
    bounce_direction = direction.normalized()
    bounce_force = force
    combo_count = 0
    combo_timer = max_combo_time