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
    var onFormSubmit: () -> Void
    
    @StateObject var viewModel = AddItemsViewModel()
    @State private var addItems: ApiResponse = ApiResponse(status200: true, message: nil)
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
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
                        if viewModel.items.count > 1 {
                            viewModel.items.remove(atOffsets: indexSet)
                        }
                    }
                    Button("Add Item"){
                        viewModel.items.append(ItemInfo())
                    }
                } else {
                    Section {
                        Text("No items added")
                    }
                }
                if (addItems.status200 == false) {
                    Text(addItems.message ?? "Error Adding Items")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                Button("Submit"){
                    Task{
                       addItems = try await viewModel.addItems(trip: tripId, tripHost: host)
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
    var canSubmit: Bool {
        viewModel.items.allSatisfy({!$0.itemName.trimmingCharacters(in: .whitespaces).isEmpty})
    }
}



//#Preview {
//    AddItemsForm()
//}
