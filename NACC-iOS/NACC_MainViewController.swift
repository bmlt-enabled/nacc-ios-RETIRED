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

class NACC_MainViewController : UIViewController
{
    let             s_offsetMultiplier: CGFloat     = 0.31  // This is a multiplier for ofsetting the tag images so they form a "chain."
    
    var             gradientLayer:CAGradientLayer?  = nil
    @IBOutlet var   resultTextDisplayView:UILabel?
    @IBOutlet var   tagDisplayView:UIView?
    @IBOutlet var   tagDisplayScroller:UIScrollView?
    @IBOutlet var   headerView: UIView?
    @IBOutlet var   cleandateLabel: UILabel?
    
    /*******************************************************************************************/
    /**
     \brief  Called when the view is loaded. We set the navbar color here.
     */
    override func viewDidLoad()
    {
        self.navigationItem.title = NSLocalizedString ( "CALC-LABEL", tableName: nil, bundle: Bundle.main, value: "CALC-LABEL", comment: "" )
        super.viewDidLoad()
    }

    /*******************************************************************************************/
    /**
        \brief  Displays a single tag in the scroll view.
        
        \param inTag a UIImage of the tag to be displayed.
        \param inOffset the vertical offset (from the top of the display view) of the tag to be drawn.
    */
    func displayTag ( inTag:UIImage, inOffset:inout CGFloat )
    {
        let imageView:UIImageView = UIImageView ( image:inTag )
        var containerRect:CGRect = self.tagDisplayView!.bounds   // See what we have to work with. We will be extending this.
        let targetRect:CGRect = CGRect ( x: (containerRect.size.width - inTag.size.width) / 2.0, y: inOffset, width: inTag.size.width, height: inTag.size.height )
        imageView.frame = targetRect
        containerRect.size.height = max ( (targetRect.origin.y + targetRect.size.height), (containerRect.origin.y + containerRect.size.height) )
        self.tagDisplayView!.frame = containerRect
        self.tagDisplayScroller!.contentSize = containerRect.size
        self.tagDisplayView!.addSubview ( imageView )
        self.tagDisplayScroller!.scrollRectToVisible(targetRect, animated: true)
        inOffset = inOffset + (inTag.size.height * self.s_offsetMultiplier)
    }
    
    /*******************************************************************************************/
    /**
        \brief  Displays the tags in the scroll view.
        
        \param inTagImageArray the array of tag images to be displayed.
    */
    func displayTags ( inTagImageArray:[UIImage] )
    {
        self.tagDisplayView!.bounds = self.tagDisplayScroller!.bounds
        if ( inTagImageArray.count > 0 )    // We need to have images to display
        {
            var offset:CGFloat = 0.0    // This will be the vertical offset for each tag.

            for tag in inTagImageArray
            {
                self.displayTag ( inTag: tag, inOffset: &offset )
            }
        }
    }
    
    /*******************************************************************************************/
    /**
        \brief  Override of base class layout preflight.
                We use this method to set up our keytag display.
    */
    override func viewDidLayoutSubviews ( )
    {
        let subViews = self.tagDisplayView!.subviews 
        
        for subView in subViews
        {
            subView.removeFromSuperview()
        }
        
        self.tagDisplayView!.frame = self.tagDisplayScroller!.bounds
        self.tagDisplayScroller!.setContentOffset ( CGPoint.zero, animated: false )
        self.tagDisplayScroller!.contentSize = self.tagDisplayView!.bounds.size

        let displayString = NACC_TagModel.getDisplayCleandate ( s_NACC_cleanDateCalc.totalDays, inYears: s_NACC_cleanDateCalc.years, inMonths: s_NACC_cleanDateCalc.months, inDays: s_NACC_cleanDateCalc.days )
        
        if ( s_NACC_cleanDateCalc.totalDays > 0 )
        {
            let resultsString:String = NSLocalizedString ( "RESULTS-LINE1", tableName: nil, bundle: Bundle.main, value: "RESULTS-LINE1", comment: "" )
            let dateString:String = s_NACC_cleanDateCalc.dateString
            
            self.cleandateLabel!.text = NSString ( format:resultsString as NSString, dateString ) as String
        }
        
        self.resultTextDisplayView!.text = displayString
        let tagModel:NACC_TagModel = NACC_TagModel ( inCalculation: s_NACC_cleanDateCalc )
        let tags:[UIImage]? = tagModel.getTags()
        if ( tags != nil )
        {
            self.displayTags ( inTagImageArray: tags! )
        }
        
        NACC_AppDelegate.setGradient()
        self.setGradient()
        let mainNavController: UINavigationController = s_NACC_AppDelegate!.window!.rootViewController as! UINavigationController
        mainNavController.navigationBar.barTintColor = mainNavController.navigationBar.backgroundColor
        super.viewDidLayoutSubviews ( )
    }
    
    /*******************************************************************************************/
    /**
        \brief  We create the gradient that we use to fill the background of the textual report.
                This is a semi-transparent gradient that allows you to see the tags beneath the report.
    */
    func setGradient()
    {
        if ( (s_NACC_AppDelegate != nil) && (s_NACC_AppDelegate!.window != nil) )
        {
            if ( s_NACC_BaseColor != nil )
            {
                var gradientEndColor:UIColor? = nil
                var gradientMidColor:UIColor? = nil
                var r:CGFloat = 0
                var g:CGFloat = 0
                var b:CGFloat = 0
                var a:CGFloat = 0
                let startPoint:CGPoint = CGPoint ( x: 0.5, y: 1 )
                let endPoint:CGPoint = CGPoint ( x: 0.5, y: 0 )
                
                if ( s_NACC_BaseColor!.getRed ( &r, green: &g, blue: &b, alpha: &a ) )
                {
                    gradientMidColor = UIColor ( red:r - 0.2, green:g - 0.2, blue:b - 0.2, alpha:0.75 )
                    gradientEndColor = UIColor ( red:r, green:g, blue:b, alpha:0.0 )
                }
                
                if ( gradientLayer != nil )
                {
                    gradientLayer!.removeFromSuperlayer()
                }
                
                gradientLayer = CAGradientLayer()
                
                if ( (gradientLayer != nil) && (gradientMidColor != nil) && (gradientEndColor != nil) )
                {
                    gradientLayer!.endPoint = endPoint
                    gradientLayer!.startPoint = startPoint
                    let clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                    let mainNavController: UINavigationController = s_NACC_AppDelegate!.window!.rootViewController as! UINavigationController
                    let endColor:CGColor = gradientEndColor!.cgColor
                    let midColor:CGColor = gradientMidColor!.cgColor
                    let startColor:CGColor = mainNavController.navigationBar.backgroundColor != nil ? mainNavController.navigationBar.backgroundColor!.cgColor : clearColor.cgColor
                    gradientLayer!.colors = [endColor, startColor]
                    gradientLayer!.colors = [   endColor,
                                                midColor,
                                                startColor
                                            ]
                    gradientLayer!.locations = [    NSNumber (value: 0.0 as Float),
                                                    NSNumber (value: 0.4 as Float),
                                                    NSNumber (value: 1.0 as Float)
                                            ]
                    gradientLayer!.frame = self.headerView!.bounds
                    self.headerView!.layer.insertSublayer ( gradientLayer!, at: 0 )
                }
            }
        }
    }
}
