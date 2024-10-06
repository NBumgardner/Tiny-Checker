extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tem = DialogueManager.GetTextInstate("D")
	add_child(tem)
	tem.position = Vector2(300,300)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
