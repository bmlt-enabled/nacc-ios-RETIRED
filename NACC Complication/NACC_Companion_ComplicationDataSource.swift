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
// MARK: - Main Complication Data Source Class
/* ###################################################################################################################################### */
/**
 This class handles the display of Watch inComplications.
 
 It implements all variants of inComplication, with Modular Large and Utilitarian Large displaying data relevant to the calculation, and the
 others used as instatiation devices.
 */
class NACC_Companion_ComplicationDataSource: NSObject, CLKComplicationDataSource {
    /* ################################################################################################################################## */
    // MARK: - Internal Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
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
                templateTmp.line2TextProvider = CLKRelativeDateTextProvider(date: NACC_Prefs().cleanDate ?? Date(), style: CLKRelativeDateStyle.natural, units: [.day])
                return templateTmp
            }
        default:
            return makeModularTemplateObject(for: inComplication)
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is a generic template generator.
     
     - parameter for: The inComplication we're generating this for.
     
     - returns: a Complication Template object.
     */
    func makeModularTemplateObject(for inComplication: CLKComplication) -> CLKComplicationTemplate? {
        #if DEBUG
            print("Template requested for inComplication (Part 1): \(String(describing: inComplication.family))")
        #endif
        
        switch inComplication.family {
        case .modularSmall:
            #if DEBUG
                print("Template requested for modularSmall")
            #endif
            if let templateImage = UIImage(named: "Complication/Modular") {
                let templateTmp = CLKComplicationTemplateModularSmallSimpleImage()
                templateTmp.imageProvider = CLKImageProvider(onePieceImage: templateImage)
                return templateTmp
            }
        case .modularLarge:
            #if DEBUG
                print("Template requested for modularLarge")
            #endif
            if let templateImage = UIImage(named: "Complication/Modular") {
                let templateTmp = CLKComplicationTemplateModularLargeStandardBody()
                let dateCalc: NACC_DateCalc = NACC_DateCalc()  ///< This holds our date calculation.
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateStyle = .short
                let dateString = dateFormatter.string(from: dateCalc.startDate ?? Date())
                templateTmp.headerImageProvider = CLKImageProvider(onePieceImage: templateImage)
                templateTmp.headerTextProvider = CLKSimpleTextProvider(text: dateString)
                templateTmp.body1TextProvider = CLKSimpleTextProvider(text: String(dateCalc.totalDays) + " " + "DAYS-SHORT".localizedVariant)
                templateTmp.body2TextProvider = CLKSimpleTextProvider(text: "")
                return templateTmp
            }
        default:
            return makeUtilitarianTemplateObject(for: inComplication)
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is a utilitarian template generator.
     
     - parameter for: The inComplication we're generating this for.
     
     - returns: a Complication Template object.
     */
    func makeUtilitarianTemplateObject(for inComplication: CLKComplication) -> CLKComplicationTemplate? {
        #if DEBUG
            print("Template requested for inComplication (Part 2): \(String(describing: inComplication.family))")
        #endif
        
        let dateCalc: NACC_DateCalc = NACC_DateCalc()  ///< This holds our date calculation.

        switch inComplication.family {
        case .utilitarianSmall:
            #if DEBUG
                print("Template requested for utilitarianSmall")
            #endif
            if let templateImage = UIImage(named: "Complication/Utilitarian") {
                let templateTmp = CLKComplicationTemplateUtilitarianSmallFlat()
                templateTmp.imageProvider = CLKImageProvider(onePieceImage: templateImage)
                templateTmp.textProvider = CLKSimpleTextProvider(text: String(dateCalc.totalDays) + " " + "DAYS-UNIT".localizedVariant)
                return templateTmp
            }
        case .utilitarianLarge:
            #if DEBUG
                print("Template requested for utilitarianLarge")
            #endif
            if let templateImage = UIImage(named: "Complication/Utilitarian") {
                let templateTmp = CLKComplicationTemplateUtilitarianLargeFlat()
                templateTmp.imageProvider = CLKImageProvider(onePieceImage: templateImage)
                templateTmp.textProvider = CLKSimpleTextProvider(text: String(dateCalc.totalDays) + " " + "DAYS-UNIT".localizedVariant)
                return templateTmp
            }
        default:
            return makeGraphicTemplateObject(for: inComplication)
        }
        
        return nil
    }
    
    /* ################################################################## */
    /**
     This is a generic template generator (second, for CC).
     
     - parameter for: The inComplication we're generating this for.
     
     - returns: a Complication Template object.
     */
    func makeGraphicTemplateObject(for inComplication: CLKComplication) -> CLKComplicationTemplate? {
        #if DEBUG
            print("Template requested for inComplication (Part 3): \(String(describing: inComplication.family))")
        #endif
        
        switch inComplication.family {
        case .graphicCircular:
            #if DEBUG
                print("Template requested for graphicCircular")
            #endif
            if  let image = UIImage(named: "Complication/Graphic Circular") {
                let templateTmp = CLKComplicationTemplateGraphicCircularImage()
                templateTmp.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                return templateTmp
            }
        case .graphicCorner:
            #if DEBUG
                print("Template requested for graphicCorner")
            #endif
            if  let image = UIImage(named: "Complication/Graphic Corner") {
                let templateTmp = CLKComplicationTemplateGraphicCornerCircularImage()
                templateTmp.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                return templateTmp
            }
        case .graphicBezel:
            #if DEBUG
                print("Template requested for graphicBezel")
            #endif
            if let image = UIImage(named: "Complication/Graphic Bezel") {
                let templateTmp = CLKComplicationTemplateGraphicBezelCircularText()
                let circularItem = CLKComplicationTemplateGraphicCircularImage()
                circularItem.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
                templateTmp.circularTemplate = circularItem
                let dateCalc: NACC_DateCalc = NACC_DateCalc()  ///< This holds our date calculation.
                templateTmp.textProvider = CLKSimpleTextProvider(text: String(dateCalc.totalDays) + " " + "DAYS-UNIT".localizedVariant)
                return templateTmp
            }
        case .graphicRectangular:
            #if DEBUG
                print("Template requested for graphicRectangular")
            #endif
            if let templateImage = UIImage(named: "Complication/Graphic Circular") {
                let templateTmp = CLKComplicationTemplateGraphicRectangularStandardBody()
                let dateCalc: NACC_DateCalc = NACC_DateCalc()  ///< This holds our date calculation.
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .none
                dateFormatter.dateStyle = .short
                let dateString = dateFormatter.string(from: dateCalc.startDate ?? Date())
                templateTmp.headerImageProvider = CLKFullColorImageProvider(fullColorImage: templateImage)
                templateTmp.headerTextProvider = CLKSimpleTextProvider(text: dateString)
                templateTmp.body1TextProvider = CLKSimpleTextProvider(text: String(dateCalc.totalDays) + " " + "DAYS-SHORT".localizedVariant)
                templateTmp.body2TextProvider = CLKSimpleTextProvider(text: "")
                return templateTmp
            }
        default:
            break
        }
        
        return nil
    }
    
    /* ################################################################################################################################## */
    // MARK: - CLKComplicationDataSource Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This sets the current timeline entry for the inComplication.
     
     - parameter for: The inComplication we're generating this for.
     - parameter withHandler: The inHandler method to be called.
     */
    func getCurrentTimelineEntry(for inComplication: CLKComplication, withHandler inHandler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        #if DEBUG
            print("Timeline Entry Requested for: \(inComplication.family)")
        #endif
        if let templateObject = makeTemplateObject(for: inComplication) {
            switch inComplication.family {
            case .modularLarge:
                if  let tObject = templateObject as? CLKComplicationTemplateModularLargeStandardBody {
                    inHandler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
                } else {
                    inHandler(nil)
                }
            case .utilitarianSmall:
                if  let tObject = templateObject as? CLKComplicationTemplateUtilitarianSmallFlat {
                    inHandler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
                } else {
                    inHandler(nil)
                }
            case .utilitarianLarge:
                if  let tObject = templateObject as? CLKComplicationTemplateUtilitarianLargeFlat {
                    inHandler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
                } else {
                    inHandler(nil)
                }
            case .graphicRectangular:
                if  let tObject = templateObject as? CLKComplicationTemplateGraphicRectangularStandardBody {
                    inHandler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: tObject))
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
    
    /* ################################################################## */
    /**
     This sets the supported placeholder.
     
     - parameter complication: The inComplication we're generating this for.
     - parameter withHandler: The inHandler method to be called.
     */
    public func getPlaceholderTemplateForComplication(complication inComplication: CLKComplication, withHandler inHandler: (CLKComplicationTemplate?) -> Void) {
        #if DEBUG
            print("Placeholder Requested for: \(inComplication.family)")
        #endif
        if let templateObject = makeTemplateObject(for: inComplication) {
            switch inComplication.family {
            case .modularLarge:
                if  let tObject = templateObject as? CLKComplicationTemplateModularLargeStandardBody {
                    inHandler(tObject)
                } else {
                    inHandler(nil)
                }
            case .utilitarianSmall:
                if  let tObject = templateObject as? CLKComplicationTemplateUtilitarianSmallFlat {
                    inHandler(tObject)
                } else {
                    inHandler(nil)
                }
            case .utilitarianLarge:
                if  let tObject = templateObject as? CLKComplicationTemplateUtilitarianLargeFlat {
                    inHandler(tObject)
                } else {
                    inHandler(nil)
                }
            case .graphicRectangular:
                if  let tObject = templateObject as? CLKComplicationTemplateGraphicRectangularLargeImage {
                    inHandler(tObject)
                } else {
                    inHandler(nil)
                }
            default:
                inHandler(templateObject)
            }
        } else {
            inHandler(nil)
        }
    }
    
    /* ################################################################## */
    /**
     This sets the supported Time Travel directions (We don't do any).
     
     - parameter for: The inComplication we're generating this for.
     - parameter withHandler: The inHandler method to be called.
     */
    func getSupportedTimeTravelDirections(for inComplication: CLKComplication, withHandler inHandler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        inHandler([])
    }
    
    /* ################################################################## */
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
