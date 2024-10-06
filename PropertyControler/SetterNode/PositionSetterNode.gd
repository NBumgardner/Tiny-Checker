class_name PositionSetterNode
extends SetterNode


func _setData(v):
	target.SetPosition(data)
	updated = true
