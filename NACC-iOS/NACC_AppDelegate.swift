/*
    This is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    NACC is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this code.  If not, see <http://www.gnu.org/licenses/>.
*/

import UIKit
import QuartzCore

var s_NACC_cleanDateCalc:NACC_DateCalc = NACC_DateCalc ()   ///< This holds our global date calculation.
var s_NACC_BaseColor:UIColor? = nil                         ///< This will hold the color that will tint our backgrounds.
var s_NACC_AppDelegate:NACC_AppDelegate? = nil
var s_NACC_GradientLayer:CAGradientLayer? = nil

@UIApplicationMain class NACC_AppDelegate: UIResponder, UIApplicationDelegate
{
    var window:UIWindow?
    
    /*******************************************************************************************/
    /**
        \brief  Simply set the SINGLETON to us.
    */
    func application ( application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary! ) -> Bool
    {
        s_NACC_AppDelegate = self
        return true
    }
    
    /*******************************************************************************************/
    /**
        \brief  We make sure that the first window is always the date selector.
    */
    func applicationWillEnterForeground( application: UIApplication! )
    {
        let mainNavController: UINavigationController = s_NACC_AppDelegate!.window!.rootViewController as UINavigationController
        
        if ( mainNavController.topViewController.isKindOfClass ( NACC_MainViewController.self ) )
        {
            mainNavController.popToRootViewControllerAnimated ( true )
        }
    }
    
    /*******************************************************************************************/
    /**
        \brief  Create the gradient for the back of the window.
    */
    class func setGradient()
    {
        if ( (s_NACC_AppDelegate != nil) && (s_NACC_AppDelegate!.window != nil) )
        {
            let mainNavController: UINavigationController = s_NACC_AppDelegate!.window!.rootViewController as UINavigationController
            
            var gradientEndColor:UIColor? = nil
            var r:CGFloat = 0
            var g:CGFloat = 0
            var b:CGFloat = 0
            var a:CGFloat = 0
            var startPoint:CGPoint = CGPointMake ( 0.5, 0 )
            var endPoint:CGPoint = CGPointMake ( 0.5, 1 )
            
            // We have the gradient get lighter. The source is the background color we set for our navigation bar.
            if ( (mainNavController.navigationBar.backgroundColor != nil) && mainNavController.navigationBar.backgroundColor!.getRed ( &r, green: &g, blue: &b, alpha: &a ) )
            {
                r = r + 0.4
                g = g + 0.4
                b = b + 0.4
                
                gradientEndColor = UIColor ( red:r, green:g, blue:b, alpha:1.0 )
            }
            
            s_NACC_BaseColor = gradientEndColor
            mainNavController.navigationBar.barTintColor = s_NACC_BaseColor
            
            if ( s_NACC_GradientLayer != nil )
            {
                s_NACC_GradientLayer!.removeFromSuperlayer()
            }
            
            s_NACC_GradientLayer = CAGradientLayer()
            
            if ( (s_NACC_GradientLayer != nil) && (gradientEndColor != nil) )
            {
                s_NACC_GradientLayer!.endPoint = endPoint
                s_NACC_GradientLayer!.startPoint = startPoint
                
                let endColor:CGColorRef = gradientEndColor!.CGColor
                let startColor:CGColorRef = mainNavController.navigationBar.backgroundColor != nil ? mainNavController.navigationBar.backgroundColor!.CGColor : nil
                
                s_NACC_GradientLayer!.colors = [endColor, startColor]
                s_NACC_GradientLayer!.locations = [ NSNumber ( float: 0.0 ),
                                                    NSNumber ( float: 1.0 )
                                                   ]
                s_NACC_GradientLayer!.frame = s_NACC_AppDelegate!.window!.bounds
                s_NACC_AppDelegate!.window!.layer.insertSublayer ( s_NACC_GradientLayer, atIndex: 0 )
            }
        }
    }
}

