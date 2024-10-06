class_name DelayEventWithData
extends DelayEvent

var data

func _init(c:Callable,t:float,d) -> void:
	function = c
	time=  t
	data = d
	
func Trigger():
	if function.get_method() == "add_child":
		if data!=null:
			function.call(data)
	else:
		function.call(data)
