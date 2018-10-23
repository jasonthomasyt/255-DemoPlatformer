package code {

	import flash.events.KeyboardEvent;
	import flash.display.Stage;

	/**
	 * The KeyboardInput class.
	 * Handles all keyboard input events.
	 */
	public class KeyboardInput {

		/** Boolean flags for each key that is pressed. */
		static public var keyLeft: Boolean = false;
		static public var keyUp: Boolean = false;
		static public var keyRight: Boolean = false;
		static public var keyDown: Boolean = false;
		static public var keyEnter: Boolean = false;
		static public var keySpace: Boolean = false;

		/**
		 * Constructor function for KeyboardInput
		 * @param stage The main scene of the game.
		 */
		static public function setup(stage: Stage) {

			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);

		} // ends KeyboardInput

		/** 
		 * Updates the key booleans when a certain key is pressed.
		 * @param keyCode The keycode of the key that is pressed.
		 * @param isDown Switches to true if the key has been pressed.
		 * @return void This method should not return anything.
		 */
		static private function updateKey(keyCode: int, isDown: Boolean): void {

			if (keyCode == 13) keyEnter = isDown;
			if (keyCode == 32) keySpace = isDown;
			if (keyCode == 65) keyLeft = isDown;
			if (keyCode == 87) keyUp = isDown;
			if (keyCode == 68) keyRight = isDown;
			if (keyCode == 83) keyDown = isDown;

		} // ends updateKey

		/**
		 * If key is pressed, set boolean to true.
		 * @param e The keyboard input event.
		 * @return void This method should not return anything.
		 */
		static private function handleKeyDown(e: KeyboardEvent): void {

			updateKey(e.keyCode, true);

		} // ends handleKeyDown

		/**
		 * If key is not pressed, set boolean to false.
		 * @param e The keyboard input event.
		 * @return void This method should not return anything.
		 */
		static private function handleKeyUp(e: KeyboardEvent): void {

			updateKey(e.keyCode, false);

		} // ends handleKeyUp
	} // ends class
} // ends package