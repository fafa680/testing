package com.nini.fafa
import android.content.Intent
import android.os.Process
import android.util.Log
import android.view.SurfaceView
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.Toast
import androidx.annotation.NonNull
import com.hover.sdk.api.Hover
import com.hover.sdk.api.HoverParameters
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
class MainActivity : FlutterActivity() {
    private var callResult: MethodChannel.Result? = null
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        val s199 = "KAKWETU"
        val s299 = "numero"
        val s3 = "montant"
        val s4 = "objet"
        val s5 = "mi"
        val s6 = "ec"
        val s7 = "bu"
        val s8 = "ci"
        val s9 = "nk"
        try {
            Hover.initialize(this)
            Hover.setBranding(s199, R.drawable.kakwetu, this)
            GeneratedPluginRegistrant.registerWith(flutterEngine)
            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            if (!context.getPackageName().equals("com.nini.fafa")) {
                this.finish()
                Process.killProcess(Process.myPid())
            }
           if (!setSecureSurfaceView()) {
               Log.e("MainActivity", "Could not secure the MainActivity!")
           }
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result? ->
                val arguments = call.arguments<Map<String, Any>>()
                val phone = arguments[s299] as String?
                val amount = arguments[s3] as String?
                val aide = arguments[s4] as String?
                if (call.method == s5) {
                    mi(phone, amount, aide)
                    callResult = result
                } else if (call.method == s6) {
                    ec(phone, amount)
                    callResult = result
                } else if (call.method == s7) {
                    bu(phone, amount)
                    callResult = result
                } else if (call.method == s8) {
                    ci(phone, amount)
                    callResult = result
                } else if (call.method == s9) {
                    nk(phone, amount)
                    callResult = result
                }
            }
        } catch (e: Exception) {
            return
        }
    }
    override fun onPause() {
        super.onPause()
        if (callResult == null) {
            this.finish()
            Process.killProcess(Process.myPid())
        }
    }
    private fun setSecureSurfaceView(): Boolean {
        val content = findViewById<ViewGroup>(android.R.id.content)
        if (!isNonEmptyContainer(content)) {
            return false
        }
        val splashView = content.getChildAt(1)
        if (!isNonEmptyContainer(splashView)) {
            return false
        }
        val flutterView = (splashView as ViewGroup).getChildAt(1)
        if (!isNonEmptyContainer(flutterView)) {
            return false
        }
        val surfaceView = (flutterView as ViewGroup).getChildAt(1)
        if (surfaceView !is SurfaceView) {
            return false
        }
        surfaceView.setSecure(true)
        this.window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        return true
    }

    private fun isNonEmptyContainer(view: View): Boolean {
        if (view !is ViewGroup) {
            return false
        }
        if (view.childCount < 1) {
            return false
        }
        return true
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        val s199 = "Bye bye"
        val s299 = "ussd_messages"
        val s3 = "uuid"
        super.onActivityResult(requestCode, resultCode, data)
        try {
            setResult(RESULT_OK, data)
            var sessionTextArr: Array<String?>? = arrayOfNulls(0)
            if (requestCode == 99 && resultCode == RESULT_CANCELED || requestCode == 199 && resultCode == RESULT_CANCELED || requestCode == 299 && resultCode == RESULT_CANCELED) {
                Toast.makeText(this, s199, Toast.LENGTH_LONG).show()
                callResult = null
            } else if (requestCode == 99) {
                sessionTextArr = data.getStringArrayExtra(s299)
                val uuid = data.getStringExtra(s3)
                callResult!!.success(sessionTextArr!![6])
            } else if (requestCode == 199) {
                sessionTextArr = data.getStringArrayExtra(s299)
                val uuid = data.getStringExtra(s3)
                callResult!!.success(sessionTextArr!![5])
            } else if (requestCode == 299) {
                sessionTextArr = data.getStringArrayExtra(s299)
                val uuid = data.getStringExtra(s3)
                callResult!!.success(sessionTextArr!![7])
            }
        } catch (e: Exception) {
            return
        }
    }

    private fun mi(phone: String?, amount: String?, aide: String?) {
        val s199 = "MainActivity"
        val s299 = "Sims are = "
        val s3 = "Hover actions are = "
        val s4 = "hover exception"
        val s5 = "KAKWETU IS WORKING"
        val s6 = "please wait few seconds..."
        val s7 = "ad8d9951"
        val s8 = "numero"
        val s9 = "montant"
        val s19999 = "objet"
        try {
            Log.d(s199, s299 + Hover.getPresentSims(this))
            Log.d(s199, s3 + Hover.getAllValidActions(this))
        } catch (e: Exception) {
            Log.e(s199, s4, e)
        }
        try {
            val i: Intent = HoverParameters.Builder(this).setHeader(s5)
                    .initialProcessingMessage(s6)
                    .request(s7).finalMsgDisplayTime(0)
                    .extra(s8, phone)
                    .extra(s9, amount)
                    .extra(s19999, aide)
                    .buildIntent()
            startActivityForResult(i, 99)
        } catch (e: Exception) {
            return
        }
    }

    private fun ec(phone: String?, amount: String?) {
        val s199 = "MainActivity"
        val s299 = "Sims are = "
        val s3 = "Hover actions are = "
        val s4 = "hover exception"
        val s5 = "KAKWETU IS WORKING"
        val s6 = "please wait few seconds..."
        val s7 = "cec006ec"
        val s8 = "numero"
        val s9 = "montant"
        try {
            Log.d(s199, s299 + Hover.getPresentSims(this))
            Log.d(s199, s3 + Hover.getAllValidActions(this))
        } catch (e: Exception) {
            Log.e(s199, s4, e)
        }
        try {
            val i: Intent = HoverParameters.Builder(this).setHeader(s5)
                    .initialProcessingMessage(s6)
                    .request(s7).finalMsgDisplayTime(0)
                    .extra(s8, phone)
                    .extra(s9, amount)
                    .buildIntent()
            startActivityForResult(i, 99)
        } catch (e: Exception) {
            return
        }
    }

    private fun bu(phone: String?, amount: String?) {
        val s199 = "MainActivity"
        val s299 = "Sims are = "
        val s3 = "Hover actions are = "
        val s4 = "hover exception"
        val s5 = "KAKWETU IS WORKING"
        val s6 = "please wait few seconds..."
        val s7 = "041386d8"
        val s8 = "numero"
        val s9 = "montant"
        try {
            Log.d(s199, s299 + Hover.getPresentSims(this))
            Log.d(s199, s3 + Hover.getAllValidActions(this))
        } catch (e: Exception) {
            Log.e(s199, s4, e)
        }
        try {
            val i: Intent = HoverParameters.Builder(this).setHeader(s5)
                    .initialProcessingMessage(s6)
                    .request(s7).finalMsgDisplayTime(0)
                    .extra(s8, phone)
                    .extra(s9, amount)
                    .buildIntent()
            startActivityForResult(i, 199)
        } catch (e: Exception) {
            return
        }
    }

    private fun nk(phone: String?, amount: String?) {
        val s199 = "MainActivity"
        val s299 = "Sims are = "
        val s3 = "Hover actions are = "
        val s4 = "hover exception"
        val s5 = "KAKWETU IS WORKING"
        val s6 = "please wait few seconds..."
        val s7 = "afce792d"
        val s8 = "numero"
        val s9 = "montant"
        try {
            Log.d(s199, s299 + Hover.getPresentSims(this))
            Log.d(s199, s3 + Hover.getAllValidActions(this))
        } catch (e: Exception) {
            Log.e(s199, s4, e)
        }
        try {
            val i: Intent = HoverParameters.Builder(this).setHeader(s5)
                    .initialProcessingMessage(s6)
                    .request(s7).finalMsgDisplayTime(0)
                    .extra(s8, phone)
                    .extra(s9, amount)
                    .buildIntent()
            startActivityForResult(i, 299)
        } catch (e: Exception) {
            return
        }
    }

    private fun ci(phone: String?, amount: String?) {
        val s199 = "MainActivity"
        val s299 = "Sims are = "
        val s3 = "Hover actions are = "
        val s4 = "hover exception"
        val s5 = "KAKWETU IS WORKING"
        val s6 = "please wait few seconds..."
        val s7 = "d591ee78"
        val s8 = "numero"
        val s9 = "montant"
        try {
            Log.d(s199, s299 + Hover.getPresentSims(this))
            Log.d(s199, s3 + Hover.getAllValidActions(this))
        } catch (e: Exception) {
            Log.e(s199, s4, e)
        }
        try {
            val i: Intent = HoverParameters.Builder(this).setHeader(s5)
                    .initialProcessingMessage(s6)
                    .request(s7).finalMsgDisplayTime(0)
                    .extra(s8, phone)
                    .extra(s9, amount)
                    .buildIntent()
            startActivityForResult(i, 99)
        } catch (e: Exception) {
            return
        }
    }

    private fun checkAppCloning() {
        val path = filesDir.path
        if (path.contains(DUAL_APP_ID_999)) {
            killProcess()
        } else {
            val count = getDotCount(path)
            if (count > APP_PACKAGE_DOT_COUNT) {
                killProcess()
            }
        }
    }

    private fun getDotCount(path: String): Int {
        var count = 0
        for (i in 0 until path.length) {
            if (count > APP_PACKAGE_DOT_COUNT) {
                break
            }
            if (path[i] == DOT) {
                count++
            }
        }
        return count
    }

    private fun killProcess() {
        this.finish()
        Process.killProcess(Process.myPid())
    }
    companion object {
        private const val CHANNEL = "it.fab.bi/hover"
        private const val APP_PACKAGE_DOT_COUNT = 3
        private const val DUAL_APP_ID_999 = "999"
        private const val DOT = '.'
    }
}
