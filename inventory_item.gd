extends Resource
#----------------------------------------------------------------------------
# Since im not smart enough rn to code my own inventory system
# im going to use one i found on yt by DevWorm
# https://www.youtube.com/watch?v=X3J0fSodKgs&t=132s
# This file is for the Item itself and it stores the Name and the Icon
# We have to call this resource every time we wanna make a new item
# 
# TL;DR This holds item data
# Select the inventory_item.gd script and then save
#----------------------------------------------------------------------------
class_name InvItem

@export var name: String = ""
@export var texture: Texture2D
