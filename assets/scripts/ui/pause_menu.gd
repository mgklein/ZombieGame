extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_main_menu_button_pressed() -> void:
	Global.game_controller.change_menu_scene("res://scenes/system/main_menu.tscn")
	Global.game_controller.current_level.queue_free()
	Global.game_controller.current_hud.queue_free()
	get_tree().paused = false


func _on_restart_pressed() -> void:
	Global.game_controller.current_hud.visible = true
	Global.game_controller.current_menu.visible = false
	Global.game_controller.current_level.queue_free()
	get_tree().paused = false
	await get_tree().process_frame
	await get_tree().physics_frame
	Global.game_controller.change_level_scene("res://levels/prototype_level_matt.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_resume_pressed() -> void:
	Global.game_controller.current_hud.visible = true
	Global.game_controller.current_menu.visible = false
	get_tree().paused = false
