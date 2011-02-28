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
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.core.IUID;
	import mx.effects.Move;
	import mx.events.EffectEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;
	
	import org.bluewolf.topo.event.BWContextMenuEvent;
	import org.bluewolf.topo.event.BluewolfEventConst;
	import org.bluewolf.topo.event.DragDropEvent;
	import org.bluewolf.topo.event.NodeMoveEvent;
	import org.bluewolf.topo.event.SelectNodeEvent;
	import org.bluewolf.topo.interf.IDragableElement;
	import org.bluewolf.topo.model.ModelLocator;
	import org.bluewolf.topo.util.TopoUtil;
	
	import spark.components.BorderContainer;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;
	
	[Event(name="LayerRemoveNode", type="org.bluewolf.topo.event.LayerRemoveNodeEvent")]
	[Event(name="DragDrop", type="org.bluewolf.topo.event.DragDropEvent")]
	[Event(name="MenuItemSelect", type="org.bluewolf.topo.event.BWContextMenuEvent")]
	
	/**
	 * Node object in topological diagram, consist with icon(optional) and name label
	 * 
	 * @author	Rui
	 */
	public class Node extends BorderContainer implements IDragableElement, IUID {
		
		private var model:ModelLocator = ModelLocator.getInstance();
		private var _uid:String;
		private var _image:Image = new Image();
		private var _icon:String = "";
		private var _label:Text = new Text();
		private var _relativeX:Number = 0;
		private var _relativeY:Number = 0;
		private var _isDragging:Boolean = false;
		private var _connectionMap:Object;
		private var _labelPosition:String;
		
		public var eMove:Move;
		public var dragStartPoint:Point;
		
		/**
		 * Constructor for Node class
		 */
		public function Node(relaX:Number=0, relaY:Number=0) {
			super();
			
			_uid = UIDUtil.createUID();
			
			this.minWidth = this.minHeight = 0;
			_connectionMap = new Object();
			
			initStyle();
			registerEvents();
			
			/* Set this border container's layout to horizontal */
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.paddingBottom = layout.paddingLeft = layout.paddingRight = layout.paddingTop = layout.gap = 0;
			this.layout = layout;
			this._label.selectable = false;
			
			this.addElement(_image);
			this.addElement(_label);
			
			this.relativeX = relaX;
			this.relativeY = relaY;
			adjustPosition();
		}
		
		/**
		 * Register initial events for the current layer
		 */
		private function registerEvents():void {
			this._image.addEventListener(Event.COMPLETE, onIconComplete);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			eMove.addEventListener(EffectEvent.EFFECT_END, onMoveEnd);
		}
		
		private function onIconComplete(e:Event):void {
			this._image.width = this._image.contentWidth;
			this._image.height = this._image.contentHeight;
//			this.width = this._image.width + this._label.width;
//			this.height = this._image.height + this._label.height;
			adjustPosition();
			this.invalidateDisplayList();
			getAllControlPoints();
			this.dispatchEvent(e);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			e.stopPropagation();
			if (e.ctrlKey) {
				this.setStyle("dropShadowVisible", !this.getStyle("dropShadowVisible"));
			} else {
				this.setStyle("dropShadowVisible", true);
			}
			var event:SelectNodeEvent = new SelectNodeEvent(
				BluewolfEventConst.SELECT_NODE, true, true, this, this.getStyle("dropShadowVisible"), e.ctrlKey);
			this.dispatchEvent(event);
			this.dragStartPoint = new Point(this.x, this.y);
			this.startDrag();
			_isDragging = true;
		}
		
		private function onMouseUp(e:MouseEvent):void {
			e.stopPropagation();
			this.stopDrag();
			_isDragging = false;
			
			getAllControlPoints();
			
			var event:DragDropEvent = new DragDropEvent(BluewolfEventConst.DRAG_DROP, true, true, this, dragStartPoint);
			this.dispatchEvent(event);
		}
		
		private function onMouseMove(e:MouseEvent):void {
			e.stopPropagation();
			if (_isDragging) {
				var event:NodeMoveEvent = new NodeMoveEvent(BluewolfEventConst.NODE_MOVE, true, true, this);
				this.dispatchEvent(event);
			}
		}
		
		private function onMoveEnd(e:EffectEvent=null):void {
			dragStartPoint = new Point(this.x, this.y);
			
			getAllControlPoints();
			
			var event:DragDropEvent = new DragDropEvent(BluewolfEventConst.DRAG_DROP, true, true, this, dragStartPoint);
			this.dispatchEvent(event);
		}
		
		override public function set uid(value:String):void {}
		
		override public function get uid():String {
			return this._uid;
		}
		
		/**
		 * Icon path of this node
		 * @param value Accessible path to a valid image
		 */
		public function set icon(value:String):void {
			_icon = value;
			_image.source = value;
		}
		
		/**
		 * Icon path of this node
		 * @return Accessible path to this node's icon
		 */
		public function get icon():String {
			return this._icon;
		}
		
		/**
		 * Node name to display right to the icon
		 */
		public function set label(value:String):void {
			this._label.text = value;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if (this._labelPosition == "left" || this._labelPosition == "right") {
				this.width = this._image.width + this._label.width;
//				this.height = this._image.height + this._label.height;
			}
			if (this._labelPosition == "left" || this._labelPosition == "right") {
				this.height = this._image.height + this._label.height;
			}
		}

		
		/**
		 * Node name to display right to the icon
		 */
		public function get label():String {
			return this._label.text;
		}
		
		/**
		 * Implemention of getAlignPoint method in IDragableElement
		 */
		public function getAlignPoint():Point {
			var point:Point = new Point(this.x, this.y);
			switch (_labelPosition) {
				case "top":
					point.y += _label.height;
					break;
				case "left":
					point.x += _label.width;
					break;
			}
			point.x += _image.width / 2;
			point.y += _image.height / 2;
			return point;
		}
		
		/**
		 * Initialize node's style
		 */
		private function initStyle():void {
			/* Set effects */
			eMove = new Move(this);
			eMove.duration = 200;
			
			this.setStyle("borderVisible", false);
			this.setStyle("backgroundAlpha", 0);
			this.setStyle("fontSize", 9);
			this.setStyle("fontColor", 0x000000);
			this._label.setStyle("fontSize", 9);
		}
		
		/**
		 * The relative x-coordinat position, range from 0 to 1(if < 0 or > 1 is also acceptable)
		 */
		public function set relativeX(value:Number):void {
			this._relativeX = value;
			this.x = model.appWidth * value;
			adjustPosition();
		}
		
		/**
		 * The relative x-coordinat position, range from 0 to 1(if < 0 or > 1 is also acceptable)
		 */
		public function get relativeX():Number {
			this._relativeX = Number((this.x / model.appWidth).toFixed(3));
			return this._relativeX;
		}
		
		/**
		 * The relative y-coordinat position, range from 0 to 1(if < 0 or > 1 is also acceptable)
		 */
		public function set relativeY(value:Number):void {
			this._relativeY = value;
			this.y = model.appHeight * value;
			adjustPosition();
		}
		
		/**
		 * The relative y-coordinat position, range from 0 to 1(if < 0 or > 1 is also acceptable)
		 */
		public function get relativeY():Number {
			this._relativeY = Number((this.y / model.appHeight).toFixed(3));
			return this._relativeY;
		}
		
		/**
		 * Adjust node position, adjustment policy depends on autoAlign property of network
		 */
		private function adjustPosition():void {
			if (model.autoAlign) {
				var point:Point = this.getAlignPoint();
				this.x = point.x - _image.width / 2;
				this.y = point.y - _image.height / 2;
				dragStartPoint = new Point(this.x, this.y);
			}
			invalidateDisplayList();
		}
		
		/**
		 * Add node's context menu items
		 * @param menuItems An array contains contextMenu items' name
		 */
		public function addContextMenuItems(menuItems:Array):void {
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			
			if (menuItems != null && menuItems.length > 0) {
				var seperatorFlag:Boolean = false;
				for each (var item:String in menuItems) {
					if (item == "-") {
						seperatorFlag = true;
						continue;
					}
					var menuItem:ContextMenuItem = new ContextMenuItem(item, seperatorFlag);
					seperatorFlag = false;
					menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuItemSelect);
					contextMenu.customItems.push(menuItem);
				}
			}
			this.contextMenu = contextMenu;
		}
		
		private function onContextMenuItemSelect(e:ContextMenuEvent):void {
			e.stopPropagation();
			var item:ContextMenuItem = e.currentTarget as ContextMenuItem;
			var event:BWContextMenuEvent = new BWContextMenuEvent(BluewolfEventConst.MENU_ITEM_SELECT,
					true, true, e.mouseTarget, e.contextMenuOwner, this, item.caption, this.className);
			this.dispatchEvent(event);
		}
		
		/**
		 * Add the connected link to this node
		 * @param node The node connect to this node by the link
		 * @param link The link which connect this node to another node
		 * @return The links array this node connected to the given node
		 */
		public function addConnection(nodeUID:String, link:Link):Array {
			if (_connectionMap[nodeUID] == null) {
				_connectionMap[nodeUID] = new Array();
			}
			_connectionMap[nodeUID].push(link);
			return _connectionMap[nodeUID];
		}
		
		/**
		 * Remove the connected link to this node
		 * @paran node The node connect to this node by the link
		 * @param link The link which connect this node to another node
		 * @return The links array this node connected to the given node
		 */
		public function removeConnection(nodeUID:String, link:Link):Array {
			if (_connectionMap[nodeUID] == null) {
				_connectionMap[nodeUID] = new Array();
			} else {
				if (ArrayUtil.arrayContainsValue(_connectionMap[nodeUID], link)) {
					ArrayUtil.removeValueFromArray(_connectionMap[nodeUID], link);
				}
			}
			return _connectionMap[nodeUID];
		}
		
		/**
		 * Get all links between this node and the given node
		 * @param node The node connect to this node
		 * @return The links array this node connected to the given node
		 */
		public function getConnection(nodeUID:String):Array {
			if (_connectionMap[nodeUID] == null) {
				_connectionMap[nodeUID] = new Array();
			}
			return _connectionMap[nodeUID];
		}
		
		private function getAllControlPoints():void {
			var fields:Array = ObjectUtil.getClassInfo(_connectionMap)["properties"] as Array;
			for each (var q:QName in fields) {
				if (_connectionMap[q.localName].length > 1) {
					var cps:Array = TopoUtil.getControlPoints(_connectionMap[q.localName][0], _connectionMap[q.localName].length-1);
					for (var i:int = 0; i < _connectionMap[q.localName].length; i++) {
						_connectionMap[q.localName][i].cPoint = cps[i];
					}
				}
			}
		}
		
		public function redrawCurveLine():void {
			this.onMoveEnd();
		}
		
		public function get labelPosition():String {
			return this._labelPosition;
		}
		
		public function set labelPosition(value:String):void {
			this._labelPosition = value;
			switch (value) {
				case "top":
					var layout:VerticalLayout = new VerticalLayout();
					layout.paddingBottom = layout.paddingLeft = layout.paddingRight = layout.paddingTop = layout.gap = 0;
					this.setElementIndex(_label, 0);
					this.layout = layout;
					break;
				case "bottom":
					layout = new VerticalLayout();
					layout.paddingBottom = layout.paddingLeft = layout.paddingRight = layout.paddingTop = layout.gap = 0;
					this.setElementIndex(_image, 0);
					this.layout = layout;
					break;
				case "left":
					var layout1:HorizontalLayout = new HorizontalLayout();
					layout1.paddingBottom = layout1.paddingLeft = layout1.paddingRight = layout1.paddingTop = layout1.gap = 0;
					this.setElementIndex(_label, 0);
					this.layout = layout1;
					break;
				case "right":
					layout1 = new HorizontalLayout();
					layout1.paddingBottom = layout1.paddingLeft = layout1.paddingRight = layout1.paddingTop = layout1.gap = 0;
					this.setElementIndex(_image, 0);
					this.layout = layout1;
					break;
			}
			invalidateDisplayList();
			onMoveEnd();
		}
		
	}
	
}