extends Node3D
signal mob_spawned(mob)

var player_is_ready = false
var player_alive = true

@export var mob_to_spawn: PackedScene = null

@onready var marker_3d = %Marker3D
@onready var timer = %Timer

func _on_timer_timeout():
	if player_is_ready and player_alive:
		#spawn a mob every time the timer times out.
		var new_mob = mob_to_spawn.instantiate()
		add_child(new_mob)
		new_mob.global_position = marker_3d.global_position
		mob_spawned.emit(new_mob)
		
func _on_game_player_died():
	player_alive = false


func _on_game_is_player_ready(difficulty):
	player_is_ready = true
	_on_timer_timeout()
	%Timer.wait_time= 12 / difficulty
	%Timer.start()
	
