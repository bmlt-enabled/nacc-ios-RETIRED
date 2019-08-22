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

/* ############################################################################################################################## */
// MARK: - Shared Constants
/* ############################################################################################################################## */
/// This is the reply to a message from the watch to the phone. Its value is either Boolean true or false.
let s_watchPhoneReplySuccessKey = "SUCCESS"
/// This message is sent from the watch to the phone. It asks the phone to update the watch with the latest version of the prefs.
let s_watchPhoneMessageHitMe = "HITME"
/// This message is sent from the watch to the phone. It asks the phone to reset its settings to default.
let s_watchPhoneMessageReset = "RESET"

/* ################################################################################################################################## */
// MARK: - NACC Preferences Derived Class
/* ################################################################################################################################## */
/**
 */
class NACC_Prefs: RVS_PersistentPrefs {
    /* ############################################################################################################################## */
    // MARK: - Private Enums
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     */
    private enum _KeyStrings: String {
        case cleanDate
        case tagDisplay
    }
    
    /* ############################################################################################################################## */
    // MARK: - Public Enums
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This flags the manner in which cleadate is reported. It is based on String, for easy storage and debugging.
     */
    public enum TagDisplay: String {
        /// No tags displayed. Cleandate only.
        case noTags
        /// Normal. Cleandate, and "standard" tags.
        case normal
        /// Cleandate, and all tags, including "special" ones.
        case specialTags
    }
    
    /* ############################################################################################################################## */
    // MARK: - Public Calculated Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This calculated property MUST be overridden by subclasses.
     It is an Array of String, containing the keys used to store and retrieve the values from persistent storage.
     */
    override public var keys: [String] {
        return [_KeyStrings.cleanDate.rawValue, _KeyStrings.tagDisplay.rawValue]
    }
    
    /* ################################################################## */
    /**
     Return our main key, so we don't need it for anything else.
     
     Can't change it.
     */
    override public var key: String {
        get {
            return "NACC"
        }
        
        set {
        }
    }
    
    /* ################################################################## */
    /**
     Accessor for the clean date.
     */
    public var cleanDate: Date! {
        get {
            return values[_KeyStrings.cleanDate.rawValue] as? Date
        }
        
        set {
            if nil != newValue {
                values[_KeyStrings.cleanDate.rawValue] = newValue
            } else {
                values.removeValue(forKey: _KeyStrings.cleanDate.rawValue)
            }
        }
    }
    
    /* ################################################################## */
    /**
     Accessor for the tag display mode.
     */
    public var tagDisplay: TagDisplay {
        get {
            if  let storedVal = values[_KeyStrings.tagDisplay.rawValue] as? String,
                let displayMode = TagDisplay(rawValue: storedVal) {
                return displayMode
            }
            
            return .normal
        }
        
        set {
            values[_KeyStrings.tagDisplay.rawValue] = newValue.rawValue
        }
    }
}
