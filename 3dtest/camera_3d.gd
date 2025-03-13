extends Camera3D

@onready var player = %ballocks

func _physics_process(delta: float) -> void:
	position.z = %ballocks.global_position.z + 5
	position.y = %ballocks.global_position.y + 1
	position.x = %ballocks.global_position.x
	pass
