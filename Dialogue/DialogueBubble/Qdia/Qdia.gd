class_name Qdia
extends Node2D


var Size:Vector2
var TextSize:float
var BoxPosition:Vector2
var ChaPosition:Vector2
var Data:QdiaData
var Delay:float

var Cha:Sprite2D
var text:DialogueBubble

var cs:V2BounceCounter

func _init(s:Vector2,textSize:float,boxPosition:Vector2,chacterPosition:Vector2,d:QdiaData,delay:float  =0):
	Size = s
	BoxPosition = boxPosition
	ChaPosition = chacterPosition
	Data = d
	Delay = delay
	TextSize = textSize
	cs = V2BounceCounter.new()
	cs.End = Vector2(1,1)
	cs.Cur = Vector2(1,1)

func SetData(d:QdiaData):
	Data = d
	Cha.texture = d.texture
	text.Text.Data.Text = d.text
	text.Text.HideAllText()
	text.Text.Play()

func ChaBounce():
	cs.AddVocility(Vector2(-0.5,1))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Delay>0:
		Delay-=delta
		if Delay<=0:
			text = (load("res://Dialogue/DialogueBubble/DialogueBubble.tscn")as PackedScene).instantiate()
			Cha = Sprite2D.new()
			Cha.texture = Data.texture
			Cha.position = ChaPosition
			add_child(Cha)
			text.FullSize = Size
			text.position = BoxPosition
			text.Text.Data.Text = Data.text
			text.Text.Data.DefaultHead.Size = TextSize
			add_child(text)
			text.Show()
			text.Text.Play()
	else:
		if !cs.Finish :
			cs.Update(delta)
			Cha.scale = cs.Data()
	
	if Input.is_action_just_pressed("MouseL") and  UFM.PointInRect(MouseManager.MousePosition()-UFN.N2GlobalPosition(text),Rect2(-Size/2,Size)):
		text.Text.Skip()
