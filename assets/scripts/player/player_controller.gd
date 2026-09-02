class_name PlayerController extends CharacterBody3D

@export var path_controller : PathFollow3D
#@export var acceleration : float = 0.01
var _target_progress : float = 0.0

func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_move"):
		_target_progress = path_controller.progress_ratio + 0.2
	
	path_controller.progress_ratio = lerp(path_controller.progress_ratio, _target_progress, delta)
