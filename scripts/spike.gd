extends Sprite2D

@onready var player: CharacterBody2D = $"../player"
@onready var hurt: AudioStreamPlayer2D = $hurt


func _on_area_2d_body_entered(_body: Node2D) -> void:
	#if body.name != "player"	:
	#	return
	print("ahh")
	hurt.play()
	player.knockback()
	
