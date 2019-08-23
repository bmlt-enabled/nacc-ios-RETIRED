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
 This class handles the display of Watch inComplications.
 
 It implements all variants of inComplication, with Modular Large and Utilitarian Large displaying data relevant to the calculation, and the
 others used as instatiation devices.

 */
class NACC_Companion_ComplicationDataSource: NSObject, CLKComplicationDataSource {
    // MARK: - Internal Methods
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     This is a generic template generator.
     
     - parameter for: The inComplication we're generating this for.
     
     - returns: a Complication Template object.
     */
    func makeTemplateObject(for inComplication: CLKComplication) -> CLKComplicationTemplate? {
        #if DEBUG
            print("Template requested for inComplication (Part 1): \(inComplication.family)")
        #endif
        
        switch inComplication.family {
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
            return makeModularTemplateObject(for: inComplication)
        }
        
        return nil
    }
    
    /*******************************************************************************************/
    /**
     This is a generic template generator.
     
     - parameter for: The inComplication we're generating this for.
     
     - returns: a Complication Template object.
     */
    func makeModularTemplateObject(for inComplication: CLKComplication) -> CLKComplicationTemplate? {
        #if DEBUG
            print("Template requested for inComplication (Part 1): \(inComplication.family)")
        #endif
        
        switch inComplication.family {
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
            return makeUtilitarianTemplateObject(for: inComplication)
        }
        
        return nil
    }
    
    /*******************************************************************************************/
    /**
     This is a utilitarian template generator.
     
     - parameter for: The inComplication we're generating this for.
     
     - returns: a Complication Template object.
     */
    func makeUtilitarianTemplateObject(for inComplication: CLKComplication) -> CLKComplicationTemplate? {
        #if DEBUG
            print("Template requested for inComplication (Part 1): \(inComplication.family)")
        #endif
        
        switch inComplication.family {
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
            return makeGraphicTemplateObject(for: inComplication)
        }
        
        return nil
    }
    

    /*******************************************************************************************/
    /**
     This is a generic template generator (second, for CC).
     
     - parameter for: The inComplication we're generating this for.
     
     - returns: a Complication Template object.
     */
    func makeGraphicTemplateObject(for inComplication: CLKComplication) -> CLKComplicationTemplate? {
        #if DEBUG
            print("Template requested for inComplication (Part 2): \(inComplication.family)")
        #endif
        
        switch inComplication.family {
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
     This sets the current timeline entry for the inComplication.
     
     - parameter for: The inComplication we're generating this for.
     - parameter withHandler: The inHandler method to be called.
     */
    func getCurrentTimelineEntry(for inComplication: CLKComplication, withHandler inHandler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if let templateObject = makeTemplateObject(for: inComplication) {
            switch inComplication.family {
            case .modularLarge:
                if  let tObject = templateObject as? CLKComplicationTemplateModularLargeStandardBody,
                    let startDate = NACC_Prefs().cleanDate {
                    tObject.body1TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
                    tObject.body2TextProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.year, .month, .day])
                    inHandler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
                } else {
                    inHandler(nil)
                }
            case .utilitarianLarge:
                if  let tObject = templateObject as? CLKComplicationTemplateUtilitarianLargeFlat,
                    let startDate = NACC_Prefs().cleanDate {
                    tObject.textProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
                    inHandler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
                } else {
                    inHandler(nil)
                }
            case .graphicRectangular:
                if  let tObject = templateObject as? CLKComplicationTemplateGraphicRectangularLargeImage,
                    let startDate = NACC_Prefs().cleanDate {
                    tObject.textProvider = CLKRelativeDateTextProvider(date: startDate, style: CLKRelativeDateStyle.natural, units: [.day])
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject)
                    inHandler(timelineEntry)
                } else {
                    inHandler(nil)
                }
            default:
                inHandler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: templateObject))
            }
        } else {
            inHandler(nil)
        }
    }

    /*******************************************************************************************/
    /**
     This sets the supported Time Travel directions (We do both forward and backward).
     
     - parameter for: The inComplication we're generating this for.
     - parameter withHandler: The inHandler method to be called.
     */
    func getSupportedTimeTravelDirections(for inComplication: CLKComplication, withHandler inHandler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        inHandler([.backward, .forward])
    }
    
    /*******************************************************************************************/
    /**
     This sets the template object for the inComplication.
     
     - parameter for: The inComplication we're generating this for.
     - parameter withHandler: The inHandler method to be called.
     */
    func getLocalizableSampleTemplate(for inComplication: CLKComplication,
                                      withHandler inHandler: @escaping (CLKComplicationTemplate?) -> Void) {
        inHandler(makeTemplateObject(for: inComplication))
    }
}
