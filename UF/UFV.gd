class_name UFV


static func V2InRange(v:Vector2,r:float)->bool:
	return not ( v.x>r or v.x<-r or v.y>r or v.y<-r)


static func V2Limit(v:Vector2,m:float)->Vector2:
	if v.x>=0 and v.x<m:
		v.x = m
	elif v.x<0 and v.x>-m:
		v.x = -m
	if v.y>=0 and v.y<m:
		v.y = m
	elif v.y<0 and v.y>-m:
		v.y = -m
	return v
	

static func V2Cut(v:Vector2,c:Vector2)->Vector2:
	if c.x>=0 and v.x>c.x:
		v.x = c.x
	elif c.x<=0 and v.x<c.x:
		v.x = c.x
	if c.y>=0 and v.y>c.y:
		v.y = c.y
	elif c.y<=0 and v.y<c.y:
		v.y = c.y
	return v


static func V2CutInRect(v:Vector2,r:Rect2)->Vector2:
	var tem = v-r.position
	if tem.x<0:
		tem.x = 0
	if tem.x>r.size.x:
		tem.x = r.size.x
	if tem.y<0:
		tem.y = 0
	if tem.y>r.size.y:
		tem.y = r.size.y
	return tem + r.position

static func V2Rotate(v:Vector2,a:float)->Vector2:
	var s = sin(a)
	var c = cos(a)
	return Vector2(c*v.x-s*v.y,s*v.x+c*v.y)
	
static func V2Rotate90(v:Vector2)->Vector2:
		return Vector2(-v.y,v.x)

static func V2Rotate270(v:Vector2)->Vector2:
	return Vector2(v.y,-v.x)
	
	
	
	
static func V2Mul(v1:Vector2,v2:Vector2)->Vector2:
	return Vector2(v1.x*v2.x,v1.y*v2.y)
	
static func V2Sub(v1:Vector2,v2:Vector2)->Vector2:
	return Vector2(v1.x/v2.x,v1.y/v2.y)


static func V2Interprate(v1:Vector2,v2:Vector2,v3:Vector2,t:float)->Vector2:
	return v1.lerp(v2,t).lerp(v2.lerp(v3,t),t)


static func V2YPress(v:Vector2,y:float)->Vector2:
	return Vector2(v.x,v.y*y)
