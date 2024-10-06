extends Node


var events:Array[DelayEvent]


func Delay(c:Callable,t:float):
	events.append(DelayEvent.new(c,t))

func DelayWithData(c:Callable,t:float,d):
	events.append(DelayEventWithData.new(c,t,d))

func UpdateEvent(dt:float):
	for i in events:
		i.time-=dt
		if i.time<=0:
			i.Trigger()
		

func ClearEvent():
	var d:int = 0
	for i in events.size():
		if events[i-d].time<=0:
			events.remove_at(i-d)
			d+=1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if delta>0.1:
		delta = 0.1
	UpdateEvent(delta)
	ClearEvent()
