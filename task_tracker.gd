extends Node

var tasks_completed = 0
var total_tasks = 3

func complete_task():
	tasks_completed += 1
	print("Tasks completed: ", tasks_completed, "/", total_tasks)

func all_tasks_done():
	return tasks_completed >= total_tasks
