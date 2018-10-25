package code {

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.ui.Keyboard;


	public class Player extends MovieClip {

		private var canDoubleJump: Boolean = false;
		private var releasedJumpButton: Boolean = false;
		private var spacePressed: Boolean = false;
		private var hasJumped: Boolean = false;

		private var gravity: Point = new Point(0, 100);
		private var maxSpeed: Number = 200;
		private var velocity: Point = new Point(1, 5);

		private const HORIZONTAL_ACCELERATION: Number = 800;
		private const HORIZONTAL_DECELERATION: Number = 800;

		private const VERTICAL_ACCELERATION: Number = 800;
		private const VERTICAL_DECELERATION: Number = 800;

		public function Player() {
			// constructor code
		} // ends constructor

		public function update(): void {

			handleJumping();

			handleWalking();

			doPhysics();

			detectGround();

		} // ends update

		private function handleJumping(): void {
			if (KeyboardInput.IsKeyDown(Keyboard.SPACE)) {
				spacePressed = true;

				if (!hasJumped && y > 250) {
					velocity.y -= VERTICAL_ACCELERATION * Time.dt;
				} else if (y <= 250) {
					hasJumped = true;
				}
			} else {
				spacePressed = false;

				if (velocity.y > 0) {
					velocity.y += VERTICAL_DECELERATION * Time.dt; // accelerate left
				}
			}
		}

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
		}

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
		}

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
		}

		private function handleDoubleJump(): void {
			if (spacePressed == false) {
				releasedJumpButton = true;
			}

			if (canDoubleJump && releasedJumpButton && spacePressed) {
				velocity.y = 0;
				velocity.y -= VERTICAL_ACCELERATION * Time.dt;
				canDoubleJump = false;
			}
		}
	} // ends Player class

} // ends package