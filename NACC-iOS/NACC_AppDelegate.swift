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
import QuartzCore
import WatchConnectivity

/* ###################################################################################################################################### */
/**
 The main App Delegate class.
 */
@UIApplicationMain
class NACC_AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    /* ################################################################## */
    /**
     This is a quick way to get this object instance (it's a SINGLETON), cast as the correct class.
     */
    static var appDelegateObject: NACC_AppDelegate {
        return (UIApplication.shared.delegate as? NACC_AppDelegate)!
    }

    /* ################################################################################################################################## */
    // MARK: - Internal Instance Properties
    /* ################################################################################################################################## */
    /// This contains our loaded prefs Dictionary.
    var loadedPrefs: NSMutableDictionary! = nil
    /// The app main window.
    var window: UIWindow?

    /* ############################################################################################################################## */
    // MARK: - Internal Instance Calculated Properties
    /* ############################################################################################################################## */
    /* ################################################################## */
    /**
     This is the WCSession. It is the default session.
     */
    var session: WCSession! {
        return WCSession.default
    }

    /* ################################################################################################################################## */
    // MARK: - Internal Instance Methods
    /* ################################################################################################################################## */
    /// Activates the Watch session.
    func activateSession() {
        if WCSession.isSupported() && (session.activationState != .activated) {
            session.delegate = self
            session.activate()
        }
    }

    /* ################################################################################################################################## */
    // MARK: - UIApplicationDelegate Protocol Methods
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     Called when the app has finished launch prep.
     
     - parameter inApplication: The application object (ignored).
     - parameter didFinishLaunchingWithOptions: The launch options (also ignored).
     
     - returns: True, if the app is to launch.
    */
    func application(_ inApplication: UIApplication, didFinishLaunchingWithOptions inLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /* ################################################################## */
        /**
         These are keys for our old prefs.
         
         We use these to load any legacy prefs from previous versions of the app.
         */
        /// The Main prefs
        let mainPrefsKey: String   = "NACCMainPrefs"
        /// The last entered cleandate.
        let datePrefsKey: String   = "NACCLastDate"
        /// Whether or not to show the tags.
        let keysPrefsKey: String   = "NACCShowTags"
        
        /*******************************************************************************************/
        /**
         Loads the old persistent prefs (if any).
         */
        func loadPrefs() {
            let temp = UserDefaults.standard.object(forKey: mainPrefsKey) as? NSDictionary
            
            if nil == temp {
                loadedPrefs = NSMutableDictionary()
            } else {
                loadedPrefs = NSMutableDictionary(dictionary: temp!)
                let newPrefs = NACC_Prefs()
                if let temp = loadedPrefs.object(forKey: datePrefsKey) as? Double {
                    newPrefs.cleanDate = Date(timeIntervalSince1970: temp)
                }
                
                if let temp = loadedPrefs.object(forKey: keysPrefsKey) as? Bool {
                    newPrefs.tagDisplay = temp ? NACC_Prefs.TagDisplay.specialTags : NACC_Prefs.TagDisplay.noTags
                }
            }
 
            UserDefaults.standard.set(nil, forKey: mainPrefsKey)
        }
        
        let newPrefs = NACC_Prefs()
        
        loadPrefs()
        
        if  nil == newPrefs.cleanDate,
            let temp = loadedPrefs.object(forKey: datePrefsKey) as? Double {
            newPrefs.cleanDate = Date(timeIntervalSince1970: temp)
        }
        
        if  let temp = loadedPrefs.object(forKey: keysPrefsKey) as? Bool {
            newPrefs.tagDisplay = temp ? .specialTags : .noTags
        }

        activateSession()
        return true
    }
    
    /*******************************************************************************************/
    /**
     We make sure that the first window is always the date selector.
    */
    func applicationWillEnterForeground( _ application: UIApplication) {
    }
    
    /* ################################################################################################################################## */
    // MARK: - WCSession Sender Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Called to send our current settings to the watch.
     */
    func sendCurrentSettingsToWatch() {
        if  .activated == session.activationState {
            let values = NACC_Prefs().values
            #if DEBUG
                print("Sending Prefs to Watch: " + String(describing: values))
            #endif
            session.sendMessage(values, replyHandler: _replyHandler, errorHandler: _errorHandler)
        }
    }
    
    /* ################################################################## */
    /**
     The reply from the watch.
     
     - parameter inReply: The reply Dictionary. It can only be succsessful.
     */
    private func _replyHandler(_ inReply: [String: Any]) {
        #if DEBUG
            print("Reply From Watch: " + String(describing: inReply))
        #endif
    }
    
    /* ################################################################## */
    /**
     Any error from the watch.
     
     - parameter inError: The error that happened.
     */
    private func _errorHandler(_ inError: Error) {
        #if DEBUG
            print("Error From Watch: " + String(describing: inError))
        #endif
    }

    /* ################################################################################################################################## */
    // MARK: - WCSessionDelegate Protocol Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Called when the session is done activating.
     
     - parameter inSession: The WatchKit session (ignored).
     - parameter activationDidCompleteWith: The activation state.
     - parameter error: Any errors (ignored).
     */
    func session(_ inSession: WCSession, activationDidCompleteWith inActivationState: WCSessionActivationState, error inError: Error?) {
        if .activated == inActivationState {
            #if DEBUG
                print("Watch session is active.")
            #endif
            sendCurrentSettingsToWatch()
        }
    }
    
    /* ################################################################## */
    /**
     Called when we receive a message from the Watch.
     
     - parameter inSession: The WatchKit session (ignored).
     - parameter didReceiveMessage: A Dictionary, with the message.
     - parameter replyHandler: A callback closure to acknowledge the receipt of the message, and send back a reply.
     */
    func session(_ inSession: WCSession, didReceiveMessage inMessage: [String: Any], replyHandler inReplyHandler: @escaping ([String: Any]) -> Void) {
        if nil != inMessage[s_watchPhoneMessageHitMe] {
            #if DEBUG
                print("Received Request for Settings from Watch.")
            #endif
            inReplyHandler([s_watchPhoneReplySuccessKey: true])
            sendCurrentSettingsToWatch()
        }
    }
    
    /* ################################################################## */
    /**
     Called when the session becomes inactive.
     
     - parameter inSession: The WatchKit session (ignored).
     */
    func sessionDidBecomeInactive(_ inSession: WCSession) {
        #if DEBUG
            print("Session became inactive.")
        #endif
    }
    
    /* ################################################################## */
    /**
     Called when the session is explicitly deactivated.
     
     - parameter inSession: The WatchKit session (ignored).
     */
    func sessionDidDeactivate(_ inSession: WCSession) {
        #if DEBUG
            print("Session deactivated.")
        #endif
    }
}
