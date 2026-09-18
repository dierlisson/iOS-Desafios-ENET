import SwiftUI

#if os(iOS) && !SWIFT_PACKAGE
@main
struct SimuladorInvestimentosApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
#elseif !SWIFT_PACKAGE
@main
struct SimuladorInvestimentosApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
#endif
