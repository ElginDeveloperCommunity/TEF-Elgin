package com.elgin.tefelginexample.ElginTefService;

import android.app.AlertDialog;
import android.content.Context;
import android.os.Looper;
import android.os.Message;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.elgin.e1.pagamentos.tef.ElginTef;
import com.elgin.tefelginexample.ElginTefService.Implementations.DadosPixImpl;
import com.elgin.tefelginexample.ElginTefService.Implementations.DadosTransacaoImpl;
import com.elgin.tefelginexample.ElginTefService.Implementations.FinalizarImpl;
import com.elgin.tefelginexample.ElginTefService.Implementations.InformarValorImpl;
import com.elgin.tefelginexample.ElginTefService.Implementations.MensagemProgressoImpl;
import com.elgin.tefelginexample.ElginTefService.Implementations.OpcaoColetaImpl;

import android.os.Handler;

import java.util.Optional;
import java.util.function.Function;


public class TefElginImpl {
    // Alert utilizado ao longo da implementação para a apresentação de mensagens e requiremento de informações, a depender da função. É necessário manter mesma instância para que cada operação consiga verificar se já há ou não um alert presente em tela.
    private AlertDialog customDialog;

    // Contexto necessário para a configuração do Tef Elgin, além disto, nesta implementação é utilizado para o uso de alerts e toasts.
    private final Context mContext;

    private final Function<String, Optional<AlertDialog.Builder>> handleMensagemProgresso;

    private final Function<String, Optional<AlertDialog.Builder>> handleOpcaoColeta;

    private final Function<String, Optional<AlertDialog.Builder>> handleInformarValor;

    private final Function<String, Optional<AlertDialog.Builder>> handleDadosTransacao;

    private final Function<String, Optional<AlertDialog.Builder>> handleFinalizar;
    private final Function<String, Optional<AlertDialog.Builder>> handleDadosPIX;

    private final Handler mHandler = new Handler(Looper.getMainLooper()) {
        @Override
        public void handleMessage(@NonNull Message msg) {
            super.handleMessage(msg);

            // Se o alert estiver na tela, remove.
            if (customDialog != null && customDialog.isShowing()) {
                customDialog.dismiss();
            }

            // Valores possíveis para a propiedade "what" do atributo Message do Handler. Cada valor corresponde a uma situação/caso diferente.
            final int MENSAGEM_PROGRESSO = 1;
            final int OPCAO_COLETA = 2;
            final int INFORMAR_VALOR = 3;
            final int DADOS_TRANSACAO = 4;
            final int FINALIZAR = 5;
            final int DADOS_IMAGEM_QRCODE_PIX  = 6;

            // Cria o novo builder de alert, cada case do switch irá definir o builder que formará o novo alert.
            Optional<AlertDialog.Builder> newBuilder = null;

            // Apenas a situação de mensagem de finalizar não deve possuír a opção de cancelamento, uma vez que a operação já finalizou.
            boolean shouldHaveCancellation = true;

            try {
                switch (msg.what) {
                    case MENSAGEM_PROGRESSO:
                        // Captura a mensagem do progresso.
                        final String mensagemProgresso = ElginTef.ObterMensagemProgresso();

                        newBuilder = handleMensagemProgresso.apply(mensagemProgresso);
                        break;
                    case OPCAO_COLETA:
                        final String opcaoColeta = ElginTef.ObterOpcaoColeta();

                        newBuilder = handleOpcaoColeta.apply(opcaoColeta);
                        break;
                    case INFORMAR_VALOR:
                        final String informarValor = ElginTef.ObterMensagemProgresso();

                        newBuilder = handleInformarValor.apply(informarValor);
                        break;
                    case DADOS_TRANSACAO:
                        final String dadosTransacao = ElginTef.ObterDadosTransacao();

                        newBuilder = handleDadosTransacao.apply(dadosTransacao);
                        break;
                    case FINALIZAR:
                        shouldHaveCancellation = false;
                        final String mensagemProgressoFinalizacao = ElginTef.ObterMensagemProgresso();

                        newBuilder = handleFinalizar.apply(mensagemProgressoFinalizacao);
                        break;
                    case DADOS_IMAGEM_QRCODE_PIX:
                        String qrCodeHexa = msg.obj.toString();

                        newBuilder = handleDadosPIX.apply(qrCodeHexa);
                        break;
                    default:
                        throw new AssertionError(msg.what);
                }
            } catch (Exception e) {
                e.printStackTrace();
                throw new AssertionError(e);
            }

            // Adiciona a opção de cancelamento ao builder. Deve ser possível cancelar na maioria das operações.
            if (shouldHaveCancellation && newBuilder.isPresent()) {
                newBuilder.get().setNegativeButton("CANCELAR", (dialog, which) -> {
                    try {
                        ElginTef.RealizarCancelamentoOperacao();
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new AssertionError(e);
                    }
                });
            }

            // A situação de captura de DADOS_TRANSACAO é a única a retornar um AlerDialog.Builder null, portanto apenas se o valor retornando não for nulo deve ser mostrado o alert.
            newBuilder.ifPresent(builder -> {
                customDialog = builder.create();
                customDialog.show();
            });
        }
    };

    // Classe auxiliar para parâmetros de configuração.
    public static class DadosAutomacao {
        private final String acNome;
        private final String acVersao;
        private final String acTextoPinpad;
        private final String acMacPinpad;

        public DadosAutomacao(@NonNull String acNome, @NonNull String acVersao, @NonNull String acTextoPinpad, @NonNull String acMacPinpad) {
            this.acNome = acNome;
            this.acVersao = acVersao;
            this.acTextoPinpad = acTextoPinpad;
            this.acMacPinpad = acMacPinpad;
        }
    }

    public TefElginImpl(Context context, DadosAutomacao dadosAutomacao, String cnpjCpf) {
        this.mContext = context;

        this.handleMensagemProgresso = new MensagemProgressoImpl(mContext);
        this.handleOpcaoColeta = new OpcaoColetaImpl(mContext);
        this.handleInformarValor = new InformarValorImpl(mContext);
        this.handleDadosTransacao = new DadosTransacaoImpl();
        this.handleFinalizar = new FinalizarImpl(mContext);
        this.handleDadosPIX = new DadosPixImpl(mContext);

        initTefElginConfiguration(dadosAutomacao, cnpjCpf);
    }

    // Configuração inicial do Tef Elgin. Com os dados necessários para configuração.
    private void initTefElginConfiguration(DadosAutomacao dadosAutomacao, String cnpjCpf) {
        ElginTef.setContext(mContext);
        ElginTef.setHandler(mHandler);

        ElginTef.InformarDadosAutomacao(dadosAutomacao.acNome, dadosAutomacao.acVersao, dadosAutomacao.acTextoPinpad, dadosAutomacao.acMacPinpad);

        // Toast avisando do ínicio da ativação do terminal.
        Toast.makeText(mContext, "Ativação de terminal iniciada!", Toast.LENGTH_SHORT).show();

        try {
            ElginTef.AtivarTerminal(cnpjCpf);
        } catch (Exception e) {
            e.printStackTrace();
            throw new AssertionError(e);
        }
    }
}
