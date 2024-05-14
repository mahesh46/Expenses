//
//  ContentView.swift
//  Expenses
//
//  Created by mahesh lad on 08/05/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: true)],
        animation: .default)
     var expenses: FetchedResults<Expense>
    
    @State private var showingAddExpense = false
    @State private var selectedExpense: Expense?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses, id: \.self) { expense in
                    NavigationLink(destination: EditExpenseView( expense: expense)) {
                        ExpenseRow(expense: expense)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(PlainListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Expenses")
            .navigationBarItems(trailing: Button(action: {
                selectedExpense = nil
                showingAddExpense.toggle()
            }) {
                Image(systemName: "plus")
            })

            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(isPresented: $showingAddExpense, expense: selectedExpense)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Handle error
                print(error.localizedDescription)
            }
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
//#Preview {
//    ContentView()
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
