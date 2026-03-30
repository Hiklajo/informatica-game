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




@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite_2_effects: AnimatedSprite2D = $AnimatedSprite2_effects





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
	if is_on_floor():
		is_jumping = false
		if was_high_fall:
			start_stun_phase()
		elif stun==true:
			animated_sprite_2d.play("stun")
#---------- animations walking
		elif velocity.x == 0:
			animated_sprite_2d.play("idle")
		elif velocity.x > 0:
			animated_sprite_2d.play("run")
			animated_sprite_2d.flip_h = false
		elif velocity.x < 0:
			animated_sprite_2d.play("run")
			animated_sprite_2d.flip_h = true	

			
	# Handle jump.
	
	if Input.is_action_pressed("move_up") and is_on_floor() && !stun:
		jump_held_time +=.12
		print(jump_held_time)
		if jump_held_time>6:
			animated_sprite_2d.play("charge")
		if jump_held_time>9:
			animated_sprite_2_effects.play("super_charge")
		if jump_held_time>10:

			start_jump()
	if Input.is_action_just_released("move_up") and is_on_floor() && !stun:
		start_jump()    


	move_and_slide()


	 

func start_jump():
	
	last_direction=0
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
	$TimerStun.start()

func _on_timer_stun_timeout() -> void:
	pass # Replace with function body.
	stun=false
	
