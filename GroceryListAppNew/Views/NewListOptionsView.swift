//
//  NewListOptionsView.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 7/22/24.
//

import SwiftUI


struct NewListOptionsView: View {
    
//    @Binding var path:NavigationPath
    @EnvironmentObject var router:Router
    
    @Binding var newListOptionsBool:Bool

    var body: some View {
//        NavigationStack {
            ZStack {
                Color("Gray_Main").ignoresSafeArea()
                VStack (spacing: 10) {
                    
                    NavigationLink (destination: CreateListView(newListOptionsBool:$newListOptionsBool)) {
                        NewListOptionLink(linkText: "Create New List")
                    }
                    
                    NavigationLink (destination: SavedListsView(newListOptionsBool:$newListOptionsBool)) {
                        NewListOptionLink(linkText: "Use Saved List")
                    }
                                        
                    Spacer()

                }
                .frame(maxWidth: .infinity)
                .padding()
                
            }
            .navigationTitle("New List Options")
//        }
    }
}

//#Preview {
//    NewListOptionsView()
//        .environmentObject(GroceryViewModel())
//}

struct NewListOptionLink: View {
    
//    var destination:any View
    
    var linkText:String
    
    var body: some View {
//        NavigationLink (destination: destination) {
            HStack {
                Text("\(linkText)")
                    .foregroundStyle(Color("Font_Dark"))
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 65)
            .padding([.leading, .trailing], 20)
            .background(Color("Gray_Secondary"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
//        }
    }
}
