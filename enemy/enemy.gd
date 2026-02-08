extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null
var health = 100
var player_in_att_range = false 
var can_take_dmg = true


func _physics_process(delta: float) -> void:
	
	deal_with_damage()
	
	if player_chase and player: # Check 'and player' to avoid crash
		position += (player.position - position) / speed
		
		# Calculate direction for animation
		if abs(player.position.x - position.x) > abs(player.position.y - position.y):
			# Horizontal Movement
			if (player.position.x - position.x) > 0:
				$AnimatedSprite2D.play("move_right")
			else:
				$AnimatedSprite2D.play("move_left") # <--- FIXED THIS LINE
		else:
			# Vertical Movement
			if (player.position.y - position.y) > 0:
				$AnimatedSprite2D.play("move_down")
			else:
				$AnimatedSprite2D.play("move_up")
	else:
		$AnimatedSprite2D.play("idle")

# --- Detection Logic (Keeping your original setup) ---

func _on_detection_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_att_range = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_att_range = false
func deal_with_damage():
	if player_in_att_range and Global.player_current_attack == true:
		if can_take_dmg:
			$take_damage_cooldown.start()
			can_take_dmg = false
			health -= 30
			print("slime took damage")
			if health <= 0:
				self.queue_free()


func _on_take_damage_cooldown_timeout() -> void:
	can_take_dmg = true
