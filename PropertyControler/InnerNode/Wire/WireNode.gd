class_name WireNode
extends PropertyNode


var parent:PropertyNode

func _init(p:PropertyNode = null):
	parent = p
	updated = true
	
func UpdateNode(dt:float):
	updated = true

func SetData(v):
	_data(v)
	updated = false
	if parent != null:
		parent.updated = false

func _data(v):
	pass
