//
//  MyWidgetBundle.swift
//  MyWidget
//
//  Created by Alondra García Morales on 25/10/23.
//

import WidgetKit
import SwiftUI

@main
struct MyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyWidget()
        MyWidgetLiveActivity()
    }
}
