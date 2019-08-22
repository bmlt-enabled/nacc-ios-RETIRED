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

class NACC_DatePickerViewController: UIViewController {
    @IBOutlet weak var  datePicker: UIDatePicker!
    @IBOutlet weak var  displayView: UIView!
    @IBOutlet weak var  explainTextField: UITextView!
    @IBOutlet weak var  calcButton: UIButton!
    @IBOutlet weak var  calcOnlySwitchButton: UIButton!
    @IBOutlet weak var  calcOnlySwitch: UISwitch!
    
    /*******************************************************************************************/
    /**
     */
    @IBAction func showTagsChanged(_: Any! = nil) {
        let prefs = NACC_Prefs()
        prefs.tagDisplay = self.calcOnlySwitch.isOn ? .specialTags : .noTags
    }
    
    /*******************************************************************************************/
    /**
     */
    @IBAction func calcOnlyButtonHit(_: Any) {
        calcOnlySwitch.isOn = !calcOnlySwitch.isOn
        self.showTagsChanged()
    }
    
    /*******************************************************************************************/
    /**
        \brief  Register the date when the picker changes value.
    
        \param  inPicker the picker object.
    */
    @IBAction func dateChanged(_ inPicker: UIDatePicker) {
        let prefs = NACC_Prefs()
        prefs.cleanDate = inPicker.date
    }
    
    /*******************************************************************************************/
    /**
        \brief  Called when the view is loaded. We set the navbar color here.
    */
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.calcButton.setTitle("CALC-LABEL".localizedVariant, for: .normal)
        self.calcOnlySwitchButton.setTitle("CALC-ONLY-LABEL".localizedVariant, for: .normal)
        self.explainTextField.text = "EXPLAIN-TEXT".localizedVariant
        let newPrefs = NACC_Prefs()
        self.calcOnlySwitch.isOn = .noTags != newPrefs.tagDisplay
        self.datePicker.date = newPrefs.cleanDate
    }
}
