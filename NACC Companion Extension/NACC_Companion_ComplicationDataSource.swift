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

import ClockKit

/* ###################################################################################################################################### */
/**
 This class handles the display of Watch complications.
 
 It implements all variants of complication, with Modular Large and Utilitarian Large displaying data relevant to the calculation, and the
 others used as instatiation devices.

 */
class NACC_Companion_ComplicationDataSource: NSObject, CLKComplicationDataSource {
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
            print("Template requested for complication (Part 1): \(complication.family)")
        #endif
        
        switch complication.family {
        case .circularSmall:
            if let templateImage = UIImage(named: "Complication/Circular") {
                let templateTmp = CLKComplicationTemplateCircularSmallSimpleImage()
                templateTmp.imageProvider = CLKImageProvider(onePieceImage: templateImage)
                return templateTmp
            }
        case .extraLarge:
            if let templateImage = UIImage(named: "Complication/Extra Large") {
                let templateTmp = CLKComplicationTemplateExtraLargeStackImage()
                templateTmp.line1ImageProvider = CLKImageProvider(onePieceImage: templateImage)
                templateTmp.line2TextProvider = CLKRelativeDateTextProvider(date: NACC_Prefs().cleanDate, style: CLKRelativeDateStyle.natural, units: [.day])
                return templateTmp
            }
        default:
            return makeModularTemplateObject(for: complication)
        }
        
        return nil
    }
    
    /*******************************************************************************************/
    /**
     This is a generic template generator.
     
     - parameter for: The complication we're generating this for.
     
     - returns: a Complication Template object.
     */
    func makeModularTemplateObject(for complication: CLKComplication) -> CLKComplicationTemplate? {
        #if DEBUG
            print("Template requested for complication (Part 1): \(complication.family)")
        #endif
        
        switch complication.family {
        case .modularSmall:
            if let templateImage = UIImage(named: "Complication/Modular") {
                let templateTmp = CLKComplicationTemplateModularSmallSimpleImage()
                templateTmp.imageProvider = CLKImageProvider(onePieceImage: templateImage)
                return templateTmp
            }
        case .modularLarge:
            if let templateImage = UIImage(named: "Complication/Modular") {
                let templateTmp = CLKComplicationTemplateModularLargeStandardBody()
                templateTmp.headerImageProvider = CLKImageProvider(onePieceImage: templateImage)
                templateTmp.headerTextProvider = CLKSimpleTextProvider(text: "COMPLICATION-LABEL".localizedVariant)
                templateTmp.body1TextProvider = CLKSimpleTextProvider(text: "")
                templateTmp.body2TextProvider = CLKSimpleTextProvider(text: "")
                return templateTmp
            }
        default:
            return makeUtilitarianTemplateObject(for: complication)
        }
        
        return nil
    }
    
    /*******************************************************************************************/
    /**
     This is a utilitarian template generator.
     
     - parameter for: The complication we're generating this for.
     
     - returns: a Complication Template object.
     */
    func makeUtilitarianTemplateObject(for complication: CLKComplication) -> CLKComplicationTemplate? {
        #if DEBUG
            print("Template requested for complication (Part 1): \(complication.family)")
        #endif
        
        switch complication.family {
        case .utilitarianSmall:
            if let templateImage = UIImage(named: "Complication/Utilitarian") {
                let templateTmp = CLKComplicationTemplateUtilitarianSmallFlat()
                templateTmp.imageProvider = CLKImageProvider(onePieceImage: templateImage)
                templateTmp.textProvider = CLKSimpleTextProvider(text: "COMPLICATION-LABEL".localizedVariant)
                return templateTmp
            }
        case .utilitarianLarge:
            if let templateImage = UIImage(named: "Complication/Utilitarian") {
                let templateTmp = CLKComplicationTemplateUtilitarianLargeFlat()
                templateTmp.imageProvider = CLKImageProvider(onePieceImage: templateImage)
                templateTmp.textProvider = CLKSimpleTextProvider(text: "")
                return templateTmp
            }
        default:
            return makeGraphicTemplateObject(for: complication)
        }
        
        return nil
    }
    

    /*******************************************************************************************/
    /**
     This is a generic template generator (second, for CC).
     
     - parameter for: The complication we're generating this for.
     
     - returns: a Complication Template object.
     */
    func makeGraphicTemplateObject(for complication: CLKComplication) -> CLKComplicationTemplate? {
        #if DEBUG
            print("Template requested for complication (Part 2): \(complication.family)")
        #endif
        
        switch complication.family {
        case .graphicCircular:
            if let image = UIImage(named: "Complication/Circular") {
                let templateTmp = CLKComplicationTemplateGraphicCircularImage()
                templateTmp.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                return templateTmp
            }
        case .graphicCorner:
            if let image = UIImage(named: "Complication/Circular") {
                let templateTmp = CLKComplicationTemplateGraphicCornerGaugeImage()
                templateTmp.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                return templateTmp
            }
        case .graphicBezel:
            if let image = UIImage(named: "Complication/Circular") {
                let templateTmp = CLKComplicationTemplateGraphicBezelCircularText()
                templateTmp.textProvider = CLKSimpleTextProvider(text: "")
                let circularItem = CLKComplicationTemplateGraphicCircularImage()
                circularItem.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                templateTmp.circularTemplate = circularItem
                return templateTmp
            }
        case .graphicRectangular:
            if let image = UIImage(named: "Complication/Modular"),
                let startDate = NACC_Prefs().cleanDate {
                let templateTmp = CLKComplicationTemplateGraphicRectangularLargeImage()
                templateTmp.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                templateTmp.textProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
                return templateTmp
            }
        default:
            break
        }
        
        return nil
    }
    
    // MARK: - CLKComplicationDataSource Methods
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     This sets the current timeline entry for the complication.
     
     - parameter for: The complication we're generating this for.
     - parameter withHandler: The handler method to be called.
     */
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if let templateObject = makeTemplateObject(for: complication) {
            switch complication.family {
            case .modularLarge:
                if  let tObject = templateObject as? CLKComplicationTemplateModularLargeStandardBody,
                    let startDate = NACC_Prefs().cleanDate {
                    tObject.body1TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
                    tObject.body2TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.year, .month, .day])
                    handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
                } else {
                    handler(nil)
                }
            case .utilitarianLarge:
                if  let tObject = templateObject as? CLKComplicationTemplateUtilitarianLargeFlat,
                    let startDate = NACC_Prefs().cleanDate {
                    tObject.textProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
                    handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
                } else {
                    handler(nil)
                }
            case .graphicRectangular:
                if  let tObject = templateObject as? CLKComplicationTemplateGraphicRectangularLargeImage,
                    let startDate = NACC_Prefs().cleanDate {
                    tObject.textProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject)
                    handler(timelineEntry)
                } else {
                    handler(nil)
                }
            default:
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: templateObject))
            }
        } else {
            handler(nil)
        }
    }

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
}
