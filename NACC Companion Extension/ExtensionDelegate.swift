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

import WatchKit
import WatchConnectivity

/* ###################################################################################################################################### */
class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    /// These are our prefs that will contain the date and tag display prefs.
    let prefs = NACC_Prefs()
    
    /* ################################################################################################################################## */
    // MARK: - Internal Calculated Properties
    /* ################################################################################################################################## */
    /// Returns the default session
    var session: WCSession {
        return WCSession.default
    }
    
    /* ################################################################## */
    /**
     Called to start activation of a Watch session.
     */
    private func _activateSession() {
        if WCSession.isSupported() && (session.activationState != .activated) {
            session.delegate = self
            session.activate()
        }
    }
    
    /* ################################################################## */
    /**
     Returns our controller, conveniently cast.
     */
    var controller: NACC_Companion_InterfaceController! {
        return WKExtension.shared().rootInterfaceController as? NACC_Companion_InterfaceController
    }

    /* ################################################################## */
    /**
     Handles replies from the phone.
     
     - parameter inReply: The reply data.
     */
    private func _replyHandler(_ inReply: [String: Any]) {
        #if DEBUG
        print("Reply From Phone: " + String(describing: inReply))
        #endif
    }
    
    /* ################################################################## */
    /**
     Handles errors in replies from the phone.
     
     - parameter inError: The error data.
     */
    private func _errorHandler(_ inError: Error) {
        #if DEBUG
        print("Error From Phone: " + String(describing: inError))
        #endif
    }

    /* ################################################################## */
    /**
     Called to ask the phone to send us its state.
     */
    private func _askPhoneForState() {
        if  .activated == session.activationState {
            let values = prefs.values
            #if DEBUG
                print("Sending Request for Prefs to Phone: " + String(describing: values))
            #endif
            session.sendMessage([s_watchPhoneMessageHitMe: ""], replyHandler: _replyHandler, errorHandler: _errorHandler)   // No extra data necessary.
        } else {
            #if DEBUG
                print("ERROR! Session not active!")
            #endif
        }
    }
    
    /* ################################################################## */
    /**
     Sends a message to the phone, asking for an update.
     */
    func sendRequestUpdateMessage() {
        if session.isReachable {
            #if DEBUG
                print("Watch Sending Update Request")
            #endif
        }
        _askPhoneForState()
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Called when the app has finished launching.
     */
    func applicationDidFinishLaunching() {
        _activateSession()
        DispatchQueue.main.async {
            if let controller = self.controller {
                controller.showPleaseWait()
            }
        }
    }

    /* ################################################################## */
    /**
     Called when the app has become active.
     */
    func applicationDidBecomeActive() {
        DispatchQueue.main.async {
            if let controller = self.controller {
                controller.requestUpdate()
            }
        }
    }

    /* ################################################################## */
    /**
     Handles background tasks.
     
     - parameter inBackgroundTasks: The task set being handled.
     */
    func handle(_ inBackgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in inBackgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask: 
                // Be sure to complete the background task once you’re done.
                if #available(watchOSApplicationExtension 4.0, *) {
                    backgroundTask.setTaskCompletedWithSnapshot(true)
                } else {
                    backgroundTask.setTaskCompleted()
                }
            case let snapshotTask as WKSnapshotRefreshBackgroundTask: 
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask: 
                if #available(watchOSApplicationExtension 4.0, *) {
                    connectivityTask.setTaskCompletedWithSnapshot(true)
                } else {
                    connectivityTask.setTaskCompleted()
                }
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask: 
                // Be sure to complete the URL session task once you’re done.
                if #available(watchOSApplicationExtension 4.0, *) {
                    urlSessionTask.setTaskCompletedWithSnapshot(true)
                } else {
                    urlSessionTask.setTaskCompleted()
                }
            default: 
                // make sure to complete unhandled task types
                if #available(watchOSApplicationExtension 4.0, *) {
                    task.setTaskCompletedWithSnapshot(true)
                } else {
                    task.setTaskCompleted()
                }
            }
        }
    }

    /* ################################################################################################################################## */
    // MARK: - WCSessionDelegate Protocol Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Called when the session activation is complete.
     
     - parameter: ignored
     - parameter activationState: The final activation state.
     - parameter error: ignored.
     */
    func session(_: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if .activated == activationState {
            #if DEBUG
                print("Watch session is active.")
            #endif
            sendRequestUpdateMessage()
        }
    }
    
    /* ################################################################## */
    /**
     Called when the Watch recieves an application context.
     
     - parameter: ignored
     - parameter didReceiveApplicationContext: ignored.
     */
    func session(_: WCSession, didReceiveApplicationContext inApplicationContext: [String: Any]) {
        #if DEBUG
            print("Watch Received Application Context: " + String(describing: inApplicationContext))
        #endif
    }
    
    /* ################################################################## */
    /**
     Called when the Watch recieves a message. We update our prefs, here.
     
     - parameter: ignored
     - parameter didReceiveMessage: ignored.
     - parameter replyHandler: The closure to be called in order to reply to the message.
     */
    func session(_: WCSession, didReceiveMessage inMessage: [String: Any], replyHandler inReplyHandler: @escaping ([String: Any]) -> Void) {
        #if DEBUG
            print("\n###\nBEGIN Watch Received Message: " + String(describing: inMessage))
        #endif
        prefs.values = inMessage
        inReplyHandler([s_watchPhoneReplySuccessKey: true]) // Let the phone know we got the message.
        DispatchQueue.main.async {
            self.controller.performCalculation()
        }
        #if DEBUG
            print("###\nEND Watch Received Message\n")
        #endif
    }
}
