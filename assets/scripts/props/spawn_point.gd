class_name SpawnPoint extends Node3D

@export var num_to_spawn: int = 3
@export var min_spawn_delay: float = 5.0 # in seconds
@export var max_spawn_delay: float = 10.0 # in seconds
@export var spawn_group_num: int = 1
@export var enemy_type: PackedScene

@onready var debug_sphere: MeshInstance3D = $DebugSphere

var level: Node3D
var done_spawning: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_sphere.visible = false
	level = self.get_parent()
	add_to_group("spawner" + str(spawn_group_num))
	randomize() # renew rng seed for random enemy spawning
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.spawn_enemies.connect(_on_player_controller_spawn_enemies)
	else:
		push_warning("Spawn point could not locate player group.")


func _on_player_controller_spawn_enemies(spawn_group: int) -> void:
	if spawn_group_num == spawn_group:
		for i in range(num_to_spawn):
			var new_enemy = enemy_type.instantiate()
			new_enemy.position = self.position
			level.add_child(new_enemy)
			await get_tree().create_timer(randf_range(min_spawn_delay, max_spawn_delay)).timeout
		done_spawning = true
