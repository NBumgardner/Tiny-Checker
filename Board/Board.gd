class_name Board
extends Node2D


@export var Data:BoardData
@export var BlockLength:float = 50:
	set(value):
		BlockLength = value
		_blockLengthSqrt3 = value*_q3
@export var BlockYPress:float = 0.8
@export var ViewRectWidth:Vector4 = Vector4(200,200,200,200)

var Blocks:Array[Array]
var _q3 = sqrt(3)
var _blockLengthSqrt3:float = BlockLength*_q3
var _BoardRect:Rect2
var AllPlayerCells:Array[BoardCell]
var AllEnemyCells:Array[BoardCell]

func GetCell(p:Vector2i)->BoardCell:
	if p.y<0 or p.x<0:
		return null
	if Blocks.size()>p.y:
		if Blocks[p.y].size()>p.x:
			return Blocks[p.y][p.x]
	return null

func GetPositionInDri(ori:Vector2i,dri:int,dis:int)->Vector2i:
	match dri:
		0:
			if dis%2==0:
				return ori+Vector2i(dis/2,-dis)
			else:
				if ori.y%2 == 0:
					return ori+Vector2i(dis/2,-dis)
				else:
					return ori+Vector2i((dis+1)/2,-dis)
		1:return ori+Vector2i(dis,0)
		2:
			if dis%2==0:
				return ori+Vector2i(dis/2,dis)
			else:
				if ori.y%2 == 0:
					return ori+Vector2i(dis/2,dis)
				else:
					return ori+Vector2i((dis+1)/2,dis)
		3:
			if dis%2==0:
				return ori+Vector2i(-(dis/2),dis)
			else:
				if ori.y%2 == 0:
					return ori+Vector2i(-((dis+1)/2),dis)
				else:
					return ori+Vector2i(-(dis/2),dis)
		4:return ori-Vector2i(dis,0)
		5:
			if dis%2==0:
				return ori+Vector2i(-(dis/2),-dis)
			else:
				if ori.y%2 == 0:
					return ori+Vector2i(-((dis+1)/2),-dis)
				else:
					return ori+Vector2i(-(dis/2),-dis)
	return Vector2i(-1,-1)
func GetCellInDri(ori:Vector2i,dri:int,dis:int)->BoardCell:
	return GetCell(GetPositionInDri(ori,dri,dis))

func GetCellInWalkRange(ori:Vector2i,r:int)->Array[BoardCell]:
	var res:Array[BoardCell]= []
	for i in 6:
		for j in r:
			res.append(GetCellInDri(ori,i,j+1))
	return res

func GetCellInRange(ori:,r:int)->Array[BoardCell]:
	var res:Array[BoardCell]= []
	for i in 6:
		var rd = i+2
		if rd>=6:
			rd -=6
		for j in r:
			res.append(GetCell(GetPositionInDri(GetPositionInDri(ori,i,r),rd,j)))
	return res
	
func GetDri(form:BoardCell,to:BoardCell)->int:
	if form == null or to == null:
		return 0
	var d = to.BoardPosition-form.BoardPosition
	if d.y == 0:
		if d.x>=0:
			return 1
		else:
			return 4
	elif d.y>0:
		if form.BoardPosition.y%2==0:
			if d.x>=0:
				return 2
			else:
				return 3
		else:
			if d.x>0:
				return 2
			else:
				return 3
	else:
		if form.BoardPosition.y%2==0:
			if d.x>=0:
				return 0
			else:
				return 5
		else:
			if d.x>0:
				return 0
			else:
				return 5
				
func GetDis(form:BoardCell,to:BoardCell)->int:
	if form == null or to == null:
		return 0
	var dir = GetDri(form,to)
	match dir:
		0:return form.BoardPosition.y-to.BoardPosition.y
		1:return to.BoardPosition.x-form.BoardPosition.x
		2:return to.BoardPosition.y-form.BoardPosition.y
		3:return to.BoardPosition.y-form.BoardPosition.y
		4:return form.BoardPosition.x-to.BoardPosition.x
		5:return form.BoardPosition.y-to.BoardPosition.y
	return form.BoardPosition.y-to.BoardPosition.y


func GetActuralDis2(form:BoardCell,to:BoardCell)->float:
	var dis = UFN.N2GlobalPosition(form)-UFN.N2GlobalPosition(to)
	dis.y/=0.8
	return dis.length_squared()

func GetCellBettween(form:BoardCell,to:BoardCell)->Array[BoardCell]:
	if form == null or to == null:
		return []
	var res:Array[BoardCell]= []
	var dri = GetDri(to,form)
	var dis = GetDis(to,form)-1
	if dis<0:
		dis = 0
	for i in dis:
		res.append(GetCellInDri(to.BoardPosition,dri,i+1))
	return res


func GetCellInFlyRange(ori:Vector2i,r:float)->Array[BoardCell]:
	var res:Array[BoardCell]= []
	for i in r:
		res.append_array(GetCellInRange(ori,i+1))
	return res

func GetCellInDriJumpRange(p:Pawn,dri:int,r:int)->Array[BoardCell]:
	var res:Array[BoardCell]= []
	if p==null:
		return  res
	if p._boardCell == null:
		return res
	for i in r:
		var cell = GetCellInDri(p._boardCell.BoardPosition,dri,i+1)
		if cell!=null and cell.PawnSlot!=null and cell.PawnSlot not in p.JumpedPawn:
			var cell2 = GetCellInDri(p._boardCell.BoardPosition,dri,i+2)
			if cell2!=null and cell2.CanAddPawn(p):
				res.append(cell2)
		else:
			break
	return res

func GetCellInJumpRange(p:Pawn,r:int)->Array[BoardCell]:
	var res:Array[BoardCell]= []
	for i in 6:
		res.append_array(GetCellInDriJumpRange(p,i,r))
	return res

func CellsNearMouse()->Array[BoardCell]:
	var res:Array[BoardCell] = []
	var ti = PositionToBoardPosition(MouseManager.MousePosition()-UFN.N2GlobalPosition(self))
	var odd:bool = ti.y%2==1
	res.append(GetCell(ti+Vector2i(0,4)))
	if odd:
		res.append(GetCell(ti+Vector2i(0,3)))
		res.append(GetCell(ti+Vector2i(1,3)))
	else:
		res.append(GetCell(ti+Vector2i(-1,3)))
		res.append(GetCell(ti+Vector2i(0,3)))
	res.append(GetCell(ti+Vector2i(0,2)))
	if odd:
		res.append(GetCell(ti+Vector2i(0,1)))
		res.append(GetCell(ti+Vector2i(1,1)))
	else:
		res.append(GetCell(ti+Vector2i(-1,1)))
		res.append(GetCell(ti+Vector2i(0,1)))
	res.append(GetCell(ti+Vector2i(0,0)))
	if odd:
		res.append(GetCell(ti+Vector2i(0,-1)))
		res.append(GetCell(ti+Vector2i(1,-1)))
	else:
		res.append(GetCell(ti+Vector2i(-1,-1)))
		res.append(GetCell(ti+Vector2i(0,-1)))
	res.append(GetCell(ti+Vector2i(0,-2)))
	if odd:
		res.append(GetCell(ti+Vector2i(0,-3)))
		res.append(GetCell(ti+Vector2i(1,-3)))
	else:
		res.append(GetCell(ti+Vector2i(-1,-3)))
		res.append(GetCell(ti+Vector2i(0,-3)))
	res.append(GetCell(ti+Vector2i(0,-4)))
	return res
		
#region PositionTransform

func BoardPositionToPosition(v:Vector2i)->Vector2:
	var off = 0
	if v.y%2 == 1:
		off = _blockLengthSqrt3 / 2
	return Vector2(v.x*_blockLengthSqrt3+off,BlockLength*1.5*v.y*BlockYPress)

func PositionToBoardPosition(v:Vector2)->Vector2i:
	var yi:int=floori((v.y+3.0/4*BlockLength*BlockYPress)/(3.0/2*BlockLength*BlockYPress)) 
	var off:float = 0
	if yi%2==0:
		off+=_blockLengthSqrt3/2
	var xi:int = floori((v.x+off)/_blockLengthSqrt3)
	return Vector2i(xi,yi)
#endregion

#region GenBoard

func Clean():
	for i in get_children():
		(i as Node).queue_free()
	Blocks = []

func GenBoard()->float:
	Clean()
	AllPlayerCells = []
	AllEnemyCells = []
	if Data == null:
		return 0
	for i in Data.Data.size():
		Blocks.append([])
		for j in Data.Data[i].line.size():
			if Data.Data[i].line[j] == 0:
				Blocks[i].append(null)
			elif Data.Data[i].line[j] >0:
				var tem = BoardCell.new()
				tem.BlockData = BoardManager.GetBoardBlockData(Data.Data[i].line[j])
				tem.BoardPosition = Vector2i(j,i)
				#add_child(tem)
				tem.position = BoardPositionToPosition(tem.BoardPosition)
				tem.blockLength = BlockLength
				tem.blockYPress = BlockYPress
				Blocks[i].append(tem)
				tem.GenBoardBlock()
			else:
				var tem = BoardCell.new()
				tem.BlockData = BoardManager.GetEnemyBoardBlockData(-Data.Data[i].line[j]-1)
				tem.BoardPosition = Vector2i(j,i)
				#add_child(tem)
				tem.position = BoardPositionToPosition(tem.BoardPosition)
				tem.blockLength = BlockLength
				tem.blockYPress = BlockYPress
				Blocks[i].append(tem)
				tem.GenBoardBlock()
				AllEnemyCells.append(tem)
	if Data.PlayerBlockStart.x>=0 and Data.PlayerBlockStart.y>=0:
		for i in 10:
			GenOneBlock(PlayerBlockPosition(i),BoardManager.GetPlayerBoardBlockData(i))
	
	var tc = 0
	var tcc = 0
	
	var maxLength = 0
	for i in Blocks:
		tc = tcc
		if i.size()>maxLength:
			maxLength = i.size()
		for j in i:
			if j !=null:
				DelayEventManager.Delay(Callable(j,"Appear"),tc)
				add_child(j)
				tc+=0.02
		tcc+=0.1
	_BoardRect = Rect2(Vector2(-ViewRectWidth[3],-ViewRectWidth[0]),Vector2((maxLength-0.5)*_blockLengthSqrt3,(Blocks.size()-1)*BlockLength*3/2*BlockYPress)+Vector2(ViewRectWidth[3]+ViewRectWidth[1],ViewRectWidth[0]+ViewRectWidth[2]))
	var vpr:Vector2 =  self.get_viewport_rect().size
	var tt = _BoardRect.size-vpr
	if tt.x<0:
		tt.x = 0
	if tt.y<0:
		tt.y=0
	_dragRect = Rect2(-tt/2,tt)
	#add_child(QRect.new(_BoardRect,5,Color(1,1,1,1)))
	return tc
	
func GenOneBlock(p:Vector2i,d:BoardBlockData):
	if Blocks.size()<=p.y:
		for i in p.y-Blocks.size()+1:
			Blocks.append([])
	if Blocks[p.y].size()<=p.x:
		for i in p.x-Blocks[p.y].size()+1:
			Blocks[p.y].append(null)
	if Blocks[p.y][p.x]!=null:
		(Blocks[p.y][p.x] as Node).queue_free()
	
	
	var tem = BoardCell.new()
	tem.BlockData = d
	tem.BoardPosition = p
	#add_child(tem)
	tem.position = BoardPositionToPosition(tem.BoardPosition)
	tem.blockLength = BlockLength
	tem.blockYPress = BlockYPress
	Blocks[p.y][p.x] = tem
	tem.GenBoardBlock()
	AllPlayerCells.append(tem)
	#tem.Appear()

func PlayerBlockPosition(i:int)->Vector2i:
	if i<=3:
		return Data.PlayerBlockStart+Vector2i(i,0)
	elif i<=6:
		if Data.PlayerBlockStart.y%2==0:
			return Data.PlayerBlockStart+Vector2i(i-4,1)
		else:
			return Data.PlayerBlockStart+Vector2i(i-4+1,1)
	elif i<=8:
		return Data.PlayerBlockStart+Vector2i(i-7+1,2)
	else:
		if Data.PlayerBlockStart.y%2==0:
			return Data.PlayerBlockStart+Vector2i(1,3)
		else:
			return Data.PlayerBlockStart+Vector2i(2,3)			
#endregion

#region Drag

var _onDrag:bool = false
var _onDragPosition:Vector2
var _dragOffset:Vector2
var _dragRect:Rect2

func DragDown():
	_onDrag = true
	_onDragPosition = MouseManager.MousePosition()-_dragOffset
	
func DragUp():
	_onDrag = false

func Draging():
	_dragOffset = MouseManager.MousePosition()-_onDragPosition

func SetBoardPosition():
	var p:Vector2 = get_viewport_rect().size/2 - _BoardRect.size/2 - _BoardRect.position
	_dragOffset = UFV.V2CutInRect(_dragOffset,_dragRect)
	position = p+_dragOffset
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("MouseM"):
		DragDown()
	if _onDrag:
		Draging()
	if Input.is_action_just_released("MouseM"):
		DragUp()
	
	SetBoardPosition()
