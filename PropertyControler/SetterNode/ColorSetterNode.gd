class_name ColorSetterNode
extends SetterNode


func _setData(v):
	target.SetColor(data)
	updated = true
