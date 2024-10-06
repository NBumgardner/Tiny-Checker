
class_name CheckContainer
extends Node2D
var last:QChecker
@export var Globel:bool = true

func Check(p:PawnData):
	if last!=null:
		last.Destory()
	if p!=null:
		SoundManager.PlaySound("Check")
		last = QChecker.new(p)
		add_child(last)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globel:
		CheckerManager.GlobalCheckerContainer = self


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MouseL"):
		Check(null)
