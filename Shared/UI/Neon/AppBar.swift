//
//  AppBar.swift
//  Rent Split (iOS)
//
//  Created by The Northstar✨ System on 2022-07-09.
//

import SwiftUI

import CollectionTools
import FunctionTools
import LazyContainers



public struct AppBar<Content: View, Title: View, Accessory: View>: View {
    
    @State
    private var size: Size = .thin
    
    @State
    private var __backupValue__showDrawer = false
    
    @Environment(\.appBarColor)
    private var color: Color
    
    var position: Position = .bottom
    
    private var __public__showDrawer: Binding<Bool>?

    @ViewBuilder
    let content: Generator<Content>
    
    @ViewBuilder
    let title: Generator<Title>
    
    @ViewBuilder
    let accessory: Generator<Accessory>
    
    @Lazy
    private var drawer: [NavigationDrawerItem]
    
    
    fileprivate init(
        position: Position = .bottom,
        showDrawer: Binding<Bool>?,
        @ViewBuilder content: @escaping Generator<Content>,
        @ViewBuilder title: @escaping Generator<Title>,
        @ViewBuilder accessory: @escaping Generator<Accessory>,
        _drawer: Lazy<[NavigationDrawerItem]>)
    {
        self.position = position
        self.__public__showDrawer = showDrawer
        self.content = content
        self.title = title
        self.accessory = accessory
        self._drawer = _drawer
    }
    
    
    init(
        position: Position = .bottom,
        showDrawer: Binding<Bool>? = nil,
        @ViewBuilder content: @escaping Generator<Content>,
        @ViewBuilder title: @escaping Generator<Title>,
        @ViewBuilder accessory: @escaping Generator<Accessory>,
        @ArrayBuilder<NavigationDrawerItem> drawer: @escaping Generator<[NavigationDrawerItem]> = {[]})
    {
        self.init(
            position: position,
            showDrawer: showDrawer,
            content: content,
            title: title,
            accessory: accessory,
            _drawer: .init(initializer: drawer)
        )
    }
    
    
    fileprivate var _$showDrawer: Binding<Bool> { __public__showDrawer ?? $__backupValue__showDrawer }
    fileprivate var showDrawer: Bool {
        get { __public__showDrawer?.wrappedValue ?? __backupValue__showDrawer }
        nonmutating set {
            __public__showDrawer?.wrappedValue = newValue
            __backupValue__showDrawer = newValue
        }
    }
    
    
    public var body: some View {
        ZStack {
            content()
                .bottomNavigationDrawer(isShowing: _$showDrawer, content: { drawer })
                .padding(position.contentPadding(forAppBarSize: size))
            
            position {
                let height = size.height
                
                ZStack {
                    let buttonSize = size.navDrawerButtonSize
                    
                    Rectangle()
                        .fill(color)
                        .ignoresSafeArea(edges: .all)
                        .frame(height: height)
                        .material(elevation: showDrawer ? 0 : 4)
                    
                    HStack {
                        justTheLabel_withOptionalNavButton(buttonSize: buttonSize)
                            .id("App Bar Title Button")
                            .animation(.spring, value: hasDrawer)
                            .frame(height: height)
                            .font(.title)
                        
                        Spacer(minLength: 0)
                        
                        accessoryView(height: height)
                            .id("App Bar Accessory View")
                            .animation(.spring, value: hasAccessory)
                            .frame(height: height)
                    }
                    .multilineTextAlignment(.leading)
                }
            }
        }
    }
    
    
    @ViewBuilder
    private func justTheLabel_withOptionalNavButton(buttonSize: CGSize) -> some View {
        Button {
            showDrawer.toggle()
        } label: {
            HStack(spacing: 0) {
                if hasDrawer {
                    Image(systemName: "line.3.horizontal")
                        .id("Nav Drawer Button")
                        .frame(minWidth: buttonSize.width, minHeight: buttonSize.height)
                        .transition(.move(edge: .leading).animation(.spring))
                }
                
                title()
                    .id("App Bar Title")
            }
        }
        .foregroundColor(.primary)
        .disabled(!hasDrawer)
    }
    
    
    @ViewBuilder
    private func accessoryView(height: CGFloat) -> some View {
        if hasAccessory {
            accessory()
                .id("App Bar Accessory")
                .transition(.move(edge: .trailing).animation(.spring))
        }
    }
}



// MARK: - Initializers

public extension AppBar {
    
    init(position: Position = .bottom,
         showDrawer: Binding<Bool>? = nil,
         @ViewBuilder content: @escaping Generator<Content>,
         @ViewBuilder title: @escaping Generator<Title>,
         @ArrayBuilder<NavigationDrawerItem> drawer: @escaping Generator<[NavigationDrawerItem]> = {[]})
    where Accessory == EmptyView
    {
        self.init(
            position: position,
            showDrawer: showDrawer,
            content: content,
            title: title,
            accessory: EmptyView.init,
            _drawer: .init(initializer: drawer)
        )
    }
    
    
    init(position: Position = .bottom,
         showDrawer: Binding<Bool>? = nil,
         @ViewBuilder content: @escaping Generator<Content>,
         @ViewBuilder accessory: @escaping Generator<Accessory>,
         @ArrayBuilder<NavigationDrawerItem> drawer: @escaping Generator<[NavigationDrawerItem]> = {[]})
    where Title == EmptyView
    {
        self.init(
            position: position,
            showDrawer: showDrawer,
            content: content,
            title: EmptyView.init,
            accessory: accessory,
            _drawer: .init(initializer: drawer)
        )
    }
    
    
    init(position: Position = .bottom,
         showDrawer: Binding<Bool>? = nil,
         @ViewBuilder content: @escaping Generator<Content>,
         @ArrayBuilder<NavigationDrawerItem> drawer: @escaping Generator<[NavigationDrawerItem]> = {[]})
    where Title == EmptyView,
        Accessory == EmptyView
    {
        self.init(
            position: position,
            showDrawer: showDrawer,
            content: content,
            title: EmptyView.init,
            accessory: EmptyView.init,
            _drawer: .init(initializer: drawer)
        )
    }
}



// MARK: - Subtypes

public extension AppBar {
    
    enum Position { // TODO: replace with ``VerticalEdge`` once all cases are supported
        case bottom
    }
    
    
    enum Size {
        case thin
    }
}



// MARK: - Private conveniences

private extension AppBar {
    /// Whether or not this app bar has a navigation drawer
    var hasDrawer: Bool {
        drawer.isNotEmpty
    }
    
    /// Whether or not this app bar has a navigation drawer
    var hasAccessory: Bool {
        Accessory.self != EmptyView.self
        && Accessory.self != Never.self
    }
}



private extension AppBar.Size {
    var height: CGFloat {
        switch self {
        case .thin: return 48
        }
    }
    
    
    var navDrawerButtonSize: CGSize {
        CGSize(width: height, height: height)
    }
}



private extension AppBar.Position {
    
    @ViewBuilder
    func callAsFunction<BuiltContent: View>(@ViewBuilder content: () -> BuiltContent) -> some View {
        switch self {
        case .bottom:
            VStack {
                Spacer(minLength: 0)
                
                content()
            }
        }
    }
}



private extension AppBar.Position {
    func contentPadding(forAppBarSize appBarSize: AppBar.Size) -> EdgeInsets {
        switch self {
        case .bottom: return .init(top: 0, leading: 0, bottom: appBarSize.height, trailing: 0)
        }
    }
}



// MARK: - Environment

private struct AppBarColorKey: SwiftUI.EnvironmentKey {
    static var defaultValue = Color.accentColor
}



private extension EnvironmentValues {
    
    var appBarColor: Color {
        get { self[AppBarColorKey.self] }
        set { self[AppBarColorKey.self] = newValue }
    }
}



public extension View {
    func appBar(color: Color) -> some View {
        environment(\.appBarColor, color)
    }
}



// MARK: - Previews

private struct SimpleTestPreview: View {
    
    @State
    var hasDrawer: Bool = true
    
    @State
    var hasAccessory: Bool = true
    
    var body: some View {
        if let accessory {
            AppBar(content: { content },
                   title: { title },
                   accessory: { accessory },
                   drawer: { drawer })
        }
        else {
            AppBar(content: { content },
                   title: { title },
                   drawer: { drawer })
        }
    }
    
    
    var content: some View {
        List {
            Section {
                Toggle("Drawer", isOn: $hasDrawer)
                Toggle("Accessory", isOn: $hasAccessory)
            }
            
            __50items
        }
    }
    
    
    var title: some View {
        Text("App Name Here")
            .frame(maxHeight: .infinity)
            .font(.title)
            .padding(.horizontal)
//            .background(Color.white)
    }
    
    
    var accessory: (some View)? {
        hasAccessory
            ? Button {} label: {
                Circle()
                    .id("Circle")
                    .frame(height: 200)
                    .foregroundStyle(Color.primary)
            }
            : nil
    }
    
    
    @ArrayBuilder<NavigationDrawerItem>
    var drawer: [NavigationDrawerItem] {
        if hasDrawer {
            NavigationDrawerItem(title: "Test Top", icon: .init(systemImage: "book.closed"), action: {})
            NavigationDrawerItem(title: "Test Middle", icon: .init(systemImage: "link"), action: {})
            NavigationDrawerItem(title: "Test Bottom", icon: .init(systemImage: "trophy"), action: {})
        }
    }
}


#Preview("Simple Test") {
    SimpleTestPreview()
}



#Preview("Safe Area Fuckery", traits: .portraitUpsideDown) {
    AppBar {
        List {
            __50items
        }
    } title: {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.5))
                .stroke(Color.red, lineWidth: 4)
                .ignoresSafeArea()
            
            Rectangle()
                .fill(Color.blue)
        }
    }
}



private let __50items: some View = {
    ForEach(1 ..< 51) { number in
        Text("\(number, format: IntegerFormatStyle.init())")
    }
}()
