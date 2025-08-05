extends Node2D

var cellCoordsX : Array = [1]
var cellCoordsY : Array = [1]
var cellCoordsBool : PackedByteArray = []
var cellCoordsTrue = {}
var GridX : float = 600.0
var GridY : float = 600.0
var cellNum : int = 3 #150 is hard limit for number of grid lines
var areLinesActive : bool = true
var areCellsFilled : bool = true

func _ready() -> void:
	_grid_points()
	_cell_fill_in()
	_draw()

func _process(delta: float) -> void:
	pass
	

func _draw() -> void:
	var cellWidth : float = GridX / cellNum
	var cellHeight : float = GridY / cellNum
	var cellResiduel : float = cellWidth
	var cellResidual2 : float = cellHeight
	var cellTrueArr : Array =[]
	var i : int
	
	draw_rect(Rect2(0.0, 0.0, GridX, GridY), Color.WHITE, true, -1)
	
	while i < (cellNum * cellNum):
		if cellCoordsBool[i] == 1:
			#print(((float(cellCoordsTrue[i].x) / float(cellNum)) * 600 ), ", ", ((float(cellCoordsTrue[i].y) / float(cellNum)) * 600))
			draw_rect(Rect2((((cellCoordsTrue[i].x - 1.0) / float(cellNum)) * 600 ), (((cellCoordsTrue[i].y - 1.0)/ float(cellNum)) * 600 ), cellWidth, cellHeight), Color.BLACK, true)
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
	while i < (cellNum):
		i += 1
		cellCoordsX.append(i)
		cellCoordsY.append(i)
	cellCoordsBool.resize((cellNum * cellNum))
	cellCoordsBool.fill(0)
	#print("(", cellCoordsX, ", ", cellCoordsY, ")")
	#print(cellCoordsBool)

func _cell_fill_in():
	var randCellsX : PackedInt32Array = []
	var randCellsY : PackedInt32Array = []
	var i : int = 0
	var currentRand : int
	var numOfFills : int = (cellNum * cellNum) * .75#randi_range((cellNum), (cellNum * 2.5))
	
	while  i < numOfFills:
		randCellsX.append(randf_range(1, (cellNum + 1)))
		randCellsY.append(randf_range(1, (cellNum + 1)))
		currentRand = clamp((randCellsX[i] * randCellsY[i]), 0, ((cellNum * cellNum) -1))
		cellCoordsBool[currentRand] = 1
		cellCoordsTrue.set(currentRand, Vector2(randCellsX[i], randCellsY[i]))
		i += 1
	#print(cellCoordsBool)
	#print(cellCoordsTrue)

func _on_generate_button_pressed() -> void:
	_grid_points()
	if areCellsFilled == true:
		_cell_fill_in()
	queue_redraw()

func _on_grid_num_input_text_changed(new_text: String) -> void:
	cellNum = clampi(int(new_text), 2, 150)
	#new_text = str(cellNum)

func _on_display_lines_check_toggled(toggled_on: bool) -> void:
	areLinesActive = toggled_on

func _on_fill_cells_check_toggled(toggled_on: bool) -> void:
	areCellsFilled = toggled_on
