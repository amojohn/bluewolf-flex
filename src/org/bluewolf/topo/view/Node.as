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
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.controls.Image;
	import mx.controls.Text;
	
	import org.bluewolf.topo.interf.IDragableElement;
	import org.bluewolf.topo.model.ModelLocator;
	
	import spark.components.BorderContainer;
	import spark.layouts.HorizontalLayout;
	
	[Event(name="LayerRemoveNode", type="org.bluewolf.topo.event.LayerRemoveNodeEvent")]
	
	/**
	 * Node object in topological diagram, consist with icon(optional) and name label
	 * 
	 * @author	Rui
	 */
	public class Node extends BorderContainer implements IDragableElement {
		
		private var model:ModelLocator = ModelLocator.getInstance();
		private var _icon:Image = new Image();
		private var _label:Text = new Text();
		private var _relativeX:Number = 0;
		private var _relativeY:Number = 0;
		
		/**
		 * Constructor for Node class
		 */
		public function Node(relaX:Number=0, relaY:Number=0) {
			super();
			
			this.minWidth = this.minHeight = 0;
			
			initStyle();
			registerEvents();
			
			/* Set this border container's layout to horizontal */
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.paddingBottom = layout.paddingLeft = layout.paddingRight = layout.paddingTop = layout.gap = 0;
			this.layout = layout;
			this._label.selectable = false;
			
			this.addElement(_icon);
			this.addElement(_label);
			
			this.relativeX = relaX;
			this.relativeY = relaY;
			adjustPosition();
		}
		
		/**
		 * Register initial events for the current layer
		 */
		private function registerEvents():void {
			this._icon.addEventListener(Event.COMPLETE, onIconComplete);
		}
		
		private function onIconComplete(e:Event):void {
			this._icon.width = this._icon.contentWidth;
			this._icon.height = this._icon.contentHeight;
			this.width = this._icon.width + this._label.width;
			if (this._icon.height > this._label.height)
				this.height = this._icon.height;
			else
				this.height = this._label.height;
			adjustPosition();
			this.invalidateDisplayList();
			this.dispatchEvent(e);
		}
		
		/**
		 * Icon path of this node
		 * @param value Accessible path to a valid image
		 */
		public function set icon(value:String):void {
			_icon.source = value;
		}
		
		/**
		 * Icon path of this node
		 * @return Accessible path to this node's icon
		 */
		public function get icon():String {
			return this._icon.source.toString();
		}
		
		/**
		 * Node name to display right to the icon
		 */
		public function set label(value:String):void {
			this._label.text = value;
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
			point.x += _icon.width / 2;
			point.y += _icon.height / 2;
			point.x = int(point.x / 10) * 10;
			point.y = int(point.y / 10) * 10;
			return point;
		}
		
		/**
		 * Initialize node's style
		 */
		private function initStyle():void {
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
				this.x = point.x - _icon.width / 2;
				this.y = point.y - _icon.height / 2;
			}
			invalidateDisplayList();
		}
		
	}
	
}