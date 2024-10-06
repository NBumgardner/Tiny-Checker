extends Node

var t:QText
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	t=  QText.new("ddddddd",Color(1,1,0),true)
	add_child(t)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MouseL"):
		t.SetText("Asdasd")
