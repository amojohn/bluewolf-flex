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
	
	import org.bluewolf.topo.interf.IDragableElement;
	
	import spark.components.BorderContainer;
	
	/**
	 * Node object in topological diagram, consist with icon(optional) and name label
	 * 
	 * @author	Rui
	 */
	public class Node extends BorderContainer implements IDragableElement {
		
		/**
		 * Constructor for Node class
		 */
		public function Node() {
			super();
			
			initStyle();
		}
		
		/**
		 * Implemention of getAlignPoint method in IDragableElement
		 */
		public function getAlignPoint():Point {
			return null;
		}
		
		/**
		 * Initialize node's style
		 */
		private function initStyle():void {
			this.setStyle("borderStyle", "none");
			this.setStyle("backgroundAlpha", 0);
			this.setStyle("fontSize", 9);
			this.setStyle("fontColor", 0x000000);
		}
		
	}
	
}