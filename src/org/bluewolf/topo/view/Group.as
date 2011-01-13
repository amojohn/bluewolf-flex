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
	import flash.geom.Point;
	
	import mx.collections.ArrayList;
	import mx.core.UIComponent;
	import mx.events.MoveEvent;
	
	import org.bluewolf.topo.event.BluewolfEventConst;
	import org.bluewolf.topo.event.DragDropEvent;
	import org.bluewolf.topo.event.LayerRemoveNodeEvent;
	import org.bluewolf.topo.interf.IDragableElement;
	import org.bluewolf.topo.model.ModelLocator;
	
	/**
	 * Group contains a group of topological objects, use different background colors
	 * to represent different groups
	 * 
	 * @author	Rui
	 */
	public class Group extends UIComponent implements IDragableElement {
		
		private var _nodes:ArrayList;
		private var _topleft:Point;
		private var _bottomright:Point;
		private var realTL:Point;
		private var realBR:Point;
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public var color:Number;
		
		/**
		 * Constructor for Group class
		 */
		public function Group(gColor:Number=0x0000ff) {
			super();
			
			registerEvents();
			
			_nodes = new ArrayList();
			resetGroupArea();
			this.color = gColor;
		}
		
		private function registerEvents():void {
		}
		
		/**
		 * Implemention of IDragableElement getAlignPoint method
		 */
		public final function getAlignPoint():Point {
			return null;
		}
		
		/**
		 * The array of nodes in this group
		 * @return An ArrayList contains all nodes in this group
		 */
		public function get nodes():ArrayList {
			return this._nodes;
		}
		
		/**
		 * Add nodes into this group
		 * @param nodes Node's objects array to be added in this group
		 * @return The updated array list of nodes
		 */
		public function addNodes(arNodes:Array):ArrayList {
			for each (var node:Node in arNodes) {
				this._nodes.addItem(node);
				node.addEventListener(BluewolfEventConst.LAYER_REMOVE_NODE, onLayerRemoveNode);
				node.addEventListener(MoveEvent.MOVE, onMove);
				node.addEventListener(Event.COMPLETE, onIconComplete);
				this.setGroupRange(node);
			}
			drawGroup();
			return this._nodes;
		}
		
		/**
		 * Remove nodes in this group
		 * @param nodes Nodes to be removed in this group
		 * @return The updated array list of nodes
		 */
		public function removeNodes(arNodes:Array):ArrayList {
			for each (var node:Node in arNodes) {
				this._nodes.removeItem(node);
			}
			
			redrawGroup();
			
			return this._nodes;
		}
		
		/**
		 * Draw a colored rectangle which represents a group according to the _topleft and _bottomright coordinates.
		 */ 
		public function drawGroup():void {
			this.graphics.clear();
			this.graphics.moveTo(_topleft.x, _topleft.y);
			this.graphics.lineStyle(1, color, 0.5);
			this.graphics.beginFill(color, 0.1);
			this.graphics.drawRect(_topleft.x, _topleft.y, _bottomright.x - _topleft.x, _bottomright.y - _topleft.y);
			this.graphics.endFill();
		}
		
		/**
		 * Reinitialize the area of this Group
		 */
		private function resetGroupArea():void {
//			_topleft = new Point(model.appWidth, model.appHeight);
			_topleft = new Point(0, 0);
			_bottomright = new Point(0, 0);
//			realTL = new Point(model.appWidth, model.appHeight);
			realTL = new Point(0, 0);
			realBR = new Point(0, 0);
		}
		
		/**
		 * Resize group area and redraw the border
		 */
		public function redrawGroup():void {
			resetGroupArea();
			
			var length:uint = nodes.length;
			for (var i:uint = 0; i < length; i++) {
				this.setGroupRange(nodes.getItemAt(i) as Node);
			}
			drawGroup();
		}
		
		/**
		 * Computing and setting the area of this group
		 * @param node The input node to be used to computing
		 */
		private function setGroupRange(node:Node):void {
			if (node.x < realTL.x) {
				_topleft.x = node.x - 5;
				realTL.x = node.x;
			}
			if (node.y < realTL.y) {
				_topleft.y = node.y - 5;
				realTL.y = node.y;
			}
			if (node.x > realBR.x) {
				_bottomright.x = node.x + node.width + 5;
				realBR.x = node.x;
			}
			if (node.y > realBR.y) {
				_bottomright.y = node.y + node.height + 5;
				realBR.y = node.y;
			}
		}
		
		private function onLayerRemoveNode(e:LayerRemoveNodeEvent):void {
			this.removeNodes([e.node]);
		}
		
		private function onMove(e:MoveEvent):void {
			redrawGroup();
		}
		
		private function onIconComplete(e:Event):void {
			redrawGroup();
		}
		
	}
	
}