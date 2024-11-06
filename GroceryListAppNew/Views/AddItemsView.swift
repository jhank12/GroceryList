//
//  AddItemsView.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 8/5/24.
//

import SwiftUI

struct AddItemsView: View {
    
    var listEntity:ListEntity
    
    
    var body: some View {
        
//        NavigationStack {
            
            ZStack {
                Color("Gray_Main").ignoresSafeArea()
                
                VStack {
                    GroceryCategoriesView(listEntity: listEntity)
                    
                    Spacer()
                    
                    
                }
                .padding()
            }
            .navigationTitle("Add More Items")
            
//        }
    }
}

//#Preview {
//    AddItemsView()
//}
