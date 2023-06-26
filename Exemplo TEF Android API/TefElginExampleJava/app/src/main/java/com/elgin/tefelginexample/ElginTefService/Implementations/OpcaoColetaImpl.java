package com.elgin.tefelginexample.ElginTefService.Implementations;

import android.app.AlertDialog;
import android.content.Context;

import com.elgin.e1.pagamentos.tef.ElginTef;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import java.util.function.Predicate;

public class OpcaoColetaImpl implements Function<String, Optional<AlertDialog.Builder>> {

    private final Context mContext;

    private static final String OPCAO_COLETA_DELIMITER = "\n";

    public OpcaoColetaImpl(Context mContext) {
        this.mContext = mContext;
    }

    @Override
    public Optional<AlertDialog.Builder> apply(String opcaoColeta) {

        // As opções dispníveís estão separar por uma quebra de linha, este é SOMENTE para o caso da escolha do número de parcelas, pois as opções fornecidas são de 2 a 100. Reduzindo o número de opções por questões de Layout.
        String[] selectableOptions = Arrays.stream(opcaoColeta.split(OPCAO_COLETA_DELIMITER)).limit(6).toArray(String[]::new);

        final AlertDialog.Builder builder = new AlertDialog.Builder(mContext);

        // O título do Alert dependerá de qual opção se trata:
        builder.setTitle(titleForOpcaoColeta(Arrays.asList(selectableOptions)));

        builder.setItems(selectableOptions, (dialog, idxSelected) -> {
            try {
                ElginTef.InformarOpcaoColeta(selectableOptions[idxSelected]);
            } catch (Exception e) {
                e.printStackTrace();
                throw new AssertionError(e);
            }
        });

        return Optional.of(builder);
    }

    private enum OpcaoColetaRequest {
        SELECT_PAYMENT_METHOD("Seleciona o método de pagamento:", options -> options.equals(Arrays.asList("Credito", "Debito"))),
        SELECT_DEBIT_DATE("Selecione a data do seu pagamento débito:", options -> options.equals(Arrays.asList("A vista", "Pre-datado"))),
        SELECT_DEBIT_INSTALLMENT_OR_USEREDE("Selecione se irá utilizar userede ou crediário", options -> options.equals(Arrays.asList("Debito-Userede", "Crediario-Userede"))),
        SELECT_IS_INSTALLMENT("Selecione se a vista ou parcelado:", options -> options.equals(Arrays.asList("A vista", "Parcelado"))),
        SELECT_INSTALLMENT_METHOD("Selecione o método de parcelamento:", options -> options.equals(Arrays.asList("Estabelecimento", "Administradora"))),
        SELECT_NUMBER_OF_INSTALLMENTS("Selecione o número de parcelas:", options -> options.contains("2"));

        final String titleMessage;
        final Predicate<List<String>> isThisOptionRequest;

        OpcaoColetaRequest(String titleMessage, Predicate<List<String>> isThisOptionRequest) {
            this.titleMessage = titleMessage;
            this.isThisOptionRequest = isThisOptionRequest;
        }
    }

    // Seleciona o título mais acertivo pro alert de escolha de opção de coleta.
    private String titleForOpcaoColeta(List<String> opcaoColeta) {
        for (OpcaoColetaRequest opcaoColetaRequest : OpcaoColetaRequest.values()) {
            if (opcaoColetaRequest.isThisOptionRequest.test(opcaoColeta)) {
                return opcaoColetaRequest.titleMessage;
            }
        }
        throw new AssertionError(opcaoColeta); // Todos os casos foram cobertos, um valor deve ter sido retornado.
    }
}
