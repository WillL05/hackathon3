extends CharacterBody2D

enum State {
	idle,
	move_right,
	move_left,
	move_up,
	move_down,
	attack_up,
	attack_down,
	attack_left,
	attack_right,
	
}


@export_category("Stats")
@export var speed: int = 400

var state: State = State.idle

var move_direction: Vector2 = Vector2.ZERO

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

var enemy_att_range = false
var enemy_att_cooldown = true
var health = 100
var player_alive = true
var attacking = false

func _physics_process(delta: float) -> void:
		movement_loop()#
		enemy_attack()
		attack()
		if health <= 0:
			player_alive = false
			health = 0 
			print("player died")
	
func movement_loop() -> void:
	move_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	move_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	var motion: Vector2 = move_direction.normalized() * speed
	set_velocity(motion)
	move_and_slide()
	
	
	if motion != Vector2.ZERO:
		if abs(motion.x) > abs(motion.y):
			if motion.x > 0:
				state = State.move_right
				update_animation()
			else:
				state = State.move_left
				update_animation()
		else:
			if motion.y > 0:
				state = State.move_down
				update_animation()
			else:
				state = State.move_up
				update_animation()
	else:
		if attacking == false:
			state= State.idle
		update_animation()

func update_animation() -> void:
	match state:
		State.idle:
			animation_playback.travel("idle")
		State.move_right:
			animation_playback.travel("move_right")
		State.move_left:
			animation_playback.travel("move_left")
		State.move_up:
			animation_playback.travel("move_up")
		State.move_down:
			animation_playback.travel("move_down")
		State.attack_up:
			animation_playback.travel("attack_up")
		State.attack_down:
			animation_playback.travel("attack_down")
		State.attack_left:
			animation_playback.travel("attack_left")
		State.attack_right:
			animation_playback.travel("attack_right")


func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_att_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_att_range = false
		
func enemy_attack():
	if enemy_att_range and enemy_att_cooldown:
		health -= 20
		enemy_att_cooldown = false
		$cooldown.start()
		print("player took damage")
	
func player():
	pass
	
func _on_cooldown_timeout() -> void:
	enemy_att_cooldown = true
	
func attack():
	
	if Input.is_action_pressed("attack"):
		Global.player_current_attack = true
		attacking = true
		var motion: Vector2 = move_direction.normalized() * speed
		if abs(motion.x) > abs(motion.y):
			if motion.x > 0:
				state = State.attack_right
				update_animation()
			else:
				state = State.attack_left
				update_animation()
		else:
			if motion.y > 0:
				state = State.attack_down
				update_animation()
			else:
				state = State.attack_up
				update_animation()
		state = State.attack_down
		update_animation()
		$deal_attack_timer.start()
		


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attacking = false
