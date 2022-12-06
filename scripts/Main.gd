extends Spatial

var player1
var player2
var next_level_resource 
var next_level
func _ready():
	if Global.player1.ends_with("guard.tscn"):
		player1 = $guard
		player2 = $thief
		$distance2.text = "Thief"
	else:
		player1 = $thief
		player2 = $guard
		$distance2.text = "Guard"
	player1.set_name(str(get_tree().get_network_unique_id()))
	player1.set_network_master(get_tree().get_network_unique_id())
	
	player2.set_name(str(Global.player2id))
	player2.set_network_master(Global.player2id)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	
	var distance 
	var a = pow((player1.transform.origin.x - player2.transform.origin.x),2)
	var b = pow((player1.transform.origin.z - player2.transform.origin.z),2)
	
	distance = sqrt(a+b)
	
	$distance.text = str(int(round(distance)))+ " m"
	if distance < 2:
		if Global.player1.ends_with("guard.tscn"):
			get_tree().change_scene("res://UI/guard_win.tscn")
		else:
			get_tree().change_scene("res://thief_loose.tscn")
		get_node("/root/Level").free()
