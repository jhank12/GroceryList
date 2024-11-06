//
//  Router.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 8/16/24.
//

import Foundation
import SwiftUI

class Router:ObservableObject {
    
    @Published var path = NavigationPath()
    
    func resetPath() {
        path = NavigationPath()
    }
    
}
