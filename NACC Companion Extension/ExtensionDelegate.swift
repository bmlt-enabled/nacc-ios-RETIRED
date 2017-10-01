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
import WatchConnectivity

/* ###################################################################################################################################### */
class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    let _mainPrefsKey: String   = "NACCMainPrefs"
    let _datePrefsKey: String   = "NACCLastDate"
    let _keysPrefsKey: String   = "NACCShowTags"

    /* ################################################################################################################################## */
    private var _mySession = WCSession.default

    // MARK: - Internal Instance Properties
    /* ################################################################################################################################## */
    /** This contains our loaded prefs Dictionary. */
    var loadedPrefs: NSMutableDictionary! = nil
    var cleanDateCalc:NACC_DateCalc! = nil ///< This holds our global date calculation.
    
    var mainController:NACC_Companion_InterfaceController! {
        get {
            var ret:NACC_Companion_InterfaceController! = nil
            
            if nil != WKExtension.shared().rootInterfaceController {
                if let temp = WKExtension.shared().rootInterfaceController as? NACC_Companion_InterfaceController {
                    ret = temp
                }
            }
            
            return ret
        }
    }
    
    /* ################################################################################################################################## */
    var session: WCSession {get { return self._mySession }}

    var lastEnteredDate: Double {
        /***************************************************************************************/
        /**
         This method returns the last entered date, which is persistent.
         
         The date is a POSIX epoch date (integer).
         */
        get {
            var ret: Double = 0
            
            if self._loadPrefs()
            {
                if let temp = self.loadedPrefs.object(forKey: _datePrefsKey) as? Double
                {
                    ret = temp
                }
            }
            
            return ret
        }
        
        /***************************************************************************************/
        /**
         This method saves the last entered date, which is persistent.
         
         The date is a POSIX epoch date (integer).
         */
        set {
            if self._loadPrefs()
            {
                self.loadedPrefs.setObject(newValue, forKey: _datePrefsKey as NSCopying)
                self._savePrefs()
            }
        }
    }
    
    var showKeys: Bool {
        /***************************************************************************************/
        /**
         This method returns whether or not to show the keytags, which is persistent.
         
         The date is a POSIX epoch date (integer).
         */
        get {
            var ret: Bool = true
            
            if self._loadPrefs()
            {
                if let temp = self.loadedPrefs.object(forKey: _keysPrefsKey) as? Bool
                {
                    ret = temp
                }
            }
            
            return ret
        }
        
        /***************************************************************************************/
        /**
         This method saves the state of the show keys switch, which is persistent.
         
         The date is a POSIX epoch date (integer).
         */
        set {
            if self._loadPrefs()
            {
                self.loadedPrefs.setObject(newValue, forKey: _keysPrefsKey as NSCopying)
                self._savePrefs()
            }
        }
    }
    
    /*******************************************************************************************/
    /**
     */
    private func _activateSession() {
        if WCSession.isSupported() && (self.session.activationState != .activated) {
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    /*******************************************************************************************/
    /**
     \brief  Saves the persistent prefs.
     */
    private func _savePrefs()
    {
        UserDefaults.standard.set(self.loadedPrefs, forKey: self._mainPrefsKey)
    }

    /*******************************************************************************************/
    /**
     \brief  Loads the persistent prefs.
     */
    private func _loadPrefs() -> Bool
    {
        let temp = UserDefaults.standard.object(forKey: self._mainPrefsKey) as? NSDictionary
        
        if nil == temp {
            self.loadedPrefs = NSMutableDictionary()
        } else {
            self.loadedPrefs = NSMutableDictionary(dictionary: temp!)
        }
        
        return nil != self.loadedPrefs
    }

    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     */
    func applicationDidFinishLaunching() {
        self._activateSession()
    }

    /*******************************************************************************************/
    /**
     */
    func applicationDidBecomeActive() {
        if 0 < self.lastEnteredDate {
            let startDate = Date(timeIntervalSince1970: self.lastEnteredDate)
            self.cleanDateCalc = NACC_DateCalc(inStartDate: startDate, inNowDate: Date())
            if nil != self.mainController {
                self.mainController.performCalculation()
            }
        }
        self.sendRequestUpdateMessage()
    }
    
    /*******************************************************************************************/
    /**
     */
    func applicationWillResignActive() {
        self._savePrefs()
    }

    /*******************************************************************************************/
    /**
     */
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                if #available(watchOSApplicationExtension 4.0, *) {
                    backgroundTask.setTaskCompletedWithSnapshot(true)
                } else {
                    // Fallback on earlier versions
                }
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                if #available(watchOSApplicationExtension 4.0, *) {
                    connectivityTask.setTaskCompletedWithSnapshot(true)
                } else {
                    // Fallback on earlier versions
                }
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                if #available(watchOSApplicationExtension 4.0, *) {
                    urlSessionTask.setTaskCompletedWithSnapshot(true)
                } else {
                    // Fallback on earlier versions
                }
            default:
                // make sure to complete unhandled task types
                if #available(watchOSApplicationExtension 4.0, *) {
                    task.setTaskCompletedWithSnapshot(true)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
    
    /*******************************************************************************************/
    /**
     */
    func sendRequestUpdateMessage() {
        if self.session.isReachable {
            let selectMsg = [s_watchkitCommsRequestUpdate:"HIT ME"]
            #if DEBUG
                print("Watch Sending Message: " + String(describing: selectMsg))
            #endif
            self.session.sendMessage(selectMsg, replyHandler: nil, errorHandler: nil)
        }
    }

    // MARK: - WCSessionDelegate Protocol Methods
    /* ################################################################################################################################## */
    /*******************************************************************************************/
    /**
     */
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if .activated == activationState {
            #if DEBUG
                print("Watch session is active.")
            #endif
        }
    }
    
    /*******************************************************************************************/
    /**
     */
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]){
        #if DEBUG
            print("Watch Received Application Context: " + String(describing: applicationContext))
        #endif
        
        if let startDate = applicationContext[s_appContext_StartDate] as? Date {
            if let endDate = applicationContext[s_appContext_EndDate] as? Date {
                self.lastEnteredDate = startDate.timeIntervalSince1970
                self._savePrefs()
                self.cleanDateCalc = NACC_DateCalc(inStartDate: startDate, inNowDate: endDate)
                self.mainController.performCalculation()
            }
        }
    }
    
    /*******************************************************************************************/
    /**
     */
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            #if DEBUG
                print("Watch Received Message: " + String(describing: message))
            #endif
        }
    }
}
