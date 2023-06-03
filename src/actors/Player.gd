extends KinematicBody2D
class_name Player

export(Resource) var moveData = preload("res://src/actors/DefaultPlayerMovementData.tres") as PlayerMovementData

export(int, "OFF", "ON") var debug

enum states {
	MOVE,
	ATTACK,
	KNOCKBACK
}
onready var velocity : Vector2 = Vector2.ZERO
onready var playerSprite: Sprite = $Sprite
onready var jumpBufferTimer: Timer = $JumpBufferTimer
onready var coyoteTimer: Timer = $CoyoteTimer
onready var remoteTransform2d: RemoteTransform2D = $RemoteTransform2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer


var state = states.MOVE
var double_jump = 1
var buffered_jump = false
var coyote_time_active = false
var is_exiting = false #is the player leaving a room?
var is_attacking = false
var is_jumping = false


######################   END HEADER SECTION ####################################


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass #END ready()


func _physics_process(delta: float) -> void:
	
	var input_vector : Vector2 = Vector2.ZERO
	input_vector = get_player_input_direction() #get player input for the frame
	
	match state:
		states.MOVE: 
			move_state(input_vector, delta)
	
	if is_meowing(): #the most important function in the entire game
		handle_meowing()
	
	pass #END _physics_process()



##########################  CUSTOM  FUNCTIONS  #################################


func move_state(input_vector, delta):
	
	#state transitions will go here
	
	
	#end state transitions 
	
	apply_gravity(delta)
	
	######     HORIZONTAL MOVEMENT   ##############
	# is player no longer pushing direction? apply friction
	if not player_inputting_move(input_vector): 
		apply_friction(delta)
		animationPlayer.play("Idle")
		
	else: #player is inputting move
		apply_acceleration(input_vector.x, delta) 
		animationPlayer.play("Move")
		#player sprite-flip logic. Default: facing right
		orient_sprite_to_movement(input_vector)
	
	######    END HORIZONTAL MOVEMENT  ############
	
	######      JUMPING  LOGIC    #########
	if is_on_floor(): #any logic for when the player lands goes here
		reset_double_jump()
	else: #logic for if the player is still in the air at the start
		#keep them in the jump animation while they're in air falling (this could be "falling animation" if we make one)
		#animationPlayer.play("Jump")
		pass
	
	if player_can_jump(): #player is on the ground and has coyote time
		handle_input_jump() #has the player submitted a jump? (pushed the button)
		
	else: #player is **NOT** on the floor and has no coyote time
		control_jump_height() #let go of jump or min jump
		handle_input_double_jump() #jumping again?
		handle_buffered_input_jump() #recognize player wants to jump
		additional_gravity(delta) #gamefeel / extra character weight
		
		#END player is **NOT** on the floor and has no coyote time section------
	
	
	###Jump state booleans to make testing more readable
	var was_on_floor = is_on_floor()
	var was_in_air = not is_on_floor()
	
	#resulting velocity gets stored (will be 0 when hits floor, and won't accumulate gravity)
	velocity = move_and_slide(velocity, Vector2.UP) 
	#we know where the player is headed after move_and slide
	
	###Jump state booleans post-move_and_slide()
	#player is NOT on the floor but they WERE before move_and_slide, therefore, they just left
	var just_left_ground = not is_on_floor() and was_on_floor
	#player is now on floor but was previously in the air, therefore they just landed
	var just_landed = is_on_floor() and was_in_air
	
	if just_landed:
		animationPlayer.play("Move")
		SoundPlayer.play_sound(SoundPlayer.library.CAT_LAND)
	#COYOTE TIME CHECK
	#did the player just leave AND are they falling downward?
	if just_left_ground and velocity.y >= 0:
		coyote_time_active = true
		coyoteTimer.start()



func get_player_input_direction() -> Vector2: #is player moving left or right? 
	return Vector2(  
		#ez way to get player input and have em cancel out
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
		#was jump just pressed AND they're on the floor? -1 (go up) otherwise, 1, (fall/go down)
		#-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0  
	)
	#END get_player_input_direction()


func apply_gravity(delta):
	velocity.y += moveData.GRAVITY * delta #changing over time, need to accomodate for time
	
	#Limit Falling Speed to defined MAX_FALL_SPEED 
	velocity.y = min(velocity.y, moveData.MAX_FALL_SPEED)
	pass #END apply_gravity()


func apply_friction(delta): #slow the player down
	velocity.x = move_toward(velocity.x, 0, moveData.DEACCELERATION * delta) #move toward is sign agnostic
	pass #END apply_friction()


func apply_acceleration(amount, delta): #speed the player up by moveData.ACCELERATION
	velocity.x = move_toward(velocity.x, moveData.MAX_HORIZONTAL_SPEED * amount, moveData.ACCELERATION * delta) #move toward is sign agnostic
	pass #END apply_acceleration()


func player_inputting_move(input_vector):
	return input_vector.x != 0

func orient_sprite_to_movement(input_vector):
	#player sprite-flip logic. Default: facing right
		if input_vector.x > 0 : #facing right
			playerSprite.flip_h = false
			
		else: #facing left
			playerSprite.flip_h = true

func reset_double_jump():
	double_jump = moveData.DOUBLE_JUMP_COUNT

func player_can_jump(): #can the player currently jump?
	return is_on_floor() or coyote_time_active


func handle_input_jump():
	#did the player just hit jump or have they jumped in the grace threshold?
	if Input.is_action_just_pressed("jump") or buffered_jump:
			velocity.y = moveData.JUMP_FORCE
			buffered_jump = false
			SoundPlayer.play_sound(SoundPlayer.library.CAT_JUMP)
			if not is_on_floor(): animationPlayer.play("Jump")
		
		


func control_jump_height():
	#CONTROLLED JUMP HEIGHT LOGIC
	#player is currently jumping but can only stop their jump once they've crossed the Minimum Jump Threshold
	if Input.is_action_just_released("jump") and velocity.y < moveData.MINIMUM_JUMP_THRESHOLD:
		velocity.y = moveData.MINIMUM_JUMP_THRESHOLD


func handle_input_double_jump():
	#DOUBLE JUMP LOGIC
	#player can jump again in the air, total number of additional jumps controlled in PlayerMovementData
	if Input.is_action_just_pressed("jump") and double_jump > 0:
		velocity.y = moveData.DOUBLE_JUMP_FORCE
		double_jump -= 1
		SoundPlayer.play_sound(SoundPlayer.library.CAT_DOUBLEJUMP)
		animationPlayer.play("Jump")
		if debug: 
			print ("I am double jumping rn")
			print ("is on floor: " + str(is_on_floor()))


func handle_buffered_input_jump():
	#BUFFERED JUMP LOGIC
	#player doesn't need to be super precise in order to jump immediately after landing
	if Input.is_action_just_pressed("jump"):
		buffered_jump = true
		jumpBufferTimer.start()


func additional_gravity(delta):
	#ADDITIONAL GRAVITY
	#player has stopped ascending, add additional gravity now (to help with "game feel")
	if velocity.y > 0: 
		velocity.y += moveData.ADDITIONAL_FALL_GRAVITY * delta


func player_die():
	if debug:
		print("player dead")
	Events.emit_signal("player_died")
	queue_free() #remove this instance of the player
	

func take_damage():
	SoundPlayer.play_sound(SoundPlayer.library.CAT_HURT)
	animationPlayer.play("Gethit")
	#player_die()
	if debug:
		print("player was damaged")
	

func is_meowing() -> bool:
	return Input.is_action_just_pressed("meow")

func handle_meowing():
	SoundPlayer.play_sound(SoundPlayer.library.CAT_MEOW)


func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2d.remote_path = camera_path



###############  SIGNAL FUNCTIONS ##################################

func _on_JumpBufferTimer_timeout() -> void:
	buffered_jump = false


func _on_CoyoteTimer_timeout() -> void:
	coyote_time_active = false



func _on_Hurtbox_area_entered(area: Area2D) -> void:
	take_damage()







