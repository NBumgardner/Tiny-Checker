extends Node

@export var b:Board

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DelayEventManager.Delay(Callable(b,"GenBoard"),1)
	
	#b.GenBoard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MouseL"):
		var tem = MouseManager.MousePosition()-UFN.N2GlobalPosition(b)
		print(b.PositionToBoardPosition(tem))
		print(b.ChildOrder(b.PositionToBoardPosition(tem)))
		#UFT.TakeScreenShot(self)
