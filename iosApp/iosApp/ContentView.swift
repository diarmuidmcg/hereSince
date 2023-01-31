import SwiftUI
import shared

enum TabIdentifier: Hashable {
  case mine, view, prev
}

struct ContentView: View {
//    let hasTags = CoreUserAttributes().hasTags
    let hasTags = true
    // current tab for entire app
    @State var selectedTab = TabIdentifier.view
    // object that contains hasAccount, connectedToSpotify, & hasConnectedCoasters
    
//    @StateObject var userAttributes = CoreUserAttributes()
    // bool on whether the user needs to update their app
    @State var needsToUpdate = false
    // object that stores the songs from the api
//    @ObservedObject var coastersConnectedToHost: CoastersFromApi = CoastersFromApi()
    // tells app there is no host
    @State var throwFirstLaunchAlert = false
    // tells app there is no host
    @State var throwCreateAccount = false
    
    @ObservedObject var vm = IOSJarViewModel()
    // main app
    var body: some View {
        ZStack{
            TabView(selection: $selectedTab) {
//              if has jars associated
                if hasTags {
                    MyJars(vm: vm).tabItem { Label("My Jars", systemImage: "loupe")}.tag(TabIdentifier.mine)
                }
                ViewJar(vm: vm).tabItem { Label("View", systemImage: "tag.circle")}.tag(TabIdentifier.view)
                PreviousJars(vm: vm).tabItem { Label("Previous", systemImage: "memories")}.tag(TabIdentifier.prev)
            }
            .actionSheet(isPresented: $throwFirstLaunchAlert) {
                ActionSheet(
                    title: Text("do you OWN a coaster?"),
                    buttons: [
                        .default(Text("yes")) {
                            throwCreateAccount = true
                        },
                        .default(Text("no").foregroundColor(Color.primary)) {
                          
                        },
                    ]
                )
            }
            .accentColor(Color.primary)
        }
    
    }
        
}
