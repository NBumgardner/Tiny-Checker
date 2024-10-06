class_name Money
extends Node2D

@export var Layer:Node2D
var text:QText
var money = 60

var pb:V2BounceCounter
var sb:V2BounceCounter
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = QText.new("60",Color(1,1,1,1),1.7,true)
	Layer.add_child(text)
	text.position = Vector2(100,-30*1.7)
	pb = V2BounceCounter.new()
	sb = V2BounceCounter.new()
	pb.Decay = 0.7
	sb.Decay = 0.7
	pb.End = Vector2(0,-200)
	pb.Cur = Vector2(0,-200)
	sb.End = Vector2(1,1)
	sb.Cur = Vector2(1,1)
	
	
func Show():
	pb.End = Vector2(0,0)
func Hide():
	pb.End = Vector2(0,-200)
func MoneyBounce():
	sb.AddVocility(Vector2(1,1))
	
	
func SetMonry(n:int):
	SoundManager.PlaySound("Gold")
	money = n
	text.SetText(str(n))
	MoneyBounce()
	
func GetMoney(n:int)->bool:
	if money<n:
		MoneyBounce()
		SoundManager.PlaySound("NoMoney")
		return false
	else:
		money-=n
		SetMonry(money)
		return true
func AddMonry(n:int):
	money+=n
	SetMonry(money)

func _process(delta: float) -> void:
	if !pb.Finish:
		pb.Update(delta)
		Layer.position = pb.Data()
	if !sb.Finish:
		sb.Update(delta)
		text.scale = sb.Data()
