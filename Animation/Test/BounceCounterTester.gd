extends Line2D


var h = 1080
var w = 1920

var t : FloatBounceCounter = FloatBounceCounter.new()
var res : PackedVector2Array

func _ready() -> void:
	t.End = 0
	t.Cur = 0
	t.Decay = 0.5
	t.StartVocilty = 1
	t.AddVocility(-200)
	res = PackedVector2Array()
	for i in 100:
		t.Update(1.0/60)
		res.append(Vector2(i*1920.0/100,(t.Data()*5+1080/2)))
		print(t.last)
		
		
	points = res

	
