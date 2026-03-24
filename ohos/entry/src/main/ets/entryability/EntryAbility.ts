// Shared EntryAbility for HarmonyOS
// Source: common/src/main/ets/entryability/EntryAbility.ts
import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';

export default class EntryAbility extends UIAbility {
  private readonly domain = 0x0000;
  private readonly tag = 'testTag';

  private safeStringify(value: unknown): string {
    if (value === undefined) {
      return 'undefined';
    }
    try {
      return JSON.stringify(value);
    } catch (_err) {
      return '[unserializable]';
    }
  }

  private logInfo(message: string): void {
    try {
      hilog.info(this.domain, this.tag, '%{public}s', message);
    } catch (_err) {
      console.info(`[EntryAbility] ${message}`);
    }
  }

  private logError(message: string): void {
    try {
      hilog.error(this.domain, this.tag, '%{public}s', message);
    } catch (_err) {
      console.error(`[EntryAbility] ${message}`);
    }
  }

  onCreate(want?: Record<string, unknown>, launchParam?: unknown) {
    const wantInfoObject: unknown = want ? want['info'] : undefined;
    const wantInfo: string = this.safeStringify(wantInfoObject);
    const launchInfo: string = this.safeStringify(launchParam);
    this.logInfo(`Ability onCreate. want.info=${wantInfo}, launchParam=${launchInfo}`);
  }

  onDestroy() {
    this.logInfo('Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    this.logInfo('Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        this.logError(`Failed to load the content. Cause: ${this.safeStringify(err)}`);
        return;
      }
      this.logInfo(`Succeeded in loading the content. Data: ${this.safeStringify(data)}`);
    });
  }

  onWindowStageDestroy() {
    this.logInfo('Ability onWindowStageDestroy');
  }

  onForeground() {
    this.logInfo('Ability onForeground');
  }

  onBackground() {
    this.logInfo('Ability onBackground');
  }
}
