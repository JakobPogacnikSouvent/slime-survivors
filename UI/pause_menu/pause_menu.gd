extends Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not get_tree().paused:
		print("Game paused")
		self.show()
		get_tree().paused = true
	
	elif event.is_action_pressed("ui_cancel") and get_tree().paused:
		print("Unpause")
		self.hide()
		get_tree().paused = false
