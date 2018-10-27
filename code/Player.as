package code {

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	/**
	 * The class for the Player object.
	 */
	public class Player extends MovieClip {

		/** Checks if the player is able to double jump. */
		private var canDoubleJump: Boolean = false;
		
		/** Checks if the player has released the jump button. */
		private var releasedJumpButton: Boolean = false;
		
		/** Checks if the player has pressed the space bar. */
		private var spacePressed: Boolean = false;
		
		/** Checks if the player has jumped. */
		private var hasJumped: Boolean = false;

		/** Sets the gravity for the player. */
		private var gravity: Point = new Point(0, 100);
		
		/** Sets the max speed for the player. */
		private var maxSpeed: Number = 200;
		
		/** Sets the velocity for the player. */
		private var velocity: Point = new Point(1, 5);

		/** Sets the horizontal acceleration constant for the player. */
		private const HORIZONTAL_ACCELERATION: Number = 800;
		
		/** Sets the horizontal deceleration constant for the player. */
		private const HORIZONTAL_DECELERATION: Number = 800;

		/** Sets the vertical acceleration constant for the player. */
		private const VERTICAL_ACCELERATION: Number = 3000;
		
		/** Sets the vertical deceleration constant for the player. */
		private const VERTICAL_DECELERATION: Number = 2500;

		/**
		 * The Player constructor class
		 */
		public function Player() {
			// constructor code
		} // ends constructor

		/**
		 * The update design pattern for the player.
		 * Handles physics, walking, jumping, and ground detection.
		 */
		public function update(): void {

			handleJumping();

			handleWalking();

			doPhysics();

			detectGround();

		} // ends update

		/**
		 * Handles the jumping action for the player.
		 */
		private function handleJumping(): void {
			if (KeyboardInput.IsKeyDown(Keyboard.SPACE)) {
				spacePressed = true;

				if (!hasJumped && y > 300) {
					velocity.y -= VERTICAL_ACCELERATION * Time.dt;
				} else if (y <= 300) {
					hasJumped = true;
				}
			} else {
				spacePressed = false;

				if (velocity.y > 0) {
					velocity.y += VERTICAL_DECELERATION * Time.dt; // accelerate left
				}
			}
		} // ends handleJumping

		/**
		 * This function looks at the keyboard input in order to accelerate the player
		 * left or right.  As a result, this function changes the player's velocity.
		 */
		private function handleWalking(): void {
			if (KeyboardInput.IsKeyDown(Keyboard.A)) velocity.x -= HORIZONTAL_ACCELERATION * Time.dt;
			if (KeyboardInput.IsKeyDown(Keyboard.D)) velocity.x += HORIZONTAL_ACCELERATION * Time.dt;

			if (!KeyboardInput.IsKeyDown(Keyboard.A) && !KeyboardInput.IsKeyDown(Keyboard.D)) { // left and right not being pressed...
				if (velocity.x < 0) { // moving left
					velocity.x += HORIZONTAL_DECELERATION * Time.dt; // accelerate right
					if (velocity.x > 0) velocity.x = 0; // clamp at 0
				}

				if (velocity.x > 0) {
					velocity.x -= HORIZONTAL_DECELERATION * Time.dt; // accelerate left
					if (velocity.x < 0) velocity.x = 0; // clamp at 0
				}
			}
		} // ends handleWalking

		/**
		 * Handles physics for the player.
		 * Sets the velocity to the gravity and max speed.
		 */
		private function doPhysics(): void {
			// apply gravity to velocity:
			velocity.x += gravity.x * Time.dt;
			velocity.y += gravity.y * Time.dt;

			// constrain to maxSpeed:
			if (velocity.x > maxSpeed) velocity.x = maxSpeed; // clamp going right
			if (velocity.x < -maxSpeed) velocity.x = -maxSpeed; // clamp going left
			if (velocity.y > maxSpeed) velocity.y = maxSpeed;
			if (velocity.y < -maxSpeed) velocity.y = -maxSpeed;

			// apply velocity to position:
			x += velocity.x * Time.dt;
			y += velocity.y * Time.dt;
		} // ends doPhysics

		/**
		 * Detects when the player has hit the ground.
		 */
		private function detectGround(): void {
			// look at y position
			var ground: Number = 350;
			if (y >= ground) {
				y = ground; // clamp
				velocity.y = 0;
				canDoubleJump = true;
				releasedJumpButton = false;
				if (!KeyboardInput.IsKeyDown(Keyboard.SPACE)) {
					hasJumped = false;
				}
			} else {
				handleDoubleJump();
			}
		} // ends detectGround

		/**
		 * Handles the double jump action for the player.
		 * Checks to see if the player is able to double jump while in the air.
		 */
		private function handleDoubleJump(): void {
			if (spacePressed == false) {
				releasedJumpButton = true;
			}

			if (canDoubleJump && releasedJumpButton && spacePressed) {
				velocity.y = 0;
				velocity.y -= VERTICAL_ACCELERATION * Time.dt;
				canDoubleJump = false;
			}
		} // ends handleDoubleJump
	} // ends Player class

} // ends package