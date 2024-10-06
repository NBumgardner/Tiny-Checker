class_name GameCounter
extends Node2D


@export var st:Sprite2D
@export var sb:Sprite2D
@export var PlayerTexture:Texture
@export var OppoenetTexture:Texture

var pBounce:V2BounceCounter

var r:FloatBounceCounter

func PlayerTurn():
	st.texture = PlayerTexture
	sb.texture = OppoenetTexture
	pBounce.End = Vector2(0,0)
	pBounce.Cur = Vector2(-300,0)
	st.position = Vector2(-300,0)
	r.AddVocility(0.7)
	SoundManager.PlaySound("Counter")

func OpponentTurn():
	st.texture = OppoenetTexture
	sb.texture =  PlayerTexture
	pBounce.End = Vector2(0,0)
	pBounce.Cur = Vector2(-300,0)
	st.position = Vector2(-300,0)
	r.AddVocility(0.7)	
	SoundManager.PlaySound("Counter2")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pBounce = V2BounceCounter.new()

	r = FloatBounceCounter.new()
	r.Speed = 2
	r.Decay = 0.4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !pBounce.Finish:
		pBounce.Update(delta)
		st.position = pBounce.Data()
	if !r.Finish:
		r.Update(delta)
		rotation = r.Data()
		

	
