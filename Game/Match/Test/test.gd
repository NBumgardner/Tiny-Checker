extends Node

@export var t: GameData
@export var m:Match
@export var b:BackPack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m.Data = t.MatchList[0]
	m.PawnPack = b
	m.InitMatch()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MouseL"):
		UFT.TakeScreenShot(self)
