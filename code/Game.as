package code {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * The class for the Game.
	 */
	public class Game extends MovieClip {

		/** Holds all platform game objects. */
		static public var platforms: Array = new Array();
		
		/** The level for the game. */
		private var level:MovieClip;
		
		/** The player object. */
		private var player:Player;
		
		/** The timer that tracks how long the camera can shake for. */
		private var shakeTimer: Number = 0;
		
		/** The multiplier for the camera shake action. */
		private var shakeMultiplier: Number = 20;

		/**
		 * The constructor function for Game.
		 * Sets up keyboard input and our game loop.
		 */
		public function Game() {
			KeyboardInput.setup(stage);
			addEventListener(Event.ENTER_FRAME, gameLoop);
			
			loadLevel();
		} // ends Game
		
		/**
		 * Loads the first level of the game.
		 * Also loads the player if it doesn't exist.
		 */
		private function loadLevel(): void {
			level = new Level01();
			addChild(level);
			
			if (level.player) {
				player = level.player;
			} else {
				player = new Player();
				addChild(player);
			}
		} // ends loadLevel

		/**
		 * The gameLoop design pattern.
		 * Updates time, the player, and keyboard input.
		 */
		private function gameLoop(e: Event): void {
			Time.update();
			
			player.update();

			doCollisionDetection();
			
			doCameraMove();

			KeyboardInput.update();
		} // ends gameLoop
		
		/**
		 * Shakes the camera whenever a certain condition is met.
		 * @param time The time added to the shakeTimer variable.
		 * @param mult The shake multiplier for the camera.
		 */
		private function shakeCamera(time: Number = .5, mult: Number = 20): void {
			shakeTimer += time;
			shakeMultiplier = mult;
		} // ends shakeCamera
		
		/**
		 * Handles camera movement.
		 * The camera follows the player around the level.
		 */
		private function doCameraMove(): void {
			var targetX: Number = -player.x + stage.stageWidth / 2;
			var targetY: Number = -player.y + stage.stageHeight / 2;
			
			var offsetX: Number = 0;
			var offsetY: Number = 0;
			
			if (shakeTimer > 0){
				shakeTimer -= Time.dt;
				
				var shakeIntensity: Number = shakeTimer;
				
				if (shakeIntensity > 1) shakeIntensity = 1;
				
				shakeIntensity = 1 - shakeIntensity; // flip falloff curve
				shakeIntensity *= shakeIntensity; // bend curve
				shakeIntensity = 1 - shakeIntensity; // flip falloff curve
				
				var shakeAmount: Number = shakeMultiplier * shakeIntensity;
				
				offsetX = Math.random() * shakeAmount - shakeAmount / 2;
				offsetY = Math.random() * shakeAmount - shakeAmount / 2;
			}
			
			var camEaseMultiplier: Number = 5;
			
			level.x += (targetX - level.x) * Time.dt * camEaseMultiplier + offsetX;
			level.y += (targetY - level.y) * Time.dt * camEaseMultiplier + offsetY;
		} // ends doCameraMove

		/**
		 * Detects collision for the player using AABB collision detection and response.
		 */
		private function doCollisionDetection(): void {

			for (var i: int = 0; i < platforms.length; i++) {
				if (player.collider.checkOverlap(platforms[i].collider)) { // if overlapping...
					// find the fix:
					var fix: Point = player.collider.findOverlapFix(platforms[i].collider);
					
					if (fix.y > 0) shakeCamera(.5, 20); // If player hits head, shake the camera.

					// apply the fix:
					player.applyFix(fix);
				}
			} // ends for

		} // ends doCollisionDetection
	} // ends Game class
} // ends package