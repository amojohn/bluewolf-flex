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
	import flash.geom.Point;
	
	import mx.controls.Alert;
	import mx.core.DragSource;
	import mx.managers.DragManager;
	
	import org.bluewolf.topo.event.BluewolfEventConst;
	import org.bluewolf.topo.event.LayerRemoveNodeEvent;
	import org.bluewolf.topo.event.RemoveLinkEvent;
	import org.bluewolf.topo.event.SelectNodeEvent;
	import org.bluewolf.topo.model.ModelLocator;
	import org.bluewolf.topo.util.TopoUtil;
	
	import spark.components.Group;
		
	/**
	 * Layer is used to create different layers in network container, it can contains nodes, links and other components
	 * 
	 * @author	Rui
	 */
	public class Layer extends Group {
		
		private var _nodes:Array;
		private var _links:Array;
		private var _groups:Array;
		private var model:ModelLocator = ModelLocator.getInstance();
		
		/**
		 * Construtor for Layer class
		 */
		public function Layer() {
			super();
			
			this.initStyle();
			this.registerEvents();
			
			this.percentWidth = this.percentHeight = 100;
			this.width = model.appWidth;
			this.height = model.appHeight;
			
			this._nodes = new Array();
			this._links = new Array();
			this._groups = new Array();
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
		private function registerEvents():void {}
		
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
			this.invalidateDisplayList();
		}
		
		/**
		 * Remove node object from this layer
		 * @param node The node object to be removed in this layer, must be an instance of Node class or Subclass from Node
		 * @return If layer contains given node and succeed in removing it, return true, otherwise, return false
		 */
		public function removeNode(node:Node):Boolean {
			var isSuccess:Boolean = false;
			if (ArrayUtil.arrayContainsValue(_nodes, node)) {
				var event:LayerRemoveNodeEvent = new LayerRemoveNodeEvent(BluewolfEventConst.LAYER_REMOVE_NODE,
					true, true, node);
				node.dispatchEvent(event);
				
				this.removeElement(node);
				ArrayUtil.removeValueFromArray(_nodes, node);
				isSuccess = true;
			}
			this.invalidateDisplayList();
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
			link.addEventListener(BluewolfEventConst.REMOVE_LINK, onRemoveLink);
			this._links.push(link);
			link.source.addConnection(link.destination.uid, link);
			link.destination.addConnection(link.source.uid, link);
			
			redrawExistLinksByNodes(link);
			
			this.invalidateDisplayList();
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
			link.source.removeConnection(link.destination.uid, link);
			link.destination.removeConnection(link.source.uid, link);
			this.invalidateDisplayList();
			return isSuccess;
		}
		
		/**
		 * Get all groups in this layer
		 * @return An array of all group objects
		 */
		public function get groups():Array {
			return this._groups;
		}
		
		/**
		 * Add group object into this layer
		 * @param group The group object to be added in this layer, must be an instance of Group class or Subclass.
		 */
		public function addGroup(group:org.bluewolf.topo.view.Group):void {
			this.addElementAt(group, 0);
			this._groups.push(group);
			this.invalidateDisplayList();
		}
		
		/**
		 * Remove group object in this layer
		 * @param group The group object to be removed in this layer
		 * @return If remove operation succeed, return true, or return false
		 */
		public function removeGroup(group:org.bluewolf.topo.view.Group):Boolean {
			var isSuccess:Boolean = false;
			if (ArrayUtil.arrayContainsValue(_groups, group)) {
				this.removeElement(group);
				ArrayUtil.removeValueFromArray(_groups, group);
				isSuccess = true;
			}
			return isSuccess;
		}
		
		private function onRemoveLink(e:RemoveLinkEvent):void {
			this.removeLink(e.link);
		}
		
		private function redrawExistLinksByNodes(link:Link):void {
			if (link.source.getConnection(link.destination.uid).length == link.destination.getConnection(link.source.uid).length) {
				var arExistLinks:Array = link.source.getConnection(link.destination.uid);
				var cps:Array = TopoUtil.getControlPoints(link, arExistLinks.length-1);
				for (var i:int = 0; i < arExistLinks.length; i++) {
					arExistLinks[i].cPoint = cps[i];
					arExistLinks[i].drawLink();
				}
			}
		}
	}
}