//
//  GroceryListAppNewApp.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 7/22/24.
//

import SwiftUI

@main
struct GroceryListAppNewApp: App {
    
    @StateObject var userListsVM = UserListsViewModel()
    @StateObject var groceryVM = GroceryViewModel()
    @StateObject var router = Router()
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(groceryVM)
                .environmentObject(router)
                .environmentObject(userListsVM)
                .environment(\.managedObjectContext, userListsVM.container.viewContext)
        }
    }
}
