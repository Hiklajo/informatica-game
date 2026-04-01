extends Node2D

@onready var fade_logo: CanvasLayer = $"Fade-logo"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	await fade_logo.fade_l(0.0, 3.0).finished
	await get_tree().create_timer(8).timeout
	await fade_logo.fade_l(1.0,3.0).finished
	get_tree().change_scene_to_file.call_deferred("res://scenes/credits.tscn")
