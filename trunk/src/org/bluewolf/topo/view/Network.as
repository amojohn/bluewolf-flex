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
	
	import mx.controls.SWFLoader;
	import mx.core.FlexGlobals;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	
	import spark.components.BorderContainer;
	
	
	[Style(name="bgImage", type="String", inherit="no")]
	
	/**
	 * Network is a container which contains one or more layers.
	 * 
	 * @author	Rui
	 */
	public class Network extends BorderContainer {
		
		private var bgLoader:SWFLoader;
		
		private static var classConstructed:Boolean = constructStyle();
		private var backgroundImage:String;
		private var bStylePropChanged:Boolean;
		
		private static function constructStyle():Boolean {
			if (!FlexGlobals.topLevelApplication.styleManager
					.getStyleDeclaration("org.bluewolf.topo.view.Network")) {
				var style:CSSStyleDeclaration = new CSSStyleDeclaration();
				style.defaultFactory = function():void {
					this.backgroundImage = "";
				};
			FlexGlobals.topLevelApplication.styleManager
				.setStyleDeclaration("org.bluewolf.topo.view.Network", style, true);
			}
			return true;
		}
		
		override public function styleChanged(styleProp:String):void {
			super.styleChanged(styleProp);
			if (styleProp == "bgImage") {
				bStylePropChanged = true;
				invalidateDisplayList();
				return;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			if (bStylePropChanged) {
				this.backgroundImage = getStyle("bgImage");
				bgLoader = new SWFLoader();
				bgLoader.addEventListener(Event.COMPLETE, onBgImageComplete);
				bgLoader.load(this.backgroundImage);
			}
		}
		
		private function onBgImageComplete(e:Event):void {
			this.setStyle("backgroundImage", bgLoader.content);
		}
		
		private var _layers:Array = new Array();
		
		public function get layers():Array {
			return this._layers;
		}
		
		/**
		 * Constructor for Network class
		 */
		public function Network() {
			super();
			
			this.initStyle();
		}
		
		/**
		 * Initialize container's style
		 */
		private function initStyle():void {
			this.setStyle("borderStyle", "none");
			this.setStyle("backgroundColor", 0xffffff);
			this.setStyle("backgroundAlpha", 1);
		}
		
		/**
		 * Add a layer in network, order by adding sequenct
		 * @param layer A layer object to add in the network
		 * @param x x-position of the added layer
		 * @param y y-position of the added layer
		 */
		public function addLayer(layer:Layer, x:Number=0, y:Number=0):void {
			layer.x = x;
			layer.y = y;
			this.addChild(layer);
			this._layers.push(layer);
		}
		
		/**
		 * Put the select layer on the top of container
		 * @param layer The layer to put on the top of network
		 */
		public function selectLayer(layer:Layer):void {
			if (ArrayUtil.arrayContainsValue(layers, layer)) {
				layer.depth = 99;
			}
		}
		
	}
}