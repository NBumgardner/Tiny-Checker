extends Node


@export var C:TextBox

var fc = FrameRateCounter.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	C.Play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fc.Update(delta)
	if Input.is_action_just_pressed("MouseL"):
		UFT.TakeScreenShot(self)
