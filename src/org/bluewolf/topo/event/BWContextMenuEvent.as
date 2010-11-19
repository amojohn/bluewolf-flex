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
	
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	
	
	public class BWContextMenuEvent extends ContextMenuEvent {
		
		private var _rootObject:* = null;
		private var _caption:String = "";
		private var _objectType:String = "";
		
		public function BWContextMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, mouseTarget:InteractiveObject=null, contextMenuOwner:InteractiveObject=null,
				rootObject:*=null, caption:String="", objectType:String="") {
			super(type, bubbles, cancelable, mouseTarget, contextMenuOwner);
			this._rootObject = rootObject;
			this._caption = caption;
			this._objectType = objectType;
		}
		
		override public function clone():Event {
			return new BWContextMenuEvent(type, bubbles, cancelable, mouseTarget, contextMenuOwner, rootObject, caption, objectType);
		}
		
		public function set rootObject(value:*):void {
			this._rootObject = value;
		}
		
		public function get rootObject():* {
			return this._rootObject;
		}
		
		public function set caption(value:String):void {
			this._caption = value;
		}
		
		public function get caption():String {
			return this._caption;
		}
		
		public function set objectType(value:String):void {
			this._objectType = value;
		}
		
		public function get objectType():String {
			return this._objectType;
		}
		
	}
}