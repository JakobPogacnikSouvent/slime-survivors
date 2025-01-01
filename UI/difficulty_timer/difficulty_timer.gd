extends Control

@onready var timer : Timer = $Timer
@onready var label : Label = $Label
@onready var progress : TextureProgressBar = $TextureProgressBar
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

const time = 30

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
	audio_player.play()
	GameManager.level += 1
	GameManager.score += 100 * GameManager.level
	var level_time = min(60, time + GameManager.level*5)
	progress.max_value = level_time
	progress.value = level_time
	timer.start(level_time)

func _set_level_label() -> void:
	$LevelLabel.text = "lv " + str(GameManager.level)
