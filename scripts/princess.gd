extends Node2D





@onready var press_to_kiss: Sprite2D = $"../PressToKiss"
@onready var particles: AnimatedSprite2D = $AnimatedSprite2D/particles
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var fade: CanvasLayer = $"../fade"

var inside = false

func _input(_event):
	if Input.is_action_just_pressed("interact"):
		if inside:
			print("interactions")
			inside = false
			particles.play("particles")
			
			animated_sprite_2d.play("frog")
			await get_tree().create_timer(4).timeout
			animated_sprite_2d.play("frog_idle")
			await fade.fade(1.0, 1.5).finished
			

func _on_area_2d_body_entered(_body: Node2D) -> void:
	print("hit")
	inside = true
	$"../PressToKiss".visible = true
 	

		
func _on_area_2d_body_exited(_body: Node2D) -> void:
	$"../PressToKiss".visible = false
	inside = false
