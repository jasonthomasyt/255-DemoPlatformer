package code {
	
	import flash.display.MovieClip;
	
	/**
	 * The class for the Platform game object.
	 */
	public class Platform extends MovieClip {
		
		/** The collider for the platform. */
		public var collider:AABB;
		
		/**
		 * The constructor function for Platform.
		 */
		public function Platform() {
			// Add collider to the platform
			collider = new AABB(width / 2, height / 2);
			collider.calcEdges(x, y);
			
			// add to platforms array...
			Game.platforms.push(this);
		} // ends Platform
	} // ends class
} // ends package
