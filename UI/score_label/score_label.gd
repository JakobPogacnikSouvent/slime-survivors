extends Control


func _ready() -> void:
	GameManager.score_updated.connect(_update_label)


func _update_label() -> void:
	$Label.text = "Score: " + str(GameManager.score)
