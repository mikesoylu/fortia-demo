package {
	import com.mikesoylu.fortia.*;
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * @author bms
	 */
	public class GameScene extends fScene {
		public var player:fImage;
		public var enemies:fObjectPool;
		
		override public function init(e:Event):void {
			super.init(e);
			// create an asset manager with the name:game
			fAssetManager.addManager("game");
			// enqueue the static contents of the Asset class and give it a name
			fAssetManager.enqueue("game", Assets);
			// start loading the assets
			fAssetManager.loadQueues(onAssetsLoaded);
			
			function onAssetsLoaded():void {
				// add a player
				player = new fImage(fAssetManager.getTexture("player_img"), fGame.width / 4, fGame.height / 2);
				addChild(player);
				
				// add an object pool for the enemies
				enemies = new fObjectPool();
				for (var i:int = 0; i < 100; i++) {
					addChild(enemies.addObject(new Enemy()) as Enemy);
				}
				
				// start spawning enemies
				Starling.juggler.delayCall(spawnEnemy, 0.5);
				
				function spawnEnemy():void {
					// pull an emeny from the pool
					var obj:fIPoolable = enemies.getObject();
					
					// revive an enemy if we have an available one in the pool
					if (obj) {
						obj.revive();
					}
					
					// continue forever
					Starling.juggler.delayCall(spawnEnemy, 0.5);
				}
			}
		}
		
		override public function update(dt:Number):void {
			super.update(dt);
			
			// check if the player & enemy pool are initialized
			if (player && enemies) {
				player.y = fGame.mouseY;
				fQuadTree.overlaps(player, enemies, playerEnemyCallback);
			}
			
			function playerEnemyCallback(pl:fIBasic, en:fIBasic):void {
				// shake the screen
				shake(0.5, 50);
				// kill the enemy
				(en as fIPoolable).kill();
				// play a sound
				fAssetManager.play("explosion_snd", 0, 0.5);
			}
		}
	}
}