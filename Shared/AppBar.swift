//
//  AppBar.swift
//  Rent Split (iOS)
//
//  Created by S🌟System on 2022-07-09.
//

import SwiftUI
import FunctionTools



public struct AppBar<Content: View, Label: View>: View {
    
    @State
    private var size: Size = .thin
    
    @Environment(\.appBarColor)
    private var color: Color
    
    var position: Position = .bottom
    
    @ViewBuilder
    let content: Generator<Content>
    
    @ViewBuilder
    let label: Generator<Label>
    
    
    public var body: some View {
        ZStack {
            content()
                .padding(position.contentPadding(forAppBarSize: size))
            
            position {
                ZStack {
                    Rectangle()
                        .fill(color)
                        .ignoresSafeArea(edges: .bottom)
                        .frame(height: size.height)
                        .material(elevation: 4)
                    
                    HStack {
                        if let label = label {
                            label()
                                .frame(height: size.height)
                        }
                        
                        Spacer()
                    }
                    .multilineTextAlignment(.leading)
                }
            }
        }
    }
}



public extension AppBar {
    
    init(position: Position = .bottom,
         @ViewBuilder content: @escaping Generator<Content>)
    where Label == EmptyView {
        self.position = position
        self.content = content
        self.label = EmptyView.init
    }
}



public extension AppBar {
    
    enum Position { // TODO: replace with ``VerticalEdge`` once all cases are supported
        case bottom
    }
    
    
    enum Size {
        case thin
    }
}



private extension AppBar.Size {
    var height: CGFloat {
        switch self {
        case .thin: return 48
        }
    }
}



private extension AppBar.Position {
    
    @ViewBuilder
    func callAsFunction<Content: View>(@ViewBuilder content: () -> Content) -> some View {
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



struct AppBar_Previews: PreviewProvider {
    
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()
    
    static var previews: some View {
        AppBar {
            List {
                ForEach(1 ..< 51) { number in
                    Text("\(number, format: IntegerFormatStyle.init())")
                }
            }
        }
        label: {
            Text("App Name Here")
                .frame(maxHeight: .infinity)
                .font(.title)
                .padding(.horizontal)
//                .background(Color.white)
        }
    }
}
