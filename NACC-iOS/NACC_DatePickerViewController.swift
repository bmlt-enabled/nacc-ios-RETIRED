//
//  NACC_DatePickerViewController.swift
//  NACC-iOS
//
//  Created by Chris Marshall on 6/29/14.
//  Copyright (c) 2014 MAGSHARE. All rights reserved.
//

import UIKit

class NACC_DatePickerViewController : UIViewController
{
    @IBOutlet var   datePicker:UIDatePicker
    @IBOutlet var   displayView: UIView
    @IBOutlet var   explainTextField: UITextView
    @IBOutlet var   calcButton: UIButton
    
    /*******************************************************************************************/
    /**
        \brief  Register the date when the picker changes value.
    
        \param  inPicker the picker object.
    */
    @IBAction func dateChanged ( inPicker: UIDatePicker )
    {
        s_NACC_cleanDateCalc = NACC_DateCalc ( inStartDate: inPicker.date )
    }
    
    /*******************************************************************************************/
    /**
        \brief  Make sure the current displayed date is registered and that the controls are visible.
    
        \param inAnimated true, if the transition is animated.
    */
    override func viewWillAppear ( inAnimated: Bool )
    {
        super.viewWillAppear ( inAnimated )
        self.datePicker.date = s_NACC_cleanDateCalc.startDate
        self.datePicker.hidden = false
        self.calcButton.hidden = false
        self.explainTextField.hidden = false
    }
    
    /*******************************************************************************************/
    /**
        \brief  Called when the view is loaded. We set the navbar color here.
    */
    override func viewWillLayoutSubviews() 
    {
        self.navigationItem.title = NSLocalizedString ( "ENTER-LABEL", tableName: nil, bundle: NSBundle.mainBundle(), value: "ENTER-LABEL", comment: "" )
        self.calcButton.setTitle ( NSLocalizedString ( "CALC-LABEL", tableName: nil, bundle: NSBundle.mainBundle(), value: "CALC-LABEL", comment: "" ), forState: UIControlState.Normal )
        self.explainTextField.text = NSLocalizedString ( "EXPLAIN-TEXT", tableName: nil, bundle: NSBundle.mainBundle(), value: "EXPLAIN-TEXT", comment: "" )
        super.viewWillLayoutSubviews()
        let mainNavController: UINavigationController = s_NACC_AppDelegate!.window!.rootViewController as UINavigationController
        mainNavController.navigationBar.barTintColor = s_NACC_BaseColor
        NACC_AppDelegate.setGradient()
    }
    
    /*******************************************************************************************/
    /**
        \brief  Hide the various items, so we don't get that ugly "overlap" effect.
    
        \param inAnimated true, if the transition is animated.
    */
    override func viewWillDisappear ( inAnimated: Bool )
    {
        s_NACC_cleanDateCalc = NACC_DateCalc ( inStartDate: self.datePicker.date )
        self.calcButton.hidden = true
        self.datePicker.hidden = true
        self.explainTextField.hidden = true
        super.viewWillDisappear ( inAnimated )
    }
}
