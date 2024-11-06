//
//  ListView.swift
//  GroceryListAppNew
//
//  Created by Joshua Hankins on 7/22/24.
//

import SwiftUI



struct ListView: View {
    
    
    var userListId:UUID
    
    @EnvironmentObject var userListsVM:UserListsViewModel
    @EnvironmentObject var groceryVM:GroceryViewModel
    @EnvironmentObject var router:Router
    
    @ObservedObject var userList:ListEntity
    
    @State var listOptionsOpen: Bool = false
    
    @State var addItemsViewOpen:Bool = false
    
    var body: some View {
        ZStack {
            Color("Gray_Main").ignoresSafeArea()
            
            
            VStack {
                
                if userList.category?.count ?? 0 > 0 {
                    
                    
                    if let catArr = userList.category?.allObjects as? [CategoryEntity] {
                        List(catArr.sorted{$0.date ?? .now < $1.date ?? .now}, id: \.self) { catList in
                            
                            
                            
                            if let categoryList = catList.listItems?.allObjects as? [ListItemEntity] {
                                Section {
                                    
                                    ForEach(categoryList.sorted{$0.date ?? .now < $1.date ?? .now}, id: \.self) { item in
                                        ListItemView(userListId: userListId, item: item)
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
                    }
                    
                    
                    
                }
                else {
                    Spacer()
                    Text("Your list is currently empty")
                        .foregroundStyle(Color("Font_Darker"))
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                    
                    Spacer()
                }
                
                NavigationLink(destination: AddItemsView(listEntity: userList)) {
                    MainButton(text: userList.category?.count ?? 0 < 1 ? "Add Items" : "Add More Items")
                }
                .padding( 20)

            }
            .padding([.top], 20)
            .toolbar {
                ToolbarItem {
                    Button {
                        listOptionsOpen = true
                    } label: {
                        Text("Options")
                        
                    }
                }
            }
            .sheet(isPresented: $listOptionsOpen) {
                ListOptionsSheet(userList: userList, listOptionsOpen:$listOptionsOpen)
                    
                    
            }
            
        }
        .navigationTitle("\(userList.listName ?? "")")
    }
    
    
    
}


//
//#Preview {
//    ListView()
//}


struct ListOptionsSheet: View {
    
    @EnvironmentObject var userListVM:UserListsViewModel
    
    var userList:ListEntity
    
    //    @Binding var path:NavigationPath
    @Binding var listOptionsOpen:Bool
    
    
    @EnvironmentObject var router:Router
    
    @State var newListName:String = ""
    
    @State var updateNameSheetOpen:Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Gray_Main").ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 35)
                    HStack (spacing: 20) {
                        Button {
                            listOptionsOpen = false
                            userListVM.saveList(listEntity: userList)
                        } label: {
                            VStack(spacing:10) {
                                ZStack {
                                    Circle()
                                        .frame(maxWidth: 70)
                                        .foregroundStyle(.green)
                                    Image(systemName: "square.and.arrow.down")
                                        .padding([.bottom], 2)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 26))
                                }
                                
                                Text("Save List")
                                    .font(.system(size: 15))
                            }
                            .foregroundStyle(Color("Font_Darker"))
                        }
                        
                        Button {
                            
                            updateNameSheetOpen = true
                            
                        } label: {
                            VStack(spacing:10) {
                                ZStack {
                                    Circle()
                                        .frame(maxWidth: 70)
                                        .foregroundStyle(.yellow)
                                    Image(systemName: "square.and.pencil")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 26))
                                }
                                
                                Text("Update List Name")
                                    .font(.system(size: 15))
                            }
                            .foregroundStyle(Color("Font_Darker"))
                        }
                        
                        
                        Button {
                            userListVM.deleteList(listEntity: userList)
                            
                            listOptionsOpen = false
                            
                            router.resetPath()
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
                .sheet(isPresented: $updateNameSheetOpen) {
                    NavigationStack {
                        ZStack {
                            Color("Gray_Main").ignoresSafeArea()
                            
                            VStack {
                                HStack {
                                    Section {
                                        TextField("", text: $newListName)
                                            .padding()
                                            .foregroundStyle(Color("Font_Dark"))
                                            .background(Color("Gray_Secondary"))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .keyboardType(.default)
                                        
                                        
                                    } header: {
                                        HStack {
                                            Text("Updated Name")
                                                .foregroundStyle(Color("Font_Darker"))
                                            Spacer()
                                        }
                                    }
                                }
                                
                                
                                Spacer()
                                
                                if !newListName.isEmpty && newListName != userList.listName {
                                    Button {
                                        
                                        updateNameSheetOpen = false
                                        listOptionsOpen = false
                                        userListVM.updateListName(newListName: newListName, listEntity: userList)
                                    } label: {
                                        MainButton(text: "Update Name")
                                    }
                                }
                                
                            }
                            .padding(18)
                            .toolbar {
                                ToolbarItem {
                                    Button("Cancel") {
                                        updateNameSheetOpen = false
                                    }
                                }
                            }
                        }
                        .navigationTitle("Update List Name")
                    }
//                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
                }
                
            }
            
        }
        .presentationDetents([.fraction(0.2)])
        .presentationDragIndicator(.visible)
    }
}

struct MainButton: View {
    
    var text:String
    
    var body: some View {
        VStack {
            Text(text)
        }
        
        .frame(maxWidth:.infinity)
        .frame(height: 60)
        .background(Color("Purple_Main"))
        .foregroundStyle(Color("Font_Main"))
        .fontWeight(.medium)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct ListItemView: View {
    
    @EnvironmentObject var userListVM:UserListsViewModel
    
    var userListId:UUID
    
    var item:ListItemEntity
    
    @State var selectedItem:ListItem?
    
    @State var itemEntity:ListItemEntity?
    
    var body: some View {
        HStack {
            
            HStack (spacing: 15) {
                Button {
                    userListVM.toggleChecked(listId: userListId, item:item)
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
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {     
            
            Button(action: {
            
            
            userListVM.deleteItemUserList(item: item)
        }, label: {
            Image(systemName: "trash.fill")
        })
        .tint(.red)
            
            
            Button (action: {
                
                selectedItem = ListItem(itemName: item.itemName ?? "", quantity: item.quantity, unit: item.unit ?? "", category: item.category ?? "")
                
            }, label: {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 72))
            })
            .tint(.yellow)
        }
        .sheet(item: $selectedItem) { listItem in
            
            EditItemSheet(item: listItem, itemEntity: item,userListId: userListId)
            
            
        }
    }
}
