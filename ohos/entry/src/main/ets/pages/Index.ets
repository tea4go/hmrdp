// Import shared component from common module using relative path
import { IndexPage } from '../../../common/src/main/ets/pages/Index'

@Entry
@Component
struct Index {
  build() {
    Column() {
      IndexPage()
    }
  }
}
