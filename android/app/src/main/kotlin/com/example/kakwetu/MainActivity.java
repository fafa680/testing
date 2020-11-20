package com.example.fafa;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;
import com.hover.sdk.permissions.PermissionActivity;
import com.hover.sdk.api.Hover;
import com.hover.sdk.api.HoverParameters;

import java.text.Collator;
import java.util.HashMap;
import java.util.Map;
import android.view.WindowManager.LayoutParams;
import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "it.fab.bi/hover";
    private MethodChannel.Result callResult;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        try{
            super.onCreate(savedInstanceState);
            Hover.initialize(this);
           Hover.setBranding("KAKWETU", R.drawable.kakwetu, this);
            GeneratedPluginRegistrant.registerWith(getFlutterEngine());
            getWindow().addFlags(LayoutParams.FLAG_SECURE);
            new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                    (call, result) -> {
    // Get arguments from flutter code
                        final Map<String, Object> arguments = call.arguments();
                        String PhoneNumber = (String) arguments.get("numero");
                        String amount = (String) arguments.get("montant");
                        String aide = (String) arguments.get("object");
                        if (call.method.equals("lumicash")) {
                            lumicash(PhoneNumber, amount,aide);
                            callResult=result;
                        }else if(call.method.equals("ecocash")){
                            ecocash(PhoneNumber,amount);
                            callResult=result;  
                        }else if(call.method.equals("bancobu")){
                            bancobu(PhoneNumber,amount);
                            callResult=result; 
                        }else if(call.method.equals("bbci")){
                            bbci(PhoneNumber,amount);
                            callResult=result; 
                        }else if(call.method.equals("ecobank")){
                            ecobank(PhoneNumber,amount);
                            callResult=result; 
                        }
    
                    });
        }catch (Exception e){
            return;
        }
        
    }

    @Override
    protected void onActivityResult (int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode,resultCode,data);
        try{
            setResult(RESULT_OK,data);
            String[] sessionTextArr = new String[0];
            if ((requestCode == 0 && resultCode == Activity.RESULT_CANCELED)||(requestCode == 1 && resultCode == Activity.RESULT_CANCELED)){
                Toast.makeText(this,"Bye bye",Toast.LENGTH_LONG).show();// "Error: " + data.getStringExtra("error")
            } else if (requestCode == 0) {
                sessionTextArr= data.getStringArrayExtra("ussd_messages");
                String uuid = data.getStringExtra("uuid");
                callResult.success(sessionTextArr[6]);
            }else if(requestCode == 1){
                sessionTextArr= data.getStringArrayExtra("ussd_messages");
                String uuid = data.getStringExtra("uuid");
                callResult.success(sessionTextArr[5]); 
            }else if(requestCode == 2){
                sessionTextArr= data.getStringArrayExtra("ussd_messages");
                String uuid = data.getStringExtra("uuid");
                callResult.success(sessionTextArr[7]);  
            }
        }catch (Exception e){
        return;
        }
    }
    private  void lumicash(String PhoneNumber,String amount,String aide){
        try {

            Log.d("MainActivity", "Sims are = " + Hover.getPresentSims(this));
            Log.d("MainActivity", "Hover actions are = " + Hover.getAllValidActions(this));
        } catch (Exception e) {
            Log.e("MainActivity", "hover exception", e);

        }
        try {
            Intent i = new HoverParameters.Builder(this).setHeader("KAKWETU IS WORKING")
            .initialProcessingMessage("please wait few seconds...")
                    .request("ad8d9951").finalMsgDisplayTime(0)
                    .extra("numero", PhoneNumber)
                    .extra("montant", amount)
                    .extra("object", aide)
                    .buildIntent();
            startActivityForResult(i,0);
        }catch (Exception e){
            return;
        }}
        private  void ecocash(String PhoneNumber,String amount){
            try {
    
                Log.d("MainActivity", "Sims are = " + Hover.getPresentSims(this));
                Log.d("MainActivity", "Hover actions are = " + Hover.getAllValidActions(this));
            } catch (Exception e) {
                Log.e("MainActivity", "hover exception", e);
    
            }
            try {
                Intent i = new HoverParameters.Builder(this).setHeader("KAKWETU IS WORKING")
                .initialProcessingMessage("please wait few seconds...")
                        .request("cec006ec").finalMsgDisplayTime(0)
                        .extra("numero", PhoneNumber)
                        .extra("montant", amount)
                        .buildIntent();
                startActivityForResult(i,0);
            }catch (Exception e){
                return;
            }}
       private  void bancobu(String PhoneNumber,String amount){
        try {

            Log.d("MainActivity", "Sims are = " + Hover.getPresentSims(this));
            Log.d("MainActivity", "Hover actions are = " + Hover.getAllValidActions(this));
        } catch (Exception e) {
            Log.e("MainActivity", "hover exception", e);

        }
        try {
            Intent i = new HoverParameters.Builder(this).setHeader("KAKWETU IS WORKING")
            .initialProcessingMessage("please wait few seconds...")
                    .request("041386d8").finalMsgDisplayTime(0)
                    .extra("numero", PhoneNumber)
                    .extra("montant", amount)
                    .buildIntent();
            startActivityForResult(i,1);
        }catch (Exception e){
            return;
        }}
        private  void ecobank(String PhoneNumber,String amount){
            try {
    
                Log.d("MainActivity", "Sims are = " + Hover.getPresentSims(this));
                Log.d("MainActivity", "Hover actions are = " + Hover.getAllValidActions(this));
            } catch (Exception e) {
                Log.e("MainActivity", "hover exception", e);
    
            }
            try {
                Intent i = new HoverParameters.Builder(this).setHeader("KAKWETU IS WORKING")
                .initialProcessingMessage("please wait few seconds...")
                        .request("afce792d").finalMsgDisplayTime(0)
                        .extra("numero", PhoneNumber)
                        .extra("montant", amount)
                        .buildIntent();
                startActivityForResult(i,2);
            }catch (Exception e){
                return;
            }}
            private  void bbci(String PhoneNumber,String amount){
                try {
        
                    Log.d("MainActivity", "Sims are = " + Hover.getPresentSims(this));
                    Log.d("MainActivity", "Hover actions are = " + Hover.getAllValidActions(this));
                } catch (Exception e) {
                    Log.e("MainActivity", "hover exception", e);
        
                }
                try {
                    Intent i = new HoverParameters.Builder(this).setHeader("KAKWETU IS WORKING")
                    .initialProcessingMessage("please wait few seconds...")
                            .request("d591ee78").finalMsgDisplayTime(0)
                            .extra("numero", PhoneNumber)
                            .extra("montant", amount)
                            .buildIntent();
                    startActivityForResult(i,0);
                }catch (Exception e){
                    return;
                }}
         

}