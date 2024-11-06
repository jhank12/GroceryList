//
//  GroceryCategoriesView.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 8/5/24.
//

import SwiftUI

struct GroceryCategoriesView: View {
    
    @EnvironmentObject var groceryVM: GroceryViewModel
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 105))
    ]
    
    var inPreviewList:Bool = false
    
    var listEntity:ListEntity?
    
    var body: some View {
        
        
        
        LazyVGrid(columns: adaptiveColumns, spacing: 15) {
            
            ForEach(groceryVM.groceryCategories, id: \.self) { category in
                NavigationLink {
                    
                    CategoryView(category:category, categoryArr: groceryVM.groceryItems[category] ?? [], inPreviewList: inPreviewList, listEntity:listEntity)
                    
                } label: {
                    
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 105, height: 105)
                                .foregroundColor(Color("Gray_Secondary"))
                            
//                            Image(uiImage: (UIImage(named: groceryVM.categoryIcons[category] ?? "")))
                            
                            if let catIcon = UIImage(named:groceryVM.categoryIcons[category] ?? "") {
                                Image(uiImage: catIcon)
                                    .scaleEffect(0.4)
                                    .frame(width: 60)
                                    .frame(height: 60)
                            }
     
                        }
                        
                        
                        Text("\(category)")
                            .foregroundColor(Color("Font_Dark"))
                            .fontWeight(.regular)
                        
                        
                        Spacer()
                        
                    }
                }
            }
        }
        
    }
    
}


//#Preview {
//    GroceryCategoriesView()
//}
