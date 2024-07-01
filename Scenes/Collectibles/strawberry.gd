extends Area2D

func _on_body_entered(body):
	queue_free()
	var strawberries = get_tree().get_nodes_in_group("Strawberry")
	print(strawberries.size())
	if strawberries.size() == 1:
		Events.level_completed.emit()
