extends CanvasLayer

var pause_menu_shown = false
signal on_reset

func _ready() -> void:
	$Kitten.hide()
	$QuickMenu.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if pause_menu_shown:
			hide_menu()
		else:
			show_menu()

func show_menu():
	$QuickMenu.show()
	pause_menu_shown = true
	get_tree().paused = true
	
func hide_menu():
	$QuickMenu.hide()
	pause_menu_shown = false
	get_tree().paused = false

func _on_resume_button_pressed() -> void:
	hide_menu()

func _on_reset_button_pressed() -> void:
	hide_menu()
	on_reset.emit()

func _on_quit_button_pressed() -> void:
	hide_menu()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
