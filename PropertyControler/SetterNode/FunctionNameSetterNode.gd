class_name FunctionNameSetterNode
extends SetterNode

@export var SetFunctionName : String




func _setData(v):
	target.call(SetFunctionName,data)
	updated = true
