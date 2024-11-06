//
//  SavedListsView.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 7/22/24.
//

import SwiftUI

struct SavedListsView: View {
    
    @EnvironmentObject var userListsVM:UserListsViewModel
    
//    @Binding var path: NavigationPath
    
    @Binding var newListOptionsBool:Bool
    
    
    
    var body: some View {
//        NavigationStack {
            ZStack {
                Color("Gray_Main").ignoresSafeArea()
                
                ScrollView {
                    Spacer().frame(height: 30)
                    VStack (spacing: 35) {
                        ForEach(userListsVM.savedLists.sorted{$0.date ?? .now > $1.date ?? .now}) { savedList in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(savedList.date ?? .now, format: .dateTime.day().month(.wide).year())
                                    .fontWeight(.medium)
                                    .font(.system(size: 22))
                                    .foregroundStyle(Color("Font_Secondary"))
                                NavigationLink(destination: SavedListView(savedList: savedList, list: savedList.savedCategories?.allObjects as? [SavedCategoryEntity] ?? [], newListOptionsBool:$newListOptionsBool)) {

                                    
                                    HStack {
                                        
                                        VStack {
                                            HStack {
                                                
                                                VStack (alignment: .leading, spacing: 2)  {
                                                    Text("\(savedList.listName ?? "")")
                                                        .foregroundStyle(Color("Font_Dark"))
                                                        .font(.system(size: 18))
                                                    
                                                }
                                                
                                                Spacer()
                                                
                                            }
                                        }
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 65)
                                    .padding([.leading, .trailing], 20)
                                    .background(Color("Gray_Secondary"))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            }
                            
                            
                        }
                    }
                    
                    
                }
                .padding()
                
            }
            .navigationTitle("Saved Lists")
    }
}


struct SavedListView: View {
    
    @EnvironmentObject var userListsVM:UserListsViewModel
    
    var savedList:SavedListEntity
    
    var list:[SavedCategoryEntity]
    
    @EnvironmentObject var router:Router
    
    @Binding var newListOptionsBool:Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var savedListOptionsOpen:Bool = false
    
    
    var body: some View {
//        NavigationStack {
            ZStack {
                Color("Gray_Main").ignoresSafeArea()
                
                VStack {
                    
                    List(list.sorted{$0.date ?? .now < $1.date ?? .now}, id: \.self) { catList in

                        if let categoryList = catList.savedItems?.allObjects as? [SavedListItemEntity] {
                            Section {
                                ForEach(categoryList.sorted{$0.date ?? .now < $1.date ?? .now}, id: \.self) { item in
                                    HStack {
                                        
                                        HStack (spacing: 15) {
                                            Button {
//                                                userListVM.toggleChecked(listId: userListId, item:item)
                                            } label: {
                                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                                    .font(.system(size: 20))
                                                    .foregroundStyle(Color("Purple_Main"))
                                            }
                                            
                                            if let itemName = item.itemName {
                                                Text("\(itemName)")
                                            }
                                            
                                        }
                                        
                                        
                                        Spacer()
                                        
                                        HStack (spacing: 0) {
                                            if let itemUnit = item.unit {
                                                if itemUnit == "x" {
                                                    Text("\(itemUnit)\(item.quantity.formatted())")
                                                } else {
                                                    Text("\(item.quantity.formatted())\(itemUnit)")
                                                    
                                                }
                                            }
                                            
                                            
                                        }
                                    }
                                    .padding([.top, .bottom])
                                    .padding([.leading, .trailing], 5)
                                    .foregroundStyle(item.isChecked ? Color("Font_Darker") : Color("Font_Dark"))
                                    .listRowBackground(Color("Gray_Secondary"))
                                    .strikethrough(item.isChecked, color: Color("Font_Darker"))
                                }
                                .listStyle(.insetGrouped)
                            } header: {
                                if let category = catList.category {
                                    HStack {
                                        Text("\(category)")
                                            .foregroundStyle(Color("Font_Darker"))
                                        Spacer()
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    .scrollContentBackground(.hidden)
                    
                    
                    Spacer()
                    
                    Button {
                        userListsVM.createListFromSaved(listEntity: savedList)
                        newListOptionsBool = false
//                        router.resetPath()
                    } label: {
                        MainButton(text: "Use List")
                            .padding()
                    }
                    
                }
                .toolbar {
                    ToolbarItem {
                        Button("Options") {
                            savedListOptionsOpen = true
                        }
                    }
                }
                .sheet(isPresented: $savedListOptionsOpen) {
                    
                    NavigationStack {
                        ZStack {
                            
                            Color("Gray_Main").ignoresSafeArea()
                            
                            VStack {
                                Spacer().frame(height: 35)
                                Button {
                                    userListsVM.deleteSavedList(savedListEntity: savedList)
                                    
                                    savedListOptionsOpen = false
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                } label: {
                                    VStack(spacing:10) {
                                        ZStack {
                                            Circle()
                                                .frame(maxWidth: 70)
                                                .foregroundStyle(.red)
                                            Image(systemName: "trash.fill")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 26))
                                        }
                                        
                                        Text("Delete List")
                                            .font(.system(size: 15))
                                    }
                                    .foregroundStyle(Color("Font_Darker"))
                                }
                                
                            }
                            
                        }
                        
                    }
                    .presentationDetents([.fraction(0.2)])
                    .presentationDragIndicator(.visible)
                }
                
                
            }
            .navigationTitle(savedList.listName ?? "")
    }
}
