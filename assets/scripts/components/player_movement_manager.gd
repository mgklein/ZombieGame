extends Node

@onready var player_controller: PlayerController = $"../MovementPath/PathController/PlayerController"

var is_moving: bool = false
var current_spawn_group: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemy_count = get_children_of_type(get_parent(), GenisysEnemy).size()
	
	var spawners = get_tree().get_nodes_in_group("spawner" + str(current_spawn_group))
	var active_spawners = spawners.size()
	for spawner in spawners:
		if spawner.done_spawning:
			active_spawners -= 1
	if enemy_count == 0 and active_spawners ==0 and not is_moving:
		is_moving = true
		await player_controller.move_player()
		is_moving = false
		current_spawn_group += 1


func get_children_of_type(parent: Node, target_type) -> Array[Node]:
	var matched_children: Array[Node] = []
	for child in parent.get_children():
		if is_instance_of(child, target_type):
			matched_children.append(child)
	return matched_children
