//
//  LocationsViewModel.swift
//  SwiftUIMapApp
//
//  Created by Hakob Ghlijyan on 06.12.2023.
//

import SwiftUI
import MapKit

class LocationsViewModel: ObservableObject {
    
    // All loaded Location    
    @Published var locations: [Location]
    
    // Current location on map
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
        
    // Current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
    // Show list of locations
    @Published var showLocationsList: Bool = false
    
    // Show location detail via sheet
    @Published var sheetLocation: Location? = nil
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapRegion(location: locations.first!)
    }
    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {            
            mapRegion = MKCoordinateRegion(
                center: location.coordinates ,
                span: mapSpan)
        }
    }
    
    func toogleLocationList() {
        withAnimation(.easeInOut) {
//            showLocationsList = !showLocationsList
            showLocationsList.toggle()
        }
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }
    
    //Func For Button Next Logic
    func nextButtonPressed() {
        
        //1. Get current index location
        guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else {        // Proveryaem tekuchy index raven li pervomu je index u v masive
            print("Dont Find Location Index")
            return
        }
        
        //2. Check if the currentIndex is Valid
        let nextIndex = currentIndex + 1                                                          // Next budet plus 1 ot togo kotoriy bil
        guard locations.indices.contains(nextIndex) else {                                        // Proverka est li v location indices ax takoy index
            //Next index is not valid - restart from 0 index
            guard let firstLocation = locations.first else {
                print("First index not found")
                return
            }
            showNextLocation(location: firstLocation)                                             // VIzivaem Func pokazivauchiy sleduychyu location
            return
        }
        //3. Next index is Valid
        let nextLocation = locations[nextIndex]                                                   // sleduychaya location ravna po nexIndex index u
        showNextLocation(location: nextLocation)                                                  // i vizivaem func kororaya pokajet novuyu location
        
    }
    
    
}
