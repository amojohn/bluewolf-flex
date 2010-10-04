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
	
	import flash.geom.Point;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.core.UIComponent;
	
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
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public var color:Number;
		
		/**
		 * Constructor for Group class
		 */
		public function Group(gColor:Number=0x0000ff) {
			super();
			
			_nodes = new ArrayList();
			_topleft = new Point(model.appWidth, model.appHeight);
			_bottomright = new Point(0, 0);
			this.color = gColor;
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
				if (node.x < _topleft.x)
					_topleft.x = node.x - 5;
				if (node.y < _topleft.y)
					_topleft.y = node.y - 5;
				if (node.x > _bottomright.x)
					_bottomright.x = node.x + node.width + 5;
				if (node.y > _bottomright.y)
					_bottomright.y = node.y + node.height + 5;
			}
			drawGroup();
			return this._nodes;
		}
		
		/**
		 * Remove nodes in this group
		 * @param nodes Nodes to be removed in this group
		 * @return The updated array list of nodes
		 */
		public function removeNodes(nodes:Array):ArrayList {
			for each (var node:Node in nodes) {
				this._nodes.removeItem(node);
			}
			return this._nodes;
		}
		
		public function drawGroup():void {
			this.graphics.clear();
			this.graphics.moveTo(_topleft.x, _topleft.y);
			this.graphics.lineStyle(2, color, 1);
			this.graphics.beginFill(color, 0.5);
			this.graphics.drawRect(_topleft.x, _topleft.y, _bottomright.x - _topleft.x, _bottomright.y - _topleft.y);
			this.graphics.endFill();
		}
		
	}
	
}