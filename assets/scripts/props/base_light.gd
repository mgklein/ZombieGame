@tool
extends OmniLight3D

@export var turn_on_group: int = 0
@export var turn_off_group: int = 1

var level: Node3D

func _ready():
	add_to_group("Lights")
	level = get_owner()
	randomize() # renew rng seed for random enemy spawning
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.spawn_enemies.connect(_on_player_controller_spawn_enemies)
	else:
		push_warning("Spawn point could not locate player group.")
	if turn_on_group > 0:
		light_energy = 0

func _func_godot_apply_properties(entity_properties: Dictionary) -> void:
	turn_on_group = entity_properties["turn_on_group"] as int
	turn_off_group = entity_properties["turn_off_group"] as int

func _func_godot_build_complete():
	omni_attenuation = 0.25
	omni_range = 7
	add_to_group("Lights")
	var new_parent = get_parent().get_child(0)
	reparent(new_parent)

func change_light_color():
	light_color = Color(1,.3,.3)

func _on_player_controller_spawn_enemies(spawn_group: int) -> void:
	if turn_on_group == spawn_group:
		light_energy = 1
	if turn_off_group == spawn_group:
		light_energy = 0
