package com.example.playerapp;

import android.os.Bundle;
import android.content.pm.PackageManager;

// import javax.naming.Context;

import android.Manifest;
import android.support.v4.content.ContextCompat;
import android.support.v4.app.ActivityCompat;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
  public static final String RECORD_AUDIO="android.permission.RECORD_AUDIO";
  @Override
  protected void onResume(){
    super.onResume();
    if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
            != PackageManager.PERMISSION_GRANTED) {
      ActivityCompat.requestPermissions(this,
              new String []{Manifest.permission.RECORD_AUDIO},
              1000);
            }
  }
}
