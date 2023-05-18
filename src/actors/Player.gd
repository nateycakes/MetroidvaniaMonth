extends KinematicBody2D

enum states {
	IDLE,
	MOVE,
	ATTACK,
	KNOCKBACK
}

export(int) var GRAVITY = 5
export(int) var FALL_GRAVITY = 10
export(int) var ACCELERATION = 200
export(int) var DEACCELERATION = 200
export(int) var FRICTION = 200
export(int) var MAX_HORIZONTAL_SPEED = 100
export(int) var MAX_FALL_SPEED = 100
export(int) var JUMP_FORCE = -200
export(int) var JUMP_RELEASE_THRESHOLD = -100
export(float) var COYOTE_TIME_LENGTH = 0.1


onready var velocity : Vector2 = Vector2.ZERO
var state = states.IDLE


######################   END HEADER SECTION ####################################


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	apply_gravity()
	var input_vector : Vector2 = Vector2.ZERO
	
	input_vector = get_player_input_direction() #get player input for the frame
	
	
	
	
	######     HORIZONTAL MOVEMENT   ##############
	if (input_vector.x == 0): #player is no longer pushing direction, apply friction
		apply_friction()
	else:
		apply_acceleration(input_vector.x) #player is moving
	######   END HORIZONTAL MOVEMENT  ############
	
	
	######      JUMPING      #########
	
	if is_on_floor(): 
		if (Input.is_action_just_pressed("jump")):
			velocity.y = JUMP_FORCE
	else: #not on the floor, adjust for player holding button for variable jump
		if (Input.is_action_just_released("jump") and velocity.y < JUMP_RELEASE_THRESHOLD):
			velocity.y = JUMP_RELEASE_THRESHOLD
			
		if velocity.y > 0:
			velocity.y += FALL_GRAVITY
	
	##########   END JUMPING     ############
	
	#resulting velocity gets stored (will be 0 when hits floor, and won't accumulate gravity)
	velocity = move_and_slide(velocity, Vector2.UP) 
	
	pass #END _physics_process()





##########################  CUSTOM  FUNCTIONS  #################################


func get_player_input_direction() -> Vector2: #is player moving left or right? 
	return Vector2(  
		#subtract right from left to determine horizontal (use strength for analog input values
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		#was jump just pressed AND they're on the floor? -1 (go up) otherwise, 1, (fall/go down)
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0  
	)
	#END get_player_input_direction()


func apply_gravity():
	velocity.y += GRAVITY
	pass #END apply_gravity()


func apply_friction(): #slow the player down
	velocity.x = move_toward(velocity.x, 0, DEACCELERATION) #move toward is sign agnostic
	pass #END apply_friction()


func apply_acceleration(amount): #speed the player up
	velocity.x = move_toward(velocity.x, MAX_HORIZONTAL_SPEED * amount, ACCELERATION) #move toward is sign agnostic
	pass #END apply_acceleration()






















