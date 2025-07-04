extends Button

var scale_normal = Vector2(1, 1)
var scale_hover = Vector2(1.2, 1.2)
var hover = false
var width = size.x
var height = size.y

func _ready():
	print(height, width) #30 89.4
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	pivot_offset = size / 2

func _process(delta):
	if hover:
		scale = scale.lerp(scale_hover, delta * 10)
	else:
		scale = scale.lerp(scale_normal, delta * 10)

func _on_mouse_entered():
	hover = true

func _on_mouse_exited():
	hover = false
