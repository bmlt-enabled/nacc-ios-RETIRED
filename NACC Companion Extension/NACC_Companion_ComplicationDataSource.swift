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
//                if 0 < extensionDelegateObject.lastEnteredDate {
//                    let startDate = Date(timeIntervalSince1970: extensionDelegateObject.lastEnteredDate)
//                    template.line2TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
//                }
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
        handler(makeTemplateObject(for: complication))
    }
    
    /*******************************************************************************************/
    /**
     This sets the current timeline entry for the complication.
     
     - parameter for: The complication we're generating this for.
     - parameter withHandler: The handler method to be called.
     */
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
//        if let templateObject = makeTemplateObject(for: complication) {
//            switch complication.family {
//            case .modularLarge:
//                if let tObject = templateObject as? CLKComplicationTemplateModularLargeStandardBody {
//                    if 0 < extensionDelegateObject.lastEnteredDate {
//                        let startDate = Date(timeIntervalSince1970: extensionDelegateObject.lastEnteredDate)
//                        tObject.body1TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
//                        tObject.body2TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.year, .month, .day])
//                        handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
//                    }
//                }
//            case .utilitarianLarge: 
//                if let tObject = templateObject as? CLKComplicationTemplateUtilitarianLargeFlat {
//                    if 0 < extensionDelegateObject.lastEnteredDate {
//                        let startDate = Date(timeIntervalSince1970: extensionDelegateObject.lastEnteredDate)
//                        tObject.textProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
//                        handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
//                    }
//                }
//            default:
//                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: templateObject))
//            }
//        } else {
//            handler(nil)
//        }
    }
}
