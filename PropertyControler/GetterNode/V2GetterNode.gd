class_name V2GetterNode
extends GetterNode

@export var Data:Vector2
@export var OutPut:PropertyNode


func _data(data:Vector2):
	Data = data
	
func UpdateNode(dt:float):
	OutPut.SetData(Data)
	updated = true
	print((OutPut as V2Wire).Data)
