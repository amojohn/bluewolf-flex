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

package org.bluewolf.topo.util {
	import flash.geom.Point;
	
	import org.bluewolf.topo.view.Link;
	
	/**
	 * TopoUtil is class which provide some common functions for other topological class to use
	 * 
	 * @author	Rui
	 */
	public class TopoUtil {
		public static function getControlPoints(link:Link, number:Number):Array {
			var arCtrlPoints:Array = [];
			var sPoint:Point = link.source.getAlignPoint();
			var dPoint:Point = link.destination.getAlignPoint();
			if (sPoint.x >= dPoint.x) {
				var p:Point = sPoint;
				sPoint = dPoint;
				dPoint = p;
			}
			var arMainCtrls:Array = TopoUtil.computeCtrlPoint(sPoint, dPoint);
			var mainCtrl1:Point = arMainCtrls[0] as Point;
			var mainCtrl2:Point = arMainCtrls[1] as Point;
			
			if (number == 0) {
				arCtrlPoints.push(Point.interpolate(sPoint, dPoint, 0.5));
			} else {
				for (var i:int = 0; i <= number; i++) {
					arCtrlPoints.push(Point.interpolate(mainCtrl1, mainCtrl2, i/number));
				}
			}
			return arCtrlPoints;
		}
		
		private static function computeCtrlPoint(p1:Point, p2:Point):Array {
			var p3:Point = new Point();
			var p4:Point = new Point();
			var coef:Number = 15 / Point.distance(p1, p2);
			p3.x = (p1.x + p2.x) / 2 - (p2.y - p1.y) * coef;
			p3.y = (p1.y + p2.y) / 2 + (p2.x - p1.x) * coef;
			p4.x = (p1.x + p2.x) / 2 + (p2.y - p1.y) * coef;
			p4.y = (p1.y + p2.y) / 2 - (p2.x - p1.x) * coef;
			return [p3, p4];
		}
	}
	
}