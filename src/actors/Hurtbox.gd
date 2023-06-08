extends Area2D

#a hurtbox with functionality to start iframes for a set duration which has custom
#signals to capture when iframes begin and end when started via collision



#I'm calling them iframes instead of invicibility bc that's a lot of letters
var iframes_active = false setget iframes_active_setter

onready var iframeTimer = $iframeTimer

signal iframes_start
signal iframes_end


func start_iframes(duration):
	iframeTimer.start(duration)
	self.iframes_active = true


func iframes_active_setter(value : bool):
	iframes_active = value
	if iframes_active:
		emit_signal("iframes_start")
	else:
		emit_signal("iframes_end")


func _on_iframeTimer_timeout() -> void:
	self.iframes_active = false


func _on_Hurtbox_iframes_start() -> void:
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)


func _on_Hurtbox_iframes_end() -> void:
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
