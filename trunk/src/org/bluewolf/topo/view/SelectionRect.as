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
	
	
	public class SelectionRect extends UIComponent {
		
		private var _start:Point;
		private var _end:Point;
		
		public function SelectionRect() {
			super();
		}
		
		public function get start():Point {
			return this._start;
		}
		
		public function set start(value:Point):void {
			this._start = value;
		}
		
		public function get end():Point {
			return this._end;
		}
		
		public function set end(value:Point):void {
			this._end = value;
			this.drawRect();
		}
		
		public function clearRect():void {
			this.graphics.clear();
		}
		
		private function drawRect():void {
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x0000ff, 1);
			this.graphics.drawRect(_start.x, _start.y, _end.x - _start.x, _end.y - _start.y);
		}
		
		public function isNodeInRect(x:Number, y:Number):Boolean {
			var topleft:Point = new Point();
			topleft.x = (_start.x <= _end.x) ? _start.x : _end.x;
			topleft.y = (_start.y <= _end.y) ? _start.y : _end.y;
			var rect:Rectangle = new Rectangle(topleft.x, topleft.y, Math.abs(_end.x - _start.x), Math.abs(_end.y - _start.y));
			return rect.contains(x, y);
		}
		
	}
}