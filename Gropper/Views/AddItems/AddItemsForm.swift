//
//  AddItemsForm.swift
//  Gropper
//
//  Created by Bryce King on 9/17/25.
//

import SwiftUI

struct AddItemsForm: View {
    let tripId: String
    let host: String
    
    @StateObject var viewModel = AddItemsViewModel()
    
    var onFormSubmit: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Section(header: Text("What Do You need?")){
            if (viewModel.items.count > 0) {
                ForEach($viewModel.items){$item in
                    VStack{
                        TextField("Item Name", text: $item.itemName)
                        Divider()
                        TextField("Item Description", text: $item.itemDescription)
                    }
                    .padding()
                }
                .onDelete{ indexSet in
                    viewModel.items.remove(atOffsets: indexSet)
                }
                
            } else{
                Section{
                    Text("No Items")
                }
            }
            Button("Add Item"){
                viewModel.items.append(ItemInfo())
            }
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button("Submit"){
                        Task{
                            viewModel.addItems(trip: tripId, tripHost: host)
                        }
                    }
                    .disabled(!canSubmit)
                    .onChange(of: viewModel.successfullyAdded) {
                        if viewModel.successfullyAdded{
                            onFormSubmit()
                            dismiss()
                        }
                    }
                }
            }
            
        }
    }
    var canSubmit: Bool {
        viewModel.items.allSatisfy({!$0.itemName.trimmingCharacters(in: .whitespaces).isEmpty})
    }
}



//#Preview {
//    AddItemsForm()
//}
