package victor.view.scenes.game.logic
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.events.TweenEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import victor.GameStage;
	import victor.components.Button;
	import victor.core.SoundManager;
	import victor.core.interfaces.IItem;
	import victor.data.LevelVo;
	import victor.utils.ArrayUtil;
	import victor.view.EffectPlayCenter;
	import victor.view.events.GameEvent;
	import victor.view.res.Item;

	[Event( name = "back_menu", type = "victor.view.events.GameEvent" )]

	[Event( name = "dispel_success", type = "victor.view.events.GameEvent" )]

	[Event( name = "add_score", type = "victor.view.events.GameEvent" )]

	[Event( name = "add_time", type = "victor.view.events.GameEvent" )]

	/**
	 * ……
	 * @author 	yangsj
	 * 			2013-6-21
	 */
	public class GameLogicComp extends Sprite
	{
		private const COLS:uint = 6;
		private const ROWS:uint = 9;
		private const COMB_TIME_UNIT:uint = 2000;
		private const COMB_REWAR_SCORE_UNIT:uint = 5;
		private const LENGTH:uint = COLS * ROWS;
		private const HALF:uint = LENGTH >> 1;

		// item 列表显示容器
		private var _listContainer:Sprite;
		// 路径线显示容器
		private var _drawPathLine:DrawPathLine;
		private var _markList:Vector.<int>;
		private var _listAry:Vector.<Vector.<IItem>>;
		private var _markAry:Vector.<int>;
		private var _seekGroups:Vector.<Vector.<IItem>>;
		private var _startItem:IItem;
		private var _endItem:IItem;
		private var _dispelNumber:int = 0;
		private var _levelVo:LevelVo;
		private var _lastClickTime:Number = 0;
		private var _combNumber:int = 0;
		private var _isOver:Boolean = false;
		private var _btnRefresh:Button;
		private var _btnBack:Button;
		private var _findPath:FindPath;

		public function GameLogicComp()
		{
			mouseEnabled = false;
			intiVars();
		}

		private function intiVars():void
		{
			var vec1:Vector.<IItem>;
			_listAry = new Vector.<Vector.<IItem>>( ROWS );
			for ( var i:uint = 0; i < ROWS; i++ )
			{
				vec1 = new Vector.<IItem>( COLS );
				for ( var j:uint = 0; j < COLS; j++ )
				{
					vec1[ j ] = new Item();
				}
				_listAry[ i ] = vec1;
			}
			//
			var leng:uint = 40;
			_markList = new Vector.<int>( leng );
			for ( i = 0; i != leng; i++ )
			{
				_markList[ i ] = ( i + 1 );
			}

			_drawPathLine = new DrawPathLine();
			_listContainer = new Sprite();
			_listContainer.y = 130 * GameStage.scaleY;
			_listContainer.x = ( GameStage.stageWidth - (( _listAry[ 0 ][ 0 ].itemWidth + 5 ) * COLS )) >> 1;

			_btnRefresh = new Button( " 刷 新 ", btnRefreshHandler );
			_btnRefresh.x = ( GameStage.stageWidth >> 1 ) - ( _btnRefresh.width >> 1 ) - 10;
			_btnRefresh.y = GameStage.stageHeight - _btnRefresh.height - 10;

			_btnBack = new Button( " 返 回 ", btnBackHandler );
			_btnBack.x = ( GameStage.stageWidth >> 1 ) + ( _btnBack.width >> 1 ) + 10;
			_btnBack.y = GameStage.stageHeight - _btnBack.height - 10;

			_listContainer.mouseEnabled = false;
			_listContainer.addEventListener( MouseEvent.CLICK, clickHandler );

			_findPath = new FindPath();
			_findPath.initMap( ROWS, COLS, _listAry );

			addChild( _listContainer );
			addChild( _btnRefresh );
			addChild( _btnBack );
			addChild( _drawPathLine );
		}

		private function btnBackHandler():void
		{
			dispatchEvent( new GameEvent( GameEvent.BACK_MENU ));
		}

		private function initMarkData( limit:uint ):void
		{
			limit = Math.min( limit, LENGTH * 0.5 );
			ArrayUtil.randomSort( _markList );
			_markAry ||= new Vector.<int>( LENGTH );
			for ( var i:uint = 0; i < LENGTH; i += 2 )
			{
				_markAry[ i ] = _markAry[ i + 1 ] = _markList[ uint( Math.random() * limit )];
			}
		}

		private function btnRefreshHandler():void
		{
			refresh();
		}

		public function initialize():void
		{
		}

		public function startAndReset( levelVo:LevelVo ):void
		{
			_isOver = false;
			_btnBack.mouseEnabled = false;
			_btnRefresh.mouseEnabled = false;
			_listContainer.removeChildren();
			_dispelNumber = 0;
			_lastClickTime = 0;
			_combNumber = 0;
			_levelVo = levelVo;

			initMarkData( levelVo.picNum );
			ArrayUtil.randomSort( _markAry );

			var item:IItem;
			var groupAry:Array;
			var tweenGroup:TimelineMax;
			for ( var i:uint = 0; i < ROWS; i++ )
			{
				groupAry = [];
				for ( var j:uint = 0; j < COLS; j++ )
				{
					item = _listAry[ i ][ j ];
					item.parentTarget = _listContainer;
					item.mark = _markAry[ i * COLS + j ];
					item.cols = j;
					item.rows = i;
					item.initialize();

					groupAry.push( TweenMax.from( item, 0.5, { x: item.x, y: item.y - GameStage.stageHeight, ease: Back.easeOut }));
				}
				tweenGroup = new TimelineMax();
				tweenGroup.addEventListener( TweenEvent.COMPLETE, complete );
				tweenGroup.appendMultiple( groupAry, 1, TweenAlign.START, 0.1 );
				tweenGroup.play();
			}

			function complete( event:TweenEvent ):void
			{
				var target:TimelineMax = event.target as TimelineMax;
				if ( target )
				{
					target.removeEventListener( TweenEvent.COMPLETE, complete );
				}

				if ( _btnRefresh )
					_btnRefresh.mouseEnabled = true;
				if ( _btnBack )
					_btnBack.mouseEnabled = true;
			}
		}

		private function refresh():void
		{
			var item:IItem;
			ArrayUtil.randomSort( _listAry );
			for ( var i:uint = 0; i < ROWS; i++ )
			{
				for ( var j:uint = 0; j < COLS; j++ )
				{
					item = _listAry[ i ][ j ];
					item.cols = j;
					item.rows = i;
					item.refresh();
				}
			}
		}

		protected function clickHandler( event:MouseEvent ):void
		{
			var target:IItem = event.target as IItem;
			if ( target )
			{
				event.stopPropagation();
				SoundManager.playClickItem();
				if ( _startItem == null )
				{
					_startItem = target;
					_startItem.selected = true;
				}
				else
				{
					_endItem = target;
					if ( _endItem == _startItem )
					{
						_startItem.selected = false;
						_startItem = null;
					}
					else if ( _startItem.mark != target.mark )
					{
						_startItem.selected = false;
						_startItem = target;
						_startItem.selected = true;
					}
					else
					{
						_endItem.selected = true;

						seek();
					}
				}
			}
		}

		///////////// seek

		private function seek():void
		{
			var tempVec1:Vector.<IItem> = _findPath.seek( _startItem, _endItem );
			// get short path
			if ( tempVec1 && tempVec1.length > 0 )
			{
				_dispelNumber++;
				setDrawLine( tempVec1 );
				checkGameProgress();
				checkAddScore();
				SoundManager.playLinkItem();
			}
			else
			{
				_startItem.selected = false;
				_endItem.selected = true;
				_startItem = _endItem;
			}
			_endItem = null;
		}

		private function setDrawLine( tempVec1:Vector.<IItem> ):void
		{
			var tempVec2:Vector.<Point> = new Vector.<Point>();
			var time:Number = 0.05 * ( tempVec1.length );
			for each ( var item:IItem in tempVec1 )
			{
				tempVec2.push( item.globalPoint );
			}
			_drawPathLine.setPoints( tempVec2 );
			_startItem.removeFromParent( time );
			_endItem.removeFromParent( time );
			_startItem = null;
		}

		private function checkGameProgress():void
		{
			if ( _dispelNumber >= HALF )
			{
				_isOver = true;
				dispatchEvent( new GameEvent( GameEvent.DISPEL_SUCCESS ));
			}
			else
			{
				dispatchEvent( new GameEvent( GameEvent.ADD_TIME, 1 ));
			}
		}

		private function checkAddScore():void
		{
			// score
			var score:int = _levelVo.score;
			if ( getTimer() - _lastClickTime <= COMB_TIME_UNIT )
			{
				_combNumber++;
				score += _combNumber * COMB_REWAR_SCORE_UNIT;
				EffectPlayCenter.instance.playCombWords( _combNumber );
			}
			else
			{
				_combNumber = 0;
			}
			if ( _combNumber > 0 && _combNumber % 3 == 0 )
			{
				TweenMax.delayedCall( 0.5, EffectPlayCenter.instance.playGoodWords );
			}
			_lastClickTime = getTimer();
			trace( "连击：" + _combNumber, "》》》》》增加分数：" + score );
			dispatchEvent( new GameEvent( GameEvent.ADD_SCORE, score ));
		}

	}
}
