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
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	/**
	 * The selection area with border when user use mouse drag to select
	 * 
	 * @author	Rui
	 */
	public class SelectionRect extends UIComponent {
		
		private var _start:Point;
		private var _end:Point;
		
		/**
		 * Constructor for SelectionRect class
		 */
		public function SelectionRect() {
			super();
		}
		
		/**
		 * Start position when mouse left button down
		 * @return A Point object present the start position
		 */
		public function get start():Point {
			return this._start;
		}
		
		/**
		 * Start position when mouse left button down
		 * @param value A Point object present the start position
		 */
		public function set start(value:Point):void {
			this._start = value;
		}
		
		/**
		 * End position when mouse left button up
		 * @return A Point object present the end position
		 */
		public function get end():Point {
			return this._end;
		}
		
		/**
		 * End position when mouse left button up
		 * @param value A Point object present the end position
		 */
		public function set end(value:Point):void {
			this._end = value;
			this.drawRect();
		}
		
		/**
		 * Clear the selection area in diagram
		 */
		public function clearRect():void {
			this.graphics.clear();
		}
		
		/**
		 * Draw the rectangle which present user selection area
		 */
		private function drawRect():void {
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x0000ff, 1);
			this.graphics.drawRect(_start.x, _start.y, _end.x - _start.x, _end.y - _start.y);
		}
		
		/**
		 * Calcute if the given node is in the selection area
		 * @param x The x coordinate of the given node
		 * @param y The y coordinate of the given node
		 * @return If the node is in the selection area, return true, otherwise return false
		 */
		public function isNodeInRect(x:Number, y:Number):Boolean {
			var topleft:Point = new Point();
			topleft.x = (_start.x <= _end.x) ? _start.x : _end.x;
			topleft.y = (_start.y <= _end.y) ? _start.y : _end.y;
			var rect:Rectangle = new Rectangle(topleft.x, topleft.y, Math.abs(_end.x - _start.x), Math.abs(_end.y - _start.y));
			return rect.contains(x, y);
		}
		
	}
}