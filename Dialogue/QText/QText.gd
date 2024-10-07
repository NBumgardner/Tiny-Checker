class_name QText
extends Node2D

var tb:TextBox
var tbPrefab:PackedScene = load("res://Dialogue/QText/QTextPrefab.tscn")
var Inst:bool = false



func SetText(s:String):
	tb.Data.Text = s
	tb.Hide()
	if Inst:
		tb.PlayAll()
	else:
		tb.Play()


func _init(s:String,c:Color,size:float,inst:bool = false,mute:bool = true,poolNum:int = 30) -> void:
	tb = tbPrefab.instantiate()
	tb.Data.DefaultHead.TextColor = c
	tb.Data.Text = s
	tb.Data.DefaultHead.Size  =size
	tb.Data.DefaultHead.LineDistant*=size
	tb.TextSpritePoolNum = poolNum

	if mute:
		tb.Data.DefaultHead.SountSetName = "Mute"
	Inst = inst
		
	add_child(tb)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Inst:
		tb.PlayAll()
	else:
		tb.Play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
