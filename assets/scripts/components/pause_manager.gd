extends Node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and not Global.game_controller.current_menu.visible:
		Global.game_controller.change_menu_scene("res://scenes/system/pause_menu.tscn")
		Global.game_controller.current_menu.visible = true
		Global.game_controller.current_hud.visible = false
