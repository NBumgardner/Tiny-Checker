class_name SelectPawn
extends Node2D


var Rect:Rect2
var aphaCounter:FloatLinerCounter
var Follower:FloatFollowCounter


var TR:Sprite2D
var BR:Sprite2D
var BL:Sprite2D
var TL:Sprite2D
var c:Color = Color(1,1,1,1)


func InitSprite():
	var tem1 = Sprite2D.new()
	tem1.texture = TextureManager.GetTexture("SelectTR")
	tem1.z_index = 1
	add_child(tem1)
	TR = tem1
	tem1 = Sprite2D.new()
	tem1.texture = TextureManager.GetTexture("SelectBR")
	tem1.z_index = 1
	add_child(tem1)
	BR = tem1
	tem1 = Sprite2D.new()
	tem1.texture = TextureManager.GetTexture("SelectBL")
	tem1.z_index = 1
	add_child(tem1)
	BL = tem1
	tem1 = Sprite2D.new()
	tem1.texture = TextureManager.GetTexture("SelectTL")
	tem1.z_index = 1
	add_child(tem1)
	TL = tem1


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

func Appear(s:float = 1,c:Color = Color(1,1,1,1)):
	aphaCounter.Start = 0
	aphaCounter.End = 1
	aphaCounter.Reset()
	Follower.End = s
	Follower.Cur = 0
	SetColor(c)
	
func DisAppear():
	aphaCounter.Start = 1
	aphaCounter.End = 0
	aphaCounter.Reset()
	Follower.End = 0


func SetColor(color:Color):
	c = color
	modulate = c
func SetApha(a:float):
	c.a = a
	modulate = c
	
func SetRect(t:float):
	TL.position = Rect.position+Rect.size/2*(1-t)
	TR.position = Rect.position+Vector2(Rect.size.x,0) + Vector2(-Rect.size.x,Rect.size.y)/2*(1-t)
	BL.position = Rect.position+Vector2(0,Rect.size.y) + Vector2(Rect.size.x,-Rect.size.y)/2*(1-t)
	BR.position = Rect.position+Rect.size + -Rect.size/2*(1-t)

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
		SetRect(Follower.Data())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdateData(delta)
