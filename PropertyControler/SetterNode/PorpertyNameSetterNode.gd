class_name PorpertyNameSetterNode
extends SetterNode

@export var SetPorpertyName : String




func _setData(v):
	target.set(SetPorpertyName,data)
	updated = true
