/*
Copyright (c) 2010 bluewolf-flex Contributors. See
http://bluewolf-flex.googlecode.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package org.bluewolf.topo.view {
	
	import com.adobe.utils.ArrayUtil;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.core.UIComponent;
	import mx.events.MoveEvent;
	
	import org.bluewolf.topo.event.BWContextMenuEvent;
	import org.bluewolf.topo.event.BluewolfEventConst;
	import org.bluewolf.topo.event.DragDropEvent;
	import org.bluewolf.topo.event.LayerRemoveNodeEvent;
	import org.bluewolf.topo.event.NodeMoveEvent;
	import org.bluewolf.topo.event.RemoveLinkEvent;
	
	[Event(name="RemoveLink", type="org.bluewolf.topo.event.RemoveLinkEvent")]
	
	/**
	 * Link object in topological diagram
	 * 
	 * @author	Rui
	 */
	public class Link extends UIComponent {
		
		private var _srcNode:Node;
		private var _dstNode:Node;
		private var _thickness:Number = 2;
		private var _color:Number = 0x00ff00;
		public var cPoint:Point;
		
		/**
		 * Constructor for Link class
		 */
		public function Link() {
			super();
			registerEvents();
		}
		
		private function registerEvents():void {
		}
		
		/**
		 * Source node of this link
		 * @param value An instance of Node class
		 */
		public function set source(value:Node):void {
			this._srcNode = value;
			this._srcNode.addEventListener(BluewolfEventConst.DRAG_DROP, onDragComplete);
			this._srcNode.addEventListener(BluewolfEventConst.LAYER_REMOVE_NODE, onLayerRemoveNode);
			this._srcNode.addEventListener(BluewolfEventConst.NODE_MOVE, onNodeMove);
			this._srcNode.addEventListener(MoveEvent.MOVE, onMove);
			this._srcNode.addEventListener(Event.COMPLETE, onIconComplete);
		}
		
		/**
		 * Source node of this link
		 * @return An instance of Node class
		 */
		public function get source():Node {
			return this._srcNode;
		}
		
		/**
		 * Destination node of this link
		 * @param value An instance of Node class
		 */
		public function set destination(value:Node):void {
			this._dstNode = value;
			this._dstNode.addEventListener(BluewolfEventConst.DRAG_DROP, onDragComplete);
			this._dstNode.addEventListener(BluewolfEventConst.LAYER_REMOVE_NODE, onLayerRemoveNode);
			this._dstNode.addEventListener(BluewolfEventConst.NODE_MOVE, onNodeMove);
			this._dstNode.addEventListener(MoveEvent.MOVE, onMove);
			this._dstNode.addEventListener(Event.COMPLETE, onIconComplete);
		}
		
		/**
		 * Destination node of this link
		 * @return An instance of Node class
		 */
		public function get destination():Node {
			return this._dstNode;
		}
		
		/**
		 * Thickness of this link
		 * @param value link's thickness value
		 */
		public function set thickness(value:Number):void {
			this._thickness = value;
			drawLink();
		}
		
		/**
		 * Thickness of this link
		 * @return link's thickness value
		 */
		public function get thickness():Number {
			return this._thickness;
		}
		
		/**
		 * Color of this link
		 * @param value link's color value
		 */
		public function set color(value:Number):void {
			this._color = value;
			drawLink();
		}
		
		/**
		 * Color of this link
		 * @return link's color value
		 */
		public function get color():Number {
			return this._color;
		}
		
		/**
		 * Draw a line between source and destination node in this Link object
		 */
		public function drawLink(lineType:String=null):void {
			this.graphics.clear();
			if (_srcNode != null && _dstNode != null) {
				var sPoint:Point = _srcNode.getAlignPoint();
				var dPoint:Point = _dstNode.getAlignPoint();
				this.graphics.moveTo(sPoint.x, sPoint.y);
				this.graphics.lineStyle(this._thickness, _color, 1);
				if (this.source.getConnection(this.destination.uid).length <= 1 || lineType == "straight") {
					this.graphics.lineTo(dPoint.x, dPoint.y);
				} else {
					this.graphics.curveTo(cPoint.x, cPoint.y, dPoint.x, dPoint.y);
				}
			}
			invalidateDisplayList();
		}
		
		/**
		 * Add link's context menu items
		 * @param menuItems An array contains contextMenu items' name
		 */
		public function addContextMenuItems(menuItems:Array):void {
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			
			if (menuItems != null && menuItems.length > 0) {
				for each (var item:String in menuItems) {
					var menuItem:ContextMenuItem = new ContextMenuItem(item);
					menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuItemSelect);
					contextMenu.customItems.push(menuItem);
				}
			}
			this.contextMenu = contextMenu;
		}
		
		private function onContextMenuItemSelect(e:ContextMenuEvent):void {
			e.stopPropagation();
			var item:ContextMenuItem = e.currentTarget as ContextMenuItem;
			var event:BWContextMenuEvent = new BWContextMenuEvent(BluewolfEventConst.MENU_ITEM_SELECT,
				true, true, e.mouseTarget, e.contextMenuOwner, this, item.caption, this.className);
			this.dispatchEvent(event);
		}
		
		/**
		 * Listen the event fired after source or destination node dragged
		 * @param e A DragEvent instance
		 */
		private function onDragComplete(e:DragDropEvent):void {
			drawLink();
		}
		
		private function onLayerRemoveNode(e:LayerRemoveNodeEvent):void {
			this.graphics.clear();
			var event:RemoveLinkEvent = new RemoveLinkEvent(BluewolfEventConst.REMOVE_LINK, true, true, this);
			this.dispatchEvent(event);
		}
		
		private function onNodeMove(e:NodeMoveEvent):void {
			drawLink("straight");
		}
		
		private function onMove(e:MoveEvent):void {
			drawLink();
		}
		
		private function onIconComplete(e:Event):void {
			drawLink();
		}
	}
	
}