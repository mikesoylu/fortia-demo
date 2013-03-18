package {
	import com.mikesoylu.fortia.*;
	import starling.textures.Texture;
	
	/**
	 * @author bms
	 */
	public class Enemy extends fImage implements fIPoolable {
		public const SPEED:Number = 10;
		
		public function Enemy() {
			super(fAssetManager.getTexture("enemy_img"), 0, 0, true);
		}
		
		public function revive():void {
			// revive the enemy at the right side of the screen
			x = fGame.width + rect.width;
			y = Math.random() * (fGame.height - rect.height) + halfHeight;
			visible = true;
		}
		
		public function get alive():Boolean {
			return visible;
		}
		
		public function kill():void {
			visible = false;
		}
		
		override public function update(dt:Number):void {
			super.update(dt);
			
			// move the enemy left
			x -= SPEED;
			if (y < halfWidth) {
				visible = false;
			}
		}
	}
}