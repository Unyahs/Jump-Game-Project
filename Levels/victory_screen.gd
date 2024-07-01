extends CenterContainer
@onready var menu_return = %MenuReturn


func _ready():
	LevelTransition.fade_from_black()
	menu_return.grab_focus()

func _on_return_pressed():
	get_tree().change_scene_to_file("res://Levels/Main Menu.tscn")
