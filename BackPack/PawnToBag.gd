class_name PawnToBag
extends Node2D

@export var TotalTime:float = 1
@export var SpeedCurve:Curve

var Bag:BackPack
var count:float
var data:PawnData
var StartPosition:Vector2
var EndPosition:Vector2
var Item:BackPackPawn
var center:Vector2

func Init(b:BackPack,d:PawnData,st:Vector2,en:Vector2):
	Bag = b
	data = d
	StartPosition = st
	EndPosition = en

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Item = BackPackPawn.new()
	Item.Data = data
	Item.GenSprite()
	Item.position = StartPosition
	add_child(Item)
	center = Vector2((StartPosition.x+EndPosition.x)/2,200)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	count+=delta
	if count>TotalTime:
		count = TotalTime
		Bag.Wubble()
		queue_free()
	var t = SpeedCurve.sample(count/TotalTime)
	Item.position = StartPosition.lerp(center,t).lerp(center.lerp(EndPosition,t),t)
