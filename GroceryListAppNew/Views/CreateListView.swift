//
//  CreateListView.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 7/22/24.
//

import SwiftUI

struct CreateListView: View {
    
    @EnvironmentObject var userListsVM:UserListsViewModel
    @EnvironmentObject var groceryVM:GroceryViewModel
    
    
    @State var previewListOpen:Bool = false
    @State var createListAlert = false
    
    @State var searchText:String = ""
    
    @EnvironmentObject var router:Router
    
    //    @Binding var path: NavigationPath
    
    @Binding var newListOptionsBool:Bool
    
    @State var confirmationSheetOpen:Bool = false
    
    
    @State var listName:String = ""
    
    
    var body: some View {
        //        NavigationStack {
        ZStack {
            Color("Gray_Main").ignoresSafeArea()
            
            VStack {
                
                
                GroceryCategoriesView(inPreviewList: true, listEntity: nil)
                
                Spacer()
                
                Button {
                    if !userListsVM.previewList.isEmpty {
                        
                        confirmationSheetOpen = true
                       
                    } else {
                        createListAlert = true
                    }
                    
                } label: {
                    MainButton(text: "Create List")
                }
                
            }
            .padding()
            .toolbar {
                ToolbarItem {
                    Button("Show Preview") {
                        previewListOpen = true
                    }
                }
            }
            .sheet(isPresented: $previewListOpen) {
                ListPreviewSheet(previewListOpen:$previewListOpen)
            }
            .sheet(isPresented: $confirmationSheetOpen) {
                
                ConfirmationSheet(confirmationSheetOpen: $confirmationSheetOpen, newListOptionsBool: $newListOptionsBool)
                
                
                
            }
            .alert("Your list is currently empty", isPresented: $createListAlert) {
                Button("Cancel", role: .cancel) {
                    createListAlert = false
                }
            }
            
        }
        .navigationTitle("Create List")
        //        }
    }
}

//#Preview {
//    CreateListView()
//        .environmentObject(UserListsViewModel())
//        .environmentObject(GroceryViewModel())
//}

struct ListPreviewSheet: View {
    
    @EnvironmentObject var userListsVM: UserListsViewModel
    
    @EnvironmentObject var groceryVM:GroceryViewModel
    
    @Binding var previewListOpen:Bool
    
    @State var previewAlertOpen:Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Gray_Main").ignoresSafeArea()
                
                VStack {
                    Spacer()
                    if !userListsVM.previewList.isEmpty {
                        List(groceryVM.groceryCategories, id: \.self) { category in
                            
                            if userListsVM.previewList[category]?.count ?? 0  > 0 {
                                Section {
                                    CategoryItems(items: userListsVM.previewList[category] ?? [])
                                } header: {
                                    HStack {
                                        Text("\(category)")
                                            .foregroundStyle(Color("Font_Darker"))
                                        Spacer()
                                    }
                                }
                            }
                            
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.insetGrouped)
                        
                        Button("Clear List") {
                            previewAlertOpen = true
                        }
                    } else {
                        Text("Your list is currently empty")
                            .foregroundStyle(Color("Font_Darker"))
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                    }
                    
                }
                .toolbar {
                    ToolbarItem {
                        Button("Close") {
                            previewListOpen = false
                        }
                    }
                }
                .alert("Warning. This action cannot be undone.", isPresented: $previewAlertOpen) {
                    Button ("Cancel", role: .cancel) {
                        previewAlertOpen = false
                    }
                    
                    Button ("Delete", role: .destructive) {
                        userListsVM.clearList()
                        previewListOpen = false
                    }
                }
                
            }
            .navigationTitle("List Preview")
            
        }
    }
}

struct CategoryItems: View {
    
    @EnvironmentObject var userListsVM:UserListsViewModel
    
    var items: [ListItem]
    
    @State var selectedItem:ListItem?
    
    var body: some View {
        ForEach(items, id: \.self) { item in
            HStack {
                
                
                Text("\(item.itemName)")
                
                
                Spacer()
                
                HStack (spacing: 0) {
                    if item.unit == "x" {
                        Text("\( item.unit)\(item.quantity.formatted())")
                    } else {
                        Text("\(item.quantity.formatted())\( item.unit)")
                        
                    }
                    
                }
            }
            .padding([.top, .bottom])
            .padding([.leading, .trailing], 5)
            .foregroundStyle(Color("Font_Dark"))
            .listRowBackground(Color("Gray_Secondary"))
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(action: {
                    
                    userListsVM.deleteItem(item:item, isPreviewList: true, listId:nil)
                    
                }, label: {
                    Image(systemName: "trash.fill")
                })
                .tint(.red)
                
                
                Button (action: {
                    
                    selectedItem = item
                    
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 72))
                })
                .tint(.yellow)
            }
        }
        .sheet(item: $selectedItem) { item in
            EditItemSheet(item:item, isPreviewList: true)
        }
        
    }
}




struct ConfirmationSheet: View {
    
    @EnvironmentObject var groceryVM:GroceryViewModel
    @EnvironmentObject var userListsVM:UserListsViewModel
    
    @State var listName:String = ""
    
    @Binding var confirmationSheetOpen:Bool
    
    @Binding var newListOptionsBool:Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Gray_Main").ignoresSafeArea()
                
                
                VStack {
                    VStack(spacing: 55) {
                        
                        HStack {
                            Section {
                                TextField("", text: $listName)
                                    .padding()
                                    .foregroundStyle(Color("Font_Dark"))
                                    .background(Color("Gray_Secondary"))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .keyboardType(.default)
                                
                                
                            } header: {
                                HStack {
                                    Text("List Name")
                                        .foregroundStyle(Color("Font_Darker"))
                                    Spacer()
                                }
                            }
                        }
                        .padding([.leading, .trailing], 20)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("Your List")
                                .padding([.leading], 20)
                                .fontWeight(.semibold)
                                .font(.system(size: 24))
                                .foregroundStyle(Color("Font_Secondary"))
                            
                            List(groceryVM.groceryCategories, id: \.self) { category in
                                
                                if userListsVM.previewList[category]?.count ?? 0  > 0 {
                                    Section {
                                        CategoryItems(items: userListsVM.previewList[category] ?? [])
                                    } header: {
                                        HStack {
                                            Text("\(category)")
                                                .foregroundStyle(Color("Font_Darker"))
                                            Spacer()
                                        }
                                    }
                                }
                                
                            }
                            .scrollContentBackground(.hidden)
                            .listStyle(.insetGrouped)
                        }
                    }
                    .padding([.top], 25)
                    
                    Spacer()
                    
                    if !listName.isEmpty {
                        Button {
                            confirmationSheetOpen = false
                            newListOptionsBool = false
                            userListsVM.createList(listName: listName)
                        } label: {
                            MainButton(text: "Confirm List")
                                .padding([.leading, .trailing], 20)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button("Cancel") {
                            confirmationSheetOpen = false
                        }
                    }
                }
                
                
                
                
            }
            .navigationTitle("Confirm List")
            
        }
    }
}
