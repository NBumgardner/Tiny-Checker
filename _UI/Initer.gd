extends Node2D

@export_multiline var discribe:String 
@export var Show:Shower
@export var MainGame:Game
@export var Lay:Node2D
var DialugurDatas:Array[QdiaData]

var ABG:QTextBox
var GOT:QTextBox

var OnDia:bool = false
var PPP:Qdia
var counter = 0

func InitDia():
	OnDia = true
	PPP = Qdia.new(Vector2(1000,400),0.8,Vector2(600,800),Vector2(1920/2,1080/2),DialugurDatas[0],0.5)
	counter+=1
	Lay.add_child(PPP)
func PlayNext():
	if counter>=DialugurDatas.size():
		OnDia = false
		Lay.queue_free()
		queue_free()
		MainGame.GameStart()
	else:
		PPP.SetData(DialugurDatas[counter])
		counter+=1
		


func Next(n):
	#ABG.Destory()
	GOT.Destory()
	Show.Hide()
	SoundManager.PlaySound("Transform")
	ABG.text.tb.Skip()
	DelayEventManager.Delay(Callable(self,"InitDia"),1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Show.ShowInst()
	ABG = QTextBox.new(discribe,Vector2(1200,700),Color(1,1,1,1),Color(0,0,0,1),0)
	ABG.NoBounce = true
	ABG.position = Vector2(400,500)
	ABG.Speed = 4
	ABG.PoolNum = 200
	add_child(ABG)
	GOT = QTextBox.new("Got It!",Vector2(250,80),Color(1,1,1,1),Color(0,0,0,1),0,true,Callable(self,"Next"),null)
	GOT.position = Vector2(700,850)
	add_child(GOT)
	DialugurDatas.append(QdiaData.new("Hello!\nthanks for comming to play with me!",TextureManager.GetTexture("INT1")))
	DialugurDatas.append(QdiaData.new("I made a checkers game this time. \nHope you like it!\nJust in case you don't know how to play, \nlet me explain the rules.",TextureManager.GetTexture("INT2")))
	DialugurDatas.append(QdiaData.new("It's super easy.\nThere are three types of move.\nMove to neighboring Block\nJumping over a piece\nJumping over multipul pieces in a row",TextureManager.GetTexture("INT3")))
	DialugurDatas.append(QdiaData.new("That's all, the rest is up to you! \nGood Luck!",TextureManager.GetTexture("INT4")))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if OnDia and Input.is_action_just_pressed("MouseL")and PPP.text!=null:
		if PPP.text.Text.finish:
			PlayNext()
		else:
			PPP.text.Text.Skip()
		
