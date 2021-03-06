//
//  ViewController.swift
//  Remind Me To
//
//  Created by Mike Kavouras on 12/9/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    let CellIdentifier = "CellIdentifier"
    
    var location = CLLocation()
    
    var search: NSURLSessionDataTask?
    
    var places: [JSON]?
    
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 0
       return manager
    }()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func submitTapped(sender: AnyObject) {
    }
    
    private func performSearch() {
        
        if let s = search {
            s.cancel()
        }
        
        search = FoursquareSearchHelper().performSearch(searchBar.text, location: location, successCallback: {(response: [JSON]?) -> Void in
            if let resp = response {
                self.places = resp
                println(self.places?.count)
            }
        })
    }
    
    
    // MARK: <CLLocationManagerDelegate>
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        location = locations[0] as CLLocation
    }

    
    // MARK: <UITextFieldDelegate>
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        resizeTextView(textView)
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        resizeTextView(textView)
    }
    
    private func resizeTextView(textView: UITextView) {
        let contentSize = textView.contentSize
        self.textViewHeightConstraint.constant = contentSize.height
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.contentOffset = CGPoint(x: 0, y: 0)
    }

}

