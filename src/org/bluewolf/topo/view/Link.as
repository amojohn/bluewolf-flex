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
	
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	
	/**
	 * Link object in topological diagram
	 * 
	 * @author	Rui
	 */
	public class Link extends UIComponent {
		
		private var _srcNode:Node;
		private var _dstNode:Node;
		public var thickness:Number = 2;
		
		/**
		 * Constructor for Link class
		 */
		public function Link() {
			super();
		}
		
		/**
		 * Source node of this link
		 * @param value An instance of Node class
		 */
		public function set source(value:Node):void {
			this._srcNode = value;
			this._srcNode.addEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);
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
			this._dstNode.addEventListener(DragEvent.DRAG_COMPLETE, onDragComplete);
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
		 * Draw a line between source and destination node in this Link object
		 */
		private function drawLink():void {
			this.graphics.clear();
			if (_srcNode != null && _dstNode != null) {
				var sp:Point = _srcNode.getAlignPoint();
				var dp:Point = _dstNode.getAlignPoint();
				this.graphics.moveTo(sp.x, sp.y);
				this.graphics.lineStyle(this.thickness, 0x00ff00);
				this.graphics.lineTo(dp.x, dp.y);
			}
			invalidateDisplayList();
		}
		
		/**
		 * Listen the event fired after source or destination node dragged
		 * @param e A DragEvent instance
		 */
		private function onDragComplete(e:DragEvent):void {
			drawLink();
		}
		
	}
	
}