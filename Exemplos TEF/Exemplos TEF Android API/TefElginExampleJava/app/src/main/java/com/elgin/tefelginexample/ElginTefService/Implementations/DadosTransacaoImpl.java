package com.elgin.tefelginexample.ElginTefService.Implementations;

import android.app.AlertDialog;
import com.elgin.tefelginexample.MainActivity;

import java.util.Optional;
import java.util.function.Function;


public class DadosTransacaoImpl implements Function<String, Optional<AlertDialog.Builder>> {

    @Override
    public Optional<AlertDialog.Builder> apply(String dadosTransacao) {
        MainActivity.telElginReturnCapture(dadosTransacao);

        return Optional.empty();
    }
}
