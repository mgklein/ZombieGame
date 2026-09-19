extends WeaponState

#var lockout_timer: Timer = Timer.new()
var lockout = false

func _on_firing_state_entered() -> void:
	if not weapon_controller:
		return
	
	# Fire immediately on state entry
	weapon_controller.fire_weapon()
	weapon_controller.current_weapon.current_projectile_speed = \
			weapon_controller.current_weapon.min_projectile_speed
	if Global.game_controller.current_hud and Global.game_controller.current_hud is UserInterface:
		Global.game_controller.current_hud.charge_level = 0.0
	#lockout_timer.one_shot = true
	#lockout_timer.wait_time = 2.0
	#lockout_timer.start()
	lockout = true
	await get_tree().create_timer(2.5).timeout
	lockout = false


func _on_firing_state_physics_processing(delta: float) -> void:
	if not weapon_controller:
		return
	
	# Check if ammo is empty
	if weapon_controller.current_ammo <= 0 and not lockout:
		weapon_controller.weapon_state_chart.send_event("onEmpty")
		return
	
	# Return to idle after firing
	if not lockout:
		weapon_controller.weapon_state_chart.send_event("onIdle")
