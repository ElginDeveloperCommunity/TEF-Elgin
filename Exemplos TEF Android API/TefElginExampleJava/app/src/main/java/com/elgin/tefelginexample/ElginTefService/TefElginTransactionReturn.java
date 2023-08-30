package com.elgin.tefelginexample.ElginTefService;

final public class TefElginTransactionReturn {
    public final String administradora;
    public final String autorizacao;
    public final String cnpjRede;
    public final String data;
    public final String mensagem;
    public final String nsu;
    public final String nsuRede;
    public final String numeroCartao;
    public final String getNumeroCartao;
    public final String parcelamento;
    public final String parcelas;
    public final String rede;
    public final String tipoCartao;
    public final String valor;
    public final String vencimento;
    public final String viaCliente;
    public final String viaEstabelecimento;
    public final String viaSMS;

    public TefElginTransactionReturn(String administradora, String autorizacao, String cnpjRede, String data, String mensagem, String nsu, String nsuRede, String numeroCartao, String getNumeroCartao, String parcelamento, String parcelas, String rede, String tipoCartao, String valor, String vencimento, String viaCliente, String viaEstabelecimento, String viaSMS) {
        this.administradora = administradora;
        this.autorizacao = autorizacao;
        this.cnpjRede = cnpjRede;
        this.data = data;
        this.mensagem = mensagem;
        this.nsu = nsu;
        this.nsuRede = nsuRede;
        this.numeroCartao = numeroCartao;
        this.getNumeroCartao = getNumeroCartao;
        this.parcelamento = parcelamento;
        this.parcelas = parcelas;
        this.rede = rede;
        this.tipoCartao = tipoCartao;
        this.valor = valor;
        this.vencimento = vencimento;
        this.viaCliente = viaCliente;
        this.viaEstabelecimento = viaEstabelecimento;
        this.viaSMS = viaSMS;
    }
}