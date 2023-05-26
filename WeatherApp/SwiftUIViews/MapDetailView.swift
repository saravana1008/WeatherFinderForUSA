//
//  MapDetailView.swift
//  WeatherApp
//
//  Created by Saravanakumar Balasubramanian on 25/05/23.
//

import SwiftUI
import MapKit


class MapViewEnvironmentObject: ObservableObject {
    @Published var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion()
}

struct MapDetailView: View {
    
    @EnvironmentObject var coordinate: MapViewEnvironmentObject
    
    var body: some View {
        GeometryReader { geometryProxy in
            Map(coordinateRegion: $coordinate.coordinateRegion)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .navigationTitle("Map Detail")
        }
    }
}

struct MapDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MapDetailView()
    }
}
