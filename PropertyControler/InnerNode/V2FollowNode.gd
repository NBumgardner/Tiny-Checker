@tool
class_name V2FollowNode
extends InnerNode


@export var End:V2Wire = V2Wire.new(self)
@export var Cur:V2Wire = V2Wire.new(self)
@export var Start:BoolWire = BoolWire.new(self)
@export var Speed:float = 1

@export var Output:PropertyNode

var counter:V2FollowCounter = V2FollowCounter.new()


func InitNode():
	counter.Speed = Speed
	counter.End = End.Data
	counter.Cur = Cur.Data

func UpdateNode(dt:float):
	if Start.Data:
		counter.End = End.Data
		if not Cur.updated:
			counter.Cur = Cur.Data
			Cur.UpdateNode(dt)
		counter.Update(dt)
		Output.SetData(counter.Data())
		if counter.Finish:
			updated = true
	
	
