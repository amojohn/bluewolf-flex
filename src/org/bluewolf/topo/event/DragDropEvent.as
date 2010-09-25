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
		public var node:Node;
		public var absoluteX:Number = 0;
		public var absoluteY:Number = 0;
		public var relativeX:Number = 0;
		public var relativeY:Number = 0;
		
		public function DragDropEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=true,
										node:Node=null) {
			super(type, bubbles, cancelable);
			this.node = node;
			this.absoluteX = node.x;
			this.absoluteY = node.y;
			this.relativeX = Number(Number(this.absoluteX / model.appWidth).toFixed(3));
			this.relativeY = Number(Number(this.absoluteY / model.appHeight).toFixed(3));
		}
		
	}
}