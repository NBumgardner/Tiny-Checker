class_name FloatGetterNode
extends GetterNode

@export var Data:float
@export var OutPut:PropertyNode


func _data(data:float):
	Data = data
	
func UpdateNode(dt:float):
	OutPut.SetData(Data)
	updated = true
