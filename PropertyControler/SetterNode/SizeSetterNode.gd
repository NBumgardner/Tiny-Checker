class_name SizeSetterNode
extends SetterNode


func _setData(v):
	target.SetSize(data)
	updated = true
