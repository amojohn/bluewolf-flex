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
	
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.BorderContainer;
	
	/**
	 * Layer is used to create different layers in network container, it can contains nodes, links and other components
	 * 
	 * @author	Rui
	 */
	public class Layer extends BorderContainer {
		
		private var _nodes:Array;
		private var _links:Array;
		
		/**
		 * Construtor for Layer class
		 */
		public function Layer() {
			super();
			
			this.initStyle();
			
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			this._nodes = new Array();
			this._links = new Array();
		}
		
		/**
		 * Disable the width property in layout, layout's width always equals to network object's width
		 */
		override public function set width(value:Number):void {}
		/**
		 * Disable the height property in layout, layout's height always equals to network object's height
		 */
		override public function set height(value:Number):void {}
		
		/**
		 * Initialize layer's style
		 */
		private function initStyle():void {
			this.setStyle("borderVisible", false);
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
		
		/**
		 * Get all nodes in this layer
		 * @return An array of nodes object
		 */
		public function get nodes():Array {
			return this._nodes;
		}
		
		/**
		 * Add node object into this layer
		 * @param node The node object to be added in this layer, must be an instance of Node class or Subclass from Node
		 */
		public function addNode(node:Node):void {
			this.addElement(node);
			this._nodes.push(node);
		}
		
		/**
		 * Remove node object from this layer
		 * @param node The node object to be removed in this layer, must be an instance of Node class or Subclass from Node
		 * @return If layer contains given node and succeed in removing it, return true, otherwise, return false
		 */
		public function removeNode(node:Node):Boolean {
			if (ArrayUtil.arrayContainsValue(_nodes, node)) {
				this.removeChild(node);
				ArrayUtil.removeValueFromArray(_nodes, node);
				return true;
			} else {
				return false;
			}
		}
		
	}
}