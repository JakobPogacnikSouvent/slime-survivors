class_name WeightedArray
extends Node

## (item, weigh)
var array : Array


func _init() -> void:
	array = []


func get_random():
	var total = _sum_weights()
	var random = randf_range(0, total)
	
	for i in array:
		var weight = i[1]
		if weight >= total:
			return i[0]
		else:
			total -= weight
	
	return array[-1][0]


func append(item, weight : float) -> void:
	array.append([item, weight])


func _sum_weights() -> float:
	var total = 0.0
	for i in array:
		total += i[1]
		
	return total
