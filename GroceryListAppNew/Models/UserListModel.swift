//
//  UserListModel.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 7/25/24.
//

import Foundation


struct UserList: Identifiable {
    var id: UUID = UUID()
    var date:Date = .now
    
    var listName:String
    
//    var listItems:[ListItem]
    var listItems:[String: [ListItem]]
    
    
}
