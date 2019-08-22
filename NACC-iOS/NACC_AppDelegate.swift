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

var s_NACC_BaseColor: UIColor?                              ///< This will hold the color that will tint our backgrounds.
var s_NACC_AppDelegate: NACC_AppDelegate?
var s_NACC_GradientLayer: CAGradientLayer?

@UIApplicationMain
/* ###################################################################################################################################### */
/**
 */
class NACC_AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    // MARK: - Constant Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     These are keys for our prefs.
     */
    let _mainPrefsKey: String   = "NACCMainPrefs"
    let _datePrefsKey: String   = "NACCLastDate"
    let _keysPrefsKey: String   = "NACCShowTags"

    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* This is the Watch connectivity session. */
    private var _mySession: WCSession! = nil

    // MARK: - Internal Instance Properties
    /* ################################################################################################################################## */
    /** This contains our loaded prefs Dictionary. */
    var loadedPrefs: NSMutableDictionary! = nil
    var window: UIWindow?
    
    // MARK: - Internal Instance Calculated Properties
    /* ################################################################################################################################## */
    var session: WCSession! {
        if nil == self._mySession {
            self._mySession = WCSession.default
        }
        
        return self._mySession
    }
    
    // MARK: - Internal Instance Methods
    /* ################################################################################################################################## */
    func activateSession() {
        if WCSession.isSupported() && (self.session.activationState != .activated) {
            self._mySession.delegate = self
            self.session.activate()
        }
    }

    // MARK: - UIApplicationDelegate Protocol Methods
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
        \brief  Simply set the SINGLETON to us.
    */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        s_NACC_AppDelegate = self
        let newPrefs = NACC_Prefs()
        
        if  nil == newPrefs.cleanDate,
            self._loadPrefs(),
            let temp = self.loadedPrefs.object(forKey: _datePrefsKey) as? Double {
            newPrefs.cleanDate = Date(timeIntervalSince1970: temp)
        }
        
        if  self._loadPrefs(),
            let temp = self.loadedPrefs.object(forKey: _keysPrefsKey) as? Bool {
            newPrefs.tagDisplay = temp ? .specialTags : .noTags
        }

        self.activateSession()
        return true
    }
    
    /*******************************************************************************************/
    /**
        \brief  We make sure that the first window is always the date selector.
    */
    func applicationWillEnterForeground( _ application: UIApplication) {
        if let mainNavController: UINavigationController = s_NACC_AppDelegate!.window!.rootViewController as? UINavigationController {
            if NSObject.isKind(of: NACC_ResultsViewController.self) {
                mainNavController.popToRootViewController(animated: true)
            }
        }
    }
    
    /*******************************************************************************************/
    /**
     \brief  Saves the persistent prefs.
     */
    func _savePrefs() {
        UserDefaults.standard.set(self.loadedPrefs, forKey: self._mainPrefsKey)
    }
    
    /*******************************************************************************************/
    /**
     \brief  Loads the persistent prefs.
     */
    func _loadPrefs() -> Bool {
        let temp = UserDefaults.standard.object(forKey: self._mainPrefsKey) as? NSDictionary
        
        if nil == temp {
            self.loadedPrefs = NSMutableDictionary()
        } else {
            self.loadedPrefs = NSMutableDictionary(dictionary: temp!)
            let newPrefs = NACC_Prefs()
            if let temp = self.loadedPrefs.object(forKey: _datePrefsKey) as? Double {
                newPrefs.cleanDate = Date(timeIntervalSince1970: temp)
            }
            
            if let temp = self.loadedPrefs.object(forKey: _keysPrefsKey) as? Bool {
                newPrefs.tagDisplay = temp ? NACC_Prefs.TagDisplay.specialTags : NACC_Prefs.TagDisplay.noTags
            }
        }
        
        return nil != self.loadedPrefs
    }
    
    // MARK: - WCSession Sender Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    func sendCurrentProfileToWatch() {
    }
    
    // MARK: - WCSessionDelegate Protocol Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if .activated == activationState {
            #if DEBUG
                print("Watch session is active.")
            #endif
            self.sendCurrentProfileToWatch()
        }
    }
    
    /* ################################################################## */
    /**
     */
    func sessionDidBecomeInactive(_ session: WCSession) {
        #if DEBUG
            print("Watch session is inactive.")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func sessionDidDeactivate(_ session: WCSession) {
        #if DEBUG
            print("Watch session deactivated.")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            #if DEBUG
                print("Phone Received Message: " + String(describing: message))
            #endif
        }
    }
}
