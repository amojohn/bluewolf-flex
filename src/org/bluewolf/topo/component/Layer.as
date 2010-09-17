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

package org.bluewolf.topo.component {
	
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.BorderContainer;
	
	/**
	 * Layer is used to create different layers in network container, it can contains nodes, links and other components
	 * 
	 * @author	Rui
	 */
	public class Layer extends BorderContainer {
		
		/**
		 * Construtor for Layer class
		 */
		public function Layer() {
			super();
			
			this.initStyle();
		}
		
		/**
		 * Initialize layer's style
		 */
		private function initStyle():void {
			this.setStyle("borderStyle", "none");
			this.setStyle("backgroundAlpha", 0);
		}
		
		/**
		 * Register initial events for the current layer
		 */
		private function registerEvents():void {
			this.addEventListener(DragEvent.DRAG_ENTER, onDragEnter);
			this.addEventListener(DragEvent.DRAG_DROP, onDragDrop);
		}
		
		private function onDragEnter(e:DragEvent):void {
			if (e.dragSource.hasFormat("dragTarget")) {
				DragManager.acceptDragDrop(e.currentTarget as BorderContainer);
			}
		}
		
		private function onDragDrop(e:DragEvent):void {
			// TODO: code executed after user finish draging object
			/*
			 * Fire an event which contains object's destination coordinate
			 */
		}
		
	}
}