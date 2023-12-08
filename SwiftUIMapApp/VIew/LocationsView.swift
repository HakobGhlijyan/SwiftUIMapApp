//
//  LocationsView.swift
//  SwiftUIMapApp
//
//  Created by Hakob Ghlijyan on 06.12.2023.
//

import SwiftUI
import MapKit

struct LocationsView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    
    let maxWigthForIpad:CGFloat = 600
    
    var body: some View {
        ZStack {
            mapLayer
            .ignoresSafeArea()
            VStack(spacing: 0.0) {
                header
                    .padding()
                    .frame(maxWidth: maxWigthForIpad)
                Spacer()
                locationsPreviewLayer
            }
        }
        // Sheet prezent screen only one location , ispolzuya $vm.sheetLocation znachenie
        // a najav knopku learn more izmenim $vm.sheetLocation na to kotoroe vibrali
        .sheet(item: $vm.sheetLocation,
               onDismiss: nil) { location in
            LocationDetailView(location: location)
        }
    }
}

#Preview {
    LocationsView()
        .environmentObject(LocationsViewModel())
}

extension LocationsView {
    
    private var header: some View {
        VStack {
            
            Button(action: vm.toogleLocationList) {
                Text(vm.mapLocation.name + " , " + vm.mapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.locations)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(.degrees(vm.showLocationsList ? 180 : 0))
                    }
            }
            
            if vm.showLocationsList {
                LocationsListView()
            }
        }
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
 
    private var mapLayer: some View {
        Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations,
            annotationContent: { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                    .shadow(radius: 10)
                    .onTapGesture {
                        vm.showNextLocation(location: location)
                    }
            }
        })
    }
    
    private var locationsPreviewLayer: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                    .shadow(color: .black.opacity(0.2), radius: 10)
                    .padding()
                    .frame(maxWidth: maxWigthForIpad)
                    .frame(maxWidth: .infinity)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    )
                    )
                }
            }
        }
    }
}
