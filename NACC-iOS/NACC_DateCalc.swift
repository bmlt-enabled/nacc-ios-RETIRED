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
class NACC_DateCalc
{
    /// The following will read like:
    /// "There have been <totalDays> between the dates. This is a period of <years> years, <months> months and <days> days."
    let totalDays: Int      ///< The total number of days.
    let years: Int          ///< The number of years since the clean date.
    let months: Int         ///< The number of months since the last year in the clean date.
    let days: Int           ///< The number of days since the last month in the clean date.
    let dateString: String  ///< This will contain a readable string of the date.
    let startDate: NSDate   ///< The starting date of the period (the cleandate).
    let endDate: NSDate     ///< The ending date of the period (today, usually).
    
    /*******************************************************************************************/
    /**
        \brief  This is the designated initializer. It takes two dates, and calculates between them.
    
        \param inCleanDate This is the "from" date. It is the start of the calculation.
        \param inNowDate This is the end date. The calculation goes between these two dates.
    */
    init ( inStartDate:NSDate, inNowDate:NSDate )
    {
        // The reason for all this wackiness, is we want to completely strip out the time element of each date. We want the days to be specified at noon.
        var fromString:String = NSDateFormatter.localizedStringFromDate ( inStartDate, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle )
        var toString:String = NSDateFormatter.localizedStringFromDate ( inNowDate, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle )
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .ShortStyle
        
        // We have stripped out the time information, and each day is at noon.
        var startDate:NSDate = dateFormatter.dateFromString ( fromString ).dateByAddingTimeInterval ( 43200 )    // Make it Noon, Numbah One.
        var stopDate:NSDate = dateFormatter.dateFromString ( toString ).dateByAddingTimeInterval ( 43200 )
        
        self.startDate = startDate
        self.endDate = stopDate
        
        self.dateString = NSDateFormatter.localizedStringFromDate ( startDate, dateStyle: NSDateFormatterStyle.LongStyle, timeStyle: NSDateFormatterStyle.NoStyle )
        
        // We get the total days, just to check for 90 or less.
        self.totalDays = Int ( trunc ( inNowDate.timeIntervalSinceDate ( inStartDate ) / 86400.0 ) ) // Change seconds into days.
        
        // Create our answer from the components of the result.
        var components = NSCalendar.currentCalendar().components ( NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit, fromDate: self.startDate, toDate: self.endDate, options: nil )
        
        self.years = components.year
        self.months = components.month
        self.days = components.day
    }
    
    /*******************************************************************************************/
    /**
        \brief  Convenience parameter-less init
    */
    convenience init ( )
    {
        self.init ( inStartDate: NSDate() )
    }
    
    /*******************************************************************************************/
    /**
        \brief  This is a convenience initializer that calculates between a given date, and now.
    
        \param inCleanDate This is the "from" date. It is the start of the calculation.
    */
    convenience init ( inStartDate:NSDate )
    {
        self.init ( inStartDate: inStartDate, inNowDate: NSDate() )
    }
    
    /*******************************************************************************************/
    /**
        \brief  This is a convenience initializer that calculates between a given date (expressed in components), and now.

        \param inCleanYear The year (fully-qualified)
        \param inCleanMonth The month (1 is January)
        \param inCleanDay The day of the month
    */
    convenience init ( inCleanYear: Int, inCleanMonth: Int, inCleanDay: Int )
    {
        let components = NSDateComponents()
        components.year = inCleanYear
        components.month = inCleanMonth
        components.day = inCleanDay
        components.hour = 0
        components.minute = 0
        components.second = 0
        let cleanDate = NSCalendar.currentCalendar().dateFromComponents ( components )
        
        self.init ( inStartDate: cleanDate )
    }
}

