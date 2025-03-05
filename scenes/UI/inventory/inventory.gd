extends Resource

class_name Inv
# TO DO: https://www.youtube.com/watch?v=fyRcR6C5H2g
# This is a file from the second tutorial

signal update

@export var items: Array[InvItem]

func insert(item: InvItem):
	var itemslot = items.filter(func(slot): return slot.item == item)
	if !itemslot.is_empty():
		itemslot[0].amount += 1
	else:
		var emptyslot = items.filter(func(slot): return slot.item == null)
	
