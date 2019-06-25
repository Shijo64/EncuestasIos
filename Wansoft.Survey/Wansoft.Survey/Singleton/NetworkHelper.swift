//
//  NetworkHelper.swift
//  EncuestaSatisfaccion
//
//  Created by Arturo Calvo on 21/01/19.
//  Copyright © 2019 Wansoft. All rights reserved.
//

import Foundation
import Reachability

class NetworkHelper:NSObject {
    
    var reachability:Reachability!
    
    static let sharedInstance = NetworkHelper()
    
    override init(){
        super.init()
        
        reachability = Reachability()!
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("error notificador de red")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }

    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkHelper.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    static func isReachable(completed: @escaping (NetworkHelper) -> Void) {
        if (NetworkHelper.sharedInstance.reachability).connection != .none {
            completed(NetworkHelper.sharedInstance)
        }
    }
    
    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkHelper) -> Void) {
        if (NetworkHelper.sharedInstance.reachability).connection == .none {
            completed(NetworkHelper.sharedInstance)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkHelper) -> Void) {
        if (NetworkHelper.sharedInstance.reachability).connection == .cellular {
            completed(NetworkHelper.sharedInstance)
        }
    }

    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkHelper) -> Void) {
        if (NetworkHelper.sharedInstance.reachability).connection == .wifi {
            completed(NetworkHelper.sharedInstance)
        }
    }
}
