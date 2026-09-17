extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_level_button_pressed() -> void:
	Global.game_controller.current_menu.visible = false
	Global.game_controller.change_level_scene("res://levels/prototype_level.tscn")
	Global.game_controller.change_hud_scene("res://scenes/ui/user_interface.tscn")


func _on_level_button_2_pressed() -> void:
	Global.game_controller.current_menu.visible = false
	Global.game_controller.change_level_scene("res://levels/prototype_level_matt.tscn")
	Global.game_controller.change_hud_scene("res://scenes/ui/user_interface.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
