extends Node3D

@onready var animation_tree = %AnimationTree

func hurt():
	# magic code. To use the oneShot node, you set the parameter "request" of the OneShot node of the AnimationTree to true
	animation_tree.set("parameters/OneShot/request", true)


func _on_death_timer_timeout():
	pass # Replace with function body.
