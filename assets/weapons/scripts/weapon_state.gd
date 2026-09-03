class_name WeaponState extends Node

var weapon_controller: WeaponController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if %WeaponStateMachine and %WeaponStateMachine is WeaponStateMachine:
		weapon_controller = %WeaponStateMachine.weapon_controller
