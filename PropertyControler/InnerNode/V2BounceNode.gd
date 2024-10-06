@tool
class_name V2BounceNode
extends InnerNode


@export var End:V2Wire = V2Wire.new(self)
@export var Cur:V2Wire = V2Wire.new(self)
@export var Vocility:V2Wire = V2Wire.new(self)
@export var Start:BoolWire = BoolWire.new(self)
@export var Frequnce:float = 1
@export var Speed:float = 1
@export var Decay:float = 1
@export var BounceRange:float = -1
@export var StartVocilty:Vector2
@export var Output:PropertyNode

var counter:V2BounceCounter = V2BounceCounter.new()


func InitNode():
	counter.Frequnce = Frequnce
	counter.Speed = Speed
	counter.Decay = Decay
	counter.BounceRange = BounceRange
	counter.StartVocilty = StartVocilty
	counter.Cur = Cur.Data
	counter.End = End.Data


func UpdateNode(dt:float):
	if Start.Data:
		counter.End = End.Data
		if not Cur.updated:
			counter.Cur = Cur.Data
			Cur.UpdateNode(dt)
		if not Vocility.updated:
			counter.AddVocility(Vocility.Data)
			Vocility.Data = Vector2(0,0)
			Vocility.UpdateNode(dt)
		counter.Update(dt)
		Output.SetData(counter.Data())
		if counter.Finish:
			updated = true
	
	
