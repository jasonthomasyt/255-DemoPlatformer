package code {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * The class for the Game.
	 */
	public class Game extends MovieClip {
		
		/**
		 * The constructor function for Game.
		 * Sets up keyboard input and our game loop.
		 */
		public function Game() {
			KeyboardInput.setup(stage);
			addEventListener(Event.ENTER_FRAME, gameLoop);
		} // ends Game
		
		/**
		 * The gameLoop design pattern.
		 * Updates time, the player, and keyboard input.
		 */
		private function gameLoop(e:Event): void {
			Time.update();
			player.update();
			
			KeyboardInput.update();
		} // ends gameLoop
	} // ends Game class
} // ends package
