// Vladislav K.

import SwiftUI

struct Home: View {
    /// Animation Properties
    @State private var expandSheet: Bool = false
    @State private var hideTabBar: Bool = false
    @Namespace private var animation

    var body: some View {
        /// Tab View
        TabView {
            customListenNowView()
                .setTabItem("Listen Now", "play.circle.fill")
                .setTabBarBackground(.init(.ultraThickMaterial))
                .hideTabBar(hideTabBar)
            /// Sample Tab's
            ListenTabView("Browse", "square.grid.2x2.fill")
            ListenTabView("Radio", "dot.radiowaves.left.and.right")
            ListenTabView("Music", "play.square.stack")
            ListenTabView("Search", "magnifyingglass")
        }
        /// Changing Tab Indicator Color
        .tint(.red)
        .safeAreaInset(edge: .bottom) {
            customBottomSheetView()
        }
        .overlay {
            if expandSheet {
                ExpandedBottomSheetView(expandSheet: $expandSheet, animation: animation)
                /// Transition for more fluent Animation
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            }
        }
        .onChange(of: expandSheet) { newValue in
            /// Delaying a Little Bit for Hiding the Tab Bar
            DispatchQueue.main.asyncAfter(deadline: .now() + (newValue ? 0.04 : 0.03)) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    hideTabBar = newValue
                }
            }
        }
    }

    /// Custom Listen Now View
    @ViewBuilder
    func customListenNowView() -> some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    Image("Card 1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)

                    Image("Card 2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .padding()
                .padding(.bottom, 100)
            }
            .navigationTitle("Listen Now")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        VStack {

                        }
                        .navigationTitle("Account Info")
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.title3)
                    }
                }
            }
        }
    }

    /// Custom Bottom Sheet
    @ViewBuilder
    func customBottomSheetView() -> some View {
        /// Animating Sheet Background (To Look Like It's Expanding From the Bottom)
        ZStack {
            if expandSheet {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay {
                       
                        MusicInfoView(expandSheet: $expandSheet, animation: animation)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
        }
        .frame(height: 70)
      
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
        })
     
        .offset(y: -49)
    }

    /// Generates Sample View with Tab Label
    @ViewBuilder
    func ListenTabView(_ title: String, _ icon: String) -> some View {

        ScrollView(.vertical, showsIndicators: false, content: {
            Text(title)
                .padding(.top, 25)
        })
        .setTabItem(title, icon)
        /// Changing Tab Background Color
        .setTabBarBackground(.init(.ultraThickMaterial))
        /// Hiding Tab Bar When Sheet is Expanded
        .hideTabBar(hideTabBar)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

/// Custom View Modifier's
extension View {
    @ViewBuilder
    func setTabItem(_ title: String, _ icon: String) -> some View {
        self
            .tabItem {
                Image(systemName: icon)
                Text(title)
            }
    }

    @ViewBuilder
    func setTabBarBackground(_ style: AnyShapeStyle) -> some View {
        self
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(style, for: .tabBar)
    }

    @ViewBuilder
    func hideTabBar(_ status: Bool) -> some View {
        self
            .toolbar(status ? .hidden : .visible, for: .tabBar)
    }
}
