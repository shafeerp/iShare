//
//  MapController.swift
//  iShare
//
//  Created by Shafeer Puthalan on 12/05/19.
//  Copyright © 2019 Shafeer Puthalan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapController: UIViewController {
    
    var inputStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var homeTextField : UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Home"
        textfield.isEnabled = true
        textfield.tag = 1
        textfield.delegate = self
        return textfield
        
    }()
    
    lazy var officeTextField : UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Office"
        textfield.isEnabled = true
        textfield.tag = 2
        textfield.delegate = self
        return textfield
    }()
    
    lazy var requestorHome : UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Requestor Home"
        textfield.isEnabled = true
        textfield.delegate = self
        textfield.tag = 3
        return textfield
    }()
    
    lazy var requestorOffice : UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Requestor Office"
        textfield.isEnabled = true
        textfield.tag = 4
        textfield.delegate = self
        return textfield
    }()
    
    
    lazy var checkButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "check"), for: .normal)
        button.addTarget(self, action: #selector(handleCheck), for: .touchUpInside)
        return button
    }()
    
    lazy var mapView : GMSMapView = {
        var view = GMSMapView()
        let camera = GMSCameraPosition.camera(withLatitude: 12.9827589, longitude: 77.6224634, zoom: 12.0)
        view = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        return view
    }()
    
    var tripDetailsView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
        view.isHidden = true
        return view
    }()
    
    var etaLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        return label
    }()
    
    var clickedTextField = UITextField()
    var markers = [Constants.Maps.ONE : GMSMarker(), Constants.Maps.TWO: GMSMarker(), Constants.Maps.THREE : GMSMarker(), Constants.Maps.FOUR : GMSMarker()]
    
    var allLocations = [String:CLLocation]()
    var polyline : GMSPolyline?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addConstraints()
    }
    
    private func setupViews(){
        self.view.addSubview(mapView)
        inputStackView.addArrangedSubview(homeTextField)
        inputStackView.addArrangedSubview(officeTextField)
        inputStackView.addArrangedSubview(requestorHome)
        inputStackView.addArrangedSubview(requestorOffice)
        self.view.addSubview(inputStackView)
        self.view.addSubview(checkButton)
        self.view.addSubview(tripDetailsView)
        self.view.addSubview(etaLabel)
    }
    
    private func addConstraints() {
        
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        homeTextField.translatesAutoresizingMaskIntoConstraints = false
        officeTextField.translatesAutoresizingMaskIntoConstraints = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        tripDetailsView.translatesAutoresizingMaskIntoConstraints = false
        etaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //Adding constraint for input stack view
        
        NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: inputStackView, attribute: .trailing, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: inputStackView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        
        NSLayoutConstraint(item: inputStackView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60).isActive = true
        
        //Adding constraint for check button
        
        NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: checkButton, attribute: .trailing, multiplier: 1, constant: 25).isActive = true
        
        NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: checkButton, attribute: .bottom, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: tripDetailsView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: tripDetailsView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: tripDetailsView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        
        //Adding constraint of textfields
        homeTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        officeTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        requestorHome.heightAnchor.constraint(equalToConstant: 35).isActive = true
        requestorOffice.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        //adding contraints for uiview
        tripDetailsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //adding contraints for label
        etaLabel.centerXAnchor.constraint(equalTo: tripDetailsView.centerXAnchor).isActive = true
        etaLabel.centerYAnchor.constraint(equalTo: tripDetailsView.centerYAnchor).isActive = true
        
        //Adding constraint of button
        checkButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
    }
    
    private func addMarker(place : GMSPlace, color : UIColor){
    
        let marker = GMSMarker()
        marker.userData = clickedTextField.tag
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.title = place.name
        marker.snippet = place.formattedAddress
        marker.icon = GMSMarker.markerImage(with: color)
        marker.map = mapView
        
    }
    private func addMarkesr(marker : GMSMarker,place : GMSPlace, color : UIColor){
        marker.map = nil
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.title = place.name
        marker.snippet = place.formattedAddress
        marker.icon = GMSMarker.markerImage(with: color)
        marker.map = mapView
        
    }
    
    @objc private func handleCheck() {
        if homeTextField.hasText && officeTextField.hasText && requestorHome.hasText && requestorOffice.hasText {
            let location = Locations(locations: allLocations)

            let diff = location.distanceIncludingRequestor() - location.calculateNormalDistance()
            print(diff)
            if diff <= 1000 {
                markDirection(directionRequest: DirectionRequest(locations: location, wayPoints: true))
            }
            else {
               CommonMethods.showAlert(title: "Not Allowed", message: "Sorry you cant accept this ride request because you have to travell additional \(diff) metres . So we are showing you the direction from your home to office", view: self)
                markDirection(directionRequest: DirectionRequest(locations: location, wayPoints: false))
            }
        }
        else {
            CommonMethods.showAlert(title: "Missing Locations", message: "Please enter all your location to continoue", view: self)
        }
    }
    
    private func markDirection(directionRequest : DirectionRequest) {
        polyline?.map = nil
        let apiClient = APIClient()
        apiClient.send(apiRequest: directionRequest) { (direction : Directions?, error) in
            if error != nil {
                print(error!)
                return
            }
            OperationQueue.main.addOperation ({
                for route in direction!.routes {
                    let routeOverviewPolyline = route.overviewPolyline
                    let points = routeOverviewPolyline.points
                    let path = GMSPath.init(fromEncodedPath: points)
                    self.polyline = GMSPolyline(path: path)
                    self.polyline?.strokeWidth = 3
                    self.polyline?.strokeColor = .red
                    let bounds = GMSCoordinateBounds(path: path!)
                    self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                    self.polyline?.map = self.mapView
                }
                self.etaLabel.text = self.getDuration(routes: (direction?.routes)!)
                self.tripDetailsView.isHidden = false
            })
            
            
            
            
        }
    }
    private func getDuration(routes : [Route]) -> String {
        
        var totalDistanceInMeters = 0
        var totalDurationInSeconds = 0
        for route in routes {
            for legs in route.legs {
                totalDistanceInMeters += legs.distance.value
                totalDurationInSeconds += legs.duration.value
            }
        }
        
        return totalDurationInSeconds.timeFormat()
    }
}
extension MapController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clickedTextField = textField
        textField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "IND"
        acController.autocompleteFilter = filter
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
}


extension MapController : GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        clickedTextField.text = place.name
        self.tripDetailsView.isHidden = true
        switch clickedTextField.tag {
        case 1:
            addMarkesr(marker: markers[Constants.Maps.ONE]!, place: place, color: .red)
            allLocations[Constants.Maps.ONE] = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            break
        case 2:
            addMarkesr(marker: markers[Constants.Maps.TWO]!, place: place, color: .red)
            allLocations[Constants.Maps.TWO] = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            break
        case 3:
            addMarkesr(marker: markers[Constants.Maps.THREE]!, place: place, color: .green)
            allLocations[Constants.Maps.THREE] = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            break
        case 4:
            addMarkesr(marker: markers[Constants.Maps.FOUR]!, place: place, color: .green)
            allLocations[Constants.Maps.FOUR] = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            break
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error){
        
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension Int {
    func timeFormat() -> String {
        let mins = self / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = self % 60
        return "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
    }
}

