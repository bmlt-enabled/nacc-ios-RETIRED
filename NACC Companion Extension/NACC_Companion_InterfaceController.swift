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
    var extensionDelegateObject: ExtensionDelegate! {
        return WKExtension.shared().delegate as? ExtensionDelegate
    }
    
    /*******************************************************************************************/
    /**
     */
    var cleanDateCalc: NACC_DateCalc! {
        return self.extensionDelegateObject.cleanDateCalc
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
                let displayString = NACC_TagModel.getDisplayCleandate(self.cleanDateCalc.totalDays, inYears: self.cleanDateCalc.years, inMonths: self.cleanDateCalc.months, inDays: self.cleanDateCalc.days)
                self.cleandateReportLabel.setText(displayString)
                
                if self.extensionDelegateObject.showKeys && (0 < self.cleanDateCalc.totalDays) {
                    let tagModel: NACC_TagModel = NACC_TagModel(inCalculation: self.cleanDateCalc)
                    let tags: [UIImage]? = tagModel.getTags()
                    if tags != nil {
                        self.displayTags(inTagImageArray: tags!)
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
        self.tagDisplay.setHidden(true)
        self.cleandateReportLabel.setHidden(true)
        self.animationGroup.setHidden(false)
    }

    /*******************************************************************************************/
    /**
     Hides the animated tags.
     */
    func hideAnimation() {
        self.tagDisplay.setHidden(!(self.extensionDelegateObject.showKeys && (0 < self.cleanDateCalc.totalDays)))
        self.cleandateReportLabel.setHidden(false)
        self.animationGroup.setHidden(true)
    }

    /*******************************************************************************************/
    /**
     \brief  Displays the tags in the tag display panel.
     
     \param inTagImageArray the array of tag images to be displayed.
     */
    func displayTags(inTagImageArray: [UIImage]) {
        let count = CGFloat(inTagImageArray.count)
        if 0 < count {
            let prototypeImage = inTagImageArray[0]
            let width = prototypeImage.size.width
            var height = prototypeImage.size.height
            height += ((height * self._offsetMultiplier) * (count - 1))
            let size = CGSize(width: width, height: height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)    // Set up an offscreen bitmap context.
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
                    let flippedImage = UIImage(cgImage: image!.cgImage!, scale: image!.scale, orientation: UIImage.Orientation.downMirrored)
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
