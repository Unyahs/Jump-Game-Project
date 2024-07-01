extends ColorRect

@onready var restart_btn = %RestartBtn
@onready var next_level_btn = %NextLevelBtn

signal retry()
signal next_level()

func _on_restart_btn_pressed():
	retry.emit()


func _on_next_level_btn_pressed():
	next_level.emit()

