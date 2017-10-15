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

import WatchKit

/* ###################################################################################################################################### */
class NACC_Companion_InterfaceController: WKInterfaceController {
    /* ################################################################################################################################## */
    @IBOutlet var cleandateReportLabel: WKInterfaceLabel!
    @IBOutlet var tagDisplay: WKInterfaceImage!
    @IBOutlet var animationGroup: WKInterfaceGroup!
    
    /* ################################################################################################################################## */
    private let _offsetMultiplier: CGFloat          = 0.31  // This is a multiplier for ofsetting the tag images so they form a "chain."
    private var _leaveMeAloneCantYouSeeImBusy: Bool = false // This is a semaphore to prevent constant resetting the requests.
    
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     */
    var extensionDelegateObject:ExtensionDelegate! {
        get {
            return WKExtension.shared().delegate as! ExtensionDelegate
        }
    }
    
    /*******************************************************************************************/
    /**
     */
    var cleanDateCalc:NACC_DateCalc! {
        get {
            return self.extensionDelegateObject.cleanDateCalc
        }
    }
    
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     */
    func performCalculation() {
        DispatchQueue.main.async {
            self.hideAnimation()
            self.tagDisplay.setImage(nil)
            if nil != self.cleanDateCalc {
                let displayString = NACC_TagModel.getDisplayCleandate ( self.cleanDateCalc.totalDays, inYears: self.cleanDateCalc.years, inMonths: self.cleanDateCalc.months, inDays: self.cleanDateCalc.days )
                self.cleandateReportLabel.setText(displayString)
                
                if self.extensionDelegateObject.showKeys && (0 < self.cleanDateCalc.totalDays) {
                    let tagModel:NACC_TagModel = NACC_TagModel ( inCalculation: self.cleanDateCalc )
                    let tags:[UIImage]? = tagModel.getTags()
                    if ( tags != nil ) {
                        self.displayTags ( inTagImageArray: tags! )
                    }
                } else {
                    if 0 == self.cleanDateCalc.totalDays {
                        self.showAnimation()
                    }
                }
            } else {
                self.showAnimation()
            }
       }
    }

    /*******************************************************************************************/
    /**
     Shows the animated tags.
     */
    func showAnimation() {
        DispatchQueue.main.async {
            self.tagDisplay.setHidden(true)
            self.cleandateReportLabel.setHidden(true)
            self.animationGroup.setHidden(false)
        }
    }

    /*******************************************************************************************/
    /**
     Hides the animated tags.
     */
    func hideAnimation() {
        DispatchQueue.main.async {
            self.tagDisplay.setHidden(!(self.extensionDelegateObject.showKeys && (0 < self.cleanDateCalc.totalDays)))
            self.cleandateReportLabel.setHidden(false)
            self.animationGroup.setHidden(true)
        }
    }

    /*******************************************************************************************/
    /**
     \brief  Displays the tags in the tag display panel.
     
     \param inTagImageArray the array of tag images to be displayed.
     */
    func displayTags ( inTagImageArray:[UIImage] )
    {
        let count = CGFloat(inTagImageArray.count)
        if 0 < count {
            let prototypeImage = inTagImageArray[0]
            let width = prototypeImage.size.width
            var height = prototypeImage.size.height
            height += ((height * self._offsetMultiplier) * (count - 1))
            let size = CGSize(width:width, height:height)
            UIGraphicsBeginImageContextWithOptions ( size, false, 0 )    // Set up an offscreen bitmap context.
            if let drawingContext = UIGraphicsGetCurrentContext() {
                // OK. The graphics context here is mirrored upside-down, so we start at the bottom, and go up
                var offset = (height - prototypeImage.size.height)
                for index in 0..<inTagImageArray.count {
                    let image = inTagImageArray[index]
                    let imageRect = CGRect(x: 0, y: offset, width: image.size.width, height: image.size.height)
                    if let cgImage = image.cgImage {
                        drawingContext.draw(cgImage, in: imageRect)
                    }
                    
                    offset -= (image.size.height * self._offsetMultiplier)
                }
                
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                if nil != image {
                    // Now, we flip the image to display naturally.
                    let flippedImage = UIImage(cgImage: image!.cgImage!, scale: image!.scale, orientation:UIImageOrientation.downMirrored)
                    self.tagDisplay.setImage(flippedImage)
                }
            }
        }
    }

    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
        This method is called when watch view controller is about to be visible to user
     */
    override func willActivate() {
        super.willActivate()
        if !self._leaveMeAloneCantYouSeeImBusy && (nil != self.cleanDateCalc) {
            self.performCalculation()
        } else {
            self._leaveMeAloneCantYouSeeImBusy = true
            self.extensionDelegateObject.sendRequestUpdateMessage()
            self.showAnimation()
        }
    }
}
