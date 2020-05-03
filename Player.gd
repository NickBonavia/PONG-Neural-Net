extends RigidBody2D

# Declare member variables here

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Get user input on Player paddle
# and move paddle.
func _on_Player_input_event(viewport, event, shape_idx):
	if event is InputEventScreenDrag:
		self.position.y = event.position.y
	return
