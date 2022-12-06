extends Node



	


func _on_Home_pressed():
	if is_network_master():
		print("I am host")
		get_tree().set_network_peer(null)
	get_tree().change_scene("res://UI/Main.tscn")
