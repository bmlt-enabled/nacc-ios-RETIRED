/**
 © Copyright 2019, Little Green Viper Software Development LLC
 
 LICENSE:
 
 MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 Little Green Viper Software Development LLC: https://littlegreenviper.com
 */

import UIKit
import QuartzCore

class NACC_ResultsViewController: UIViewController {
    /*******************************************************************************************/
    /**
     */
    static let s_offsetMultiplier: CGFloat     = 0.31  // This is a multiplier for ofsetting the tag images so they form a "chain."

    /*******************************************************************************************/
    /**
     */
    @IBOutlet weak var  resultTextDisplayView: UILabel!
    @IBOutlet weak var  tagDisplayView: UIView!
    @IBOutlet weak var  tagDisplayScroller: UIScrollView!
    @IBOutlet weak var  headerView: UIView!
    @IBOutlet weak var  cleandateLabel: UILabel!
    @IBOutlet weak var  doneButton: UIButton!
    
    /*******************************************************************************************/
    /**
     \brief  Called When the DONE button is hit.
     */
    @IBAction func doneButtonHit(_: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*******************************************************************************************/
    /**
     \brief  Called when the view is loaded. We set the navbar color here.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.setTitle(doneButton.title(for: .normal)?.localizedVariant, for: .normal)
    }

    /*******************************************************************************************/
    /**
        \brief  Displays a single tag in the scroll view.
        
        \param inTag a UIImage of the tag to be displayed.
        \param inOffset the vertical offset (from the top of the display view) of the tag to be drawn.
    */
    func displayTag(inTag: UIImage, inOffset: inout CGFloat) {
        let imageView: UIImageView = UIImageView(image: inTag)
        var containerRect: CGRect = tagDisplayView!.bounds   // See what we have to work with. We will be extending this.
        let targetRect: CGRect = CGRect(x: (containerRect.size.width - inTag.size.width) / 2.0, y: inOffset, width: inTag.size.width, height: inTag.size.height)
        imageView.frame = targetRect
        containerRect.size.height = max((targetRect.origin.y + targetRect.size.height), (containerRect.origin.y + containerRect.size.height))
        tagDisplayView!.frame = containerRect
        tagDisplayScroller!.contentSize = containerRect.size
        tagDisplayView!.addSubview(imageView)
        tagDisplayScroller!.scrollRectToVisible(targetRect, animated: true)
        inOffset += (inTag.size.height * type(of: self).s_offsetMultiplier)
    }
    
    /*******************************************************************************************/
    /**
        \brief  Displays the tags in the scroll view.
        
        \param inTagImageArray the array of tag images to be displayed.
    */
    func displayTags(inTagImageArray: [UIImage]) {
        let prefs = NACC_Prefs()
        
        if .noTags != prefs.tagDisplay {
            tagDisplayView!.bounds = tagDisplayScroller!.bounds
            if !inTagImageArray.isEmpty {  // We need to have images to display
                var offset: CGFloat = 0.0    // This will be the vertical offset for each tag.

                for tag in inTagImageArray {
                    displayTag(inTag: tag, inOffset: &offset)
                }
            }
        }
    }
    
    /*******************************************************************************************/
    /**
        \brief  Override of base class layout preflight.
                We use this method to set up our keytag display.
    */
    override func viewDidLayoutSubviews() {
        let subViews = tagDisplayView!.subviews
        
        for subView in subViews {
            subView.removeFromSuperview()
        }
        
        tagDisplayView!.frame = tagDisplayScroller!.bounds
        tagDisplayScroller!.setContentOffset(CGPoint.zero, animated: false)
        tagDisplayScroller!.contentSize = tagDisplayView!.bounds.size

        let dateCalc: NACC_DateCalc = NACC_DateCalc()  ///< This holds our date calculation.

        let displayString = NACC_TagModel.getDisplayCleandate(dateCalc.totalDays, inYears: dateCalc.years, inMonths: dateCalc.months, inDays: dateCalc.days)
        
        if dateCalc.totalDays > 0 {
            let resultsString: String = NSLocalizedString("RESULTS-LINE1", tableName: nil, bundle: Bundle.main, value: "RESULTS-LINE1", comment: "")
            let dateString: String = dateCalc.dateString
            
            cleandateLabel?.text = NSString(format: resultsString as NSString, dateString) as String
        }
        
        resultTextDisplayView?.text = displayString
        let tagModel: NACC_TagModel = NACC_TagModel(inCalculation: dateCalc)
        let tags: [UIImage]? = tagModel.getTags()
        if tags != nil {
            displayTags(inTagImageArray: tags!)
        }
        
        NACC_AppDelegate.appDelegateObject.sendCurrentSettingsToWatch()

        super.viewDidLayoutSubviews()
    }
}
