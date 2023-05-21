extends Resource
class_name PlayerMovementData

#force of how much fallspeed accumulates on player per frame
export(int) var GRAVITY = 4
#additional force to make player fall once jump is released
export(int) var ADDITIONAL_FALL_GRAVITY = 0
#how strong the player's jump will be (negative values are "up")
export(int) var JUMP_FORCE = -150
#the minimum height a jump will be
export(int) var MINIMUM_JUMP_THRESHOLD = -40
#how long the coyote timer will be
export(float) var COYOTE_TIME_LENGTH = 0.1
#the rate at which the player accumulates horizontal speed
export(int) var ACCELERATION = 200
#the rate at which player speed decays once movement is let go
export(int) var DEACCELERATION = 200
#maximum speed the player can move horizontally
export(int) var MAX_HORIZONTAL_SPEED = 75
#maximum speed the player can fall
export(int) var MAX_FALL_SPEED = 300
#total number of additional jumps the player has
export(int) var DOUBLE_JUMP_COUNT = 1
