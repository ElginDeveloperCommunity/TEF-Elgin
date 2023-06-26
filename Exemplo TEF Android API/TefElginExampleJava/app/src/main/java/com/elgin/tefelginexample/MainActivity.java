package com.elgin.tefelginexample;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.content.res.AppCompatResources;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Looper;
import android.os.Handler;
import android.os.Message;
import android.preference.PreferenceManager;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import static com.elgin.tefelginexample.ElginTefService.TefElginImpl.*;

import com.elgin.e1.pagamentos.tef.ElginTef;
import com.elgin.tefelginexample.ElginTefService.Masks.InputMaskMoney;
import com.elgin.tefelginexample.ElginTefService.TefElginImpl;
import com.elgin.tefelginexample.ElginTefService.TefElginTransactionReturn;
import com.google.gson.Gson;
import com.google.gson.JsonParser;

import com.elgin.e1.Impressora.Termica;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.stream.Collectors;

public class MainActivity extends AppCompatActivity {
    // Objeto com implementação do comportamento do TEF.
    private TefElginImpl tefElginImplObj;

    // Objeto SharedPreferences utilizado para manter o CNPJ inserido em cache.
    private SharedPreferences sharedPreferences;

    // Chave para o cnpj cacheado.
    private final static String CACHE_KEY_CNPJ = "cachedCnpj";

    // Dados para configuração inicial.
    private static final DadosAutomacao dadosAutomacaoExample = new DadosAutomacao("ElginTef Android", "1.0.0.1", "ElginTef", "");
    private static final String cnpjCpfElgin = "";

    // Formas de pagamento disponíveis.
    private enum FormaPagamento {
        CREDITO, DEBITO, TODOS
    }

    // Formas de financiamento disponíveis.
    private enum FormaFinanciamento {
        LOJA("3"), ADM("2"), A_VISTA("1");

        // Cada forma de financiamento tem um valor que deve ser passado ao TEF ELGIN.
        private final String valorTefElgin;

        FormaFinanciamento(String valorTefElgin) {
            this.valorTefElgin = valorTefElgin;
        }
    }

    // Ações disponíveis, correspondente aos botões na tela.
    private enum Acao {
        VENDA, CANCELAMENTO
    }

    // Variáveis de controle de seleção na tela.
    private FormaPagamento formaPagamentoSelecionada;
    private FormaFinanciamento formaFinanciamentoSelecionada;

    // Ultima referência de venda, necessária para o cancelamento de venda no TEF ELGIN.
    public static String lastElginTefNSU = "";

    //// Views ////

    // Botões de formas de pagamento.
    private Button buttonCreditOption, buttonDebitOption, buttonVoucherOption;

    // Botões de forma de parcelamento.
    private Button buttonStoreOption, buttonAdmOption, buttonCashOption;

    // Botões de ações.
    private Button buttonSendTransaction, buttonCancelTransaction, buttonResetCachedCNPJ, buttonPIX;

    // TextViews.
    private EditText editTextValueTEF, editTextInstallmentsTEF;

    // Captura o layout referente aos botoões de financiamento, para aplicar a lógica de sumir estas opções caso o pagamento por débito seja selecionado.
    private LinearLayout linearLayoutInstallmentsMethodsTEF;

    // Captura o layout referente ao campo de "número de parcelas", para aplicar a loǵica de sumir este campo caso o pagamento por débito seja selecionado.
    private LinearLayout linearLayoutNumberOfInstallmentsTEF;

    public static TextView textViewViaTef;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Printer initialization
        startInternalPrinter();

        // SharedPreferences initalization
        sharedPreferences = getPreferences(MODE_PRIVATE);

        // Layout settings
        layoutConfig();

        startTefElgin();
    }

    private void startTefElgin() {
        if (!sharedPreferences.contains(CACHE_KEY_CNPJ)) {
            askCnpjCpf();
        }
        else {
           tefElginImplObj = new TefElginImpl(this, dadosAutomacaoExample, readCnpjFromPreferences());
        }
    }

    private void layoutConfig() {
        initEditTextViews();
        initLayoutChangesViews();
        initOptionsButtonViews();

        applyInitialActivityState();
    }

    private String readCnpjFromPreferences() {
        return sharedPreferences.getString(CACHE_KEY_CNPJ, ""); // The empty default "" string will be used for the cnpj reset/update button operation
    }

    private void writeCnpjOnPreferences(String cnpj) {
        sharedPreferences.edit().putString(CACHE_KEY_CNPJ, cnpj).apply();
    }

    private void askCnpjCpf() {
        AlertDialog.Builder alert = new AlertDialog.Builder(this);

        final EditText edittext = new EditText(this);
        edittext.setText(readCnpjFromPreferences());

        alert.setTitle("Entre com o CNPJ/CPF");

        edittext.setText(cnpjCpfElgin);

        alert.setView(edittext);

        alert.setPositiveButton("Conectar no servidor!", (dialog, whichButton) ->
        {

            final String insertedCnpjCpf = edittext.getText().toString();
            if(insertedCnpjCpf.isEmpty()) {
                Toast.makeText(this, "O CNPJ não pode ser vazio!", Toast.LENGTH_LONG).show();
                finish();
            }

            writeCnpjOnPreferences(insertedCnpjCpf);

            // Inicia o Tef Elgin, conecta no servidor.
            startTefElgin();
        });

        alert.setCancelable(false);

        alert.show();
    }

    // Inicia a impressora interna do dispositivo.
    private void startInternalPrinter() {
        Termica.setActivity(this);
        Termica.AbreConexaoImpressora(6, "M10", "", 0);
    }

    @Override
    protected void onStop() {
        super.onStop();

        // Ao final, fecha a conexão com a impressora interna.
        Termica.FechaConexaoImpressora();
    }

    private void initEditTextViews() {
        editTextValueTEF = findViewById(R.id.editTextInputValueTEF);
        editTextInstallmentsTEF = findViewById(R.id.editTextInputInstallmentsTEF);

        // Adiciona máscara ao input de valor.
        editTextValueTEF.addTextChangedListener(new InputMaskMoney(editTextValueTEF));
        // Valor inicial de 20 reais.
        editTextValueTEF.setText("2000");

        // Campo de apresentação de Via cliente e relatório da transação.
        textViewViaTef = findViewById(R.id.textViewViaTef);
        // Torna o campo rolável.
        textViewViaTef.setMovementMethod(new ScrollingMovementMethod());
    }

    private void initLayoutChangesViews() {
        linearLayoutNumberOfInstallmentsTEF = findViewById(R.id.linearLayoutNumberOfInstallmentsTEF);
        linearLayoutInstallmentsMethodsTEF = findViewById(R.id.linearLayoutInstallmentsMethodsTEF);
    }

    private void initOptionsButtonViews() {
        //// Botões de formas de pagamento ////

        buttonCreditOption = findViewById(R.id.buttonCreditOption);
        buttonDebitOption = findViewById(R.id.buttonDebitOption);
        buttonVoucherOption = findViewById(R.id.buttonVoucherOption);

        buttonCreditOption.setOnClickListener(v -> updatePaymentMethodBusinessRule(FormaPagamento.CREDITO));
        buttonDebitOption.setOnClickListener(v -> updatePaymentMethodBusinessRule(FormaPagamento.DEBITO));
        buttonVoucherOption.setOnClickListener(v -> updatePaymentMethodBusinessRule(FormaPagamento.TODOS));

        //// Botões de formas de parcelamento

        buttonStoreOption = findViewById(R.id.buttonStoreOption);
        buttonAdmOption = findViewById(R.id.buttonAdmOption);
        buttonCashOption = findViewById(R.id.buttonCashOption);

        buttonStoreOption.setOnClickListener(v -> updateInstallmentMethodBusinessRule(FormaFinanciamento.LOJA));
        buttonAdmOption.setOnClickListener(v -> updateInstallmentMethodBusinessRule(FormaFinanciamento.ADM));
        buttonCashOption.setOnClickListener(v -> updateInstallmentMethodBusinessRule(FormaFinanciamento.A_VISTA));

        //// Botões de ação ////
        buttonSendTransaction = findViewById(R.id.buttonSendTransactionTEF);
        buttonCancelTransaction = findViewById(R.id.buttonCancelTransactionTEF);
        buttonResetCachedCNPJ = findViewById(R.id.buttonResetCachedCNPJ);

        buttonSendTransaction.setOnClickListener(v -> {
            if (isEntriesValid()) {
                try {
                    sendTefElginAction(Acao.VENDA);
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new AssertionError(e);
                }
            }
        });

        buttonCancelTransaction.setOnClickListener(v -> {
            if (isEntriesValid()) {
                try {
                    sendTefElginAction(Acao.CANCELAMENTO);
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new AssertionError(e);
                }
            }
        });


        buttonResetCachedCNPJ.setOnClickListener(v -> askCnpjCpf());
    }

    // Aplica a configuração inicial do Tef ao abrir da atividade.
    private void applyInitialActivityState() {
        updatePaymentMethodBusinessRule(FormaPagamento.CREDITO);
        updateInstallmentMethodBusinessRule(FormaFinanciamento.A_VISTA);
    }

    // Atualiza as regras e decoração de tela, de acordo com a forma de pagamento selecionada.
    private void updatePaymentMethodBusinessRule(FormaPagamento formaPagamentoSelecionada) {
        // Atualiza a váriavel de controle.
        this.formaPagamentoSelecionada = formaPagamentoSelecionada;

        // 1. Caso a opção de débito ou todos seja seleciona, o campo "número de parcelas" devem sumir, caso a opção selecionada seja a de crédito, o campo deve reaparecer.
        linearLayoutNumberOfInstallmentsTEF.setVisibility(formaPagamentoSelecionada != FormaPagamento.CREDITO ? View.INVISIBLE : View.VISIBLE);

        // 2. Caso a opção de débito ou todos seja selecionada, os botões "tipos de parcelamento" devem sumir, caso a opção de crédito seja selecionada, devem reaparecer.
        linearLayoutInstallmentsMethodsTEF.setVisibility(formaPagamentoSelecionada != FormaPagamento.CREDITO ? View.INVISIBLE : View.VISIBLE);

        // 3. Muda a coloração da borda dos botões de formas de pagamento, conforme o método seleciondo.
        buttonCreditOption.setBackgroundTintList(AppCompatResources.getColorStateList(this, formaPagamentoSelecionada == FormaPagamento.CREDITO ? R.color.verde : R.color.black));
        buttonDebitOption.setBackgroundTintList(AppCompatResources.getColorStateList(this, formaPagamentoSelecionada == FormaPagamento.DEBITO ? R.color.verde : R.color.black));
        buttonVoucherOption.setBackgroundTintList(AppCompatResources.getColorStateList(this, formaPagamentoSelecionada == FormaPagamento.TODOS ? R.color.verde : R.color.black));
    }

    // Atualiza as regras e decoração de tela, de acordo com a forma de parcelamento selecionada.
    private void updateInstallmentMethodBusinessRule(FormaFinanciamento formaFinanciamentoSelecionada) {
        // Atualiza a variável de controle.
        this.formaFinanciamentoSelecionada = formaFinanciamentoSelecionada;

        // 1. Caso a forma de parcelamento selecionada seja a vista, o campo "número de parcelas" deve ser "travado" em "1", caso contrário o campo deve ser destravado e inserido "2", pois é o minimo de parcelas para as outras modalidades.
        editTextInstallmentsTEF.setEnabled(formaFinanciamentoSelecionada != FormaFinanciamento.A_VISTA);
        editTextInstallmentsTEF.setText(formaFinanciamentoSelecionada == FormaFinanciamento.A_VISTA ? "1" : "2");

        // 2. Muda a coloração da borda dos botões de formas de parcelamento, conforme o método seleciondo.
        buttonStoreOption.setBackgroundTintList(AppCompatResources.getColorStateList(this, formaFinanciamentoSelecionada == FormaFinanciamento.LOJA ? R.color.verde : R.color.black));
        buttonAdmOption.setBackgroundTintList(AppCompatResources.getColorStateList(this, formaFinanciamentoSelecionada == FormaFinanciamento.ADM ? R.color.verde : R.color.black));
        buttonCashOption.setBackgroundTintList(AppCompatResources.getColorStateList(this, formaFinanciamentoSelecionada == FormaFinanciamento.A_VISTA ? R.color.verde : R.color.black));
    }

    private void sendTefElginAction(Acao acao) throws Exception {
        final String treatedvalue = getTextValueTEFClean();

        switch (acao) {
            case VENDA:
                switch (formaPagamentoSelecionada) {
                    case CREDITO:
                        ElginTef.RealizarTransacaoCredito(treatedvalue, formaFinanciamentoSelecionada.valorTefElgin, editTextInstallmentsTEF.getText().toString());
                        break;
                    case DEBITO:
                        ElginTef.RealizarTransacaoDebito(treatedvalue);
                        break;
                    case TODOS:
                        ElginTef.RealizarTransacao();
                        break;
                }
                break;
            case CANCELAMENTO:
                if (lastElginTefNSU.isEmpty()) {
                    alertMessageStatus("Alert", "É necessário realizar uma transação antres para realizar o cancelamento no TEF ELGIN!");
                    return;
                }

                // Data do dia de hoje, usada como um dos parâmetros necessário para o cancelamento de transação no TEF Elgin.
                Date todayDate = new Date();

                // Objeto capaz de formatar a date para o formato aceito pelo Elgin TEF dd/MM/yy. Para esta aplicação exemplo apenas será enviado a data atual, uma vez que se tratam de vendas feitas em servidor de homologação.
                SimpleDateFormat dateFormatter = new SimpleDateFormat("dd/MM/yy");

                final String todayDateAsString = dateFormatter.format(todayDate);

                ElginTef.RealizarCancelamentoTransacao(treatedvalue, lastElginTefNSU, todayDateAsString);
                break;
            default:
                throw new AssertionError(acao); // Ainda não há opção de CONFIGURAÇÃO para o Tef Elgin, a lógica de layout não permite que esta opção seja escolhida.
        }
    }

    // Função que é invocada em uma das ações do handler, invocada quando uma transação é finalizada.
    public static void telElginReturnCapture(String dadosTransacao) {
        TefElginTransactionReturn transactionData = new Gson().fromJson(dadosTransacao, TefElginTransactionReturn.class);

        if (transactionData.viaCliente != null) {
            final String viaCliente = transactionData.viaCliente;

            printTransactionReturn(viaCliente);

            textViewViaTef.setText(viaCliente);
            lastElginTefNSU = transactionData.nsu;
        } else if (dadosTransacao.contains("relatorioTransacoes")) {
            final String relatorioTransacoes = JsonParser.parseString(dadosTransacao).getAsJsonObject().get("relatorioTransacoes").getAsString();

            printTransactionReturn(relatorioTransacoes);

            textViewViaTef.setText(relatorioTransacoes);
        }
    }

    private static void printTransactionReturn(String transactionReturn) {
        Termica.ImpressaoTexto(transactionReturn, 1, 0, 0);
        Termica.Corte(15);
    }

    //// Validacao e Utils ////

    // O valor deve ser passado para o Tef Elgin de acordo de acordo com a máscara ".##", na máscara implementada para valor monetário basta substituir a vírgula pelo ponto.
    private String getTextValueTEFClean() {
        return editTextValueTEF.getText().toString().replaceAll(",", ".");
    }

    // Validação das entradas.
    public boolean isEntriesValid() {
        if (isValueNotEmpty(editTextValueTEF.getText().toString())) {
            if (!isInstallmentEmptyOrLessThanZero(editTextInstallmentsTEF.getText().toString())) {
                alertMessageStatus("Alerta", "Digite um número de parcelas válido maior que 0.");
                return false;
            }
            return true;
        } else {
            alertMessageStatus("Alerta", "Verifique a entrada de valor de pagamento!");
            return false;
        }
    }

    private void alertMessageStatus(String titleAlert, String messageAlert) {
        AlertDialog alertDialog = new AlertDialog.Builder(this).create();
        alertDialog.setTitle(titleAlert);
        alertDialog.setMessage(messageAlert);
        alertDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "OK", (dialog, which) -> dialog.dismiss());
        alertDialog.show();
    }

    private static boolean isValueNotEmpty(String inputTextValue) {
        return !inputTextValue.equals("");
    }

    private boolean isInstallmentEmptyOrLessThanZero(String inputTextInstallment) {
        return !inputTextInstallment.equals("") && Integer.parseInt(inputTextInstallment) > 0;
    }

    private Handler handler = new Handler(Looper.getMainLooper()) {
        @Override
        public void handleMessage(@NonNull Message msg) {
            super.handleMessage(msg);

            String saidaTexto = (String) msg.obj;
            Integer saidaInt = msg.what;
            String toToast = "OBJ: " + saidaTexto + ", WHAT: " + saidaInt;
            Toast.makeText(getApplicationContext(), toToast, Toast.LENGTH_LONG).show();
        }
    };
}