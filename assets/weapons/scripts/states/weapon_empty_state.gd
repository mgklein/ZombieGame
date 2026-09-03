extends WeaponState


func _on_empty_state_entered() -> void:
	print("Out of axes!")

func _on_empty_state_processing(delta: float) -> void:
	# Could check for reload input here
	pass
