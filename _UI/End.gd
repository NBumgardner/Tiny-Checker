class_name GameIsEnd
extends Node


@export var Show:Shower

var DialugurDatas:Array[QdiaData]
var OnDia:bool = false
var PPP:Qdia
var counter = 0

func InitDia():
	Show.Show()
	OnDia = true
	PPP = Qdia.new(Vector2(1000,400),0.8,Vector2(600,800),Vector2(1920/2,1080/2),DialugurDatas[0],1)
	counter+=1
	PPP.text
	add_child(PPP)
func PlayNext():
	if counter<DialugurDatas.size():
		PPP.SetData(DialugurDatas[counter])
		counter+=1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialugurDatas.append(QdiaData.new("Well, this is the end.
Thank you for playing till the end.",TextureManager.GetTexture("INT2")))
	DialugurDatas.append(QdiaData.new("Sorry for not having a decent ending.
That's all I could do in 48 hours.",TextureManager.GetTexture("INT2")))
	DialugurDatas.append(QdiaData.new("In fact, lot of interesting stuff 
were dropped because of time issues
Maybe I ll find time to finish them.",TextureManager.GetTexture("INT2")))
	
	DialugurDatas.append(QdiaData.new(".   .   .   .   ",TextureManager.GetTexture("INT2"))) # Replace with function body.
	DialugurDatas.append(QdiaData.new("See you next time!",TextureManager.GetTexture("INT1")))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if OnDia and Input.is_action_just_pressed("MouseL")and PPP.text!=null:
		PlayNext()
