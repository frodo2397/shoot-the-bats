extends RigidBody3D

signal died
signal puff
signal touched_player

@onready var bat_model = %bat_model
@onready var player = get_node("/root/Game/Player")
@onready var death_timer = %death_timer
@onready var hurt_sound = %HurtSound
@onready var ko_sound = %KOSound

#mobs will move at different speeds
var speed = randf_range(2.0, 4.0)
var health = 5
var dead = false

func _physics_process(delta):
	#go towards the player at all times
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0.0
	
	#comes with RigidBody3D node
	linear_velocity = direction * speed
	
	#magic number: face the player. facing away from the player , then rotate pi radians or 180 degrees. 
	bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI
	



#notice: this gets triggered in the bullet's script because it has collisions that detect more eaily. 
func take_damage():
	bat_model.hurt()
	health -= 1
	
	if health == 0 and not dead:
		#notice: will take no action if hit when already dead. 
		dead = true
		set_physics_process(false)
		gravity_scale = 1.0
		var direction = -1.0 * global_position.direction_to(player.global_position)
		#face away from player
		var upward_force = Vector3.UP * randf_range(1.0, 5.0)
		lock_rotation = false #roll away when dead
		apply_central_impulse(direction * 10 + upward_force)
		%death_timer.start()
		died.emit()
		ko_sound.play()
	
	else:
		hurt_sound.play()

#actually destroy the mob once it has had the chance to roll away for a while.
func _on_death_timer_timeout():
	puff.emit()
	queue_free()
	

func _on_area_3d_body_entered(body):
	if body.name == "Player" :
		touched_player.emit()
		health = 1
		take_damage()
