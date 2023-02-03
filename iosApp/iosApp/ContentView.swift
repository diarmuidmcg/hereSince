import SwiftUI
import shared

enum TabIdentifier: Hashable {
  case mine, view, prev
}

struct ContentView: View {
    // current tab for entire app
    @State var selectedTab = TabIdentifier.view
    // view model from kotlin
    @ObservedObject var vm = IOSJarViewModel()
    
    // main app
    var body: some View {
        ZStack{
            TabView(selection: $selectedTab) {
//              if has jars associated
                if vm.user.userJars.count > 0 {
                    MyJars(vm: vm).tabItem { Label("My Jars", systemImage: "loupe")}.tag(TabIdentifier.mine)
                }
                ViewJar(vm: vm).tabItem { Label("View", systemImage: "tag.circle")}.tag(TabIdentifier.view)
                PreviousJars(vm: vm).tabItem { Label("Previous", systemImage: "memories")}.tag(TabIdentifier.prev)
            }
            .accentColor(Color.primary)
        }
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform:
                handleUserActivityReadingUid
        )
    
    }
    
    // this checks the launch url & if it includes a coasterUid, navigates to the searchbar or has the user connect to the coaster
    func handleUserActivityReadingUid(_ userActivity: NSUserActivity) {

        // sets the url if there is one
        guard let incomingUrl = userActivity.webpageURL
              else {
            return
        }
        
//        probably pass url into kotlin func here
//        this func will update -> launchJarModal
        
        // divides it & makes potentional uid = lastSection
        let dividedUrl = incomingUrl.absoluteString.split(separator: "/")
        let lastSection = dividedUrl[dividedUrl.count - 1]
        
        print(lastSection)
        // each uid is exactly 14 chars
        if (lastSection.count == 14) {
            print("uid is \(String(lastSection))")

            
            
        }
    }
        
}
