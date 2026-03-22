package com.example.helloapp;

import android.os.Bundle;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.view.Gravity;

import androidx.appcompat.app.AppCompatActivity;

/**
 * Main Activity for Android platform
 * Note: For full ArkUI-X support, install the ArkUI-X SDK and uncomment the AceAbility version
 */
public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Create a simple UI programmatically
        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setGravity(Gravity.CENTER);
        layout.setBackgroundColor(0xFFF1F3F5);

        Button button = new Button(this);
        button.setText("Hello ArkUI-X");
        button.setTextSize(20);
        button.setOnClickListener(v -> {
            android.util.Log.i("HelloApp", "Button clicked");
        });

        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
            400, 150
        );
        layout.addView(button, params);

        setContentView(layout);

        // Configure window
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
    }
}
