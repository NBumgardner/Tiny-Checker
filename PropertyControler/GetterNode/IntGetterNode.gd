class_name IntGetterNode
extends GetterNode

@export var Data:int
@export var OutPut:PropertyNode



func _data(data:int):
	Data = data
	
func UpdateNode(dt:float):
	OutPut.SetData(Data)
	updated = true
