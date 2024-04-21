extends Node3D

var LIGHT = 'LIGHT'
var DARK = 'DARK'

@export var _curr_player = 'Black'

var Z = 'z'
var OPTIONS = [-1, 0, 1]
var FORWARD = 'F'
var BACKWARD = 'B'

var NORTH = 'N'
var SOUTH = 'S'
var EAST = 'E'
var WEST = 'W'

var NORTH_WEST = 'NW'
var NORTH_EAST = 'NE'
var SOUTH_WEST = 'SW'
var SOUTH_EAST = 'SE'

var _curr_move_src = null
var _curr_valid_moves = []

var _prev_move_src = null
var _prev_move_dst = null

var _board = {
	'a1_1': null, 
	'a2_1': null, 
	'a3_3': null,
	'a4_3': null,
	
	# B Rank
	'b1_1': null,
	'b2_1': null,
	'b2_2': null,
	'b3_2': null,
	'b4_2': null,
	'b5_2': null,
	'b4_3': null,
	'b5_3': null,
	'b6_3': null,
	'b7_3': null,
	'b6_4': null,
	'b7_4': null,
	'b8_4': null,
	'b9_4': null,
	'b9_3': null,
	'b10_3': null,
	
	# C
	'c2_2': null,
	'c3_2': null,
	'c4_2': null,
	'c5_2': null,
	'c4_3': null,
	'c5_3': null,
	'c6_3': null,
	'c7_3': null,
	'c6_4': null,
	'c7_4': null,
	'c8_4': null,
	'c9_4': null,
	
	# D
	'd2_2': null,
	'd3_2': null,
	'd4_2': null,
	'd5_2': null,
	'd4_3': null,
	'd5_3': null,
	'd6_3': null,
	'd7_3': null,
	'd6_4': null,
	'd7_4': null,
	'd8_4': null,
	'd9_4': null,
	
	# E
	'e1_1': null,
	'e2_1': null,
	'e2_2': null,
	'e3_2': null,
	'e4_2': null,
	'e5_2': null,
	'e4_3': null,
	'e5_3': null,
	'e6_3': null,
	'e7_3': null,
	'e6_4': null,
	'e7_4': null,
	'e8_4': null,
	'e9_4': null,
	'e9_3': null,
	'e10_3': null,
	
	# F
	'f1_1': null, 
	'f2_1': null, 
	'f3_3': null,
	'f4_3': null,
}

var PAWN_HOME_ROW = [
	# White Pawns
	'a2_1', 'b2_1', 'b3_2', 'c3_2', 'd3_2', 'e2_1', 'e3_2', 'f2_1'
]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Black Pieces
	_board['a1_1'] = 'RookBlackA_1'
	_board['a2_1'] = 'PawnBlackA_1'
	_board['b1_1'] = 'QueenBlack'
	_board['b2_1'] = 'PawnBlackB_1'
	_board['b2_2'] = 'KnightBlackB_2'
	_board['b3_2'] = 'PawnBlackB_2'
	_board['c2_2'] = 'BishopBlackC_2'
	_board['c3_2'] = 'PawnBlackC_2'
	_board['d2_2'] = 'BishopBlackD_2'
	_board['d3_2'] = 'PawnBlackD_2'
	_board['e1_1'] = 'KingBlack'
	_board['e2_1'] = 'PawnBlackE_1'
	_board['e2_2'] = 'KnightBlackE_2'
	_board['e3_2'] = 'PawnBlackE_2'
	_board['f1_1'] = 'RookBlackF_1'
	_board['f2_1'] = 'PawnBlackF_1'
	
	# White Pieces


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _get_file(coordinate: String) -> String:
	var parts = coordinate.split("_")
	var file_rank = parts[0]
	return file_rank[0]


func _get_rank(coordinate: String) -> int:
	var parts = coordinate.split("_")
	var file_rank = parts[0]
	return int(file_rank.substr(1, file_rank.length() - 1))


func _get_z(coordinate: String) -> int:
	var parts = coordinate.split("_")
	return int(parts[1])


func _offset_file(file: String, offset: int) -> String:
	var letters = ['a','b','c', 'd', 'e', 'f']
	var index = letters.find(file)
	var new_index = (index + offset)
	
	if new_index < 0 or new_index >= letters.size():
		return Z
	
	return letters[new_index]


func _move(_start_coord: String, f_offset: int, r_offset: int, z_offset: int):
	var parts = _start_coord.split("_")
	var file_rank = parts[0]
	var z = int(parts[1])
	var file = file_rank[0]
	var rank = int(file_rank.substr(1, file_rank.length() - 1))
	
	var new_f = _offset_file(file, f_offset)
	var new_r = rank + r_offset
	var new_z = z + z_offset
	
	return new_f + str(new_r) + "_" + str(new_z)


func _get_valid_moves(coord: String):
	
	var piece = _board[coord]
	var valid_moves: Array[String] = []
	
	if 'Pawn' in piece:
		# TODO: En Passant
		_pawn(coord, valid_moves)
		_pawn_captures(coord, valid_moves)
		print('Pawn', coord , 'valid moves:', valid_moves)
	elif 'Rook' in piece:
		_rook(coord, valid_moves, NORTH, coord, {})
		_rook(coord, valid_moves, SOUTH, coord, {})
		_rook(coord, valid_moves, EAST, coord, {})
		_rook(coord, valid_moves, WEST, coord, {})
		print('Rook', coord , 'valid moves:', valid_moves)
	elif 'Bishop' in piece:
		_bishop(coord, valid_moves, NORTH_WEST, coord, {})
		_bishop(coord, valid_moves, NORTH_EAST, coord, {})
		_bishop(coord, valid_moves, SOUTH_WEST, coord, {})
		_bishop(coord, valid_moves, SOUTH_EAST, coord, {})
		print('Bishop', coord , 'valid moves:', valid_moves)
	elif 'Queen' in piece:
		_rook(coord, valid_moves, NORTH, coord, {})
		_rook(coord, valid_moves, SOUTH, coord, {})
		_rook(coord, valid_moves, EAST, coord, {})
		_rook(coord, valid_moves, WEST, coord, {})
		_bishop(coord, valid_moves, NORTH_WEST, coord, {})
		_bishop(coord, valid_moves, NORTH_EAST, coord, {})
		_bishop(coord, valid_moves, SOUTH_WEST, coord, {})
		_bishop(coord, valid_moves, SOUTH_EAST, coord, {})
		print('Queen', coord , 'valid moves:', valid_moves)
	else:
		print(piece, "is not a recognized piece.")
	
	return valid_moves


func _on_square_hover(_new_active_coordinate: String):
	
	# New piece selection
	if _curr_move_src == null:
		if _board[_new_active_coordinate] != null:
			_highlight(_new_active_coordinate)
			_curr_move_src = _new_active_coordinate
			if _curr_valid_moves != null:
				for cvm in _curr_valid_moves:
					_unhint(cvm)
			_curr_valid_moves = _get_valid_moves(_new_active_coordinate)
			for c in _curr_valid_moves:
				_hint(c)
		return
		
	# De-select current piece
	if _curr_move_src == _new_active_coordinate:
		_unhighlight(_curr_move_src)
		_curr_move_src = null
		for cvm in _curr_valid_moves:
			_unhint(cvm)
		_curr_valid_moves = []
		return
	
	# Move piece
	if _curr_valid_moves.has(_new_active_coordinate):
		
		if _prev_move_src != null:
			_unhighlight(_prev_move_src)
			
		if _prev_move_dst != null:
			_unhighlight(_prev_move_dst)
		
		_prev_move_src = _curr_move_src
		_prev_move_dst = _new_active_coordinate
		
		var chess_piece: Node3D = get_node(_board[_prev_move_src])
		var tile: CSGBox3D = get_node(_prev_move_dst).get_node('ColorSquare')
		var tile_pos = tile.global_transform.origin
		chess_piece.global_transform.origin = tile_pos + Vector3(0, .48, 0)
		
		_board[_prev_move_dst] = _board[_prev_move_src]
		_board[_prev_move_src] = null
		
		_highlight(_prev_move_src)
		_highlight(_prev_move_dst)
		
		_curr_move_src = null
		for cvm in _curr_valid_moves:
			_unhint(cvm)
		_curr_valid_moves = []
		
		return
	
	# Change piece selection
	if _board[_new_active_coordinate] != null:
		_unhighlight(_curr_move_src)
		_highlight(_new_active_coordinate)
		_curr_move_src = _new_active_coordinate
		if _curr_valid_moves != null:
			for cvm in _curr_valid_moves:
				_unhint(cvm)
		_curr_valid_moves = _get_valid_moves(_new_active_coordinate)
		for c in _curr_valid_moves:
			_hint(c)
		return
	
	_unhighlight(_curr_move_src)
	_curr_move_src = null


func _hint(_coordinate: String):
	var unhinted_area: Area3D = get_node(_coordinate)
	var unhinted_box: CSGCylinder3D = unhinted_area.get_node("HintSquare")
	unhinted_box.visible = true
	unhinted_box.material.emission_enabled = true


func _unhint(_coordinate: String):
	var unhinted_area: Area3D = get_node(_coordinate)
	var unhinted_box: CSGCylinder3D = unhinted_area.get_node("HintSquare")
	unhinted_box.visible = false
	unhinted_box.material.emission_enabled = false
	

func _highlight(_coordinate: String):
	
	var unhighlighted_area: Area3D = get_node(_coordinate)
	var unhighlighted_box: CSGBox3D = unhighlighted_area.get_node("ColorSquare")
	unhighlighted_box.material.albedo_color = Color("#FFFF33")


func _unhighlight(_coordinate: String):
	
	var highlighted_area: Area3D = get_node(_coordinate)
	var highlighted_box: CSGBox3D = highlighted_area.get_node("ColorSquare")
	
	if _get_square_type(_coordinate) == 'light':
		highlighted_box.material.albedo_color = Color('#EBECD0')
	else:
		highlighted_box.material.albedo_color = Color('#739552')


func _get_square_type(_coordinate: String):
	
	# Example coordinate: c2_4
	var parts = _coordinate.split("_")
	var file_rank = parts[0]
	var z = parts[1]
	var file = file_rank[0]
	var rank = int(file_rank.substr(1, file_rank.length() - 1))
	
	if (file == 'a' or file == 'c' or file == 'e'):
		if rank % 2 == 0:
			return 'light'
		else:
			return 'dark'
			
	if (file == 'b' or file == 'd' or file == 'f'):
		if rank % 2 == 0:
			return 'dark'
		else:
			return 'light'


func _is_valid_square(coord: String) -> bool:
	
	if not _board.has(coord):
		# non-existent square
		return false
	
	if _board[coord] != null and _curr_player in _board[coord]:
		# Can't capture own pieces
		return false
	
	return true


func _is_valid_pawn_capture(coord: String) -> bool:
	
	if not _board.has(coord):
		# non-existent square
		return false
	
	if _board[coord] != null and _curr_player in _board[coord]:
		# Can't capture own pieces
		return false
	
	if _board[coord] == null:
		# Pawns can only capture diagonally
		return false
	
	return true


func _pawn_captures(coord: String, valid_moves: Array[String]):
	if _curr_player == LIGHT:
		var new_coord = _move(coord, 1, -1, 0)
		if _is_valid_pawn_capture(new_coord):
			valid_moves.append(new_coord)
		new_coord = _move(coord, -1, -1, 0)
		if _is_valid_pawn_capture(new_coord):
			valid_moves.append(new_coord)
	else:
		var new_coord = _move(coord, 1, 1, 0)
		if _is_valid_pawn_capture(new_coord):
			valid_moves.append(new_coord)
		new_coord = _move(coord, -1, 1, 0)
		if _is_valid_pawn_capture(new_coord):
			valid_moves.append(new_coord)


func _pawn(coord: String, valid_moves: Array[String]):
	
	var distance = 1
	
	if coord in PAWN_HOME_ROW:
		distance = 2
	
	if _curr_player == LIGHT:
		_pawn_helper(coord, valid_moves, NORTH, coord, {}, distance)
	else:
		_pawn_helper(coord, valid_moves, SOUTH, coord, {}, distance)


func _pawn_helper(
	coord: String, 
	moves: Array, 
	d: String, 
	skip: String, 
	seen: Dictionary,
	count: int
) -> Array:
	
	if seen.has(coord):
		return moves
	
	seen[coord] = true
		
	if coord != skip and not _is_valid_square(coord):
		return moves
	
	if coord != skip:
		moves.append(coord)
	
	if count <= 0:
		return moves
	
	var f = _get_file(coord)
	var r = _get_rank(coord)
	var z = _get_z(coord)
	
	if d == NORTH:
		_pawn_helper(f + str(r - 1) + "_" + str(z), moves, d, skip, seen, count - 1)
	elif d == SOUTH:
		_pawn_helper(f + str(r + 1) + "_" + str(z), moves, d, skip, seen, count - 1)
	
	_pawn_helper(f + str(r) + "_" + str(z + 1), moves, d, skip, seen, count)
	_pawn_helper(f + str(r) + "_" + str(z - 1), moves, d, skip, seen, count)
	
	return moves

func _rook(
	coord: String, moves: Array, d: String, skip: String, seen: Dictionary
) -> Array:
	
	if seen.has(coord):
		return moves
	
	seen[coord] = true
		
	if coord != skip and not _is_valid_square(coord):
		return moves
	
	if coord != skip:
		moves.append(coord)
	
	var f = _get_file(coord)
	var r = _get_rank(coord)
	var z = _get_z(coord)
	
	if d == NORTH:
		_rook(f + str(r + 1) + "_" + str(z), moves, d, skip, seen)
	elif d == SOUTH:
		_rook(f + str(r - 1) + "_" + str(z), moves, d, skip, seen)
	elif d == EAST:
		_rook(
			_offset_file(f, -1) + str(r) + "_" + str(z), moves, d , skip, seen
		)
	elif d == WEST:
		_rook(
			_offset_file(f, 1) +  str(r) + "_" + str(z), moves, d , skip, seen
		)
	
	_rook(f + str(r) + "_" + str(z + 1), moves, d, skip, seen)
	_rook(f + str(r) + "_" + str(z - 1), moves, d, skip, seen)

	return moves


func _bishop(
	coord: String, moves: Array, d: String, skip: String, seen: Dictionary
) -> Array:
	
	if seen.has(coord):
		return moves
	
	seen[coord] = true
	
	if coord != skip and not _is_valid_square(coord):
		return moves
	
	if coord != skip:
		moves.append(coord)
	
	var f = _get_file(coord)
	var r = _get_rank(coord)
	var z = _get_z(coord)
	
	if d == NORTH_WEST:
		_bishop(
			_offset_file(f, 1) + str(r - 1) + "_" + str(z), 
			moves, d , skip, seen
		)
	elif d == NORTH_EAST:
		_bishop(
			_offset_file(f, -1) + str(r - 1) + "_" + str(z), 
			moves, d , skip, seen
		)
	elif d == SOUTH_WEST:
		_bishop(
			_offset_file(f, 1) + str(r + 1) + "_" + str(z), 
			moves, d , skip, seen
		)
	elif d == SOUTH_EAST:
		_bishop(
			_offset_file(f, -1) + str(r + 1) + "_" + str(z), 
			moves, d, skip, seen
		)
	
	_bishop(
		f + str(r) + "_" + str(z + 1), moves, d, skip, seen
	)
	_bishop(
		f + str(r) + "_" + str(z - 1), moves, d, skip, seen
	)

	return moves

