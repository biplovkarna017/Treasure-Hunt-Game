extends KinematicBody

var gravity = -9.8
var velocity = Vector3()
var camera
var anim_player
var character
master func shutItDown():
	rpc("ShutDown")
sync func ShutDown():
	get_tree().quit()
sync var is_moving
#puppet var puppet_position = Vector3(0,0,0) setget puppet_position_set
#onready var tween = $Tween

const SPEED = 6
const ACCELERATION = 3
const DE_ACCELERATION = 5


var anim_to_play
func _ready():
	anim_player = $AnimationPlayer
	character = get_node(".")
	if Global.player1 == "res://assets/guard/guard.tscn":
		$Camera.make_current()
remote func _set_position(pos):
	global_transform = pos
remote func _data_received(data):
	if not is_network_master():
		anim_to_play = "idle"
		is_moving = data
		if is_moving:
			anim_to_play = "rigAction"
		var current_anim = anim_player.get_current_animation()
		if current_anim != anim_to_play:
			anim_player.play(anim_to_play)
	
func _physics_process(delta):
	var dir = Vector3()
	is_moving = false
	var previous_position = global_transform.origin
	camera = get_node("Camera").get_global_transform()
	if is_network_master():
		if(Input.is_action_pressed("move_fw")):
			dir += -camera.basis[2] 
			is_moving = true
		if(Input.is_action_pressed("move_bw")):
			dir += camera.basis[2]
			is_moving = true
		if(Input.is_action_pressed("move_l")):
			dir += -camera.basis[0] 
			is_moving = true
		if(Input.is_action_pressed("move_r")):
			dir += camera.basis[0]
			is_moving = true
		if(Input.is_action_pressed("Key_Q")):
			shutItDown()

	dir.y = 0
	dir = dir.normalized()
	velocity.y += delta * gravity
	
	var hv = velocity
	hv.y = 0
	
	var new_pos = dir*SPEED
	var accel = DE_ACCELERATION
	
	if (dir.dot(hv)>0):
		accel = ACCELERATION
	
	hv = hv.linear_interpolate(new_pos,accel * delta)
	velocity.x = hv.x
	velocity.z = hv.z
	if is_network_master():
		velocity = move_and_slide(velocity,Vector3(0,1,0))
		rpc_unreliable("_set_position",global_transform)
	rpc("_data_received",is_moving)
	if is_moving:
		var angle = atan2(hv.x,hv.z)
		var char_rot = character.get_rotation()
		char_rot.y = angle
		character.set_rotation(char_rot)

#	_play_anim(is_moving)
	if is_network_master():
		anim_to_play = "idle"
		if is_moving:
			anim_to_play = "rigAction"
		var current_anim = anim_player.get_current_animation()
		if current_anim != anim_to_play:
			anim_player.play(anim_to_play)

		
		
	
#func puppet_position_set(new_value) -> void:
#	puppet_position = new_value
#
#	tween.interpolate_property(self, "global_transform.origin", global_transform.origin, puppet_position, 0.1)
#	tween.start()
#func _on_Network_tick_rate_timeout():
#	if is_network_master():
#		rset_unreliable("puppet_position",global_transform.origin)
