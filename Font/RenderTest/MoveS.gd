extends Sprite2D



var t:bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if t:
		position = position + Vector2(10,0)
		t = false
		
	else:
		position = position + Vector2(-10,0)
		t = true
