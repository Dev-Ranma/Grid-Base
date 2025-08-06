extends Node2D

var cellCoordsX : Array = [1]
var cellCoordsY : Array = [1]
var cellCoordsBool : PackedByteArray = []
var cellCoordsTrue : PackedVector2Array = []
var cellGridIndex : Array[Array] # 0: X-Coordinate, 1: Y-Coordinate, 2: Cell Fill
var GridX : float = 600.0
var GridY : float = 600.0
var cellNum : int = 3 #150 is hard limit for number of grid lines
var areLinesActive : bool = true
var areCellsFilled : bool = true
var autorunPre : bool
var autorunPost : bool
@onready var timer = $Timer


func _ready() -> void:
	_grid_points()
	_cell_fill_in()
	_draw()

func _process(delta: float) -> void:
	if autorunPost == true:
		_ret_to_go()

func _draw() -> void:
	var cellWidth : float = GridX / cellNum
	var cellHeight : float = GridY / cellNum
	var cellResiduel : float = cellWidth
	var cellResidual2 : float = cellHeight
	var cellTrueArr : Array =[]
	var i : int
	
	draw_rect(Rect2(0.0, 0.0, GridX, GridY), Color.WHITE, true, -1)
	
	while i < (cellNum * cellNum):
		if cellGridIndex[i][2] == 1:
			draw_rect(Rect2((((cellGridIndex[i][0] - 1.0) / float(cellNum)) * 600 ), (((cellGridIndex[i][1] - 1.0)/ float(cellNum)) * 600 ), cellWidth, cellHeight), Color.BLACK, true)
		i += 1
	
	draw_rect(Rect2(0.0, 0.0, GridX, GridY), Color.RED, false, 4)
	
	if areLinesActive == true:
		for cells in (cellNum - 1):
			var lineStartX = Vector2(cellWidth, 0.0)
			var lineEndX = Vector2(cellWidth, 600.0)
			var lineStartY = Vector2(0.0, cellHeight)
			var lineEndY = Vector2(600.0, cellHeight)
			draw_line(lineStartX, lineEndX, Color.RED)
			draw_line(lineStartY, lineEndY, Color.RED)
			cellWidth += cellResiduel
			cellHeight += cellResidual2

func _grid_points():
	var i : int = 1
	var x : int = 0
	var y : int = 0
	
	for cell in (cellNum * cellNum):
		cellGridIndex.resize(cellNum * cellNum)
		cellGridIndex[cell] = [(x+1), (y+1), 0]
		x += 1
		if x == cellNum:
			x = 0
			y += 1

func _cell_fill_in():
	var randCellsX : PackedInt32Array = []
	var randCellsY : PackedInt32Array = []
	var i : int = 0
	var currentRand : int
	var numOfFills : int = (cellNum * cellNum) * .75
	
	while i < numOfFills:
		i += 1
		currentRand = randi_range(0, ((cellNum * cellNum) - 1))
		cellGridIndex[currentRand][2] = 1
		#cellCoordsBool[currentRand] = true
		#cellCoordsTrue[currentRand] = Vector2(randi_range(1, cellNum), randi_range(1, cellNum))
	#print(cellGridIndex)

func _ret_to_go():
	_grid_points()
	if areCellsFilled == true:
		_cell_fill_in()
	queue_redraw()

func _on_generate_button_pressed() -> void:
	if autorunPre == true:
		autorunPost = true
		#print(autorunPost)
	else:
		autorunPost = false
		#print(autorunPost)
	_ret_to_go()

func _on_grid_num_input_text_changed(new_text: String) -> void:
	cellNum = clampi(int(new_text), 2, 150)
	#new_text = str(cellNum)

func _on_display_lines_check_toggled(toggled_on: bool) -> void:
	areLinesActive = toggled_on

func _on_fill_cells_check_toggled(toggled_on: bool) -> void:
	areCellsFilled = toggled_on

func _on_autorun_check_toggled(toggled_on: bool) -> void:
	autorunPre = toggled_on
	#print(autorunPre)

func _on_timer_timeout() -> void:
	pass
