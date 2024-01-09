//
//  MoneySplitView.swift
//  Rent Split
//
//  Created by The Northstar✨ System on 9/27/22.
//

import SwiftUI

import AppUniqueIdentifier
import CollectionTools
import RentSplitTools
import RectangleTools



struct MoneySplitView: View {
    
    @Environment(\.editMode)
    var editMode
    
    @Binding
    var moneySplitter: MoneySplitter
    
    @State
    private var showNewBenefactorSelectionSheet: Bool = false
    
    
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
                .deleteDisabled(moneySplitter.roommates.count <= 2)
            } header: {
                Text("Roommates")
            } footer: {
                HStack {
                    Spacer()
                    
                    editOnlyButton {
                        moneySplitter.add(person: .init(color: .auto(numberOfExistingPeople: moneySplitter.people.count)),
                                          asRoommate: .init(funding: .default))
                    } label: {
                        Label("Add a roommate", systemImage: "plus")
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            if !moneySplitter.benefactors.isEmpty {
                Section {
                    Text("Benefactors")
                } content: {
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
                            .navigationTitle("Edit Benefactor")
                        } label: {
                            HStack(alignment: .firstTextBaseline) {
                                Text(moneySplitter.getOrGenerateName(of: benefactor))
                                Text(moneySplitter.fundingDescription(for: benefactor))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        moneySplitter.benefactors.remove(atOffsets: indexSet)
                    }
                    .onMove { indices, newOffset in
                        moneySplitter.benefactors.move(fromOffsets: indices, toOffset: newOffset)
                    }
                } footer: {
                    add(a: "benefactor") {
                        showNewBenefactorSelectionSheet = true
                    }
                }
            }
            else {
                editOnlyButton {
                    showNewBenefactorSelectionSheet = true
                } label: {
                    Label("Add a benefactor", systemImage: "plus")
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
                .deleteDisabled(moneySplitter.expenses.count <= 1)
            } footer: {
                add(a: "expense") {
                    moneySplitter.addNewExpense()
                } leadingView: {
                    Text("Total: \(moneySplitter.expensesTotal, format: FloatingPointFormatStyle.Currency(code: "USD"))")
                }
            }
            
            Divider()
                .listRowBackground(Color.clear)
            
            Section("Split") {
                MoneySplitChart(split: moneySplitter)
                    .frame(height: 200)
//                ForEach(moneySplitter.split.shares) { share in
////                    Text(share.person.name)
//                    Text("\(share.person.name) owes \(share.expenseSum.description)")
//                }
            }
            .listStyle(.plain)
            .background(.clear)
        }
        
        .toolbar(content: EditButton.init)
        
        .sheet(isPresented: $showNewBenefactorSelectionSheet) {
            List(NewBenefactor.allCases(existingPeople: moneySplitter.people)) { newBenefactor2 in
                Button {
                    let selectedPerson: Person
                    switch newBenefactor2 {
                    case .existingPerson(let person):
                        selectedPerson = person
                        
                    case .newPerson:
                        selectedPerson = .init(color: .auto(for: moneySplitter))
                    }
                    
                    moneySplitter.add(
                        person: selectedPerson,
                        asBenefactor: .init())
                    
                    showNewBenefactorSelectionSheet = false
                } label: {
                    switch newBenefactor2 {
                    case .newPerson:
                        Label("New person", systemImage: "plus")
                        
                    case .existingPerson(let person):
                        Text(person.name)
                    }
                }
            }
            .presentationDetents([.fraction(0.4)])
            .overlay {
                VStack {
                    Rectangle().fill(Color.red)
                        .frame(width: 50, height: 8, alignment: .top)
                        .padding(.top, 8)
                    
                    Spacer(minLength: 0)
                }
            }
        }
    }
}



private extension MoneySplitView {
    
    func add<LeadingView: View>(
        a itemName: LocalizedStringKey,
        action: @escaping () -> Void,
        leadingView: @escaping () -> LeadingView)
    -> some View {
        HStack(alignment: .top) {
            leadingView()
            
            Spacer()
            
            editOnlyButton {
                action()
            } label: {
                Label("Add an \(Text(itemName))", systemImage: "plus")
                    .foregroundStyle(.primary)
            }
            .buttonStyle(.bordered)
        }
    }
    
    
    func add(a itemName: LocalizedStringKey, action: @escaping () -> Void) -> some View {
        add(a: itemName, action: action, leadingView: EmptyView.init)
    }
    
    
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
    
    
    enum NewBenefactor: Identifiable, Hashable {
        case existingPerson(Person)
        case newPerson
        
        
        var id: Person.ID {
            switch self {
            case .existingPerson(let person):
                return person.id
                
            case .newPerson:
                return .privateUse(offset: 0)
            }
        }
        
        
        static func allCases(existingPeople: [Person]) -> [Self] {
            existingPeople.map { .existingPerson($0) }
            + .newPerson
        }
        
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .existingPerson(let person):
                hasher.combine(person.id)
                
            case .newPerson:
                hasher.combine(AppUniqueIdentifier.newPerson)
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
            .environment(\.editMode, .constant(.active))
    }
    
    
    
    struct Preview: View {
        
        @State
        var moneySplitter = MoneySplitter.demo
        
        var body: some View {
            NavigationView {
                MoneySplitView(moneySplitter: $moneySplitter)
            }
        }
    }
}
