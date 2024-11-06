//
//  GroceryItemModel.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 8/9/24.
//

import Foundation

struct GroceryItemStruct:Identifiable, Hashable {
    
    var id:UUID = UUID()
    
    var name:String
    var category:String
    
    var isCustomItem:Bool = false
    
}


