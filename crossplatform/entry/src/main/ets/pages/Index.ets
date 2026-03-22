// Cross-platform shared ArkUI code
// This file is shared between HarmonyOS, Android, and iOS

@Entry
@Component
struct Index {
  @State message: string = 'Hello'

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
