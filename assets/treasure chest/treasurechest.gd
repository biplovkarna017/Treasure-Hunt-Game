extends Spatial



onready var treasure_anim = $AnimationPlayer
onready var timer = $Timer
func _ready():
	treasure_anim.stop()
remote func _gameOver():
	if Global.player1.ends_with("guard.tscn"):
		get_tree().change_scene("res://guard_loose.tscn")
	else:
		get_tree().change_scene("res://thief_loose2.tscn")
	get_node("/root/Level").free()
func _on_Timer_timeout():
	rpc("_gameOver")
	if Global.player1.ends_with("guard.tscn"):
		get_tree().change_scene("res://UI/guard_win2.tscn")
	else:
		get_tree().change_scene("res://UI/thief_win.tscn")
	timer.stop()
	get_node("/root/Level").free()


func _on_treasurechest_body_entered(body):
		treasure_anim.play("treasureAnim")
		timer.set_wait_time(2)
		timer.start()
