class_name GenisysEnemy
extends CharacterBody3D

@export var enemy_groups: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for group in enemy_groups:
		add_to_group(group)


func on_triggered() -> void:
	# Override in child classes
	pass
