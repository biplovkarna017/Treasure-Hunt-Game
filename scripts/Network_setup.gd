extends Control
#var player = load("res://assets/guard/guard.tscn")
#var player = load("res://assets/thief/thief.tscn")
onready var multiplayer_config_ui = $Multiplayer_config
onready var server_ip_address = $Multiplayer_config/Server_ip_addr
onready var device_ip_address = $CanvasLayer/Device_ip_address
var player
remote func _player_info(data):
	Global.player1 = data.player1
	Global.player2 = data.player2
	print("I am thief")
func _ready() -> void:
	$Multiplayer_config/Guard.hide()
	$Multiplayer_config/Thief.hide()
	get_tree().connect("network_peer_connected",self,"_player_connected") 
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	get_tree().connect("connected_to_server",self,"_connected_to_server")
	get_tree().connect("server_disconnected",self,"_server_disconnected")
	
	device_ip_address.text = Network.ip_address
remote func _player(player):
	
	Global.player1 = player.player1
	Global.player2 = player.player2
	_load_game()
	queue_free()
func _load_game():
	var game = preload("res://Main.tscn").instance() 
	get_tree().get_root().add_child(game)
	device_ip_address.hide()
	hide()
func _player_connected(id) -> void:
	
	Global.player2id = id #new
	Global.player1id = get_tree().get_network_unique_id()
	if is_network_master():
		$Multiplayer_config/Guard.show()
		$Multiplayer_config/Thief.show()
	$Multiplayer_config/Create_server.disabled = true
	$Multiplayer_config/Join_server.disabled = true
	
func _player_disconnected(id) -> void:
	print("Player "+ str(id)+ " has disconnected")
func _server_disconnected():
	print("Server disconnected")
func _on_Create_server_pressed():
#	multiplayer_config_ui.hide()
#	Network.create_server()
	var net = NetworkedMultiplayerENet.new() #new
	net.create_server(6969,2)
	get_tree().set_network_peer(net)

	device_ip_address.text = Network.ip_address + "\nServer Created!\nWaiting for player..."
	$Multiplayer_config/Create_server.disabled = true
func _connected_to_server():
	print("Connected to server")
	pass

func _on_Join_server_pressed():
	if server_ip_address.text != "":
#		multiplayer_config_ui.hide()
#		Network.ip_address = server_ip_address.text
#		Network.join_server()
		if is_network_master():
			get_tree().set_network_peer(null)
			$Multiplayer_config/Create_server.disabled = false
		var net = NetworkedMultiplayerENet.new() #new
		net.create_client(server_ip_address.text,6969)
		get_tree().set_network_peer(net)
		
		$Multiplayer_config/Guard.hide()
		$Multiplayer_config/Thief.hide()

		device_ip_address.text = Network.ip_address + "\n\n Connecting... Please Wait"
		
#		Global.player1 = "res://assets/thief/thief.tscn"
#		Global.player2 = "res://assets/guard/guard.tscn"
		




func _on_Guard_pressed():
	player = {"player1":"res://assets/thief/thief.tscn","player2":"res://assets/guard/guard.tscn"}
	Global.player1 = "res://assets/guard/guard.tscn"
	rpc("_player",player)
	if is_network_master():
		_load_game()
		queue_free()
		#get_node("/root/Network_setup").free()


func _on_Thief_pressed():
	player = {"player1":"res://assets/guard/guard.tscn","player2":"res://assets/thief/thief.tscn"}
	Global.player1 = "res://assets/thief/thief.tscn"
	rpc("_player",player)
	if is_network_master():
		_load_game()
		queue_free()
		#get_node("/root/Network_setup").free()

	
