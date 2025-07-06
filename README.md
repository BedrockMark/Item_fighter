# Psyclean_heartship
Psyclean heartship reborn

# Notes
### Naming conventions
- For files, I tend to use snake_case ---> mob_data_test_demo_refined.gd
- For class names, Godot use PascalCase ---> class_name MobData extend Resource
- For functions, Godot use snake_case ---> func attack_with_ability():
- For nodes, Godot use PascalCase ---> $SceneManager
- For variables, camelCase can fit because python do it ---> var abilityCoolDownCount: float = 10.0
- For abilities/buffs, PascalCase, as they represent functions ---> var ability:= {"OneHundredThousandVolt", 1}

# TODO List
### 1. Scenes
- Basic class structure refine -> res://class/
	- ~~item~~, mob, ~~item category~~, buff
- ~~Scene manager~~ -> res://scene/scene_manager.tscn
	- ~~Demo scene~~ -> res://scene/arena/demo.tscn
- UI -> res://UI/ui_manager.tscn
	- GUI.tscn
	- Menu.tscn
	- Setting.tscn
- Inventory -> res://class/inventory.gd
	- Input_item, has_item, take_item, remove_item
- Finite state machine
	- Enemy states, friendly states, (NPC states?)

### 2. Data/formula
- Health <-> dmg setting
	- ~~DMG calculation~~
	- General HP/DMG/Defence level
	- Upgrade setting (both for players and enemies)
- Physical setting
	- Speed?
	- Collision rebounce?
	- Shape?
- Capability
	- ~~How many item, weapon, ability can player/mobs have~~

### 3. Asset
- Item Category
	- Category Icon, Category theme
- Item
	- Default icon, holded icon, inventory icon, shooted icon
