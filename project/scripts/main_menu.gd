extends Control


func _on_join_button_pressed():
	var ip_address = $IPLineEdit.text
	MultiplayerController.player_info["username"] = $UsernameLineEdit.text
	MultiplayerController.join(ip_address)


func _on_host_button_pressed():
	MultiplayerController.player_info["username"] = $UsernameLineEdit.text
	MultiplayerController.host()
