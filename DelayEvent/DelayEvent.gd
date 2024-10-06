class_name DelayEvent
extends RefCounted

var time:float
var function:Callable


func _init(c:Callable,t:float) -> void:
	function = c
	time= t
	

func Trigger():
	if function.get_object()!=null:
		function.call()
