package com.trydos.delivery

import android.content.Context
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.trydos.audio/settings"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setCallAudioMode") {
                val mode = call.arguments as? String ?: "normal"
                setCallAudioMode(mode)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun setCallAudioMode(mode: String) {
        val am = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        
        when (mode) {
            "earpiece" -> {
                // Earpiece Mode (Matching the "working" logic)
                am.mode = AudioManager.MODE_IN_COMMUNICATION
                am.isSpeakerphoneOn = false
                
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    val devices = am.availableCommunicationDevices
                    val earpiece = devices.find { it.type == AudioDeviceInfo.TYPE_BUILTIN_EARPIECE }
                    if (earpiece != null) {
                        try {
                            am.setCommunicationDevice(earpiece)
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                }
            }
            "speaker" -> {
                // Speaker Mode (Matching the "working" logic)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    try {
                        am.clearCommunicationDevice()
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
                // Important: The "working" code uses MODE_NORMAL and isSpeakerphoneOn = true for speaker
                am.mode = AudioManager.MODE_NORMAL
                am.isSpeakerphoneOn = true
            }
            "normal" -> {
                // Return to Normal (When call ends)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    try {
                        am.clearCommunicationDevice()
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
                am.mode = AudioManager.MODE_NORMAL
                am.isSpeakerphoneOn = false
            }
        }
    }
}
