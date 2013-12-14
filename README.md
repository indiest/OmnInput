OmnInput
========

OmnInput is the only Input System you need for your Flash(AIR) games.

Features:
--------

* Easy-to-use API and configurable
	* The API is designed as three layers: Controllers, InputManager, and OmnInput facade.
	* If you are making a game with simple controls(let's say, just move and jump) and target single platform, you can pick up a Controller class and use them out-of-box.
	```as3
		// Use SPACE key on Keyboard to jump
		var kc:KeyboardController = new KeyboardController(stage);
		kc.keyDownEvent.add(function(key:KeyboardControllerKey) {if (key.keyCode == Keyboard.SPACE) player.jump();});
		// Swipe left/right on the touch screen to move
		var gc:GestouchController = new GestouchController();
		gc.addGesture(new SwipeGesture(player));
		gc.keyDownEvent.add(function(key:GestouchControllerKey) { player.move((key.gesture as SwipeGesture).offsetX);});
	```

	* If you are considering making an arcade game with features like Movement Accerlation and Combos, InputManager will be your best choice.
	```as3
		// Initialize InputManager. An InputManager instance represents a player that uses some of your input devices (keyboard, mouse, joystick, touch screen, etc.)
		var input:InputManager = new InputManager();
		// Add controllers. You can add all types of controllers in one InputManager instance.
		input.addController(new KeyboardController(stage))
			.addController(new MouseController(stage));
		// Add actions which are triggered by Controller Keys. Controller Keys can function only if relevant Controllers are added.
		input.addAction(new InputAction("Left", Vector.<ControllerKey>([
				 KeyboardControllerKey.fromName("LEFT"),
				 KeyboardControllerKey.fromName("A"),
				 MouseControllerKey.DRAG_LEFT
				 ])
			))
			.addAction(new InputAction("Right", Vector.<ControllerKey>([
				 KeyboardControllerKey.fromName("RIGHT"),
				 KeyboardControllerKey.fromName("D"),
				 MouseControllerKey.DRAG_RIGHT
				 ])
			));

		// Add axes which are triggered by negative Controller Keys or positive Controller Keys. Consider an axis as two directions of movement.
		input.addAxis(new InputAxis(InputAxis.AXIS_ID_X, 
				 input.getAction("Left").keys,
				 input.getAction("Right").keys
			))
			.addAxis(new InputAxis(InputAxis.AXIS_ID_Y, 
				 input.getAction("Up").keys,
				 input.getAction("Down").keys
			))

		// Now in your main update function, add these code:
		// This MUST be called. deltaSecond is the interval between two updates.
		input.update(deltaSecond);
		// Query action status
		if (input.isActionActive("Left"))
		{
			// Do something
			trace(input.getAction("Left").isHolding);
		}
		// Or use axis to move objects
		obj.x += 100 * _im.getAxisValue(InputAxis.AXIS_ID_X);
		obj.y += 100 * _im.getAxisValue(InputAxis.AXIS_ID_Y);
	```

	* If you have a superbly complex game which supports multiplayers, and has many in-game characters which have different combo skills, all you need to do is write a player-friendly config textfile and load it with OmnInput.loadConfig():
	```JSON
		{
			"managers":
			[
				{
					"controllers":
					[
						"Keyboard", "Mouse"
					],
					"actions":
					[
						{
							"id": "Move Left", "keys": ["LEFT", "A", "MOUSE DRAG LEFT"]
						},
						{
							"id": "Move Right", "keys": ["RIGHT", "D", "MOUSE DRAG RIGHT"]
						},
						{
							"id": "Move Up", "keys": ["UP", "W", "MOUSE DRAG UP"]
						},
						{
							"id": "Move Down", "keys": ["DOWN", "S", "MOUSE DRAG DOWN"]
						},
						{
							"id": "Shoot", "keys": ["SPACE"], "minHoldTime": 0, "cooldownTime": 0.2
						},
						{
							"id": "Blast", "keys": ["SPACE"], "minHoldTime": 1.0, "cooldownTime": 3.0, "activateOnUnhold": true
						}
					],
					"axes":
					[
						{
							"id": "X", "negativeKeys": "Move Left", "positiveKeys": "Move Right"
						},
						{
							"id": "Y", "negativeKeys": "Move Up", "positiveKeys": "Move Down"
						}
					],
					"combos":
					[
						{
							"id": "Super Shoot", "moves": ["Move Left", "Move Right", "Shoot"]
						}
					]
				}
			]
		}
	```


* Build-in physics features like pressure and axis accerlation.
* Support both event driven and real-time query model for every key status.
* Support controllers:
	* [x] Keyboard
	* [x] Mouse
	* [x] Touch Gestures
	* [ ] Virtual Joystick
	* [ ] OUYA
	* [ ] XBox
	* [ ] Leap Motion

Library dependencies:
--------
* Signal (event system)
* Gestouch (required only if you use GestouchController)

Design Principles:
--------
* In Controllers layer, signals are dispatched when native events(KeyboardEvent, MouseEvent, etc.) are dispatched;
* In InputManager layer, signals are dispatched in update() of InputAction/InputAxis/InputCombo.

Concepts:
--------
* Controller and ControllerKey
* Action and Axis
* Combo

