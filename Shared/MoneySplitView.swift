//
//  MoneySplitView.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 9/27/22.
//

import SwiftUI

import RentSplitTools
import RectangleTools



struct MoneySplitView: View {
    
    @Environment(\.editMode)
    var editMode
    
    @Binding
    var moneySplitter: MoneySplitter
    
    
    var body: some View {
        List {
            Section {
                ForEach(moneySplitter.roommates) { roommate in
                    NavigationLink {
                        Form(content: {
                            TextField("Name", text: .init(
                                get: { moneySplitter.getOrGenerateName(of: roommate) },
                                set: { moneySplitter.set(\.name, of: roommate, to: $0) }))
                            
                            switch roommate.funding {
                            case .income(let incomeRate):
                                TextField("Funds",
                                          value: .init(
                                            get: { incomeRate.money },
                                            set: { moneySplitter.set(
                                                \.funding,
                                                 ofRoommateWithId: roommate.id,
                                                 to: .income($0 / incomeRate.time)) }),
                                          formatter: NumberFormatter.currency())
                                
                            case .benefactor(id: _, weight: _):
                                Text("Benefactors are not yet")
                            }
                        })
                        .navigationTitle(moneySplitter.getOrGenerateName(of: roommate))
                    } label: {
                        HStack(alignment: .firstTextBaseline) {
                            Text(moneySplitter.getOrGenerateName(of: roommate))
                            Text(moneySplitter.fundingDescription(for: roommate))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    moneySplitter.roommates.remove(atOffsets: indexSet)
                }
                .onMove { indices, newOffset in
                    moneySplitter.roommates.move(fromOffsets: indices, toOffset: newOffset)
                }
            } header: {
                Text("Roommates")
            } footer: {
                HStack {
                    Spacer()
                    
                    editOnlyButton {
                        moneySplitter.add(person: .init(),
                                          asRoommate: .init(funding: .default))
                    } label: {
                        Label("Add a roommate", systemImage: "plus")
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            if !moneySplitter.benefactors.isEmpty {
                Section("Benefactors") {
                    ForEach(moneySplitter.benefactors) { benefactor in
                        NavigationLink {
                            Form(content: {
                                TextField("Name", text: .init(
                                    get: { moneySplitter.getOrGenerateName(of: benefactor) },
                                    set: { moneySplitter.set(\.name, of: benefactor, to: $0) }))
                                
                                TextField("Contribution", value: .init(
                                    get: { benefactor.contribution.money },
                                    set: { moneySplitter.set(\.contribution.money, ofBenefactorWithId: benefactor.id, to: $0) }),
                                          formatter: NumberFormatter.currency())
                            })
                            .navigationTitle(moneySplitter.getOrGenerateName(of: benefactor))
                        } label: {
                            HStack(alignment: .firstTextBaseline) {
                                Text(moneySplitter.getOrGenerateName(of: benefactor))
                                Text(moneySplitter.fundingDescription(for: benefactor))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            
            Section {
                Text("Expenses")
            } content: {
                ForEach(moneySplitter.expenses) { expense in
                    NavigationLink {
                        Form(content: {
                            Section {
                                TextField("Name", text: .init(
                                    get: { expense.name },
                                    set: { moneySplitter.set(\.name, of: expense, to: $0) }))
                                
                                TextField("Value", value: .init(
                                    get: { expense.rate.money },
                                    set: { moneySplitter.set(\Expense.rate.money, of: expense, to: $0) }),
                                          formatter: NumberFormatter.currency())
                            } footer: {
                                Text("Expenses total: \(moneySplitter.expensesTotal, format: FloatingPointFormatStyle.Currency(code: "USD"))")
                            }
                        })
                        .navigationTitle(expense.name)
                    } label: {
                        HStack(alignment: .firstTextBaseline) {
                            Text(expense.rate.description)
                            Text(expense.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    moneySplitter.expenses.remove(atOffsets: indexSet)
                }
                .onMove { indices, newOffset in
                    moneySplitter.expenses.move(fromOffsets: indices, toOffset: newOffset)
                }
            } footer: {
                HStack {
                    Text("Total: \(moneySplitter.expensesTotal, format: FloatingPointFormatStyle.Currency(code: "USD"))")
                    
                    Spacer()
                    
                    editOnlyButton {
                        moneySplitter.addNewExpense()
                    } label: {
                        Label("Add an expense", systemImage: "plus")
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            Divider()
                .listRowBackground(Color.clear)
            
            Section("Split") {
                ForEach(moneySplitter.split.shares) { share in
//                    Text(share.person.name)
                    Text("\(share.person.name) owes \(share.expenseSum.description)")
                }
            }
        }
        .toolbar(content: EditButton.init)
    }
}



private extension MoneySplitView {
    @ViewBuilder
    func editOnlyButton<Label: View>(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) -> some View {
        switch editMode?.wrappedValue {
        case .active,
                .transient:
                Button(action: action, label: label)
            
        case .inactive,
                .none:
            EmptyView()
            
        @unknown default:
            EmptyView()
        }
    }
}



extension MoneySplitView {
    typealias OnModification<Subject, Field> = (Modification<Subject, Field>) -> Void
    
    
    
    struct Modification<Subject, Field> {
        let field: WritableKeyPath<Subject, Field>
        let subject: Subject
        let newValue: Field
    }
}



struct MoneySplitView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
            .environment(\.editMode, .constant(.active))
    }
    
    
    
    struct Preview: View {
        
        @State
        var moneySplitter = MoneySplitter()
        
        var body: some View {
            NavigationView {
                MoneySplitView(moneySplitter: $moneySplitter)
            }
        }
    }
}
