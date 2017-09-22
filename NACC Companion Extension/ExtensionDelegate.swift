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
    /* ################################################################################################################################## */
    private var _mySession = WCSession.default
    var cleanDateCalc:NACC_DateCalc! = nil ///< This holds our global date calculation.
    var mainController:NACC_Companion_InterfaceController! {
        get {
            return WKExtension.shared().rootInterfaceController as! NACC_Companion_InterfaceController
        }
    }
    
    /* ################################################################################################################################## */
    var session: WCSession {get { return self._mySession }}
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    private func _activateSession() {
        if WCSession.isSupported() && (self.session.activationState != .activated) {
            self.session.delegate = self
            self.session.activate()
        }
    }

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        self._activateSession()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    /* ################################################################## */
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

    /* ################################################################################################################################## */
    
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
        }
    }
    
    /* ################################################################## */
    /**
     */
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]){
        #if DEBUG
            print("Watch Received Application Context: " + String(describing: applicationContext))
        #endif
        
        if let startDate = applicationContext[s_appContext_StartDate] as? Date {
            if let endDate = applicationContext[s_appContext_EndDate] as? Date {
                self.cleanDateCalc = NACC_DateCalc(inStartDate: startDate, inNowDate: endDate)
                self.mainController.performCalculation()
            }
        }
    }
    
    /* ################################################################## */
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
