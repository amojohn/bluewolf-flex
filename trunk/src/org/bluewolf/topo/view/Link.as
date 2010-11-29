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
	
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.MoveEvent;
	
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
			drawLink();
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
			drawLink();
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
		 * Draw a line between source and destination node in this Link object
		 */
		public function drawLink():void {
			this.graphics.clear();
			if (_srcNode != null && _dstNode != null) {
				var sPoint:Point = _srcNode.getAlignPoint();
				var dPoint:Point = _dstNode.getAlignPoint();
				this.graphics.moveTo(sPoint.x, sPoint.y);
				this.graphics.lineStyle(this._thickness, 0x00ff00);
				this.graphics.lineTo(dPoint.x, dPoint.y);
			}
			invalidateDisplayList();
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
			drawLink();
		}
		
		private function onMove(e:MoveEvent):void {
			drawLink();
		}
	}
	
}