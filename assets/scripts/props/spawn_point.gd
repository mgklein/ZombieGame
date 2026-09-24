@tool
class_name SpawnPoint extends Node3D



@export var num_to_spawn: int = 3
@export var min_spawn_delay: float = 5.0 # in seconds
@export var max_spawn_delay: float = 10.0 # in seconds
@export var spawn_group_str: String = "Enemy1"
@export var enemy_type: PackedScene


var level: Node3D
#const ENEMY_SCENE: PackedScene = preload("res://scenes/enemies/simple_enemy.tscn")

func _func_godot_apply_properties(entity_properties: Dictionary) -> void:
	num_to_spawn = entity_properties["num_to_spawn"] as int
	min_spawn_delay = entity_properties["min_spawn_delay"] as float
	max_spawn_delay = entity_properties["max_spawn_delay"] as float
	spawn_group_str = entity_properties["spawn_group_str"] as String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#debug_sphere.visible = false
	enemy_type = preload("res://scenes/enemies/gb-simple_enemy.tscn")
	level = self.get_parent()
	randomize() # renew rng seed for random enemy spawning
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.spawn_enemies.connect(_on_player_controller_spawn_enemies)
	else:
		push_warning("Spawn point could not locate player group.")


func _on_player_controller_spawn_enemies(spawn_group: int) -> void:
	if spawn_group_str == "Enemy" + str(spawn_group):
		for i in range(num_to_spawn):
			await get_tree().create_timer(randf_range(min_spawn_delay, max_spawn_delay)).timeout
			var new_enemy = enemy_type.instantiate()
			new_enemy.position = self.position
			level.add_child(new_enemy)
