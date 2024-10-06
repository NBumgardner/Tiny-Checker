class_name UFM



static func Min(a:float,b:float)->float:
	if a<=b:
		return a
	else:
		return b
		
static func MinVector2(a:Vector2)->float:
	return min(a.x,a.y)


static func Lerp(v1,v2,t:float):
	return v1+t*(v2-v1)
	
	
static func AbsMin(a:float,b:float)->bool:
	if a>0:
		return a<b
	else:
		return a>-b

static func AbsInRange(f:float,r:float)->bool:
	return not(f>r or f<-r)
	
static func PointInRect(p:Vector2,r:Rect2)->bool:
	return p.x>=r.position.x and p.x<=r.position.x+r.size.x and p.y>r.position.y and p.y<r.position.y+r.size.y

static func NumInSortedArray(n:float,a:Array)->int:
	if a.size()<=0:
		return -1
	elif n<0:
		return -1
	elif n>a[-1]:
		return -1
	else:
		var s:int = 0
		var end:int = a.size()-1
		var tem = (s+end)/2
		while s!=end:
			if n>a[tem]:
				s = tem
				if tem == end-1:
					if n>a[end-1]:
						s = end
					else:
						end = s
			else:
				end = tem
			
			tem = (s+end)/2
		return end
		
static func FloatLimit(v:float,m:float)->float:
	if v>=0 and v<m:
		return m
	elif v<0 and v>-m:
		return -m
	return v
	

static func FloatCut(v:float,c:Vector2)->float:
	if c.x<=c.y and v>c.y:
		return c.y
	elif c.x>c.y and v<c.y:
		return c.y
		
	return v
	
static func GetRandonItem(array):
	if array is not Array:
		return null
	else:
		var t = array as Array
		if t.size()<=0:
			return null
		else:
			return t[randi_range(0,t.size()-1)]
