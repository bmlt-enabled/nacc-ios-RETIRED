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
    @IBOutlet var cleandateReportLabel: WKInterfaceLabel!
    @IBOutlet var tagDisplayGroup: WKInterfaceGroup!
    
    var extensionDelegateObject:ExtensionDelegate! {
        get {
            return WKExtension.shared().delegate as! ExtensionDelegate
        }
    }
    
    var cleanDateCalc:NACC_DateCalc! {
        get {
            return self.extensionDelegateObject.cleanDateCalc
        }
    }

    /* ################################################################################################################################## */
    func performCalculation() {
        DispatchQueue.main.async {
            if 0 < self.cleanDateCalc.totalDays {
                let displayString = NACC_TagModel.getDisplayCleandate ( self.cleanDateCalc.totalDays, inYears: self.cleanDateCalc.years, inMonths: self.cleanDateCalc.months, inDays: self.cleanDateCalc.days )
                self.cleandateReportLabel.setText(displayString)
            }
        }
    }
    
    /* ################################################################################################################################## */
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.cleandateReportLabel.setText("APP-NOT-CONNECTED".localizedVariant)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
