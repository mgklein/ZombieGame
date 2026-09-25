@tool
extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _func_godot_build_complete():
	var new_parent = get_parent().get_child(0)
	reparent(new_parent)
