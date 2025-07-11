extends Node3D
@onready var score_label = $ScoreLabel
signal player_died
signal is_player_ready

var difficulty = 1
var score = 0
var mobs_alive = 0
var player_HP = 100
var player_ready = false
var player_dead = false

func player_is_ready():
	player_ready = true
	%SeptemberSky.play()
	is_player_ready.emit(difficulty)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and player_HP > 0 and not player_ready:
		player_is_ready()

	if event.is_action_pressed("1") and not player_ready:
		update_labels(0,0,0,1)
		player_is_ready()
	if event.is_action_pressed("2") and not player_ready:
		update_labels(0,0,0,2)
		player_is_ready()
	if event.is_action_pressed("3") and not player_ready:
		update_labels(0,0,0,3)
		player_is_ready()
	if event.is_action_pressed("4") and not player_ready:
		update_labels(0,0,0,4)
		player_is_ready()
	if event.is_action_pressed("5") and not player_ready:
		update_labels(0,0,0,5)
		player_is_ready()
		
	elif event.is_action_pressed("ui_accept") and player_HP <= 0 or event.is_action_pressed("reset"):
		get_tree().reload_current_scene.call_deferred()
	
	

func update_labels(sc:int, alive:int, hp: int, diff: int):
	if (diff != 0):
		difficulty = diff
		return
	
	player_HP += hp
	%DirectionalLight3D.light_energy = player_HP * 3.0 / 100.0
	%WorldEnvironment.environment.background_color = Color(0.0 + 0.01*max((100-player_HP), 0.00001), 0.207 * player_HP / 100, 0.437 * player_HP / 100)
	%WorldEnvironment.environment.glow_intensity = 1.47 * ((100 - player_HP) / 50 + 1)
	%SeptemberSky.pitch_scale = (-(100.0-player_HP) / 100 + 1.2)
	var label_text = "Score: " + str(score) + "\nBats Alive: " + str(mobs_alive) + "\nHP: " + str(player_HP) + "\nDifficulty (1-5): " + str(difficulty)
	if player_HP <= 0 and not player_dead:
		player_dead = true
		%SeptemberSky.stop()
		%GameOver.play()
		player_died.emit()
		score_label.text = label_text + "\n YOU HAVE PERISHED. Press F1 to Respawn..."
	elif not player_dead:
		score += sc
		mobs_alive += alive
		label_text = "Score: " + str(score) + "\nBats Alive: " + str(mobs_alive) + "\nHP: " + str(player_HP) + "\nDifficulty (1-5): " + str(difficulty)
		score_label.text = label_text

func do_puff(mob_global_position):
	const SMOKE_PUFF = preload("res://mob/smoke_puff/smoke_puff.tscn")
	var puff = SMOKE_PUFF.instantiate()
	add_child(puff)
	puff.global_position = mob_global_position
	
func increase_score():
	update_labels(1, -1, 0, 0)
	
func decrease_HP():
	update_labels(0,0,-10 * difficulty, 0)

func _on_mob_body_entered(body):
	if body.name == "Player":
		update_labels(0,0,-10, 0)

func _on_mob_spawner_3d_mob_spawned(mob):
	update_labels(0, 1, 0, 0)
	mob.died.connect(increase_score)
	mob.puff.connect(func():
		do_puff(mob.global_position)
		)
	mob.touched_player.connect(decrease_HP)
	do_puff(mob.global_position)

func _on_kill_plane_body_entered(body):
	if body.name == "Player":
		update_labels(0,0,-player_HP, 0)
