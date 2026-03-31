extends CharacterBody2D
#movement
var move_speed: float= 500
#--jumping
var jump_power_initial: float=-40
var jump_horizontal_power_initial: float = 15
var jump_power: float = 0
var is_jumping: bool = false
#--falling
var was_high_fall: bool = false
var stun: bool = false


var jump_held_time: float = 1#editted
var last_direction: float

var gravity = 	250	

#---------------------------------
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D




@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite_2_effects: AnimatedSprite2D = $AnimatedSprite2_effects
@onready var jumpsound: AudioStreamPlayer2D = $jumpsound
@onready var fall: AudioStreamPlayer2D = $fall





func _physics_process(delta: float) -> void:
#jump things
	if velocity.y > 600:
		was_high_fall = true
		

	if is_jumping:
		if velocity.x == 0:
			animated_sprite_2d.play("jump_up")
			
			if last_direction<0:
				last_direction=5

			elif last_direction>0:
				last_direction=-5

		velocity.x=last_direction*move_speed*delta
	else:
		velocity.x= get_input_velocity() * move_speed * delta

	if is_on_floor():
		is_jumping = false

		if stun==true:
			animated_sprite_2d.play("stun")
		
		elif was_high_fall:
			start_stun_phase()
		
#---------- animations walking
		elif velocity.x == 0:
			animated_sprite_2d.play("idle")
		elif velocity.x > 0:
			animated_sprite_2d.play("run")
			animated_sprite_2d.flip_h = false
		elif velocity.x < 0:
			animated_sprite_2d.play("run")
			animated_sprite_2d.flip_h = true	

	
	if not is_on_floor() && !stun:
		velocity.y += (gravity*3)*delta
		#debug
		#print(velocity.y)
#--------------animations jump		
		
		if velocity.y > 0 :
			if velocity.x < 0:
				animated_sprite_2d.play("jump_side_down")
				animated_sprite_2d.flip_h = false
			elif velocity.x > 0:
				animated_sprite_2d.play("jump_side_down")
				animated_sprite_2d.flip_h = true
			elif velocity.x == 0:		
				animated_sprite_2d.play("jump_down")
		if velocity.y < 0 :
			if velocity.x < 0:
				animated_sprite_2d.play("jump_side_up")
				animated_sprite_2d.flip_h = false
			elif velocity.x > 0:
				animated_sprite_2d.play("jump_side_up")
				animated_sprite_2d.flip_h = true
			elif velocity.x == 0:		
				animated_sprite_2d.play("jump_up")
	
			
	# Handle jump.
	
	if Input.is_action_pressed("move_up") and is_on_floor() && !stun:
		jump_held_time +=.12
		print(jump_held_time)
		if jump_held_time>0:
			animated_sprite_2d.play("charge")
		if jump_held_time>1:
			animated_sprite_2d.play("jump_charge_1")
		if jump_held_time>2:
			animated_sprite_2d.play("jump_charge_2")
		if jump_held_time>3:
			animated_sprite_2d.play("jump_charge_3")
		if jump_held_time>4:
			animated_sprite_2d.play("jump_charge_4")
		if jump_held_time>5:
			animated_sprite_2d.play("jump_charge_5")
		if jump_held_time>6:
			animated_sprite_2d.play("jump_charge_6")
		if jump_held_time>7:
			animated_sprite_2d.play("jump_charge_7")
		if jump_held_time>8:
			animated_sprite_2d.play("jump_charge_8")
		if jump_held_time>9:
			animated_sprite_2d.play("jump_charge_9")
		if jump_held_time>9:
			animated_sprite_2_effects.play("super_charge")
		if jump_held_time>10:

			start_jump()
	if Input.is_action_just_released("move_up") and is_on_floor() && !stun:
		start_jump()    


	move_and_slide()
	if Input.is_action_just_released("interact"):
		get_tree().reload_current_scene()
	animated_sprite_2d.scale.x = move_toward(animated_sprite_2d.scale.x, 1,0.8*delta)
	animated_sprite_2d.scale.y = move_toward(animated_sprite_2d.scale.y, 1, 0.8*delta)
	collision_shape_2d.scale.x = move_toward(collision_shape_2d.scale.x, 1, 0.8*delta)
	collision_shape_2d.scale.y = move_toward(animated_sprite_2d.scale.y, 1, 0.8*delta)
func start_jump():

	#squish effect
	animated_sprite_2d.scale  = Vector2(1.3, 0.7)
	collision_shape_2d.scale = Vector2(1.3, 0.7)
	last_direction=0
	#----sound
	jumpsound.play()
	#----walking
	if Input.is_action_just_released("move_right") || Input.is_action_pressed("move_right"):
		last_direction = jump_horizontal_power_initial
	if Input.is_action_just_released("move_left") || Input.is_action_pressed("move_left"):
		last_direction = -jump_horizontal_power_initial
	is_jumping = true
	velocity.y=jump_power_initial * jump_held_time
	velocity.x= last_direction * (move_speed/100)
	
	#reset jump
	jump_power = jump_power_initial
	jump_held_time = 1 #editted
	
func get_input_velocity():
	var horizontal := 0.0
	
	if Input.is_action_pressed("move_right") && jump_held_time == 1 && !is_jumping && !stun:
		horizontal = 8
		last_direction= jump_horizontal_power_initial
	if Input.is_action_pressed("move_left") && jump_held_time == 1 && !is_jumping && !stun:
		horizontal = -8
		last_direction=-jump_horizontal_power_initial
	return horizontal
	
func knockback():
	velocity.y = 300

	
func start_stun_phase():
	#player fell from high point
	was_high_fall = false
	stun = true
	fall.play()
	$TimerStun.start()

func _on_timer_stun_timeout() -> void:
	pass # Replace with function body.
	stun=false
	
