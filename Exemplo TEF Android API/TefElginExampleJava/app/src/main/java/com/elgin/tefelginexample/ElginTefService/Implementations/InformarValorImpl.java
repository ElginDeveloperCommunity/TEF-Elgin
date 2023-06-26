package com.elgin.tefelginexample.ElginTefService.Implementations;

import android.app.AlertDialog;
import android.content.Context;
import android.text.InputType;
import android.widget.EditText;

import com.elgin.e1.pagamentos.tef.ElginTef;
import com.elgin.tefelginexample.ElginTefService.Masks.InputMaskMoney;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.util.Optional;
import java.util.function.Function;

public class InformarValorImpl implements Function<String, Optional<AlertDialog.Builder>> {

    private final Context mContext;

    public InformarValorImpl(Context mContext) {
        this.mContext = mContext;
    }
    @Override
    public Optional<AlertDialog.Builder> apply(String informarValor) {
        // Inicializa o EditText que será utilizado como view para receber o input do valor.
        final EditText editTextForInputDialog = new EditText(mContext);

        // O retorno da situação de informarValor é um json como {"automacao_coleta_mascara":".##","mensagemResultado":"Valor","automacao_coleta_tipo":"N"}.
        final JsonObject informarValorColetaJson = JsonParser.parseString(informarValor).getAsJsonObject();

        // Define a máscara do InputType.
        final String automacaoColetaMascara = informarValorColetaJson.get("automacao_coleta_mascara").getAsString();

        // Define o tipo de coleta, podendo ser numérica ("N") ou de data ("D)
        final String automacaoColetaTipo = informarValorColetaJson.get("automacao_coleta_tipo").getAsString();

        // Configura o editText de acordo com o tipo de input requisitado.
        configureEditTextInputAccordingly(editTextForInputDialog, automacaoColetaMascara, automacaoColetaTipo);

        // Define a mensagem representado o tipo de dado que devera ser inserido "Valor" ou "Data"
        final String mensagemResultado = informarValorColetaJson.get("mensagemResultado").getAsString();

        final AlertDialog.Builder builder = new AlertDialog.Builder(mContext);

        // Muda o titulo do alert.
        builder.setTitle("Insira o " + mensagemResultado + " da operação.");

        // Realiza o binding do input com o alert.
        builder.setView(editTextForInputDialog);

        // Configurado o alert para apresentar o input esperando a entrada do valor requisitado. O alert deve ser configurado para invocar a função de informação do valor escolhido ao ser clicado.
        builder.setPositiveButton("CONFIRMAR", (dialog, which) -> {
            try {
                ElginTef.InformarOpcaoColeta(editTextForInputDialog.getText().toString().replaceAll(",", ".")); // A máscara implementada utiliza "," ao invés de ".", que é o formato esperado pelo Elgin Tef.
            } catch (Exception e) {
                e.printStackTrace();
                throw new AssertionError(e);
            }
        });

        return Optional.of(builder);
    }

    private void configureEditTextInputAccordingly(EditText editTextForInputDialog, String automacaoColetaMascara, String automacaoColetaTipo) {
        // Se a máscara se referir a conotação monetária que divide os centavos por ".", adicione a mascára ao input.
        if (automacaoColetaMascara.equals(".##")) {
            editTextForInputDialog.setText("0.00");
            editTextForInputDialog.addTextChangedListener(new InputMaskMoney(editTextForInputDialog));
        } else {
            editTextForInputDialog.removeTextChangedListener(new InputMaskMoney(editTextForInputDialog));
            editTextForInputDialog.setHint(automacaoColetaMascara); // Caso contrário, escreve como hint a máscara.
        }

        // Modifica o tipo de input type.
        switch (automacaoColetaTipo) {
            case "N":
                editTextForInputDialog.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
                break;
            case "D":
                editTextForInputDialog.setInputType(InputType.TYPE_CLASS_DATETIME | InputType.TYPE_DATETIME_VARIATION_DATE);
                break;
            default:
                editTextForInputDialog.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_NORMAL);
        }
    }

}
