extends WeaponState


func _on_empty_state_entered() -> void:
	print("Out of axes!")

func _on_empty_state_processing(delta: float) -> void:
	weapon_controller.current_ammo = weapon_controller.current_weapon.max_ammo
	weapon_controller.weapon_state_chart.send_event("onIdle")
