class_name Direction


enum Dir {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	UP_LEFT,
	UP_RIGHT,
	DOWN_LEFT,
	DOWN_RIGHT,
}

static func to_vec(d: Dir) -> Vector2:
	match d:
		Dir.UP:         return Vector2(0, -1)
		Dir.DOWN:       return Vector2(0,  1)
		Dir.LEFT:       return Vector2(-1, 0)
		Dir.RIGHT:      return Vector2( 1, 0)
		Dir.UP_LEFT:    return Vector2(-1, -1).normalized()
		Dir.UP_RIGHT:   return Vector2( 1, -1).normalized()
		Dir.DOWN_LEFT:  return Vector2(-1,  1).normalized()
		Dir.DOWN_RIGHT: return Vector2( 1,  1).normalized()
	return Vector2.ZERO


static func from_vec(v: Vector2) -> Dir:
	var sx: int = sign(v.x) as int
	var sy: int = sign(v.y) as int
	if sx == 0 and sy == -1: return Dir.UP
	if sx == 0 and sy ==  1: return Dir.DOWN
	if sx == -1 and sy == 0: return Dir.LEFT
	if sx ==  1 and sy == 0: return Dir.RIGHT
	if sx == -1 and sy == -1: return Dir.UP_LEFT
	if sx ==  1 and sy == -1: return Dir.UP_RIGHT
	if sx == -1 and sy ==  1: return Dir.DOWN_LEFT
	return Dir.DOWN_RIGHT
