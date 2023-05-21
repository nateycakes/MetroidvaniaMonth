extends KinematicBody2D
class_name Player

export(Resource) var moveData = preload("res://src/actors/DefaultPlayerMovementData.tres") as PlayerMovementData

enum states {
	MOVE,
	ATTACK,
	KNOCKBACK
}
onready var velocity : Vector2 = Vector2.ZERO
onready var playerSprite: = $Sprite
onready var jumpBufferTimer: = $JumpBufferTimer
onready var coyoteTimer: = $CoyoteTimer

var state = states.MOVE
var double_jump = 1
var buffered_jump = false
var coyote_time_active = false
var debug = true


######################   END HEADER SECTION ####################################


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass #END ready()


func _physics_process(delta: float) -> void:
	
	var input_vector : Vector2 = Vector2.ZERO
	input_vector = get_player_input_direction() #get player input for the frame
	
	match state:
		states.MOVE: 
			move_state(input_vector)
	
	pass #END _physics_process()



##########################  CUSTOM  FUNCTIONS  #################################


func move_state(input_vector):
	
	#state transitions will go here
	
	
	#end state transitions 
	
	apply_gravity()
	
	######     HORIZONTAL MOVEMENT   ##############
	if (input_vector.x == 0): #player is no longer pushing direction, apply friction
		apply_friction()
	else:
		apply_acceleration(input_vector.x) #player is moving
	######    END HORIZONTAL MOVEMENT  ############
	
	
	
	######      JUMPING  LOGIC    #########
	
	if is_on_floor():
		#Reset the double jump when the player lands
		reset_double_jump()
	
	if player_can_jump(): #player is on the ground and has coyote time
		
		handle_jump_input() #has the player submitted a jump? (pushed the button)
		
	else: #player is **NOT** on the floor and has no coyote time
		
		#CONTROLLED JUMP HEIGHT LOGIC
		#player is currently jumping but can only stop their jump once they've crossed the Minimum Jump Threshold
		if Input.is_action_just_released("jump") and velocity.y < moveData.MINIMUM_JUMP_THRESHOLD:
			velocity.y = moveData.MINIMUM_JUMP_THRESHOLD
		
		#DOUBLE JUMP LOGIC
		#player can jump again in the air, total number of additional jumps controlled in PlayerMovementData
		if Input.is_action_just_pressed("jump") and double_jump > 0:
			velocity.y = moveData.JUMP_FORCE
			double_jump -= 1
			if debug: 
				print ("I am double jumping rn")
				print ("is on floor: " + str(is_on_floor()))
		
		#BUFFERED JUMP LOGIC
		#player doesn't need to be super precise in order to jump immediately after landing
		if Input.is_action_just_pressed("jump"):
			buffered_jump = true
			jumpBufferTimer.start()
		
		#ADDITIONAL GRAVITY
		#player has stopped ascending, add additional gravity now (to help with "game feel")
		if velocity.y > 0: 
			velocity.y += moveData.ADDITIONAL_FALL_GRAVITY
			
		#END player is **NOT** on the floor and has no coyote time section------
	
	
	
	var was_on_floor = is_on_floor()
	
	#resulting velocity gets stored (will be 0 when hits floor, and won't accumulate gravity)
	velocity = move_and_slide(velocity, Vector2.UP) 
	#we know where the player is headed after move_and slide
	
	#COYOTE TIME CHECK
	#player is NOT on the floor but they WERE before move_and_slide, therefore, they just left
	var just_left_ground = not is_on_floor() and was_on_floor
	
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


func apply_gravity():
	velocity.y += moveData.GRAVITY
	
	#Limit Falling Speed to defined MAX_FALL_SPEED 
	velocity.y = min(velocity.y, moveData.MAX_FALL_SPEED)
	pass #END apply_gravity()


func apply_friction(): #slow the player down
	velocity.x = move_toward(velocity.x, 0, moveData.DEACCELERATION) #move toward is sign agnostic
	pass #END apply_friction()


func apply_acceleration(amount): #speed the player up by moveData.ACCELERATION
	velocity.x = move_toward(velocity.x, moveData.MAX_HORIZONTAL_SPEED * amount, moveData.ACCELERATION) #move toward is sign agnostic
	pass #END apply_acceleration()


func handle_jump_input():
	#did the player just hit jump or have they jumped in the grace threshold?
	if Input.is_action_just_pressed("jump") or buffered_jump:
			velocity.y = moveData.JUMP_FORCE
			buffered_jump = false


func reset_double_jump():
	double_jump = moveData.DOUBLE_JUMP_COUNT

func player_can_jump(): #can the player currently jump?
	return is_on_floor() or coyote_time_active







###############  SIGNAL FUNCTIONS ##################################

func _on_JumpBufferTimer_timeout() -> void:
	buffered_jump = false


func _on_CoyoteTimer_timeout() -> void:
	coyote_time_active = false
