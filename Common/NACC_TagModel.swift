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

import UIKit

/* ###################################################################################################################################### */
/**
 These are String class extensions that we'll use throughout the app.
 */
extension String {
    /* ################################################################## */
    /**
     */
    var localizedVariant: String {
        return NSLocalizedString(self, comment: "")
    }
}

/***********************************************************************************************/
/**
    \class  NACC_TagModel

     This class wil determine which NA tags are the proper ones for the cleantime, and will
            instantiate and maintain the image assets for them (including constructing the tags).
*/
/***********************************************************************************************/
class NACC_TagModel {
    /**
        This will be assigned to describe available tags.
    */
    struct NACC_TagModel_TagData {
        /// The name of the image we will use as the tag base (if the tag applies).
        let baseImageName: String
        /// The name of the face (text) image.
        let faceImageName: String
        /// These are the coefficients we apply, to see if the tag applies.
        /// If this tag is assigned for a certain number of total days, that is indicated here. If it is specified, the rest of these fields are ignored.
        let totalDays: Int
        /// The rest of these are for specific durations, measured in months, days, and years. If totalDays is specified, these are ignored.
        /// If totalDays is not specified, then all 3 of these are considered at once.
        /// Days past a month.
        let days: Int
        /// Months past a year.
        let months: Int
        /// Years.
        let years: Int
    }
    
    /// This is the calculation object that will govern which tags will be displayed.
    let calculation: NACC_DateCalc
    
    /*******************************************************************************************/
    /**
         Yuck. This is a big, fat, hairy mess of cyclomatic complexity. However, there doesn't
                really seem to be a better way of getting the display of natural text.
                This function generates a text response that announces the cleantime, in a casual,
                natural set of sentences.
        
     - parameter inCalculation: the date calculation that we will display as text.
        
     - returns: a string, containing the cleandate text.
    */
    class func getDisplayCleandate(_ inTotalDays: Int, inYears: Int, inMonths: Int, inDays: Int) -> String {
        var resultsString: String = ""
        
        // This is the first line, where we count days.
        if inTotalDays == 1 {  // Brand new {
            resultsString = "RESULTS-DAY".localizedVariant
        } else if inTotalDays < 0 {
            resultsString = "RESULTS-SUPPORT".localizedVariant
        } else {
            resultsString = String(format: "RESULTS-DAYS".localizedVariant, inTotalDays)
        }
        
        // The next line is more involved, as it breaks into years, months and days.
        if inTotalDays > 90 {
            resultsString = handleOver90(inTotalDays, inYears: inYears, inMonths: inMonths, inDays: inDays, resultsString)
        }
        
        return resultsString
    }
    
    /*******************************************************************************************/
    /**
     Generates a report for over 90 days.
     
     - parameter inTotalDays: The total number of days since the cleandate.
     - parameter inYears: The number of years since the cleandate.
     - parameter inMonths: The number of months, past the years, since the cleandate.
     - parameter inDays: The number of days, past the months, since the cleandate.
     
     - returns: A String, with the report.
     */
    class func handleOver90(_ inTotalDays: Int, inYears: Int, inMonths: Int, inDays: Int, _ inResultsString: String) -> String {
        if (inYears > 1) && (inMonths > 1) && (inDays > 1) {   // Multiple of years, months and days.
            return inResultsString + String(format: "RESULTS-COMPLEX-1".localizedVariant, inYears, inMonths, inDays)
        } else if (inYears > 1) && (inMonths > 1) && (inDays == 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-2".localizedVariant, inYears, inMonths)
        } else if (inYears > 1) && (inMonths == 1) && (inDays == 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-3".localizedVariant, inYears)
        } else if (inYears == 1) && (inMonths == 1) && (inDays == 1) {
            return inResultsString + "RESULTS-COMPLEX-4".localizedVariant
        } else if (inYears == 1) && (inMonths > 1) && (inDays == 0) {
            return inResultsString + String(format: "RESULTS-COMPLEX-5".localizedVariant, inMonths)
        } else if (inYears == 1) && (inMonths == 1) && (inDays == 0) {
            return inResultsString + "RESULTS-COMPLEX-6".localizedVariant
        }
        
        return inResultsString + handleOver90Part2(inTotalDays, inYears: inYears, inMonths: inMonths, inDays: inDays, inResultsString)
    }
    
    /*******************************************************************************************/
    /**
     CC Overflow handler.
     
     Handles creating the report for over 90 days (part 23).
     
     - parameter inTotalDays: The total number of days since the cleandate.
     - parameter inYears: The number of years since the cleandate.
     - parameter inMonths: The number of months, past the years, since the cleandate.
     - parameter inDays: The number of days, past the months, since the cleandate.
     
     - returns: A String, with the report.
     */
    class func handleOver90Part2(_ inTotalDays: Int, inYears: Int, inMonths: Int, inDays: Int, _ inResultsString: String) -> String {
        if (inYears == 1) && (inMonths == 0) && (inDays > 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-7".localizedVariant, inDays)
        } else if (inYears == 1) && (inMonths == 0) && (inDays == 1) {
            return inResultsString + "RESULTS-COMPLEX-8".localizedVariant
        } else if (inYears > 1) && (inMonths > 1) && (inDays == 0) {
            return inResultsString + String(format: "RESULTS-COMPLEX-9".localizedVariant, inYears, inMonths)
        } else if (inYears == 0) && (inMonths > 1) && (inDays > 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-10".localizedVariant, inMonths, inDays)
        } else if (inYears == 0) && (inMonths > 1) && (inDays == 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-11".localizedVariant, inMonths)
        } else if (inYears == 0) && (inMonths > 1) && (inDays == 0) {
            return inResultsString + String(format: "RESULTS-COMPLEX-12".localizedVariant, inMonths)
        } else if (inYears > 1) && (inMonths == 0) && (inDays == 0) {
            return inResultsString + String(format: "RESULTS-COMPLEX-13".localizedVariant, inYears)
        } else if (inYears > 1) && (inMonths == 1) && (inDays == 0) {
            return inResultsString + String(format: "RESULTS-COMPLEX-14".localizedVariant, inYears)
        } else if (inYears == 1) && (inMonths > 1) && (inDays > 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-15".localizedVariant, inMonths, inDays)
        } else if (inYears == 1) && (inMonths > 1) && (inDays == 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-16".localizedVariant, inMonths)
        } else if (inYears == 0) && (inMonths == 1) && (inDays > 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-17".localizedVariant, inDays)
        } else {
            return handleOver90Part3(inTotalDays, inYears: inYears, inMonths: inMonths, inDays: inDays, inResultsString)
        }
    }
    
    /*******************************************************************************************/
    /**
     CC Overflow handler.
     
     Handles creating the report for over 90 days (part 3).
     
     - parameter inTotalDays: The total number of days since the cleandate.
     - parameter inYears: The number of years since the cleandate.
     - parameter inMonths: The number of months, past the years, since the cleandate.
     - parameter inDays: The number of days, past the months, since the cleandate.
     
     - returns: A String, with the report.
     */
    class func handleOver90Part3(_ inTotalDays: Int, inYears: Int, inMonths: Int, inDays: Int, _ inResultsString: String) -> String {
        if (inYears == 0) && (inMonths == 1) && (inDays == 1) { // Should never happen.
            return inResultsString + "RESULTS-COMPLEX-18".localizedVariant
        } else if (inYears > 1) && (inMonths == 0) && (inDays > 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-19".localizedVariant, inYears, inDays)
        } else if (inYears > 1) && (inMonths == 0) && (inDays == 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-20".localizedVariant, inYears)
        } else if (inYears == 1) && (inMonths == 0) && (inDays == 0) {
            return inResultsString + "RESULTS-COMPLEX-21".localizedVariant
        } else if (inYears > 1) && (inMonths == 1) && (inDays > 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-22".localizedVariant, inYears, inDays)
        } else if (inYears == 1) && (inMonths == 1) && (inDays > 1) {
            return inResultsString + String(format: "RESULTS-COMPLEX-23".localizedVariant, inDays)
        }
        
        return inResultsString
    }

    /*******************************************************************************************/
    /**
     A class function that will use our current localization to determine the correct tag name.
        
     - parameter inIndex: The index of the tag we are looking up.
        
     - returns: a tuple, containing both the base (tag) file name, and the face (text) file name.
    */
    class func determineImageNames(_ inIndex: Int) -> (baseName: String,  ///< The tag base file name
                                                            faceName: String   ///< The tag face file name.
                                                           ) {
        let currentLocale: Locale? = Locale.current
        let localeIDTemp: NSString = currentLocale!.identifier as NSString
        let localeID = localeIDTemp.substring(to: 2)
        
        let returnedBaseName = String(format: "tag_%02d", inIndex)
        var returnedFaceName = String(format: "face_%02d_%@", inIndex, localeID)

        let testImage: UIImage? = UIImage(named: returnedFaceName) // Test to see if we can get the image for the face.
        
        if(testImage == nil) // Default to English if no image for this language.
        {
            returnedFaceName = String(format: "face_%02d_en", inIndex)
        }

        return(baseName: returnedBaseName, faceName: returnedFaceName)
    }
    
    /*******************************************************************************************/
    /**
     This loads our available strings
        
     - returns: an array of prepared NACC_TagModel_TagData objects.
    */
    class func setUpAvailableImages() -> [NACC_TagModel_TagData] {
        // This current implementation is real clunky. I'll revisit it when I improve my Swift-Fu.
        var ret: [NACC_TagModel_TagData] = []
        
        var index = 1
        
        var names: (baseName: String, faceName: String) = NACC_TagModel.determineImageNames(index)
        
        index += 1
        
        let tagData1 = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 1, days: 0, months: 0, years: 0)
        
        ret.append(tagData1)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1

        let tagData30 = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 30, days: 0, months: 0, years: 0)
        
        ret.append(tagData30)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1

        let tagData60 = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 60, days: 0, months: 0, years: 0)
        
        ret.append(tagData60)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1

        let tagData90 = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 90, days: 0, months: 0, years: 0)
        
        ret.append(tagData90)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1

        let tagData6Mo = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 0, days: 0, months: 6, years: 0)
        
        ret.append(tagData6Mo)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1

        let tagData9Mo = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 0, days: 0, months: 9, years: 0)
        
        ret.append(tagData9Mo)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1
        
        let tagData1Yr = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 0, days: 0, months: 0, years: 1)
        
        ret.append(tagData1Yr)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1

        let tagData18Mo = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 0, days: 0, months: 6, years: 1)
        
        ret.append(tagData18Mo)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1

        let tagData2Yr = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 0, days: 0, months: 0, years: 2)
        
        ret.append(tagData2Yr)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1
        
        let tagData5Yr = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 0, days: 0, months: 0, years: 5)
        
        ret.append(tagData5Yr)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1
        
        let tagData10Yr = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 0, days: 0, months: 0, years: 10)
        
        ret.append(tagData10Yr)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1
        
        let tagData15Yr = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 0, days: 0, months: 0, years: 15)
        
        ret.append(tagData15Yr)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1

        let tagData20Yr = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 0, days: 0, months: 0, years: 20)
        
        ret.append(tagData20Yr)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1
        
        let tagData25Yr = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 0, days: 0, months: 0, years: 25)
        
        ret.append(tagData25Yr)
        
        names = NACC_TagModel.determineImageNames(index)
        
        index += 1
        
        let tagData10K = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 10000, days: 0, months: 0, years: 0)
        
        ret.append(tagData10K)
        
        names = NACC_TagModel.determineImageNames(index)
        
        let tagData30Yr = NACC_TagModel_TagData(baseImageName: names.baseName, faceImageName: names.faceName, totalDays: 0, days: 0, months: 0, years: 30)
        
        ret.append(tagData30Yr)
        
        return ret
    }
    
    /*******************************************************************************************/
    /**
     This composes a tag image, based on the three image resource names provided.
        
     - parameter inBaseName: The name of the tag base image.
     - parameter inFaceName: The name of the text to overlay on the tag.
     - parameter inRingClosed: if true, the closed ring image will be used. If not, the open one will be used. Default is false.
        
        - returns: an instance of UIImage. May be nil, if the operation fails.
    */
    class func constructTag(_ inBaseName: String, inFaceName: String, inRingClosed: Bool = false) -> UIImage? {
        var ret: UIImage? = nil  // Start off pessimistic
        
        if let baseImage: UIImage = UIImage(named: inBaseName) {
            if let faceImage: UIImage = UIImage(named: inFaceName) {
                if let ringImage: UIImage = UIImage(named: (inRingClosed ? "ring_02": "ring_01")) { // Select the correct ring image.
                    let aspect: CGFloat = 580.0 / 320.0
                    let width: CGFloat = baseImage.size.width
                    let height: CGFloat = width * aspect
                    
                    let size: CGSize = CGSize(width: width, height: height)
                    
                    UIGraphicsBeginImageContextWithOptions(size, false, 0)    // Set up an offscreen bitmap context.
                    
                    // Draw the transparent images over each other.
                    baseImage.draw(at: CGPoint(x: 0.0, y: height - baseImage.size.height ))
                    faceImage.draw(at: CGPoint(x: 0.0, y: height - faceImage.size.height ))
                    
                    let ringleft: CGFloat = (size.width - ringImage.size.width) / 2.0
                    
                    ringImage.draw(at: CGPoint(x: ringleft, y: 0.0 ))
                    
                    ret = UIGraphicsGetImageFromCurrentImageContext()   // Get the resulting composite image as a single image.
                    UIGraphicsEndImageContext()
                }
            }
        }
        
        return ret
    }
    
    /*******************************************************************************************/
    /**
     Checks a given tag data template against the given calculation to see if the tag applies.
        
     - parameter inCalculation: This is the NACC_DateCalc instance that has calculated the cleantime.
     - parameter inTagTemplate: This is the tag template we are checking.
        
     - returns: true if the tag applies to this calculation.
    */
    class func doesThisTagApply(inCalculation: NACC_DateCalc, inTagTemplate: NACC_TagModel_TagData) -> Bool {
        var ret: Bool = false
        
        // If this is a days counter, then we simply see if the calculation is higher. Simple.
        if (inTagTemplate.totalDays > 0) && (inCalculation.totalDays >= inTagTemplate.totalDays) {
            ret = true
        } else { // Otherwise, we need to compare years, months and days. Bit more involved.
            if inCalculation.totalDays > 90 { // Doesn't even come into play for less than 90.
                // This is a quick and dirty way to compare.
                let tagScore = (inTagTemplate.years * 10000) + (inTagTemplate.months * 100) + inTagTemplate.days
                let caclcScore = (inCalculation.years * 10000) + (inCalculation.months * 100) + inCalculation.days
                
                ret = caclcScore >= tagScore
            }
        }
        
        return ret
    }
    
    /*******************************************************************************************/
    /**
     The designated initializer.
        
     - parameter inCalculation: This is the NACC_DateCalc instance that has calculated the cleantime.
    */
    init(inCalculation: NACC_DateCalc) {
        calculation = inCalculation
    }
    
    /*******************************************************************************************/
    /**
     Convenience parameter-less init
    */
    convenience init() {
        self.init(inCalculation: NACC_DateCalc())
    }
    
    /*******************************************************************************************/
    /**
     This builds up an array of UIImages to be used to display the tags.
        
    - returns: an array of UIImage.
    */
    func getTags() -> [UIImage]? {
        var tagImages: [UIImage] = []                   // This is an array that will hold each of the aggregated image objects, in the order of display.
        
        if calculation.totalDays > 0 {
            let tagDataArray = NACC_TagModel.setUpAvailableImages() // Get our pool.
            
            var isFirst: Bool = true
            
            var index = 0
            
            for i in 0..<9 {
                index = i
                
                let tagTemplate = tagDataArray[index]
                if NACC_TagModel.doesThisTagApply(inCalculation: calculation, inTagTemplate: tagTemplate) {
                    tagImages.append(NACC_TagModel.constructTag(tagTemplate.baseImageName, inFaceName: tagTemplate.faceImageName, inRingClosed: isFirst)!)
                    isFirst = false // Only the first one is closed.
                }
            }
            
            var years: Int = calculation.years
            
            if years > 2 {
                var year = 3
                
                while years > 2 {
                    if year == 5 {
                        let fiveYearTag = tagDataArray[index + 1]
                        tagImages.append(NACC_TagModel.constructTag(fiveYearTag.baseImageName, inFaceName: fiveYearTag.faceImageName, inRingClosed: false)!)
                    } else if year == 10 {
                        let tenYearTag = tagDataArray[index + 2]
                        tagImages.append(NACC_TagModel.constructTag(tenYearTag.baseImageName, inFaceName: tenYearTag.faceImageName, inRingClosed: false)!)
                    } else if year == 15 {
                        let fifteenYearTag = tagDataArray[index + 3]
                        tagImages.append(NACC_TagModel.constructTag(fifteenYearTag.baseImageName, inFaceName: fifteenYearTag.faceImageName, inRingClosed: false)!)
                    } else if year == 25 {
                        let twentyFiveYearTag = tagDataArray[index + 5]
                        tagImages.append(NACC_TagModel.constructTag(twentyFiveYearTag.baseImageName, inFaceName: twentyFiveYearTag.faceImageName, inRingClosed: false)!)
                    } else if year == 30 {
                        let twentyFiveYearTag = tagDataArray[index + 7]
                        tagImages.append(NACC_TagModel.constructTag(twentyFiveYearTag.baseImageName, inFaceName: twentyFiveYearTag.faceImageName, inRingClosed: false)!)
                    } else if (year % 10) == 0 {
                        let twentyYearTag = tagDataArray[index + 4]
                        tagImages.append(NACC_TagModel.constructTag(twentyYearTag.baseImageName, inFaceName: twentyYearTag.faceImageName, inRingClosed: false)!)
                    } else {
                        let twoYearTag = tagDataArray[index]
                        tagImages.append(NACC_TagModel.constructTag(twoYearTag.baseImageName, inFaceName: twoYearTag.faceImageName, inRingClosed: false)!)
                        
                        if (year == 27) && (calculation.totalDays >= 10000) {
                            let tenKayDaysTag = tagDataArray[index + 6]
                            tagImages.append(NACC_TagModel.constructTag(tenKayDaysTag.baseImageName, inFaceName: tenKayDaysTag.faceImageName, inRingClosed: false)!)
                        }
                    }
                
                    year += 1
                    years -= 1
                }
            }
        }
        
        return tagImages
    }
}
