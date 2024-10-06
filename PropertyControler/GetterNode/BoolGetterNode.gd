class_name BoolGetterNode
extends GetterNode

@export var Data:bool
@export var OutPut:PropertyNode


func _data(data:bool):
	Data = data
	
func UpdateNode(dt:float):
	OutPut.SetData(Data)
	updated = true
