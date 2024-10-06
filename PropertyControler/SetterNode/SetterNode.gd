class_name SetterNode
extends PropertyNode


@export var TargetIndex:int = 0
var target
var data

func SetData(v):
	data = v
	_setData(v)
	updated = false

func _setData(v):
	pass

func UpdateNode(dt:float):
	pass
