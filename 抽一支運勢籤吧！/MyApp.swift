import SwiftUI

/// 應用程式的進入點（App Entry Point）
/// 負責啟動整個「抽一支運勢籤吧！」應用程式並載入主畫面
@main struct MyApp: App {
    /// 定義應用程式的場景（Scene）階層結構
    var body: some Scene {
        // 建立主要視窗群組，並將 ContentView 設為起始根視圖
        WindowGroup {
            ContentView()
        }
    }
}
