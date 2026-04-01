extends Node2D
@onready var credit_fade: CanvasLayer = $"credit-fade"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	credit_fade.fade_c(0.0, 3.0)
	
	
