import SwiftUI

// MARK: - 資料型別定義 (Data Models)

/// 運勢籤資料模型
/// 用於儲存單支靈籤的完整資訊（包含運勢等級、籤號標題、籤詩、解曰、開運建議、幸運物、代表圖示與主題色）
struct FortuneSlip: Identifiable, Equatable {
    /// 唯一識別碼，供 SwiftUI 清單與視圖追蹤使用
    let id = UUID()
    /// 運勢階梯索引：0（最壞：大凶）～ 7（最好：大吉）
    let rankIndex: Int
    /// 籤號名稱（例如：「第一籤」）
    let slipNumber: String
    /// 運勢等級名稱（例如：「大凶」、「平」、「大吉」）
    let level: String
    /// 籤題（四字或八字成語標題）
    let title: String
    /// 靈籤詩句內容（四句七言絕句）
    let poem: String
    /// 解曰（針對當前運勢的詳細解析）
    let interpretation: String
    /// 祈福與行事宜忌建議
    let advice: String
    /// 開運加持小物
    let luckyItem: String
    /// 代表圖示名稱（使用 Apple SF Symbols）
    let symbolName: String
    /// 該運勢等級對應的主題代表色
    let badgeColor: Color
}

/// 臺灣傳統擲筊結果列舉型別
/// 包含「聖筊」、「笑筊」、「無筊」三種結果，並提供對應的視覺狀態與文字說明
enum JiaobeiResult: String, CaseIterable {
    /// 聖筊：一正一反，代表神明應允加持，運勢提升一級
    case sheng = "聖筊"
    /// 笑筊：兩平面皆向上，代表神明笑而不答，維持原運勢
    case xiao = "笑筊"
    /// 無筊（蓋筊）：兩凸面皆向上，代表神明否定或時機未到，運勢降低一級
    case wu = "無筊"

    /// 筊杯落地時的正反面狀態文字說明
    var blockOrientationText: String {
        switch self {
        case .sheng:
            return "一正一反（一平面、一凸面）"
        case .xiao:
            return "兩平面皆向上"
        case .wu:
            return "兩凸面皆向上"
        }
    }

    /// 神明旨意與改運效果的詳細說明
    var description: String {
        switch self {
        case .sheng:
            return "代表神明同意、肯定或事情順利，將原本抽籤的運勢向好的那邊提升一級！"
        case .xiao:
            return "代表神明笑而不答、考慮中，不改變原有的運勢結果。"
        case .wu:
            return "代表神明不同意、否定、或時機不宜，將原本抽籤的運勢向壞的那邊降低一級。"
        }
    }

    /// 左側筊杯是否為平面向上（true = 正面／平面向上，false = 反面／凸面向上）
    var leftIsFlatUp: Bool {
        switch self {
        case .sheng: return true
        case .xiao:  return true
        case .wu:    return false
        }
    }

    /// 右側筊杯是否為平面向上（true = 正面／平面向上，false = 反面／凸面向上）
    var rightIsFlatUp: Bool {
        switch self {
        case .sheng: return false
        case .xiao:  return true
        case .wu:    return false
        }
    }

    /// 各擲筊結果對應的視覺主題強調色
    var tintColor: Color {
        switch self {
        case .sheng: return Color(red: 0.82, green: 0.18, blue: 0.15) // 喜慶硃砂紅
        case .xiao:  return Color(red: 0.80, green: 0.52, blue: 0.12) // 溫潤琥珀金
        case .wu:    return Color(red: 0.42, green: 0.42, blue: 0.46) // 沉穩鐵灰
        }
    }
}

// MARK: - 主畫面 (ContentView)

/// 應用程式的主畫面視圖
/// 整合「靈籤抽取」、「運勢階梯顯示」與「傳統擲筊改運祈福系統」三大核心功能
struct ContentView: View {
    /// 從最壞到最好共 8 筆運勢籤資料，依序儲存在陣列中：
    /// 順序：大凶 (0) -> 中凶 (1) -> 小凶 (2) -> 平 (3) -> 吉 (4) -> 小吉 (5) -> 中吉 (6) -> 大吉 (7)
    private let fortunes: [FortuneSlip] = [
        FortuneSlip(
            rankIndex: 0,
            slipNumber: "第一籤",
            level: "大凶",
            title: "烏雲蔽日・靜守待時",
            poem: "黑雲壓城風雨急，\n孤舟夜渡浪千層；\n莫道前途無知己，\n且收帆影待天明。",
            interpretation: "目前時運較為低迷，諸事容易遭遇阻礙與波折，切忌衝動行事或冒險投資。",
            advice: "宜保守低調、多行善積德；忌遠行冒險、與人爭執。",
            luckyItem: "平安護身符、溫熱茶飲",
            symbolName: "cloud.bolt.rain.fill",
            badgeColor: Color(red: 0.25, green: 0.25, blue: 0.30)
        ),
        FortuneSlip(
            rankIndex: 1,
            slipNumber: "第二籤",
            level: "中凶",
            title: "逆水行舟・步步為營",
            poem: "逆水行舟費力多，\n風波暗湧莫輕過；\n耐心守得雲開日，\n自有清風送碧波。",
            interpretation: "近期計畫推進較費心力，容易出現事倍功半之感，需格外留意細節與人際溝通。",
            advice: "宜深思熟慮、請益長輩；忌急躁妄動、輕信流言。",
            luckyItem: "檀香木飾品、深色筆記本",
            symbolName: "wind.snow",
            badgeColor: Color(red: 0.38, green: 0.34, blue: 0.42)
        ),
        FortuneSlip(
            rankIndex: 2,
            slipNumber: "第三籤",
            level: "小凶",
            title: "霧裡看花・謹慎前行",
            poem: "曉霧迷濛掩翠微，\n行人駐足問歸期；\n但將心事從頭理，\n日出雲消見柳堤。",
            interpretation: "眼下雖有些許小困擾或迷惑，但只要冷靜釐清方向，問題終能迎刃而解。",
            advice: "宜整理思緒、按部就班；忌分心大意、半途而廢。",
            luckyItem: "白水晶、清香綠茶",
            symbolName: "cloud.fog.fill",
            badgeColor: Color(red: 0.45, green: 0.48, blue: 0.54)
        ),
        FortuneSlip(
            rankIndex: 3,
            slipNumber: "第四籤",
            level: "平",
            title: "風平浪靜・安穩自在",
            poem: "水碧山青萬里寬，\n不驚風雨不驚寒；\n日常耕讀隨緣過，\n自有清歡在世間。",
            interpretation: "整體運勢平穩無波，雖無大起大落之驚喜，卻是休養生息、穩固根基的好時機。",
            advice: "宜維持規律、充實自我；忌好高騖遠、心浮氣躁。",
            luckyItem: "竹製書籤、素色帆布袋",
            symbolName: "leaf.fill",
            badgeColor: Color(red: 0.26, green: 0.56, blue: 0.46)
        ),
        FortuneSlip(
            rankIndex: 4,
            slipNumber: "第五籤",
            level: "吉",
            title: "春風拂柳・漸入佳境",
            poem: "東風吹暖百花開，\n燕子雙雙報喜來；\n勤懇耕耘終有獲，\n安心闊步上高臺。",
            interpretation: "運勢轉佳，過去付出的努力開始展現成果，身邊亦有助人相伴，諸事順遂。",
            advice: "宜積極行動、廣結善緣；忌懈怠拖延、錯失良機。",
            luckyItem: "紅線手環、柑橘香氛",
            symbolName: "sun.and.horizon.fill",
            badgeColor: Color(red: 0.82, green: 0.48, blue: 0.16)
        ),
        FortuneSlip(
            rankIndex: 5,
            slipNumber: "第六籤",
            level: "小吉",
            title: "喜鵲登枝・小有斬獲",
            poem: "喜鵲枝頭報好音，\n門庭添喜笑盈盈；\n雖然未到巔峰處，\n已有清香滿院庭。",
            interpretation: "生活中將迎來令人欣喜的小確幸，工作與學業皆有突破，心情愉悅舒暢。",
            advice: "宜把握契機、分享喜悅；忌驕傲自滿、忽略細節。",
            luckyItem: "金色鑰匙圈、桂花糕點",
            symbolName: "bird.fill",
            badgeColor: Color(red: 0.86, green: 0.36, blue: 0.18)
        ),
        FortuneSlip(
            rankIndex: 6,
            slipNumber: "第七籤",
            level: "中吉",
            title: "紫氣東來・貴人相扶",
            poem: "紫氣東來映碧天，\n順風揚帆一日千；\n貴人指路通大道，\n名利雙收福壽全。",
            interpretation: "鴻運漸開，不僅自身實力得以發揮，更有貴人暗中相助，所求之事多能如願以償。",
            advice: "宜大展身手、乘勝追擊；忌猶豫不決、固步自封。",
            luckyItem: "紫晶吊墜、紅玉紅茶",
            symbolName: "sparkles",
            badgeColor: Color(red: 0.80, green: 0.20, blue: 0.22)
        ),
        FortuneSlip(
            rankIndex: 7,
            slipNumber: "第八籤",
            level: "大吉",
            title: "鴻運當頭・萬事亨通",
            poem: "金龍騰躍入雲霄，\n萬道霞光照錦袍；\n心想事成天賜福，\n春風得意步步高。",
            interpretation: "上上大吉之籤！天時、地利、人和俱備，財運、事業、感情皆處巔峰，心想事成。",
            advice: "宜心懷感恩、勇敢追夢、樂善好施，福氣更加綿長。",
            luckyItem: "黃金錦囊、牡丹花茶",
            symbolName: "crown.fill",
            badgeColor: Color(red: 0.78, green: 0.12, blue: 0.12)
        )
    ]

    /// 每支運勢籤最多可重抽（擲筊改運）的次數上限
    private let maxRedrawLimit: Int = 3

    // MARK: - 狀態屬性 (@State Properties)

    /// 目前抽中或改運後的運勢籤索引值（nil 代表尚未抽籤）
    @State private var currentIndex: Int? = nil
    /// 改運前的運勢等級名稱（用於在卡片右上角顯示改運前後的變化軌跡）
    @State private var previousLevelName: String? = nil
    /// 是否正在播放搖晃籤筒的動畫
    @State private var isShakingCylinder: Bool = false
    /// 是否展開「改運祈福系統（傳統擲筊）」區塊
    @State private var showPraySystem: Bool = false
    /// 是否正在播放擲出筊杯的旋轉動畫
    @State private var isThrowingBlocks: Bool = false
    /// 最近一次擲筊的結果（聖筊、笑筊或無筊）
    @State private var lastJiaobeiResult: JiaobeiResult? = nil
    /// 擲筊後的改運結果提示訊息
    @State private var jiaobeiStatusMessage: String? = nil
    /// 當前這支靈籤剩餘的擲筊改運次數（每抽新籤會重置為 3 次）
    @State private var remainingRedrawCount: Int = 3

    // MARK: - 計算屬性 (Computed Properties)

    /// 根據 `currentIndex` 取得目前對應的運勢籤資料模型
    private var currentFortune: FortuneSlip? {
        guard let index = currentIndex, fortunes.indices.contains(index) else { return nil }
        return fortunes[index]
    }

    /// 判斷目前是否已經達到最高運勢「大吉」（索引為陣列最後一項）
    private var isMaxFortune: Bool {
        currentIndex == fortunes.count - 1
    }

    // MARK: - 主視圖佈局 (Main Body)

    var body: some View {
        ZStack {
            // 傳統廟宇暖色宣紙漸層背景，鋪滿整個螢幕安全區域外
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.95, blue: 0.89),
                    Color(red: 0.94, green: 0.88, blue: 0.78)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // 主要捲動內容區塊
            ScrollView {
                VStack(spacing: 20) {
                    // 1. 頂部廟宇匾額標題區
                    headerSection

                    // 2. 運勢階梯進度條（由左至右顯示：大凶 ~ 大吉）
                    fortuneScaleBar

                    // 3. 籤詩結果卡片 或 尚未抽籤時的籤筒視覺畫面
                    if let fortune = currentFortune {
                        // 已抽籤：以圖文卡片呈現詳細籤詩與解曰
                        FortuneSlipCardView(
                            fortune: fortune,
                            previousLevelName: previousLevelName
                        )
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.92).combined(with: .opacity),
                            removal: .opacity
                        ))
                    } else {
                        // 尚未抽籤：顯示搖晃籤筒的待機引導畫面
                        EmptyCylinderPlaceholderView(isShaking: isShakingCylinder)
                    }

                    // 4. 抽籤／重新抽籤按鈕
                    drawButton

                    // 5. 改運祈福系統（若已抽出籤且尚未達「大吉」則顯示擲筊系統；若已達「大吉」則顯示祝賀橫幅）
                    if currentFortune != nil && !isMaxFortune {
                        prayAndJiaobeiSection
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else if isMaxFortune {
                        maxFortuneCongratsBanner
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
            }
        }
    }

    // MARK: - 子視圖區塊 (Subviews)

    /// 頂部廟宇匾額標題與祈福引導說明
    private var headerSection: some View {
        VStack(spacing: 6) {
            HStack(spacing: 10) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(Color(red: 0.82, green: 0.18, blue: 0.14))
                Text("靈籤祈福・抽一支運勢籤吧！")
                    .font(.title2.bold())
                    .foregroundStyle(Color(red: 0.45, green: 0.12, blue: 0.10))
                Image(systemName: "flame.fill")
                    .foregroundStyle(Color(red: 0.82, green: 0.18, blue: 0.14))
            }
            Text("誠心默念心中所求，點擊下方按鈕抽取今日運勢靈籤")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 4)
    }

    /// 顯示從最壞（大凶）到最好（大吉）共 8 個等級的橫向序列指示列
    private var fortuneScaleBar: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 標題與目前所在等級文字
            HStack {
                Text("運勢階梯（由壞至好）")
                    .font(.caption.bold())
                    .foregroundStyle(Color(red: 0.50, green: 0.25, blue: 0.15))
                Spacer()
                if let fortune = currentFortune {
                    Text("目前：\(fortune.level)")
                        .font(.caption.bold())
                        .foregroundStyle(fortune.badgeColor)
                }
            }

            // 8 個運勢等級的標籤格，當前抽中的等級會放大並高亮顯示
            HStack(spacing: 4) {
                ForEach(fortunes) { item in
                    let isSelected = item.rankIndex == currentIndex
                    Text(item.level)
                        .font(.system(size: 11, weight: isSelected ? .heavy : .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isSelected ? item.badgeColor : Color.white.opacity(0.65))
                        )
                        .foregroundStyle(isSelected ? .white : .primary.opacity(0.75))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(
                                    isSelected ? Color.yellow : Color.brown.opacity(0.25),
                                    lineWidth: isSelected ? 2 : 1
                                )
                        )
                        .scaleEffect(isSelected ? 1.06 : 1.0)
                        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: currentIndex)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.55))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color.brown.opacity(0.2), lineWidth: 1)
                )
        )
    }

    /// 抽籤主按鈕（根據是否已抽過籤，自動切換圖示與按鈕文字）
    private var drawButton: some View {
        Button {
            drawRandomFortune()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: currentFortune == nil ? "hands.and.sparkles.fill" : "arrow.trianglehead.2.clockwise.rotate.90")
                    .font(.title3.bold())
                    .rotationEffect(.degrees(isShakingCylinder ? -18 : 0))
                Text(currentFortune == nil ? "誠心抽一支運勢籤" : "重新抽一支運勢籤")
                    .font(.headline.bold())
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.82, green: 0.16, blue: 0.14),
                        Color(red: 0.64, green: 0.10, blue: 0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color(red: 0.95, green: 0.80, blue: 0.45), lineWidth: 1.5)
            )
            .shadow(color: Color.red.opacity(0.25), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    /// 改運祈福系統（傳統擲筊互動區塊，每支運勢籤最多只能重抽改運三次）
    private var prayAndJiaobeiSection: some View {
        VStack(spacing: 14) {
            // 展開或收合「改運祈福系統」的切換按鈕
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showPraySystem.toggle()
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "moon.stars.fill")
                        .font(.title3)
                        .foregroundStyle(.yellow)
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text("🙏 改運祈福系統（傳統擲筊）")
                                .font(.headline.bold())
                                .foregroundStyle(.white)

                            // 顯示目前剩餘的改運次數標籤
                            Text("剩餘 \(remainingRedrawCount)/\(maxRedrawLimit) 次")
                                .font(.caption2.bold())
                                .padding(.horizontal, 7)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(Color.black.opacity(0.25)))
                                .foregroundStyle(.yellow)
                        }
                        Text(showPraySystem ? "每支運勢籤最多可重抽改運 \(maxRedrawLimit) 次" : "對運勢不滿意？點此向神明擲筊祈福改運（每籤限 \(maxRedrawLimit) 次）")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    Spacer()
                    Image(systemName: showPraySystem ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                .padding(14)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.72, green: 0.42, blue: 0.10),
                            Color(red: 0.56, green: 0.28, blue: 0.06)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)

            // 展開後的擲筊互動面板
            if showPraySystem {
                VStack(spacing: 16) {
                    // 1. 臺灣傳統擲筊改運規則說明小卡
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Label("台灣傳統擲筊改運規則", systemImage: "info.circle.fill")
                                .font(.subheadline.bold())
                                .foregroundStyle(Color(red: 0.52, green: 0.20, blue: 0.12))
                            Spacer()
                            Text("每支籤限重抽 \(maxRedrawLimit) 次")
                                .font(.caption.bold())
                                .foregroundStyle(remainingRedrawCount > 0 ? Color(red: 0.72, green: 0.30, blue: 0.10) : .secondary)
                        }

                        JiaobeiRuleRow(
                            badge: "聖筊",
                            color: Color(red: 0.82, green: 0.18, blue: 0.15),
                            detail: "一正一反：神明同意加持，運勢向好提升一級"
                        )
                        JiaobeiRuleRow(
                            badge: "笑筊",
                            color: Color(red: 0.80, green: 0.52, blue: 0.12),
                            detail: "兩平面皆向上：神明笑而不答，維持原有運勢"
                        )
                        JiaobeiRuleRow(
                            badge: "無筊",
                            color: Color(red: 0.42, green: 0.42, blue: 0.46),
                            detail: "兩凸面皆向上：神明否定或時機不宜，運勢向壞降低一級"
                        )
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.99, green: 0.96, blue: 0.90))
                    )

                    // 2. 左右雙筊杯圖形展示區
                    JiaobeiVisualView(
                        result: lastJiaobeiResult,
                        isThrowing: isThrowingBlocks
                    )

                    // 3. 擲筊結果文字說明與運勢升降提示
                    if let result = lastJiaobeiResult {
                        VStack(spacing: 6) {
                            HStack(spacing: 8) {
                                Text(result.rawValue)
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(result.tintColor))

                                Text(result.blockOrientationText)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(result.tintColor)
                            }

                            Text(result.description)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)

                            if let statusMsg = jiaobeiStatusMessage {
                                Text(statusMsg)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(Color(red: 0.65, green: 0.15, blue: 0.12))
                                    .padding(.top, 2)
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(result.tintColor.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(result.tintColor.opacity(0.35), lineWidth: 1)
                                )
                        )
                    }

                    // 4. 剩餘改運次數進度指示與「誠心擲筊改運」動作按鈕
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            // 以星芒與禁止圖示視覺化呈現剩餘次數
                            ForEach(0..<maxRedrawLimit, id: \.self) { index in
                                Image(systemName: index < remainingRedrawCount ? "sparkles" : "circle.slash")
                                    .font(.caption.bold())
                                    .foregroundStyle(index < remainingRedrawCount ? Color.orange : Color.secondary.opacity(0.5))
                            }
                            Text(remainingRedrawCount > 0
                                 ? "本支運勢籤尚可改運重抽 \(remainingRedrawCount) 次"
                                 : "本支運勢籤已用完 \(maxRedrawLimit) 次改運重抽機會")
                                .font(.caption.bold())
                                .foregroundStyle(remainingRedrawCount > 0 ? Color(red: 0.60, green: 0.25, blue: 0.10) : .secondary)
                        }

                        // 擲筊按鈕（當剩餘次數歸零時自動反灰並停用）
                        Button {
                            throwJiaobei()
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: remainingRedrawCount > 0 ? "hands.clap.fill" : "lock.fill")
                                    .font(.headline)
                                Text(remainingRedrawCount > 0
                                     ? "誠心擲筊改運（剩餘 \(remainingRedrawCount) 次）"
                                     : "已達改運重抽上限（\(maxRedrawLimit)/\(maxRedrawLimit)）")
                                    .font(.headline.bold())
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(
                                LinearGradient(
                                    colors: remainingRedrawCount > 0
                                        ? [
                                            Color(red: 0.88, green: 0.32, blue: 0.14),
                                            Color(red: 0.72, green: 0.18, blue: 0.10)
                                        ]
                                        : [
                                            Color.gray.opacity(0.65),
                                            Color.gray.opacity(0.45)
                                        ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(
                                color: remainingRedrawCount > 0 ? Color.orange.opacity(0.25) : .clear,
                                radius: 4,
                                x: 0,
                                y: 2
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(remainingRedrawCount <= 0)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.88))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.brown.opacity(0.3), lineWidth: 1.2)
                        )
                )
            }
        }
    }

    /// 當運勢已達最高等級「大吉」時顯示的祝賀橫幅（此時無需再顯示改運祈福系統）
    private var maxFortuneCongratsBanner: some View {
        VStack(spacing: 10) {
            // 若是透過擲出「聖筊」晉升至大吉，額外顯示神明應允的祝賀訊息
            if let result = lastJiaobeiResult, result == .sheng, let msg = jiaobeiStatusMessage {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(Color(red: 0.82, green: 0.18, blue: 0.15))
                    Text("擲出【聖筊】— \(msg)")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color(red: 0.70, green: 0.15, blue: 0.12))
                }
            }

            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(.yellow)
                VStack(alignment: .leading, spacing: 3) {
                    Text("鴻運當頭・已達最高運勢「大吉」")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color(red: 0.65, green: 0.12, blue: 0.10))
                    Text("目前運勢已至頂峰，無需再進行改運祈福，祝您萬事如意！")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.95, blue: 0.82),
                            Color(red: 0.99, green: 0.89, blue: 0.70)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.orange.opacity(0.55), lineWidth: 1.5)
                )
        )
    }

    // MARK: - 互動邏輯 (Interaction Methods)

    /// 隨機抽出一支運勢籤，並重置該支籤的改運重抽次數與相關狀態
    private func drawRandomFortune() {
        // 觸發籤筒搖晃動畫（來回重複 3 次）
        withAnimation(.easeInOut(duration: 0.18).repeatCount(3, autoreverses: true)) {
            isShakingCylinder = true
        }

        // 從 8 支運勢籤中隨機挑選一個索引
        let randomIndex = Int.random(in: fortunes.indices)
        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
            currentIndex = randomIndex
            previousLevelName = nil
            lastJiaobeiResult = nil
            jiaobeiStatusMessage = nil
            remainingRedrawCount = maxRedrawLimit // 重置改運次數為上限（3 次）
            showPraySystem = false
            isShakingCylinder = false
        }
    }

    /// 執行擲筊動作，並根據擲出的結果（聖筊／笑筊／無筊）升降或維持運勢等級
    private func throwJiaobei() {
        // 確保尚有剩餘改運次數，且目前已抽出一支靈籤
        guard remainingRedrawCount > 0, let oldIndex = currentIndex else { return }
        let oldLevel = fortunes[oldIndex].level

        // 啟動筊杯拋擲動畫
        withAnimation(.easeInOut(duration: 0.25)) {
            isThrowingBlocks = true
        }

        // 隨機產生擲筊結果（聖筊、笑筊、無筊）
        let outcome = JiaobeiResult.allCases.randomElement() ?? .xiao

        withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
            isThrowingBlocks = false
            remainingRedrawCount -= 1 // 扣除 1 次改運機會
            lastJiaobeiResult = outcome

            switch outcome {
            case .sheng:
                // 聖筊：向好的那邊提升一級（最高不超過「大吉」）
                let newIndex = min(oldIndex + 1, fortunes.count - 1)
                currentIndex = newIndex
                previousLevelName = oldLevel
                let newLevel = fortunes[newIndex].level
                jiaobeiStatusMessage = "神明應允加持！運勢由「\(oldLevel)」提升為「\(newLevel)」！"

            case .xiao:
                // 笑筊：不改變原有的運勢結果
                previousLevelName = nil
                jiaobeiStatusMessage = "神明笑而不語，運勢維持「\(oldLevel)」不變。"

            case .wu:
                // 無筊：向壞的那邊降低一級（最低不低於「大凶」）
                if oldIndex > 0 {
                    let newIndex = oldIndex - 1
                    currentIndex = newIndex
                    previousLevelName = oldLevel
                    let newLevel = fortunes[newIndex].level
                    jiaobeiStatusMessage = "時機未到，運勢由「\(oldLevel)」下降一級為「\(newLevel)」。"
                } else {
                    previousLevelName = nil
                    jiaobeiStatusMessage = "目前已是最低運勢「\(oldLevel)」，請多行善事靜待轉機。"
                }
            }
        }
    }
}

// MARK: - 運勢籤卡片視圖 (FortuneSlipCardView)

/// 運勢籤結果卡片視圖
/// 以傳統靈籤排版呈現籤號、運勢等級印章、籤題、詩句、解曰剖析、行事宜忌與開運小物
struct FortuneSlipCardView: View {
    /// 要顯示的運勢籤資料
    let fortune: FortuneSlip
    /// 若經過擲筊改運，傳入改運前的運勢等級名稱以顯示變化軌跡
    let previousLevelName: String?

    var body: some View {
        VStack(spacing: 16) {
            // 1. 頂部籤號膠囊標籤與改運軌跡標籤（例如：小凶 -> 平）
            HStack {
                Text(fortune.slipNumber)
                    .font(.subheadline.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(fortune.badgeColor.opacity(0.15))
                    )
                    .foregroundStyle(fortune.badgeColor)

                Spacer()

                // 若有改運前的等級紀錄，顯示刪除線與箭頭對比
                if let prev = previousLevelName {
                    HStack(spacing: 4) {
                        Text(prev)
                            .strikethrough()
                            .foregroundStyle(.secondary)
                        Image(systemName: "arrow.right")
                            .font(.caption.bold())
                        Text(fortune.level)
                            .bold()
                    }
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.yellow.opacity(0.3)))
                    .foregroundStyle(Color(red: 0.60, green: 0.15, blue: 0.10))
                }
            }

            // 2. 代表圖示圓章與大字運勢等級、籤題
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    fortune.badgeColor.opacity(0.25),
                                    fortune.badgeColor.opacity(0.06)
                                ],
                                center: .center,
                                startRadius: 8,
                                endRadius: 46
                            )
                        )
                        .frame(width: 84, height: 84)
                        .overlay(
                            Circle()
                                .strokeBorder(fortune.badgeColor.opacity(0.45), lineWidth: 2)
                        )

                    Image(systemName: fortune.symbolName)
                        .font(.system(size: 38))
                        .foregroundStyle(fortune.badgeColor)
                        .symbolEffect(.pulse, options: .repeating)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(fortune.level)
                        .font(.system(size: 38, weight: .heavy, design: .serif))
                        .foregroundStyle(fortune.badgeColor)

                    Text(fortune.title)
                        .font(.headline)
                        .foregroundStyle(Color(red: 0.32, green: 0.20, blue: 0.14))
                }

                Spacer()
            }

            Divider()
                .overlay(Color.brown.opacity(0.25))

            // 3. 靈籤詩句區塊（採用襯線字體置中排版）
            VStack(spacing: 6) {
                Label("【靈籤詩句】", systemImage: "scroll.fill")
                    .font(.caption.bold())
                    .foregroundStyle(Color(red: 0.58, green: 0.24, blue: 0.14))

                Text(fortune.poem)
                    .font(.system(.body, design: .serif).weight(.semibold))
                    .foregroundStyle(Color(red: 0.25, green: 0.15, blue: 0.10))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.97, green: 0.93, blue: 0.85))
                    )
            }

            // 4. 解曰剖析、行事宜忌與開運加持（多項詳細資訊列表）
            VStack(alignment: .leading, spacing: 10) {
                FortuneDetailRow(
                    icon: "book.closed.fill",
                    label: "解曰剖析",
                    content: fortune.interpretation,
                    tint: fortune.badgeColor
                )

                FortuneDetailRow(
                    icon: "compass.drawing",
                    label: "行事宜忌",
                    content: fortune.advice,
                    tint: fortune.badgeColor
                )

                FortuneDetailRow(
                    icon: "gift.fill",
                    label: "開運加持",
                    content: fortune.luckyItem,
                    tint: fortune.badgeColor
                )
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 1.0, green: 0.99, blue: 0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(fortune.badgeColor.opacity(0.6), lineWidth: 2.5)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}

/// 運勢籤卡片內的單列詳細資訊元件（包含左側圖示、小標題與內文）
struct FortuneDetailRow: View {
    /// SF Symbols 圖示名稱
    let icon: String
    /// 欄位標題（例如：「解曰剖析」）
    let label: String
    /// 欄位詳細內容文字
    let content: String
    /// 主題強調色
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(tint)
                .frame(width: 22, alignment: .center)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption.bold())
                    .foregroundStyle(tint)
                Text(content)
                    .font(.subheadline)
                    .foregroundStyle(.primary.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - 尚未抽籤時的籤筒視覺視圖 (EmptyCylinderPlaceholderView)

/// 尚未抽籤時顯示的傳統硃紅籤筒待機畫面
struct EmptyCylinderPlaceholderView: View {
    /// 是否正在搖晃籤筒（控制旋轉動畫角度）
    let isShaking: Bool

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // 背光圓形漸層光暈
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.orange.opacity(0.22),
                                Color.red.opacity(0.05)
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 85
                        )
                    )
                    .frame(width: 170, height: 170)

                // 竹籤與籤筒插畫組合
                VStack(spacing: -8) {
                    // 籤筒內露出的 7 支扇形排列竹籤（頂部點綴紅漆）
                    HStack(spacing: 5) {
                        ForEach(0..<7, id: \.self) { idx in
                            RoundedRectangle(cornerRadius: 3)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.82, green: 0.16, blue: 0.12),
                                            Color(red: 0.88, green: 0.72, blue: 0.45)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 9, height: CGFloat(38 + (idx % 3) * 8))
                                .rotationEffect(.degrees(Double(idx - 3) * 4.5))
                        }
                    }

                    // 硃紅鑲金籤筒筒身與「靈籤」字樣貼紙
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.76, green: 0.16, blue: 0.12),
                                        Color(red: 0.55, green: 0.09, blue: 0.08)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 92, height: 96)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .strokeBorder(Color(red: 0.92, green: 0.76, blue: 0.38), lineWidth: 2.5)
                            )

                        Text("靈籤")
                            .font(.system(size: 24, weight: .heavy, design: .serif))
                            .foregroundStyle(Color(red: 0.98, green: 0.86, blue: 0.50))
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .strokeBorder(Color(red: 0.98, green: 0.86, blue: 0.50), lineWidth: 1.2)
                            )
                    }
                }
                .rotationEffect(.degrees(isShaking ? 8 : 0))
            }

            // 引導標題與操作說明文字
            Text("籤筒內備有【大凶 ～ 大吉】共八階運勢靈籤")
                .font(.subheadline.bold())
                .foregroundStyle(Color(red: 0.48, green: 0.22, blue: 0.12))

            Text("點擊下方「誠心抽一支運勢籤」即可抽出今日專屬籤詩；\n若想祈求神明加持轉運，還可透過「傳統擲筊」改運祈福（每支籤限重抽三次）！")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.75))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.brown.opacity(0.25), lineWidth: 1.5)
                )
        )
    }
}

// MARK: - 臺灣傳統筊杯圖形繪製視圖 (Jiaobei Views)

/// 左右成對的雙筊杯視覺展示視圖
struct JiaobeiVisualView: View {
    /// 目前的擲筊結果（nil 代表尚未擲出）
    let result: JiaobeiResult?
    /// 是否正在播放擲筊動畫
    let isThrowing: Bool

    var body: some View {
        HStack(spacing: 32) {
            // 左側筊杯
            SingleJiaobeiBlockView(
                isFlatUp: result?.leftIsFlatUp ?? true,
                isMirrored: false,
                angle: isThrowing ? -25 : -12,
                title: result == nil ? "左筊（待擲）" : (result!.leftIsFlatUp ? "正（平面向上）" : "反（凸面向上）")
            )

            // 右側筊杯（水平鏡像翻轉）
            SingleJiaobeiBlockView(
                isFlatUp: result?.rightIsFlatUp ?? false,
                isMirrored: true,
                angle: isThrowing ? 25 : 12,
                title: result == nil ? "右筊（待擲）" : (result!.rightIsFlatUp ? "正（平面向上）" : "反（凸面向上）")
            )
        }
        .padding(.vertical, 8)
    }
}

/// 單一筊杯（弦月形）繪製與正反面視覺呈現視圖
struct SingleJiaobeiBlockView: View {
    /// 是否為平面向上（true = 正面淺木紋，false = 反面深紅朱漆凸面）
    let isFlatUp: Bool
    /// 是否水平鏡像翻轉（用於區分左右對稱的筊杯）
    let isMirrored: Bool
    /// 擺放或拋擲時的旋轉角度
    let angle: Double
    /// 筊杯下方的狀態說明標籤
    let title: String

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                if isFlatUp {
                    // 平面向上（正）：呈現淺木紋平面與紅漆邊框
                    CrescentBlockShape()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.95, green: 0.84, blue: 0.65),
                                    Color(red: 0.87, green: 0.72, blue: 0.48)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 86, height: 52)
                        .overlay(
                            CrescentBlockShape()
                                .stroke(Color(red: 0.78, green: 0.14, blue: 0.12), lineWidth: 4)
                        )
                } else {
                    // 凸面向上（反）：呈現立體深紅朱漆弧面與放射狀高光
                    CrescentBlockShape()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.92, green: 0.26, blue: 0.22),
                                    Color(red: 0.62, green: 0.08, blue: 0.08)
                                ],
                                center: .init(x: 0.45, y: 0.35),
                                startRadius: 4,
                                endRadius: 46
                            )
                        )
                        .frame(width: 86, height: 52)
                        .overlay(
                            CrescentBlockShape()
                                .stroke(Color(red: 0.45, green: 0.05, blue: 0.05), lineWidth: 2)
                        )
                }
            }
            .scaleEffect(x: isMirrored ? -1 : 1, y: 1)
            .rotationEffect(.degrees(angle))
            .shadow(color: Color.black.opacity(0.18), radius: 4, x: 0, y: 3)

            Text(title)
                .font(.caption2.bold())
                .foregroundStyle(isFlatUp ? Color(red: 0.62, green: 0.38, blue: 0.12) : Color(red: 0.72, green: 0.14, blue: 0.12))
        }
    }
}

/// 弦月形筊杯自訂幾何形狀（Shape）
/// 利用兩條二次貝茲曲線（QuadCurve）描繪傳統木製筊杯的外弧與內弧輪廓
struct CrescentBlockShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let start = CGPoint(x: rect.minX, y: rect.midY + 6)
        let end = CGPoint(x: rect.maxX, y: rect.midY + 6)

        path.move(to: start)
        // 外弧（較大彎曲度，形成筊杯上緣弧線）
        path.addQuadCurve(
            to: end,
            control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.45)
        )
        // 內弧（較平緩，形成筊杯下緣弧線）
        path.addQuadCurve(
            to: start,
            control: CGPoint(x: rect.midX, y: rect.midY + rect.height * 0.25)
        )
        path.closeSubpath()
        return path
    }
}

/// 擲筊規則說明小卡中的單行規則元件（包含膠囊徽章與說明文字）
struct JiaobeiRuleRow: View {
    /// 筊杯結果名稱（例如：「聖筊」）
    let badge: String
    /// 徽章背景代表色
    let color: Color
    /// 規則詳細文字說明
    let detail: String

    var body: some View {
        HStack(spacing: 8) {
            Text(badge)
                .font(.caption2.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 7)
                .padding(.vertical, 2)
                .background(Capsule().fill(color))

            Text(detail)
                .font(.caption)
                .foregroundStyle(.primary.opacity(0.85))
        }
    }
}

// MARK: - 預覽 (Preview)

#Preview {
    ContentView()
}
