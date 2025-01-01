extends Control
	
@onready var back_button = %BackButton

func _ready() -> void:
	self.hide()
	back_button.pressed.connect(self.hide)

func _input(event: InputEvent) -> void:
	if PlayerStats.HP == 0:
		return
	
	
	if event.is_action_pressed("ui_cancel") and not get_tree().paused:
		print("Game paused")
		self.show()
		get_tree().paused = true
	
	elif event.is_action_pressed("ui_cancel") and get_tree().paused:
		print("Unpause")
		self.hide()
		get_tree().paused = false
