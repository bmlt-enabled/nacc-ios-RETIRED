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

class NACC_DatePickerViewController : UIViewController
{
    @IBOutlet var   datePicker:UIDatePicker?
    @IBOutlet var   displayView: UIView?
    @IBOutlet var   explainTextField: UITextView?
    @IBOutlet var   calcButton: UIButton?
    
    /*******************************************************************************************/
    /**
        \brief  Register the date when the picker changes value.
    
        \param  inPicker the picker object.
    */
    @IBAction func dateChanged ( _ inPicker: UIDatePicker )
    {
        s_NACC_cleanDateCalc = NACC_DateCalc ( inStartDate: inPicker.date )
    }
    
    /*******************************************************************************************/
    /**
        \brief  Make sure the current displayed date is registered and that the controls are visible.
    
        \param inAnimated true, if the transition is animated.
    */
    override func viewWillAppear ( _ inAnimated: Bool )
    {
        super.viewWillAppear ( inAnimated )
        self.datePicker!.date = s_NACC_cleanDateCalc.startDate! as Date
        self.datePicker!.isHidden = false
        self.calcButton!.isHidden = false
        self.explainTextField!.isHidden = false
    }
    
    /*******************************************************************************************/
    /**
        \brief  Called when the view is loaded. We set the navbar color here.
    */
    override func viewWillLayoutSubviews() 
    {
        self.navigationItem.title = NSLocalizedString ( "ENTER-LABEL", tableName: nil, bundle: Bundle.main, value: "ENTER-LABEL", comment: "" )
        self.calcButton!.setTitle ( NSLocalizedString ( "CALC-LABEL", tableName: nil, bundle: Bundle.main, value: "CALC-LABEL", comment: "" ), for: UIControlState() )
        self.explainTextField!.text = NSLocalizedString ( "EXPLAIN-TEXT", tableName: nil, bundle: Bundle.main, value: "EXPLAIN-TEXT", comment: "" )
        super.viewWillLayoutSubviews()
        let mainNavController: UINavigationController = s_NACC_AppDelegate!.window!.rootViewController as! UINavigationController
        mainNavController.navigationBar.barTintColor = s_NACC_BaseColor
        NACC_AppDelegate.setGradient()
    }
    
    /*******************************************************************************************/
    /**
        \brief  Hide the various items, so we don't get that ugly "overlap" effect.
    
        \param inAnimated true, if the transition is animated.
    */
    override func viewWillDisappear ( _ inAnimated: Bool )
    {
        s_NACC_cleanDateCalc = NACC_DateCalc ( inStartDate: self.datePicker!.date )
        self.calcButton!.isHidden = true
        self.datePicker!.isHidden = true
        self.explainTextField!.isHidden = true
        super.viewWillDisappear ( inAnimated )
    }
}
