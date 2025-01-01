class_name WeightedArray
extends Node

## (item, weigh)
var array : Array


func _init() -> void:
	array = []


func pop_random():
	var total = _sum_weights()
	var random = randf_range(0, total)
	
	for i in range(len(array)):
		var item = array[i]
		var weight = item[1]
		if weight >= random:
			array.remove_at(i)
			return item[0]
		else:
			random -= weight
	
	var item = array.pop_back()
	return item[0]


func append(item, weight : float) -> void:
	array.append([item, weight])


func _sum_weights() -> float:
	var total = 0.0
	for i in array:
		total += i[1]
		
	return total
