//
//  TripEditVC.swift
//  CCCTripSpiltr
//
//  Created by Ryan Murphy on 4/28/20.
//  Copyright © 2020 Ryan Murphy. All rights reserved.
//

import UIKit

class TripEditVC: UIViewController {

    var tripID: String?
    
    var trip: Trip?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTrip()
        
    }
    
    func configureUI() {
        guard let trip = trip else { return }
        self.title = trip.name
    }
    
    func getTrip() {
        
        guard let tripID = tripID else { return }
        NetworkController.shared.getTrip(for: tripID) { [weak self] (trip, error) in
            guard let self = self else { return }
            if let error = error {
                NSLog(error.rawValue)
            }
            guard let trip = trip else { return }
            self.trip = trip
            self.configureUI()
        }
    }
}
