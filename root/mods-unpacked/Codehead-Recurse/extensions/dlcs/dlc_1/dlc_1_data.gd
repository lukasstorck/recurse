extends "res://dlcs/dlc_1/dlc_1_data.gd"

func recurse_item(item_data: ItemParentData, player_index: int) -> ItemParentData:
	var base_item

	# find base version of item
	if item_data is ItemData:
		base_item = ItemService.get_item_from_id(item_data.my_id)
	else:
		base_item = ItemService.get_element(ItemService.weapons, item_data.my_id)
	

	# apply curse that is atleast as strong as before
	var recursed_item = .curse_item(base_item, player_index, false, item_data.curse_factor)
	return recursed_item
