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

package org.bluewolf.topo.event {
	
	import flash.events.Event;
	
	import org.bluewolf.topo.model.ModelLocator;
	import org.bluewolf.topo.view.Node;
	
	/**
	 * Event to be dispatched after dragging node
	 * 
	 * @author	Rui
	 */
	public class DragDropEvent extends Event {
		
		private var model:ModelLocator = ModelLocator.getInstance();
		private var _node:Node;
		private var _relativeX:Number = 0;
		private var _relativeY:Number = 0;
		
		/**
		 * Constructor for DragDropEvent class
		 */
		public function DragDropEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=true,
										node:Node=null) {
			super(type, bubbles, cancelable);
			this._node = node;
			this._relativeX = Number(Number(node.x / model.appWidth).toFixed(3));
			this._relativeY = Number(Number(node.y / model.appHeight).toFixed(3));
		}
		
		override public function clone():Event {
			return new DragDropEvent(type, bubbles, cancelable, _node);
		}
		
		/**
		 * The dragged node which dispatched the DragDropEvent
		 * @return The dragged node
		 */
		public function get node():Node {
			return this._node;
		}
		
		/**
		 * The value of relative x coordinate
		 * @return A number value of relative x
		 */
		public function get relativeX():Number {
			return this._relativeX;
		}
		
		/**
		 * The value of relative y coordinate
		 * @return A number value of relative y
		 */
		public function get relativeY():Number {
			return this._relativeY;
		}
		
	}
}