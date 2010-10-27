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
	
	import org.bluewolf.topo.view.Node;
	
	
	/**
	 * Event to be dispatched after select or unselect when click the node
	 * 
	 * @author	Rui
	 */
	public class SelectNodeEvent extends Event {
		
		private var _node:Node;
		private var _isSelect:Boolean = false;
		
		/**
		 * Constructor for SelectNodeEvent class
		 */
		public function SelectNodeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,
										oNode:Node=null, bIsSelect:Boolean=false) {
			super(type, bubbles, cancelable);
			this._node = oNode;
			this._isSelect = bIsSelect;
		}
		
		override public function clone():Event {
			return new SelectNodeEvent(type, bubbles, cancelable, _node, _isSelect);
		}
		
		public function set node(value:Node):void {
			this._node = value;
		}
		
		public function get node():Node {
			return this._node;
		}
		
		public function set isSelect(value:Boolean):void {
			this._isSelect = value;
		}
		
		public function get isSelect():Boolean {
			return this._isSelect;
		}
	}
}