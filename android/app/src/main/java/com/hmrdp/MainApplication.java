package com.hmrdp;

import android.util.Log;

import ohos.stage.ability.adapter.StageApplication;

/**
 * Main Application for Android platform with ArkUI-X support
 * Requires: arkui_android_adapter.jar
 */
public class MainApplication extends StageApplication {
    private static final String LOG_TAG = "Hmrdp";

    @Override
    public void onCreate() {
        Log.i(LOG_TAG, "MainApplication onCreate");
        super.onCreate();
        Log.i(LOG_TAG, "StageApplication initialized");
    }
}
