extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass


func _on_body_entered(body: Node2D) -> void:
	# FIX: Only register if the body is the Player
	if body.is_in_group("player"):
		InteractionManager.register_area(self)

func _on_body_exited(body: Node2D) -> void:
	# FIX: Only unregister if the body is the Player
	if body.is_in_group("player"):
		InteractionManager.unregister_area(self)
