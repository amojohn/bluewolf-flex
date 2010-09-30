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
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import org.bluewolf.topo.event.BluewolfEventConst;
	import org.bluewolf.topo.event.DragDropEvent;
	import org.bluewolf.topo.model.ModelLocator;
	
	import spark.components.Group;
	
	
	[Event(name="DragDrop", type="org.bluewolf.topo.event.DragDropEvent")]
	
	/**
	 * Network is a container which contains one or more layers.
	 * 
	 * @author	Rui
	 */
	public class Network extends Group {
		
		private var _layers:Array = new Array();
		private var model:ModelLocator = ModelLocator.getInstance();
		
		/**
		 * If autoAlign is true, all dragable elements in this network will automatically align to 10 x 10 unit,
		 * if autoAlign is false, all dragable elements will locate in the exactly position.
		 */
		public function set isAutoAlign(value:Boolean):void {
			model.autoAlign = value;
		}
		
		/**
		 * If autoAlign is true, all dragable elements in this network will automatically align to 10 x 10 unit,
		 * if autoAlign is false, all dragable elements will locate in the exactly position.
		 */
		public function get isAutoAlign():Boolean {
			return model.autoAlign;
		}
		
		public function get layers():Array {
			return this._layers;
		}
		
		/**
		 * Constructor for Network class
		 */
		public function Network() {
			super();
			
			this.initStyle();
			this.registerEvents();
		}
		
		/**
		 * Initialize container's style
		 */
		private function initStyle():void {
			this.setStyle("borderVisible", false);
			this.setStyle("backgroundAlpha", 0);
		}
		
		/**
		 * Register initial events for this network
		 */
		private function registerEvents():void {
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
			this.addEventListener(DragEvent.DRAG_ENTER, onDragEnter);
			this.addEventListener(DragEvent.DRAG_DROP, onDragDrop);
		}
		
		/**
		 * Things to do after creating the network object
		 * @param e FlexEvent
		 */
		private function onInit(e:FlexEvent):void {
			model.appWidth = this.width;
			model.appHeight = this.height;
		}
		
		/**
		 * Add a layer in the network, order by adding sequenct
		 * @param layer A layer object to add in the network
		 * @param x x-position of the added layer
		 * @param y y-position of the added layer
		 * @return The added layer's index in this network
		 */
		public function addLayer(layer:Layer):int {
			layer.x = 0;
			layer.y = 0;
			this.addElement(layer);
			this._layers.push(layer);
			return layers.length - 1;
		}
		
		/**
		 * Remove a layer in the network
		 * @param layer The layer object to be deleted in the network
		 * @return If the network contains the given layer and succeed in removing it, return true,
		 * otherwise, return false
		 */
		public function removeLayer(layer:Layer):Boolean {
			var isSuccess:Boolean = false;
			if (ArrayUtil.arrayContainsValue(layers, layer)) {
				ArrayUtil.removeValueFromArray(layers, layer);
				isSuccess = true;
			}
			return isSuccess;
		}
		
		/**
		 * Put the select layer on the top of container
		 * @param layer The layer to put on the top of network
		 * @return If the network contains the given layer, return the selected layer, otherwise, return null
		 */
		public function selectLayer(layer:Layer):Layer {
			var layerProxy:Layer = null;
			if (ArrayUtil.arrayContainsValue(layers, layer)) {
				layer.depth = 99;
				layerProxy = layer;
			}
			return layerProxy;
		}
		
		private function onDragEnter(e:DragEvent):void {
			if (e.dragSource.hasFormat("node")) {
				DragManager.acceptDragDrop(e.currentTarget as Network);
			}
		}
		
		private function onDragDrop(e:DragEvent):void {
			var dataObj:Object = e.dragSource.dataForFormat("mouse") as Object;
			var dragNode:Node = e.dragInitiator as Node;
			dragNode.x = this.mouseX - dataObj.x;
			dragNode.y = this.mouseY - dataObj.y;
			
			var event:DragDropEvent = new DragDropEvent(BluewolfEventConst.DRAG_DROP, false, true, dragNode);
			this.dispatchEvent(event);
		}
		
	}
}