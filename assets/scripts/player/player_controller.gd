class_name PlayerController extends CharacterBody3D

@export var path_controller : PathFollow3D
@export var duration: float = 4.0 # Time in seconds to complete a path movement
@export var num_stop_positions = 5
var position_index: int = 0

signal spawn_enemies(spawn_group: int)


#func _ready() -> void:
	#await get_tree().process_frame
	#var spawners = get_tree().get_nodes_in_group("spawners")
	#for spawner in spawners:
		#if spawner.has_method("_on_player_controller_spawn_enemies"):
			#self.spawn_enemies.connect(spawner._on_player_controller_spawn_enemies)
func _ready() -> void:
	spawn_enemies.emit(0)


func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)


func get_target_progress():
	return min((1.0 / num_stop_positions) * position_index, 1.0)


func move_along_path_smoothly(target_ratio: float) -> void:	
	# Create the tween
	var tween = create_tween()
	
	# Set transition type to SINE, QUAD, or CUBIC for smooth easing
	tween.set_trans(Tween.TRANS_SINE)
	# Set ease type to EASE_IN_OUT (accelerate then decelerate)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Animate the progress_ratio from current ratio to target ratio
	tween.tween_property(path_controller, "progress_ratio", target_ratio, duration)


func move_player():
	position_index = min(position_index + 1, num_stop_positions)
	print("moving to " + str(position_index))
	move_along_path_smoothly(get_target_progress())
	await get_tree().create_timer(duration).timeout
	spawn_enemies.emit(position_index)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_move"):
		move_player()
