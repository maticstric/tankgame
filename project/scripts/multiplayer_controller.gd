extends Node


const PORT = 8910
const MAX_CLIENTS = 4


var players = {}

var player_info = {
	"username": ""
}

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)


func join(ip_address):
	# Create client.
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.multiplayer_peer = peer


func host():
	# Create server.
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	
	players[1] = player_info
	
	get_tree().change_scene_to_file("res://project/scenes/menus/lobby_menu.tscn")


@rpc("any_peer", "call_remote", "reliable")
func register_player(new_player_info):
	var new_peer_id = multiplayer.get_remote_sender_id()
	
	players[new_peer_id] = new_player_info


@rpc("authority", "call_local", "reliable")
func start_game():
	get_tree().change_scene_to_file("res://project/scenes/levels/test_level.tscn")


func _on_peer_connected(peer_id):
	print(str(multiplayer.get_unique_id()) + ": new peer connected with id " + str(peer_id))
	register_player.rpc_id(peer_id, player_info)

func _on_peer_disconnected(peer_id):
	print(str(multiplayer.get_unique_id()) + ": peer disconnected with id " + str(peer_id))
	
	if peer_id == 1: # Host disconnected
		leave_server()

func _on_connected_to_server():
	print(str(multiplayer.get_unique_id()) + ": I succesfully joined the server!")
	
	players[multiplayer.get_unique_id()] = player_info
	
	get_tree().change_scene_to_file("res://project/scenes/menus/lobby_menu.tscn")

# For client
func leave_server():
	multiplayer.multiplayer_peer.close()
	get_tree().change_scene_to_file("res://project/scenes/menus/main_menu.tscn")


# For host
func terminate_server():
	multiplayer.multiplayer_peer.close()
	get_tree().change_scene_to_file("res://project/scenes/menus/main_menu.tscn")
