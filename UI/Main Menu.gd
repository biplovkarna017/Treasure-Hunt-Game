extends CanvasLayer




func _on_play_pressed():
	get_tree().change_scene("res://Network_setup.tscn")


func _on_quit_pressed():
	get_tree().quit()
