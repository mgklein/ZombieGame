extends WeaponState


func _on_charging_state_processing(delta: float) -> void:
	if not weapon_controller:
		return
	
	weapon_controller.current_weapon.current_projectile_speed = \
			min(weapon_controller.current_weapon.max_projectile_speed,
			weapon_controller.current_weapon.current_projectile_speed + 0.1)
	
	if Global.game_controller.current_hud and Global.game_controller.current_hud is UserInterface:
		Global.game_controller.current_hud.charge_level = (
				(weapon_controller.current_weapon.current_projectile_speed-weapon_controller.current_weapon.min_projectile_speed) / 
				(weapon_controller.current_weapon.max_projectile_speed-weapon_controller.current_weapon.min_projectile_speed)
		)
	
	if Input.is_action_just_released("fire"):
		weapon_controller.weapon_state_chart.send_event("onFiring")
		return
