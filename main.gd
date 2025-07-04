extends Node

func _ready():
	var total_lines = 0
	var script_files = []
	var dir = DirAccess.open("res://")
	if dir:
		_recursive_script_search(dir, script_files)
	
	for file_path in script_files:
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file:
			var lines = 0
			while not file.eof_reached():
				file.get_line()
				lines += 1
			total_lines += lines
			#print(file_path + ": " + str(lines) + " lines")
	
	print("\nTotal lines of code: " + str(total_lines))

func _recursive_script_search(dir: DirAccess, script_files: Array):
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir() and file_name != "." and file_name != "..":
			var sub_dir = DirAccess.open(dir.get_current_dir() + "/" + file_name)
			_recursive_script_search(sub_dir, script_files)
		elif file_name.ends_with(".gd"):
			script_files.append(dir.get_current_dir() + "/" + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
