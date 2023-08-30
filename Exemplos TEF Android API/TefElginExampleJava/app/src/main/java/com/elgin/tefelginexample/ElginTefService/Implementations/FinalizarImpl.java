package com.elgin.tefelginexample.ElginTefService.Implementations;

import android.app.AlertDialog;
import android.content.Context;

import java.util.Optional;
import java.util.function.Function;

public class FinalizarImpl implements Function<String, Optional<AlertDialog.Builder>> {

    private final Context mContext;

    public FinalizarImpl(Context mContext) {
        this.mContext = mContext;
    }

    @Override
    public Optional<AlertDialog.Builder> apply(String mensagemProgressoFinalizacao) {
        return Optional.of(new AlertDialog.Builder(mContext).setMessage("Mensagem Finalização")
                .setMessage(mensagemProgressoFinalizacao)
                .setPositiveButton("OK", (dialog, i) -> dialog.dismiss())
        );
    }
}
