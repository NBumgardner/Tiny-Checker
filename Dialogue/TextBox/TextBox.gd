class_name TextBox
extends Node2D

@export var Area:Rect2

@export var Data:TextData
@export var InterTime:float = 0.060
@export var MinInterTime:float = 0.015
@export var TextSpritePoolNum = 400


var curHead:TextHeader
var curFont:FontSetter
var curAnimeData:TextAnimeData
var curSoundSet:TextSoundSet
var finish:bool = true
var state:int = 0
var charCount:int = 0
var timeCount:float = 0
var timePass:float = 0
var distantPass:float = 0
var offset:Vector2
var textSpritePool:Array[TextCountroler]
var textSpriteCount:int = 0

var TextAppearList:Array[Array]
var TextDisCount:Array[Array]
var TextLineCount:int = 0
var _maxLine = 7

var IsOnScreen:bool = false

func InitTexts():
	for i in TextSpritePoolNum:
		var tem = DialogueManager.GetTextInstate()
		textSpritePool.append(tem)
		add_child(tem)
		
func GetNextText()->TextCountroler:
	var res =  textSpritePool[textSpriteCount]
	textSpriteCount+=1
	if textSpriteCount>=TextSpritePoolNum:
		textSpriteCount = 0
	return res
	
func HideAllText():
	for i in textSpritePool:
		i.Disappear()

func ShowText(c:String,p:Vector2,s:Vector2, d:CharData)->TextCountroler:
	var tem = GetNextText()
	if tem!=null:
		print(c)
		curFont.SetSprite(tem,c)
		tem.SetColor(curHead.TextColor)
		tem.SetPosition(Vector2(p.x+d.rect.size.x/2*s.y,p.y+(d.offset+d.rect.size.x/2)*s.y-curHead.LineOffset))
		tem.SetScale(s)
		tem.SetAnimeData(curAnimeData)
		tem.SetCycleInit(timePass+distantPass/curHead.CycleLength)
		var ts = curSoundSet.SoundName(c)
		if state == 1:
			SoundManager.PlaySound(ts,-10)
		else:
			SoundManager.PlaySound(ts)
		tem.Sound = ts
		tem.Appear()
	return tem
	
func Reset():
	finish = false
	charCount = 0
	timeCount = 0
	state = 0
	offset = Area.position
	timePass = 0
	distantPass = 0
	for i in _maxLine:
		TextAppearList[i].clear()
		TextDisCount[i].clear()
	TextLineCount = 0

func SetHeader(h:TextHeader):
	curHead = h
	curFont = DialogueManager.GetFontSetter(h.FontName)
	curAnimeData = DialogueManager.GetAnimeData(h.AnimeName)
	curSoundSet = DialogueManager.GetSoundSet(h.SountSetName)
	
func Play(d:TextData = null):
	if d!=null:
		Data = d
	if Data == null:
		return 
	SetHeader(Data.DefaultHead)
	Reset()
	IsOnScreen = true
	
func PlayAll():
	Play(null)
	while !finish:
		UpdateNextChar()
		
func Hide():
	HideAllText()
	finish = true
	IsOnScreen = false
	
func NextChar():
	charCount+=1
	if charCount>=Data.Text.length():
		finish = true
		return
	if Data.Text[charCount] == "<":
		if charCount+1<Data.Text.length() and Data.Text[charCount+1] == ">":
			charCount+=2
			SetHeader(Data.DefaultHead)
		elif charCount+2<Data.Text.length() and Data.Text[charCount+2] == ">":
			var c = Data.Text[charCount+1]
			if c in "0123456789":
				var tem:int = c.to_int()
				charCount+=3
				if tem<Data.HeadList.size():
					SetHeader(Data.HeadList[tem])
				else :
					SetHeader(Data.DefaultHead)
	
	
	
	if charCount>=Data.Text.length():
		finish = true

func UpdateNextChar():
	if charCount>=Data.Text.length():
		finish = true
		return 
	var c:String = Data.Text[charCount]
	if c == " ":
		var tem = curFont.GetCharData("-").rect.size.x*curHead.Size+curHead.CharDistant
		offset.x += tem
		distantPass+=tem
		if TextLineCount<_maxLine:
			TextAppearList[TextLineCount].append(null)
			if TextDisCount[TextLineCount].size()<=0:
				TextDisCount[TextLineCount].append(tem)
			else:
				TextDisCount[TextLineCount].append(tem+TextDisCount[TextLineCount][-1])

	elif c == "\n":
		offset.x = Area.position.x
		offset.y +=curHead.LineDistant
		TextLineCount+=1


	else:
		var box:CharData = curFont.GetCharData(c)
		var tt = ShowText(c,offset,Vector2(curHead.Size,curHead.Size),box)
		var tem = box.rect.size.x*curHead.Size+curHead.CharDistant
		offset.x+=tem
		distantPass+=tem
		if TextLineCount<_maxLine:
			TextAppearList[TextLineCount].append(tt)
			if TextDisCount[TextLineCount].size()<=0:
				TextDisCount[TextLineCount].append(tem)
			else:
				TextDisCount[TextLineCount].append(tem+TextDisCount[TextLineCount][-1])
		
	
	NextChar()

func UpdateText(dt:float):
	timeCount+=dt
	var t = InterTime/curHead.Speed
	if state == 1:
		t = MinInterTime
	elif t<MinInterTime:
		t = MinInterTime
	
	
	while timeCount>t and !finish:
		UpdateNextChar()
		timeCount-=t
	timePass+=dt
func Skip():
	state = 1
	
	
func CheckHover():
	var tem = UFN.N2GlobalScale(self)
	var mp = MouseManager.MousePosition()
	var ap = UFN.N2GlobalPosition(self)+UFV.V2Mul(Area.position,tem)
	if UFM.PointInRect(mp,Rect2(ap,Area.size)):
		CheckHoverText(UFV.V2Sub(mp-ap,tem))
	else:
		if lastHoverText!=null:
			lastHoverText.DeHover()
			lastHoverText =null
		

var lastHoverText:TextCountroler = null
func CheckHoverText(dis:Vector2):
	var l:int = floori(dis.y/curHead.LineDistant)
	var h:TextCountroler = null
	if l>=0 and l<_maxLine:
		var tem = UFM.NumInSortedArray(dis.x,(TextDisCount[l]))
		if tem>=0:
			h = TextAppearList[l][tem]
	if h!=null:
		if Input.is_action_just_pressed("MouseL"):
			h.Click()
	if lastHoverText!=h:
		if lastHoverText!=null:
			lastHoverText.DeHover()
		if h!=null:
			h.Hover()
			h.AddVocility(MouseManager.MouseSpeed()*0.006)
		lastHoverText = h


	
	
func _ready() -> void:
	InitTexts()	
	for i in _maxLine:
		TextAppearList.append([])
		TextDisCount.append([])
func _process(delta: float) -> void:
	if !finish:
		UpdateText(delta)
	if IsOnScreen:
		CheckHover()
