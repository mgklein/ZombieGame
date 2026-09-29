extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_all_lights_red():
	var all_light_nodes = get_tree().get_nodes_in_group("Lights")
	var first_light = get_tree().get_first_node_in_group("Lights")
	get_tree().call_group("Lights","change_light_color")
	print(get_tree().get_node_count_in_group("Lights"))
	print(first_light)
	for i in all_light_nodes:
		i.change_light_color()
	var player_node = get_tree().get_first_node_in_group("player")
	if player_node != null:
		player_node.spawn_enemies.emit(0)
