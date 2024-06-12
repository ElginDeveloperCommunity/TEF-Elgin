package com.elgin.tefelginexample.ElginTefService.Implementations;


import android.app.AlertDialog;
import android.content.Context;
import android.util.Log;

import java.util.Optional;
import java.util.function.Function;

public class MensagemProgressoImpl implements Function<String, Optional<AlertDialog.Builder>> {

    private final Context mContext;

    public MensagemProgressoImpl(Context mContext) {
        this.mContext = mContext;
    }

    @Override
    public Optional<AlertDialog.Builder> apply(String mensagemProgresso) {
        Log.d("MADARA MensagemProgresso", "happened!");

        return Optional.of(new AlertDialog.Builder(mContext)
                .setMessage("Mensagem Progresso")
                .setMessage(mensagemProgresso));
    }
}
