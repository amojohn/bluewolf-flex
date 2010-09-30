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
	
	import flash.events.MouseEvent;
	
	import mx.core.DragSource;
	import mx.managers.DragManager;
	
	import org.bluewolf.topo.event.DragDropEvent;
	
	import spark.components.Group;
	
	[Event(name="Drag_Drop", type="org.bluewolf.topo.event.DragDropEvent")]
	
	/**
	 * Layer is used to create different layers in network container, it can contains nodes, links and other components
	 * 
	 * @author	Rui
	 */
	public class Layer extends Group {
		
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
			node.addEventListener(MouseEvent.MOUSE_MOVE, onNodeMouseMove);
		}
		
		/**
		 * Remove node object from this layer
		 * @param node The node object to be removed in this layer, must be an instance of Node class or Subclass from Node
		 * @return If layer contains given node and succeed in removing it, return true, otherwise, return false
		 */
		public function removeNode(node:Node):Boolean {
			var isSuccess:Boolean = false;
			if (ArrayUtil.arrayContainsValue(_nodes, node)) {
				this.removeElement(node);
				ArrayUtil.removeValueFromArray(_nodes, node);
				isSuccess = true;
			}
			return isSuccess;
		}
		
		/**
		 * Get all links in this layer
		 * @return An array of links object
		 */
		public function get links():Array {
			return this._links;
		}
		
		/**
		 * Add link object into this layer
		 * @param link The link object to be added in this layer, must be an instance of Link class or Subclass from Link
		 */
		public function addLink(link:Link):void {
			this.addElementAt(link, 0);
			this._links.push(link);
		}
		
		/**
		 * Remove link object from this layer
		 * @param link The link object to be removed in this layer, must be an instance of Link class or Subclass from Link
		 * @return If layer contains given link and succeed in removing it, return true, otherwise, return false
		 */
		public function removeLink(link:Link):Boolean {
			var isSuccess:Boolean = false;
			if (ArrayUtil.arrayContainsValue(_links, link)) {
				this.removeElement(link);
				ArrayUtil.removeValueFromArray(_links, link);
				isSuccess = true;
			}
			return isSuccess;
		}
		
		private function onNodeMouseMove(e:MouseEvent):void {
			var indicator:Node = e.currentTarget as Node;
			var dataSource:DragSource = new DragSource();
			dataSource.addData(indicator, "node");
			dataSource.addData({x:indicator.mouseX, y:indicator.mouseY}, "mouse");
			DragManager.doDrag(indicator, dataSource, e);
		}
	}
}