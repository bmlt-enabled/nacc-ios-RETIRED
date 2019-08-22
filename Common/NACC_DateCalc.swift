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

import Foundation

/***********************************************************************************************/
/**
    \class  NACC_DateCalc
    \brief  This is the fundamental core of the cleantme calculator.

            It works by taking an input date (1-day resolution), and a "today" date (which can be
            omitted), and calculates the time interval between them. It uses the appropriate
            calendar (if Iranian, it uses the Persian Solar Calendar).
            All the action happens in the designated initializer. Once the class is instantiated,
            its work is done.
*/
/***********************************************************************************************/
class NACC_DateCalc {
    /// The following will read like: 
    /// "There have been <totalDays> between the dates. This is a period of <years> years, <months> months and <days> days."
    let totalDays: Int      ///< The total number of days.
    var years: Int = 0      ///< The number of years since the clean date.
    var months: Int = 0     ///< The number of months since the last year in the clean date.
    var days: Int = 0       ///< The number of days since the last month in the clean date.
    let dateString: String  ///< This will contain a readable string of the date.
    let startDate: Date?    ///< The starting date of the period (the cleandate).
    let endDate: Date?      ///< The ending date of the period (today, usually).
    
    /*******************************************************************************************/
    /**
        \brief  This is the designated initializer. It takes two dates, and calculates between them.
    
        \param inStartDate This is the "from" date. It is the start of the calculation.
        \param inNowDate This is the end date. The calculation goes between these two dates.
    */
    init(inStartDate: Date, inNowDate: Date) {
        // The reason for all this wackiness, is we want to completely strip out the time element of each date. We want the days to be specified at noon.
        let fromString: String = DateFormatter.localizedString(from: inStartDate, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
        let toString: String = DateFormatter.localizedString(from: inNowDate, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        
        // We have stripped out the time information, and each day is at noon.
        startDate = dateFormatter.date(from: fromString)?.addingTimeInterval(43200)  // Make it Noon, Numbah One.
        endDate = dateFormatter.date(from: toString)?.addingTimeInterval(43200)
        
        dateString = DateFormatter.localizedString(from: startDate!, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
        
        // We get the total days, just to check for 90 or less.
        totalDays = Int(trunc(inNowDate.timeIntervalSince(inStartDate) / 86400.0 )) // Change seconds into days.
        
        if (startDate != nil && endDate != nil) && (startDate! < endDate!) {
            let myCalendar: Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            // Create our answer from the components of the result.
            let unitFlags: NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
            let myComponents = (myCalendar as NSCalendar).components(unitFlags, from: startDate!, to: endDate!, options: NSCalendar.Options.wrapComponents)
            
            if  let yearsTmp = myComponents.year,
                let monthsTmp = myComponents.month,
                let daysTmp = myComponents.day {
                years = yearsTmp
                months = monthsTmp
                days = daysTmp
            }
        }
    }
    
    /*******************************************************************************************/
    /**
        \brief  Convenience parameter-less init
    */
    convenience init() {
        self.init(inStartDate: NACC_Prefs().cleanDate)
    }
    
    /*******************************************************************************************/
    /**
        \brief  This is a convenience initializer that calculates between a given date, and now.
    
        \param inStartDate This is the "from" date. It is the start of the calculation.
    */
    convenience init(inStartDate: Date) {
        self.init(inStartDate: inStartDate, inNowDate: Date())
    }
    
    /*******************************************************************************************/
    /**
        \brief  This is a convenience initializer that calculates between a given date (expressed in components), and now.

        \param inCleanYear The year (fully-qualified)
        \param inCleanMonth The month (1 is January)
        \param inCleanDay The day of the month
    */
    convenience init(inCleanYear: Int, inCleanMonth: Int, inCleanDay: Int) {
        var components = DateComponents()
        components.year = inCleanYear
        components.month = inCleanMonth
        components.day = inCleanDay
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        self.init(inStartDate: Calendar.current.date(from: components)!)
    }
}
