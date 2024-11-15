extends Control

@onready var timer : Timer = $Timer
@onready var label : Label = $Label
@onready var progress : TextureProgressBar = $TextureProgressBar

const time = 10

func _ready() -> void:
	timer.timeout.connect(_timeout)
	timer.start(time)
	progress.max_value = time
	progress.value = time
	_set_level_label()
	GameManager.level_increased.connect(_set_level_label)

func _process(delta: float) -> void:
	label.text = str(floor(timer.time_left))
	progress.value = timer.time_left


func _timeout() -> void:
	GameManager.level += 1


func _set_level_label() -> void:
	$LevelLabel.text = "lv " + str(GameManager.level)
