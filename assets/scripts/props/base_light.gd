@tool
extends OmniLight3D

func _ready():
	add_to_group("Lights")

func _func_godot_build_complete():
	omni_attenuation = 0.25
	omni_range = 7
	add_to_group("Lights")
	var new_parent = get_parent().get_child(0)
	reparent(new_parent)

func change_light_color():
	light_color = Color(1,.3,.3)
