extends Node

signal punish_AI()

onready var Num = get_node("/root/NumGD")

# Declare member variables here. Examples:
export (bool) var recordStats = false
onready var play = false
onready var hits : float = 0.0
onready var misses : float = 0.0
onready var minPassed = 0
var statsFile : File
var filenameDate : String

# Called when the node enters the scene tree for the first time.
func _ready():
	if recordStats == true:
		statsFile = File.new()
		var time = OS.get_datetime()
		var sec = str(time.second)
		var minu = str(time.minute)
		var hour = str(time.hour)
		filenameDate = "AIStats_"+hour+minu+sec+".csv"
		$StatsTimer.start(300)

# Signal handler for ball entering
# Player goal
func _on_AreaGoalP_body_entered(body):
	print("AI Scored")
	$Ball.resetBall()

# Signal handlerfor ball entering
# AI goal. Emits the punish_AI singal
# when training
func _on_AreaGoalAI_body_entered(body):
	print("Player Scored")
	if play == false:
		emit_signal("punish_AI")
	$Ball.resetBall()

# Signal handler for Save button
# being pressed
func _on_SaveButton_pressed():
	get_tree().paused = true
	var filename = $GUI/SaveTextBox.text
	var file = File.new()
	file.open(filename, File.WRITE);
	file.store_line(JSON.print($AI_Player.STM))
	file.close()
	get_tree().paused = false

# Signal handler for Load button
# being pressed.
func _on_LoadButton_pressed():
	get_tree().paused = true
	var filename = $GUI/LoadTextBox.text
	var file = File.new()
	file.open(filename, File.READ);
	$AI_Player.STM.clear()
	$AI_Player.stateStack.clear()
	$AI_Player.position.y = 300
	$AI_Player.STM = JSON.parse(file.get_as_text()).result
	$Ball.position = Vector2(300, 300)
	file.close()
	get_tree().paused = false

# Signal handler for switching between
# Train mode and play mode
func _on_PlayMode_pressed():
	get_tree().paused = true
	# if play mode allow user input
	# else make wall for 'perfect'
	if $GUI/PlayMode.pressed == true:
		$Player.scale.y = 1
		$Player.input_pickable = true
		play = true
	else:
		$Player.scale.y = 10
		$Player.position.y = 300
		$Player.input_pickable = false
		play = false
	get_tree().paused = false

# Write hit/miss ratio to csv every 5 minutes
func _on_StatsTimer_timeout():
	minPassed += 5
	if !statsFile.file_exists(filenameDate):
		statsFile.open(filenameDate, File.WRITE)
	else:
		statsFile.open(filenameDate, File.READ_WRITE)
	statsFile.seek_end()
	statsFile.store_line(str(hits/(misses+hits)) + "," + str(minPassed))
	statsFile.close()
	hits = 0.0
	misses = 0.0
	$StatsTimer.start(300)