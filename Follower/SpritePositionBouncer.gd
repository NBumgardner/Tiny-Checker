extends Sprite2D

@export var Parent:Node2D
@export var GlobalPosition:bool = false

@export var Speed:float =1:
	set(value):
		Speed = value
		bounce.Speed = value
@export var Decay:float = 1:
	set(value):
		Decay = value
		bounce.Decay = value
@export var Frequnce:float = 1:
	set(value):
		Frequnce = value
		bounce.Frequnce = value

var bounce:V2BounceCounter
var lastParentPosition:Vector2


func SetPosition(p:Vector2):
	bounce.End = p
	
func SetCurPosition(p:Vector2):
	bounce._cur = p

func ParentPosition():
	var res:Vector2 = Vector2(0,0)
	if GlobalPosition:
		var tem = self.get_parent()
		while tem!=null and tem is Node2D:
			res+=tem.position
			tem = tem.get_parent()
		return res
	elif Parent!=null:
		return Parent.position
	else:
		return Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lastParentPosition = ParentPosition()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tem = ParentPosition()
	bounce._cur+lastParentPosition-tem
	lastParentPosition = tem
	bounce.Update(delta)
	position = bounce.Data()
