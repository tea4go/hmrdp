// Shared Index page for HarmonyOS
// Source: common/src/main/ets/pages/Index.ets
@Entry
@Component
struct Index {
  @State message: string = 'Hello ArkUI-X 2026-03-24'

  build() {
    Row() {
      Column() {
        Button(this.message)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width(200)
          .height(50)
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .borderRadius(10)
          .onClick(() => {
            console.info('Button clicked');
          })
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}
