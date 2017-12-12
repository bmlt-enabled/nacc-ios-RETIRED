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
 along with this code.  If not, see <http: //www.gnu.org/licenses/>.
 */

import WatchKit
import ClockKit

/* ###################################################################################################################################### */
/**
 This class handles the display of Watch complications.
 
 It implements all variants of complication, with Modular Large and Utilitarian Large displaying data relevant to the calculation, and the
 others used as instatiation devices.

 */
class NACC_Companion_ComplicationDataSource: NSObject, CLKComplicationDataSource {
    // MARK: - Internal Calculated Properties
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     This is an accessor for the main Extension Delegate object, where we can get our settings.
     */
    var extensionDelegateObject: ExtensionDelegate! {
        return WKExtension.shared().delegate as? ExtensionDelegate
    }

    // MARK: - Internal Methods
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     This is a generic template generator.
     
     - parameter for: The complication we're generating this for.
     
     - returns: a Complication Template object.
     */
    func makeTemplateObject(for complication: CLKComplication) -> CLKComplicationTemplate? {
        #if DEBUG
            print("Template requested for complication: \(complication.family)")
        #endif
        
        var template: CLKComplicationTemplate? = nil
        
        switch complication.family {
        case .circularSmall: 
            template = CLKComplicationTemplateCircularSmallSimpleImage()
            if let templateImage = UIImage(named: "Complication/Circular") {
                (template as? CLKComplicationTemplateCircularSmallSimpleImage)?.imageProvider = CLKImageProvider(onePieceImage: templateImage)
            }
        case .modularSmall:
            template = CLKComplicationTemplateModularSmallSimpleImage()
            if let templateImage = UIImage(named: "Complication/Modular") {
                (template as? CLKComplicationTemplateModularSmallSimpleImage)?.imageProvider = CLKImageProvider(onePieceImage: templateImage)
            }
        case .modularLarge:
            template = CLKComplicationTemplateModularLargeStandardBody()
            if let templateImage = UIImage(named: "Complication/Modular") {
                (template as? CLKComplicationTemplateModularLargeStandardBody)?.headerImageProvider = CLKImageProvider(onePieceImage: templateImage)
            }
            (template as? CLKComplicationTemplateModularLargeStandardBody)?.headerTextProvider = CLKSimpleTextProvider(text: "COMPLICATION-LABEL".localizedVariant)
            (template as? CLKComplicationTemplateModularLargeStandardBody)?.body1TextProvider = CLKSimpleTextProvider(text: "")
            (template as? CLKComplicationTemplateModularLargeStandardBody)?.body2TextProvider = CLKSimpleTextProvider(text: "")
        case .utilitarianSmall:
            template = CLKComplicationTemplateUtilitarianSmallFlat()
            if let templateImage = UIImage(named: "Complication/Utilitarian") {
                (template as? CLKComplicationTemplateUtilitarianSmallFlat)?.imageProvider = CLKImageProvider(onePieceImage: templateImage)
            }
            (template as? CLKComplicationTemplateUtilitarianSmallFlat)?.textProvider = CLKSimpleTextProvider(text: "COMPLICATION-LABEL".localizedVariant)
        case .utilitarianLarge:
            template = CLKComplicationTemplateUtilitarianLargeFlat()
            if let templateImage = UIImage(named: "Complication/Utilitarian") {
                (template as? CLKComplicationTemplateUtilitarianLargeFlat)?.imageProvider = CLKImageProvider(onePieceImage: templateImage)
            }
            (template as? CLKComplicationTemplateUtilitarianLargeFlat)?.textProvider = CLKSimpleTextProvider(text: "")
        case .extraLarge:
            if let templateImage = UIImage(named: "Complication/Extra Large") {
                let template = CLKComplicationTemplateExtraLargeStackImage()
                template.line1ImageProvider = CLKImageProvider(onePieceImage: templateImage)
                if 0 < self.extensionDelegateObject.lastEnteredDate {
                    let startDate = Date(timeIntervalSince1970: self.extensionDelegateObject.lastEnteredDate)
                    template.line2TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
                }
            }
        default:
            break
        }
        
        return template
    }
    
    // MARK: - CLKComplicationDataSource Methods
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     This sets the supported Time Travel directions (We do both forward and backward).
     
     - parameter for: The complication we're generating this for.
     - parameter withHandler: The handler method to be called.
     */
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.backward, .forward])
    }
    
    /*******************************************************************************************/
    /**
     This sets the template object for the complication.
     
     - parameter for: The complication we're generating this for.
     - parameter withHandler: The handler method to be called.
     */
    func getLocalizableSampleTemplate(for complication: CLKComplication,
                                      withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(self.makeTemplateObject(for: complication))
    }
    
    /*******************************************************************************************/
    /**
     This sets the current timeline entry for the complication.
     
     - parameter for: The complication we're generating this for.
     - parameter withHandler: The handler method to be called.
     */
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if let templateObject = self.makeTemplateObject(for: complication) {
            switch complication.family {
            case .modularLarge: 
                if let tObject = templateObject as? CLKComplicationTemplateModularLargeStandardBody {
                    if 0 < self.extensionDelegateObject.lastEnteredDate {
                        let startDate = Date(timeIntervalSince1970: self.extensionDelegateObject.lastEnteredDate)
                        tObject.body1TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
                        tObject.body2TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.year, .month, .day])
                        handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
                    }
                }
            case .utilitarianLarge: 
                if let tObject = templateObject as? CLKComplicationTemplateUtilitarianLargeFlat {
                    if 0 < self.extensionDelegateObject.lastEnteredDate {
                        let startDate = Date(timeIntervalSince1970: self.extensionDelegateObject.lastEnteredDate)
                        tObject.textProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
                        handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
                    }
                }
            default: 
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: templateObject))
            }
        } else {
            handler(nil)
        }
    }
}
