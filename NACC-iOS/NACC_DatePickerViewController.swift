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

class NACC_DatePickerViewController: UIViewController {
    @IBOutlet weak var  datePicker: UIDatePicker?
    @IBOutlet weak var  displayView: UIView?
    @IBOutlet weak var  explainTextField: UITextView?
    @IBOutlet weak var  calcButton: UIButton?
    @IBOutlet weak var  calcOnlyLabel: UILabel!
    @IBOutlet weak var  calcOnlySwitch: UISwitch!
    
    /*******************************************************************************************/
    /**
     */
    @IBAction func showTagsChanged(_ sender: UISwitch) {
        s_NACC_AppDelegate?.showKeys = sender.isOn
        if let appDelegate = UIApplication.shared.delegate as? NACC_AppDelegate {
            appDelegate.sendCurrentProfileToWatch()
        }
    }
    
    /*******************************************************************************************/
    /**
        \brief  Register the date when the picker changes value.
    
        \param  inPicker the picker object.
    */
    @IBAction func dateChanged(_ inPicker: UIDatePicker) {
        let posixDate = inPicker.date.timeIntervalSince1970
        s_NACC_AppDelegate?.lastEnteredDate = posixDate
        s_NACC_cleanDateCalc = NACC_DateCalc(inStartDate: inPicker.date)
        if let appDelegate = UIApplication.shared.delegate as? NACC_AppDelegate {
            appDelegate.sendCurrentProfileToWatch()
        }
    }
    
    /*******************************************************************************************/
    /**
        \brief  Make sure the current displayed date is registered and that the controls are visible.
    
        \param inAnimated true, if the transition is animated.
    */
    override func viewWillAppear(_ inAnimated: Bool) {
        super.viewWillAppear(inAnimated)
        let posixDate = s_NACC_AppDelegate?.lastEnteredDate
        self.datePicker!.date = Date(timeIntervalSince1970: posixDate!)
        self.datePicker!.isHidden = false
        self.calcButton!.isHidden = false
        self.explainTextField!.isHidden = false
        self.dateChanged(self.datePicker!)
    }
    
    /*******************************************************************************************/
    /**
        \brief  Called when the view is loaded. We set the navbar color here.
    */
    override func viewWillLayoutSubviews() {
        self.navigationItem.title = NSLocalizedString("ENTER-LABEL", tableName: nil, bundle: Bundle.main, value: "ENTER-LABEL", comment: "")
        self.calcButton!.setTitle(NSLocalizedString("CALC-LABEL", tableName: nil, bundle: Bundle.main, value: "CALC-LABEL", comment: ""), for: UIControl.State())
        self.calcButton!.setTitle(NSLocalizedString("CALC-LABEL", tableName: nil, bundle: Bundle.main, value: "CALC-LABEL", comment: ""), for: UIControl.State())
        self.calcOnlyLabel!.text = NSLocalizedString("CALC-ONLY-LABEL", tableName: nil, bundle: Bundle.main, value: "CALC-LABEL", comment: "")
        self.explainTextField!.text = NSLocalizedString("EXPLAIN-TEXT", tableName: nil, bundle: Bundle.main, value: "EXPLAIN-TEXT", comment: "")
        self.calcOnlySwitch.isOn = (s_NACC_AppDelegate?.showKeys)!
        super.viewWillLayoutSubviews()
        let mainNavController: UINavigationController = (s_NACC_AppDelegate!.window!.rootViewController as? UINavigationController)!
        mainNavController.navigationBar.barTintColor = s_NACC_BaseColor
        NACC_AppDelegate.setGradient()
    }
    
    /*******************************************************************************************/
    /**
        \brief  Hide the various items, so we don't get that ugly "overlap" effect.
    
        \param inAnimated true, if the transition is animated.
    */
    override func viewWillDisappear(_ inAnimated: Bool) {
        s_NACC_cleanDateCalc = NACC_DateCalc(inStartDate: self.datePicker!.date)
        if let appDelegate = UIApplication.shared.delegate as? NACC_AppDelegate {
            appDelegate.sendCurrentProfileToWatch()
        }
        self.calcButton!.isHidden = true
        self.datePicker!.isHidden = true
        self.explainTextField!.isHidden = true
        super.viewWillDisappear(inAnimated)
    }
}
