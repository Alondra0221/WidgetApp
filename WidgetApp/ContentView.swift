//
//  ContentView.swift
//  WidgetApp
//
//  Created by Alondra García Morales on 24/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("How Are you?")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
