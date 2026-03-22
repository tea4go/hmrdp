package com.hmrdp;

import android.os.Bundle;
import android.util.Log;

import ohos.stage.ability.adapter.StageActivity;

/**
 * Main Activity for Android platform with ArkUI-X support
 * Naming convention: moduleName + abilityName + "Activity" = Entry + EntryAbility + Activity
 * Requires: arkui_android_adapter.jar
 */
public class EntryEntryAbilityActivity extends StageActivity {
    private static final String TAG = "Hmrdp";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.i(TAG, "EntryEntryAbilityActivity onCreate");

        // Set instance name: bundleName:moduleName:abilityName:
        // Must be called before super.onCreate()
        setInstanceName("com.example.hmrdp:entry:EntryAbility:");

        super.onCreate(savedInstanceState);

        Log.i(TAG, "StageActivity created with instance: com.hmrdp:entry:EntryAbility:");
    }

    @Override
    protected void onDestroy() {
        Log.i(TAG, "StageActivity destroyed");
        super.onDestroy();
    }

    @Override
    protected void onResume() {
        Log.i(TAG, "StageActivity resume");
        super.onResume();
    }

    @Override
    protected void onPause() {
        Log.i(TAG, "StageActivity pause");
        super.onPause();
    }
}
