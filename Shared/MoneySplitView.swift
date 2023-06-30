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
    
    @Binding
    var moneySplitter: MoneySplitter
    
    
    var body: some View {
        List {
            Section("Roommates") {
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
            } footer: {
                Text("Total: \(moneySplitter.expensesTotal, format: FloatingPointFormatStyle.Currency(code: "USD"))")
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
