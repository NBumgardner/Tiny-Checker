class_name SelectBlockA
extends Node2D



var aphaCounter:FloatLinerCounter
var Follower:FloatFollowCounter


var TA:Sprite2D
var RA:Sprite2D
var LA:Sprite2D
var c:Color

var _lq3
var _l
var _yp

func InitSprite():
	var tem1 = Sprite2D.new()
	tem1.texture = TextureManager.GetTexture("SelectTA")
	tem1.z_index = 0
	add_child(tem1)
	TA = tem1
	tem1 = Sprite2D.new()
	tem1.texture = TextureManager.GetTexture("SelectRA")
	tem1.z_index = 0
	add_child(tem1)
	RA = tem1
	tem1 = Sprite2D.new()
	tem1.texture = TextureManager.GetTexture("SelectLA")
	tem1.z_index = 0
	add_child(tem1)
	LA = tem1
	_lq3 = BoardManager.GetLQ3()
	_l = BoardManager.GetL()
	_yp = BoardManager.GetYP()
	


func _init() -> void:
	modulate = Color(1,1,1,0)
	InitSprite()
	aphaCounter = FloatLinerCounter.new()
	aphaCounter.Start = 0
	aphaCounter.End = 0
	aphaCounter.LinerTime = 0.1
	Follower = FloatFollowCounter.new()
	Follower.End = 0
	Follower.Speed = 7
	visible = false

func Appear(s:float = 1):
	aphaCounter.Start = 0
	aphaCounter.End = 1
	aphaCounter.Reset()
	Follower.End = s
	Follower.Cur = 0
	
func DisAppear():
	aphaCounter.Start = 1
	aphaCounter.End = 0
	aphaCounter.Reset()
	Follower.End = 0
	


func SetColor(color:Color):
	c = color

func SetApha(a:float):
	c.a = a
	modulate = c
	
func SetHex(t:float):
	TA.position = Vector2(0,-_l*t*_yp)
	RA.position = Vector2(_lq3+6,_l*_yp)*t/2
	LA.position = Vector2(-_lq3-6,_l*_yp)*t/2

func UpdateData(dt:float):
	if !aphaCounter.Finish:
		aphaCounter.Update(dt)
		var t = aphaCounter.Data()
		SetApha(t)
		if t>0:
			visible = true
		else:
			visible = false
	if !Follower.Finish:
		Follower.Update(dt)
		SetHex(Follower.Data())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdateData(delta)
