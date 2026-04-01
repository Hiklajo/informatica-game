extends Area2D






func _on_body_entered(_body: Node2D) -> void:
	print("new scene")
	get_tree().change_scene_to_file.call_deferred("res://scenes/end_cutscene.tscn")
