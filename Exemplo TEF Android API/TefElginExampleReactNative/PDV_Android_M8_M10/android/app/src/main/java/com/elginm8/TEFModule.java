package com.elginm8;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Promise;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import androidx.annotation.NonNull;
import android.content.Intent;
import android.widget.Toast;
import android.util.Log;
import android.view.View;
import android.content.pm.ActivityInfo;
// import Arguments
import com.facebook.react.bridge.Arguments;


import java.util.Map;
import java.util.HashMap;

import com.elgin.e1.pagamentos.tef.ElginTef;

public class TEFModule extends ReactContextBaseJavaModule implements ActivityEventListener {
    public static ReactApplicationContext reactContext;
    public Activity mactivity;

   TEFModule(ReactApplicationContext context) {
        super(context);
        this.reactContext = context;
        reactContext.addActivityEventListener(this);
   }

    @Override
    public String getName() { return "TEFModule"; }
    public void onNewIntent(Intent intent) {}
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {}

    private final Handler mHandler = new Handler(Looper.getMainLooper()) {
        @Override
        public void handleMessage(@NonNull Message msg) {
            try {
                super.handleMessage(msg);

                final int MENSAGEM_PROGRESSO = 1;
                final int OPCAO_COLETA = 2;
                final int INFORMAR_VALOR = 3;
                final int DADOS_TRANSACAO = 4;
                final int FINALIZAR = 5;
                final int TESTE_PIX = 6;

                String mensagem = "";
                WritableMap params = Arguments.createMap();


                switch (msg.what) {
                    case MENSAGEM_PROGRESSO:
                        mensagem = ElginTef.ObterMensagemProgresso();
                        break;
                    case OPCAO_COLETA:
                        mensagem = ElginTef.ObterOpcaoColeta();
                        break;
                    case INFORMAR_VALOR:
                        mensagem = ElginTef.ObterMensagemProgresso();
                        break;
                    case DADOS_TRANSACAO:
                        mensagem = ElginTef.ObterDadosTransacao();
                        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("tefResult", mensagem);
                        break;
                    case FINALIZAR:
                        mensagem = ElginTef.ObterMensagemProgresso();
                        break;
                    case TESTE_PIX:
                        mensagem = ElginTef.ObterMensagemProgresso();
                        break;
                    default:
                        throw new AssertionError(msg.what);
                }

                params.putString("message", mensagem);
                params.putInt("type", msg.what);
                reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("TefHandler", params);

            } catch (Exception e) {
                e.printStackTrace();
                throw new AssertionError(e);
            }
        }
    };

    @ReactMethod
    public void initTEF(Promise promise) {
        Activity mactivity = getCurrentActivity();
        ElginTef.setContext(mactivity);
        ElginTef.setHandler(mHandler);

        WritableMap map = Arguments.createMap();
        map.putBoolean("result", true);
        map.putString("message", "TEF Iniciado");
        promise.resolve(map);
    }

    @ReactMethod
    public void automationData(String name, String version, String tef_screen_text) {
        try {
            ElginTef.InformarDadosAutomacao(name, version, tef_screen_text, "");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ReactMethod
    public void activateTerminal(String document, Promise promise) {
        try {
            ElginTef.AtivarTerminal(document);

            WritableMap map = Arguments.createMap();
            map.putBoolean("result", true);
            map.putString("message", "Terminal Iniciado");
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void startDebitTransaction(String value, Promise promise) {
        try {
            ElginTef.RealizarTransacaoDebito(value);

            WritableMap map = Arguments.createMap();
            map.putBoolean("result", true);
            map.putString("message", "Transação Iniciada");
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void startCreditTransaction(String value, String tipo_financiamento, String numero_parcelas,Promise promise) {
        try {
            ElginTef.RealizarTransacaoCredito(value, tipo_financiamento, numero_parcelas);

            WritableMap map = Arguments.createMap();
            map.putBoolean("result", true);
            map.putString("message", "Transação Iniciada");
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    @ReactMethod
    public void printDailyReport() {
        try {
            ElginTef.ImprimirRelatorioDiario();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ReactMethod
    public void startPIXTransaction(String value) {
        try {
            ElginTef.RealizarTransacaoPIX(value);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @ReactMethod
    public void printLastReceipt() {
        try {
            ElginTef.ReimprimirUltimoComprovante();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ReactMethod
    public void cancelCurrentSale() {
        try {
            ElginTef.RealizarCancelamentoOperacao();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ReactMethod
    public void cancelSale(String valorTotal, String nsu, String data) {
        try {
            ElginTef.RealizarCancelamentoTransacao(valorTotal, nsu, data);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}