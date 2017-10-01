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
import ClockKit

/* ###################################################################################################################################### */
/**
 */
class NACC_Companion_ComplicationDataSource: NSObject, CLKComplicationDataSource {
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     */
    var extensionDelegateObject:ExtensionDelegate! {
        get {
            return WKExtension.shared().delegate as! ExtensionDelegate
        }
    }

    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
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
                (template as! CLKComplicationTemplateCircularSmallSimpleImage).imageProvider = CLKImageProvider(onePieceImage: templateImage)
            }
            break
        case .modularSmall:
            template = CLKComplicationTemplateModularSmallSimpleImage()
            if let templateImage = UIImage(named: "Complication/Modular") {
                (template as! CLKComplicationTemplateModularSmallSimpleImage).imageProvider = CLKImageProvider(onePieceImage: templateImage)
            }
            break
        case .modularLarge:
            template = CLKComplicationTemplateModularLargeStandardBody()
            if let templateImage = UIImage(named: "Complication/Modular") {
                (template as! CLKComplicationTemplateModularLargeStandardBody).headerImageProvider = CLKImageProvider(onePieceImage: templateImage)
            }
            (template as! CLKComplicationTemplateModularLargeStandardBody).headerTextProvider = CLKSimpleTextProvider(text: "NACC")
            (template as! CLKComplicationTemplateModularLargeStandardBody).body1TextProvider = CLKSimpleTextProvider(text: "")
            (template as! CLKComplicationTemplateModularLargeStandardBody).body2TextProvider = CLKSimpleTextProvider(text: "")
            break
        case .utilitarianSmall:
            template = CLKComplicationTemplateUtilitarianSmallFlat()
            if let templateImage = UIImage(named: "Complication/Utilitarian") {
                (template as! CLKComplicationTemplateUtilitarianSmallFlat).imageProvider = CLKImageProvider(onePieceImage: templateImage)
            }
            (template as! CLKComplicationTemplateUtilitarianSmallFlat).textProvider = CLKSimpleTextProvider(text: "HAI")
            break
        case .utilitarianLarge:
            template = CLKComplicationTemplateUtilitarianLargeFlat()
            if let templateImage = UIImage(named: "Complication/Utilitarian") {
                (template as! CLKComplicationTemplateUtilitarianLargeFlat).imageProvider = CLKImageProvider(onePieceImage: templateImage)
            }
            (template as! CLKComplicationTemplateUtilitarianLargeFlat).textProvider = CLKSimpleTextProvider(text: "HAI")
            break
        case .extraLarge:
            template = CLKComplicationTemplateExtraLargeSimpleImage()
            if let templateImage = UIImage(named: "Complication/Extra Large") {
                (template as! CLKComplicationTemplateExtraLargeSimpleImage).imageProvider = CLKImageProvider(onePieceImage: templateImage)
            }
            break
        default:
            break
        }
        
        return template
    }
    
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     */
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.backward, .forward])
    }
    
    /*******************************************************************************************/
    /**
     */
    func getLocalizableSampleTemplate(for complication: CLKComplication,
                                      withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(self.makeTemplateObject(for: complication))
    }
    
    /*******************************************************************************************/
    /**
     */
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if let templateObject = self.makeTemplateObject(for: complication) {
            if .modularLarge == complication.family {
                if let tObject = templateObject as? CLKComplicationTemplateModularLargeStandardBody {
                    if 0 < self.extensionDelegateObject.lastEnteredDate {
                        let startDate = Date(timeIntervalSince1970:  self.extensionDelegateObject.lastEnteredDate)
                        tObject.body1TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.year, .month])
                        tObject.body2TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
                    }
                }
            }
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: templateObject)
            handler(entry)
        } else {
            handler(nil)
        }
    }
}
