class_name TextCountroler
extends Sprite2D


var Visable:bool = false
var PositionAppear:V2BounceCounter = V2BounceCounter.new()
var ScaleAppear:V2BounceCounter = V2BounceCounter.new()
var RotateAppear:FloatBounceCounter = FloatBounceCounter.new()
var AphaAppear:FloatLinerCounter = FloatLinerCounter.new()


var PositionCycle:V2CycleCounter = V2CycleCounter.new()
var ScaleCycle:V2CycleCounter = V2CycleCounter.new()
var RorateCycle:FloatCycleCounter = FloatCycleCounter.new()


var PositionDisappear : V2FollowCounter = V2FollowCounter.new()
var ScaleDisappear:V2FollowCounter = V2FollowCounter.new()
var AphaDisappear:FloatLinerCounter = FloatLinerCounter.new()

var Sound:String

var _state:int = -1
var defaultScale:Vector2



func _init():
	RotateAppear.End = 0
	AphaAppear.Start = 0
	AphaAppear.End = 1
	AphaDisappear.Start = 1
	AphaDisappear.End = 0
	ScaleCycle.Origin = Vector2(1,1)
	PositionAppear.StartVocilty = Vector2(1,1)
	ScaleAppear.StartVocilty = Vector2(1,1)
	RotateAppear.StartVocilty =1
	

func SetPosition(p:Vector2):
	PositionAppear.End = p
	
func SetScale(s:Vector2):
	ScaleAppear.End = s
	defaultScale = s
	
func Hover():
	ScaleAppear.End = defaultScale*1.6
	SoundManager.PlaySound(Sound,-13)
func DeHover():
	ScaleAppear.End = defaultScale
	
func Click():
	ScaleAppear.AddVocility(Vector2(1,1))
	SoundManager.PlaySound(Sound)

func AddVocility(v:Vector2):
	PositionAppear.AddVocility(v)

func SetCycleInit(n:float):
	PositionCycle.SetCycleInit(n)
	ScaleCycle.SetCycleInit(n)
	RorateCycle.SetCycleInit(n)

func SetColor(c:Color):
	self_modulate.r = c.r
	self_modulate.g = c.g
	self_modulate.b = c.b
	
	
func SetApha(a:float):
	self_modulate.a = a
	
	
func SetAnimeData(d:TextAnimeData):
	PositionAppear.Cur = d.AppearPositionStart
	PositionAppear.Speed = d.AppearPositionSpeed
	PositionAppear.Decay = d.AppearPositionDecay
	
	ScaleAppear.Cur = d.AppearScaleStart
	ScaleAppear.Speed = d.AppearScaleSpeed
	ScaleAppear.Decay = d.AppearPositionDecay
	
	RotateAppear.Cur = d.AppearRotateStart
	RotateAppear.Speed = d.AppearRotateSpeed
	RotateAppear.Decay = d.AppearRotateDecay
	
	if d.FadeIn:
		AphaAppear.LinerTime = d.FadeInTime
		AphaAppear.Reset()
	else:
		AphaAppear.LinerTime = 2
		AphaAppear.Count = 2
		
	if d.CyclePositionRange!=Vector2(0,0):
		PositionCycle.Intensity = 1
		PositionCycle.MaxRange = d.CyclePositionRange
		PositionCycle.CycleTime = d.CyclePositionTime
		PositionCycle.Phase = d.CyclePositionPhase
	else:
		PositionCycle.Intensity = 0
		
	if d.CycleScaleRange!=Vector2(1,1):
		ScaleCycle.Intensity = 1
		ScaleCycle.MaxRange = d.CycleScaleRange
		ScaleCycle.CycleTime = d.CycleScaleTime
		ScaleCycle.Phase = d.CycleScalePhase
	else:
		ScaleCycle.Intensity = 0
		
	if d.CycleRotateRange!=0:
		RorateCycle.Intensity = 1
		RorateCycle.MaxRange = d.CycleRotateRange
		RorateCycle.CycleTime = d.CycleRotateTime
	else:
		RorateCycle.Intensity = 0
		
		
	PositionDisappear.End = d.DisappearPositionOffset
	PositionDisappear.Speed = d.DisappearPositionSpeed
	
	ScaleDisappear.End = d.DisappearScaleOffset
	ScaleDisappear.Speed = d.DisappearScaleSpeed
	
	if d.FadeOut:
		AphaDisappear.LinerTime = d.FadeInTime
		AphaDisappear.Reset()
	else:
		AphaDisappear.LinerTime = 2
		AphaDisappear.Count = 0
		AphaDisappear.Finish = true


func IsAppear()->bool:
	return Visable == true and _state == 1
	
func Appear():
	Visable = true
	visible = true
	PositionAppear.Cur+=PositionAppear.End
	ScaleAppear.Cur = UFV.V2Mul(ScaleAppear.Cur,ScaleAppear.End)
	_state = 1
	if AphaAppear.Finish:
		SetApha(0)
	else:
		SetApha(1)
	
func Disappear():
	if _state == 1:
		PositionDisappear.End += position
		PositionDisappear.Cur = position
		ScaleDisappear.End = UFV.V2Mul(ScaleDisappear.End,scale)
		ScaleDisappear.Cur = scale
		_state = 2
	
func Hide():
	_state = -1
	Visable = false
	visible = false
	
func UpdateAppear(dt: float):
	if !PositionAppear.Finish:
		PositionAppear.Update(dt)
	if !PositionCycle.Finish:
		PositionCycle.Update(dt)
	position = PositionAppear.Data()+PositionCycle.Data()
	
	
	if !ScaleAppear.Finish:
		ScaleAppear.Update(dt)
	if !ScaleCycle.Finish:
		ScaleCycle.Update(dt)
	scale = UFV.V2Mul(ScaleAppear.Data(),ScaleCycle.Data())
	
	if !RotateAppear.Finish:
		RotateAppear.Update(dt)
	if !RorateCycle.Finish:
		RorateCycle.Update(dt)
	rotation = RotateAppear.Data()+RorateCycle.Data()
	
	if !AphaAppear.Finish:
		AphaAppear.Update(dt)
		SetApha(AphaAppear.Data())
		
func UpdateDisAppear(dt:float):
	var bp = PositionDisappear.Finish
	var bs = ScaleDisappear.Finish
	var ba = AphaDisappear.Finish
	if bp and bs and ba:
		Hide()
	else:
		if bp:
			PositionDisappear.Update(dt)
			position = PositionDisappear.Data()
		if bs:
			ScaleDisappear.Update(dt)
			scale = ScaleDisappear.Data()
		if ba:
			AphaDisappear.Update(dt)
			SetApha(AphaDisappear.Data())
	
func _process(delta: float) -> void:
	match _state:
		1:
			UpdateAppear(delta)
		2:
			UpdateDisAppear(delta)
