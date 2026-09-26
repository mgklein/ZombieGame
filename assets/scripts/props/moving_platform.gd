@tool
class_name MovingPlatform extends AnimatableBody3D

@export var move_distance: float = 2.0
@export var move_time: float = 2.0
@export var move_direction: Vector3 = Vector3(0,1,0)
@export var func_godot_properties: Dictionary

var start_position: Vector3
var end_position: Vector3
var platform_tween: Tween

func _func_godot_apply_properties(entity_properties: Dictionary) -> void:
	move_distance = entity_properties["move_distance"] as float
	move_time = entity_properties["move_time"] as float
	move_direction = entity_properties["move_direction"] as Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		start_position = global_position
		end_position = start_position + (move_direction.normalized() * move_distance)
		_start_movement()

func _start_movement() -> void:
	platform_tween = create_tween()
	platform_tween.set_loops()
	platform_tween.tween_property(self, "global_position", end_position, move_time)
	platform_tween.tween_property(self, "global_position", start_position, move_time)
