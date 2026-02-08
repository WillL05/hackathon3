extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea

const lines: Array[String] = [
	"hey"
]
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	var text_pos = global_position - Vector2(0,36)
	DialogManager.start_dialog(global_position,lines)
	await DialogManager.dialog_finished
