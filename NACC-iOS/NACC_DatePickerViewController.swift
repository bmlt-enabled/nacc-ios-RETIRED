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

/* ###################################################################################################################################### */
/**
 The ViewController class for the date selector screen.
 */
class NACC_DatePickerViewController: UIViewController {
    /// The date picker view
    @IBOutlet weak var  datePicker: UIDatePicker!
    /// The text with the explanation
    @IBOutlet weak var  explainTextField: UITextView!
    /// The Calculate button
    @IBOutlet weak var  calcButton: UIButton!
    /// The button that toggles the switch
    @IBOutlet weak var  calcOnlySwitchButton: UIButton!
    /// The show tags switch.
    @IBOutlet weak var  calcOnlySwitch: UISwitch!
    
    /* ################################################################################################################################## */
    // MARK: - @IBAction Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Called when the Show Tags Switch changes.
     
     - parameter: Ignored
     */
    @IBAction func showTagsChanged(_: Any! = nil) {
        let prefs = NACC_Prefs()
        prefs.tagDisplay = calcOnlySwitch.isOn ? .specialTags : .noTags
        NACC_AppDelegate.appDelegateObject.sendCurrentSettingsToWatch()
    }
    
    /* ################################################################## */
    /**
     Called when the Show Tags Button Toggler is hit.
     
     - parameter: Ignored
     */
    @IBAction func calcOnlyButtonHit(_: Any) {
        calcOnlySwitch.setOn(!calcOnlySwitch.isOn, animated: true)
        showTagsChanged()
    }
    
    /* ################################################################## */
    /**
     Register the date when the picker changes value.
    
     - parameter inPicker: the picker object.
    */
    @IBAction func dateChanged(_ inPicker: UIDatePicker) {
        let prefs = NACC_Prefs()
        prefs.cleanDate = inPicker.date
        NACC_AppDelegate.appDelegateObject.sendCurrentSettingsToWatch()
    }
    
    /* ################################################################################################################################## */
    // MARK: - Base Class Override Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Called when the view is loaded. We set the navbar color here.
    */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calcButton.setTitle("CALC-LABEL".localizedVariant, for: .normal)
        calcOnlySwitchButton.setTitle("CALC-ONLY-LABEL".localizedVariant, for: .normal)
        explainTextField.text = "EXPLAIN-TEXT".localizedVariant
        let newPrefs = NACC_Prefs()
        calcOnlySwitch.isOn = .noTags != newPrefs.tagDisplay
        datePicker.date = newPrefs.cleanDate ?? Date()
    }
}
