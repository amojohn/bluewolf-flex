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
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.effects.Zoom;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	
	import org.bluewolf.topo.event.BluewolfEventConst;
	import org.bluewolf.topo.event.DragDropEvent;
	import org.bluewolf.topo.event.SelectNodeEvent;
	import org.bluewolf.topo.model.ModelLocator;
	
	import spark.components.Group;
	
	
	[Event(name="DragDrop", type="org.bluewolf.topo.event.DragDropEvent")]
	
	/**
	 * Network is a container which contains one or more layers.
	 * 
	 * @author	Rui
	 */
	public class Network extends Group {
		
		[Embed(source="assets/move_hand.png")]
		private var move_hand:Class;
		
		private var _cursorId:int;
		private var _layers:Array;
		private var _zoomCoefficient:Number;
		private var _zoom:Zoom;
		public var selectedLayer:Layer;
		private var _selectionRect:SelectionRect;
		private var _selectedNodes:Array;
		private var _background:Image = new Image();
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
		
		public function get background():Image {
			return this._background;
		}
		
		/**
		 * Constructor for Network class
		 */
		public function Network() {
			super();
			
			this.initStyle();
			this.registerEvents();
			
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
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
			this.addEventListener(FlexEvent.CREATION_COMPLETE, init);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(BluewolfEventConst.SELECT_NODE, onSelectNode);
			this.addEventListener(BluewolfEventConst.DRAG_DROP, onNodeDragDrop);
		}
		
		/**
		 * Things to do after creating the network object
		 * @param e FlexEvent
		 */
		private function init(e:FlexEvent=null):void {
			model.appWidth = this.width;
			model.appHeight = this.height;
			
			_background.scaleContent = true;
			_background.width = this.width;
			_background.height = this.height;
			addElementAt(background,0);
			
			_layers = new Array();
			_zoomCoefficient = 1;
			selectedLayer = null;
			_selectedNodes = new Array();
			
			_zoom = new Zoom();
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
			this.selectedLayer = layer;
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
			if (ArrayUtil.arrayContainsValue(layers, layer)) {
				layer.depth = 99;
				selectedLayer = layer;
			}
			return selectedLayer;
		}
		
		/**
		 * Zoom the topological diagram size to the given coefficient
		 * @param coefficient The value of new size coefficient
		 */
		public function zoom(coefficient:Number):void {
//			_zoom.targets = this.layers;
//			_zoom.zoomWidthFrom = _zoom.zoomHeightFrom = _zoomCoefficient;
//			_zoom.zoomWidthTo = _zoom.zoomHeightTo = coefficient;
//			_zoomCoefficient = coefficient;
//			_zoom.play();
			this.scaleX = this.scaleY = coefficient;
		}
		
		/**
		 * All selected nodes by mouse in the network
		 * @return An array of all selected nodes
		 */
		public function get selectedNodes():Array {
			return this._selectedNodes;
		}
		
		/**
		 * Handle of selecting or unselecting node by click it with CTRL button
		 */
		private function onSelectNode(e:SelectNodeEvent):void {
			if (e.ctrlKey) {
				if (e.isSelect && !ArrayUtil.arrayContainsValue(_selectedNodes, e.node)) {
					_selectedNodes.push(e.node);
				} else if (!e.isSelect && ArrayUtil.arrayContainsValue(_selectedNodes, e.node)) {
					ArrayUtil.removeValueFromArray(_selectedNodes, e.node);
				}
			} else {
				if (!ArrayUtil.arrayContainsValue(_selectedNodes, e.node)) {
					for each (var node:Node in _selectedNodes) {
						node.setStyle("dropShadowVisible", false);
					}
					_selectedNodes = new Array();
					e.node.setStyle("dropShadowVisible", true);
					_selectedNodes.push(e.node);
				}
			}
			var layer:Layer = e.node.parent as Layer;
			layer.setElementIndex(e.node, layer.numElements-1);
		}
		
		public function selectNode(id:String=""):Node {
			var sNode:Node = null;
			if (id != "") {
				for each (var layer:Layer in this._layers) {
					for each (var node:Node in layer.nodes) {
						if (node.id == id) {
							sNode = node;
							break;
						}
					}
					if (sNode != null) {
						break;
					}
				}
				for each (var n:Node in selectedNodes) {
					n.setStyle("dropShadowVisible", false);
				}
				this._selectedNodes = [sNode];
				sNode.setStyle("dropShadowVisible", true);
			}
			return sNode;
		}
		
		public function reset():void {
			this.removeAllElements();
			this.init();
		}
		
		/**
		 * Event listeners for Network class
		 */
		private function onMouseDown(e:MouseEvent):void {
//			if (e.altKey) {
				e.stopPropagation();
				
				var event:Event = new Event("startDragLayer",true);
				dispatchEvent(event);
				
				try {
					CursorManager.removeCursor(_cursorId);
				} catch (err:Error) {
					trace(err);
				}
				this.selectedLayer.startDrag();
				_cursorId = CursorManager.setCursor(move_hand);
//			} else {
//				_selectionRect = new SelectionRect();
//				this.addElement(_selectionRect);
//				model.isSelectRect = true;
//				_selectionRect.start = new Point(e.localX, e.localY);
//			}
		}
		
		private function onMouseMove(e:MouseEvent):void {
			if (e.localX <= 5 || e.localX >= model.appWidth-5 || e.localY <= 5 || e.localY >= model.appHeight-5) {
				try {
					this.selectedLayer.stopDrag();
					var event:Event = new Event("stopDragLayer",true);
					dispatchEvent(event);
				} catch (error:Error) {
					trace(error);
				}
				CursorManager.removeCursor(_cursorId);
			}
			if (model.isSelectRect) {
				_selectionRect.end = new Point(e.localX, e.localY);
			}
		}
		
		private function onMouseUp(e:MouseEvent):void {
			e.stopPropagation();
			
			var event:Event = new Event("stopDragLayer",true);
			dispatchEvent(event);
			
			this.selectedLayer.stopDrag();
			CursorManager.removeCursor(_cursorId);
			if (model.isSelectRect) {
				_selectionRect.end = new Point(e.localX, e.localY);
				_selectionRect.clearRect();
				for each (var node:Node in _selectedNodes) {
					node.setStyle("dropShadowVisible", false);
				}
				_selectedNodes = new Array();
				for each (var layer:Layer in _layers) {
					for each (node in layer.nodes) {
						if (_selectionRect.isNodeInRect(node.x, node.y)) {
							_selectedNodes.push(node);
							node.setStyle("dropShadowVisible", true);
						}
					}
				}
				this.removeElement(_selectionRect);
				_selectionRect = null;
			}
			model.isSelectRect = false;
		}
		
		private function onNodeDragDrop(e:DragDropEvent):void {
			var offsetX:Number = e.node.x - e.startPoint.x;
			var offsetY:Number = e.node.y - e.startPoint.y;
			for each (var node:Node in _selectedNodes) {
				if (node != e.node) {
					node.setStyle("moveEffect", node.eMove);
					node.move(node.x + offsetX, node.y + offsetY);
					node.setStyle("moveEffect", null);
				}
			}
		}
		
	}
}