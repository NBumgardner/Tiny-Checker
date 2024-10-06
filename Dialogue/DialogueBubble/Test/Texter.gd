extends Node

@export var t:DialogueBubble
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tem = Qdia.new(Vector2(400,400),1,Vector2(500,500),Vector2(400,400),QdiaData.new("asasdasasasddsd\nddddddddadadasdas\ndasdasdasdasdasdddasda",null),2)
	
	add_child(tem)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("MouseL"):
		#t.Show()
		#t.Text.Play()
	#if Input.is_action_just_pressed("MouseR"):
		#t.Hide()
