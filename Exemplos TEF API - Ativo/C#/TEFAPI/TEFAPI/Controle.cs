using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using Newtonsoft.Json;
using System.Windows;

namespace TEFAPI
{
    internal class Controle
    {
        // CONSTANTES PARA TIPO FLUXO
        public const int TIPO_FLUXO_SOLICITACAO_CAPTURA = 0;
        public const int TIPO_FLUXO_PROSSEGUIR_CAPTURA = 1;
        public const int TIPO_FLUXO_CANCELAR_CAPTURA = 2;
        public const int TIPO_FLUXO_RETORNAR_CAPTURA = 3;
        public const int TIPO_FLUXO_SEGUIR_FLUXO = 4;

        // OPERAÇÕES DE PAGAMENTO
        public const int PAGAMENTO_DEBITO = 1;
        public const int PAGAMENTO_CREDITO = 2;
        public const int OPERACAO_CANCELAMENTO_ADM = 12;
        public const int OPERACAO_REIMPERSSAO = 128;
        public const int OPERACAO_CONFIGURACAO = 256;
        public const int OPERACAO_CANCELMAENTO = 512;

        // OP��ES PARA CONFIRMA��O DA TRANSA��O OU CANCELAMENTO
        public const int CANCELAR_OPERACAO = 0;
        public const int CONFIRMAR_OPERACAO = 1;

        // OP��ES PARA FINALIZA��O DA OPERA��O
        public const int FINALIZAR_TRANSACAO = 0;  // Automa��o comercial continuar� executando.
        public const int FINALIZAR_AUTOMACAO = 1; // Automa��o comercial est� sendo encerrada

        static int retorno;
        public int operacao = 0;

        /// <summary>
        /// Chama função da dll api para autenticar o pdv
        /// </summary>
        /// <returns></returns>
        public static string Autenticador()
        {
            try
            {
                retorno = ApiTEF.ElginTEF_Autenticador();
                if (retorno == 0)
                {
                    return retorno.ToString();
                }
                else
                {
                    MessageBox.Show("Houve um erro na autenticação, mais informações na área de Logs", "Alerta");
                    return retorno.ToString();
                }
            }
            catch (Exception err)
            {
                return err.ToString();
            }
        }

        // inicia a operação se a verificação das informações retorna 0
        public static string IniciaOperacao()
        {
            retorno = ApiTEF.ElginTEF_IniciarOperacaoTEF();
            if (retorno == 0)
            {
                return retorno.ToString();
            }
            else
            {
                MessageBox.Show("Houve um erro ao iniciar, mais informações na área de Logs", "Alerta");
                return retorno.ToString();
            }
        }
        
        /// <summary>
        /// Função chamada pelo TEFLoop() para comunicar com a API.
        /// A API modifica o json enviado (passado por referência / ponteiro), adicionando e modificando campos a serem tratados
        /// pelas funções que atualizarão a tela do usuário.
        /// </summary>
        /// <param name="CodOpe">código da operação, ex: crédito, débito.</param>
        /// <param name="json_req">String json que será modifica pela API</param>
        /// <returns></returns>
        public static string RealizaPagamento(int CodOpe, string json_req)
        {
            try
            {
                StringBuilder json_string = new StringBuilder(json_req, json_req.Length + 4096);
                int tamD = json_string.Length;
                retorno = ApiTEF.ElginTEF_RealizarPagamentoTEF(CodOpe, json_string, ref tamD);

                Variaveis.AtualizarDicEJsonAPI(json_string.ToString());
                return json_string.ToString();
            }
            catch (Exception err)
            {
                return err.ToString();
            }
        }

        /// <summary>
        /// Função chamada pelo TEFLoop() para comunicar com a API.
        /// A API modifica o json enviado (passado por referência / ponteiro), adicionando e modificando campos a serem tratados
        /// pelas funções que atualizarão a tela do usuário.
        /// </summary>
        /// <param name="CodOpe">código da operação, ex: Cancelamento, Reimpressão.</param>
        /// <param name="json_req">String json que será modifica pela API</param>
        /// <returns></returns>
        public static string RealizaADM(int CodOpe, string json_req)
        {
            try
            {
                StringBuilder json_string = new StringBuilder(json_req, json_req.Length + 4096);
                int tamD = json_string.Length;
                retorno = ApiTEF.ElginTEF_RealizarAdmTEF(CodOpe, json_string, ref tamD);

                Variaveis.AtualizarDicEJsonAPI(json_string.ToString());
                return json_string.ToString();
            }
            catch (Exception err)
            {
                return err.ToString();
            }
        }

        /// <summary>
        /// Função chamada pelo TEFLoop() para comunicar com a API.
        /// A API modifica o json enviado (passado por referência / ponteiro), adicionando e modificando campos a serem tratados
        /// pelas funções que atualizarão a tela do usuário.
        /// </summary>
        /// <param name="json_req">String json que será modifica pela API</param>
        /// <returns></returns>
        public static string RealizaConfiguracao(string json_req)
        {
            try
            {
                StringBuilder json_string = new StringBuilder(json_req, json_req.Length + 4096);
                int tamD = json_string.Length;
                retorno = ApiTEF.ElginTEF_RealizarConfiguracao(json_string, ref tamD);

                Variaveis.AtualizarDicEJsonAPI(json_string.ToString());
                return json_string.ToString();
            }
            catch (Exception err)
            {
                return err.ToString();
            }
        }

        // =====================================================================================
        // FUNÇÃO QUE REALIZA A CHAMADA DA API PARA AS FUNÇÕES QUE FUNCIONAM EM FLUXO CONTINUADO
        public static string FluxoColeta(int operacao)
        {
            // QUANDO A COLETA É FINALIZADA A SEQUENCIA CAPTURA RETORNA 99 E O FLUXO DEVE SER ENCERRADO
            if (Variaveis.Dic["SequenciaCaptura"].ToString() == "99")
            {
                return "";
            }

            // PROCESSA OPERACAO PAGAMENTO
            if (operacao == PAGAMENTO_CREDITO || operacao == PAGAMENTO_DEBITO || operacao == 0)
            {

                Variaveis.JsonAPI = JsonConvert.SerializeObject(Variaveis.Dic, Formatting.Indented);
                string x = RealizaPagamento(operacao, Variaveis.JsonAPI);
                return x;
            }
            // PROCESSA OPERACAO CONFIGURAÇÃO AMBIENTE
            else if (operacao == OPERACAO_CONFIGURACAO)
            {
                // realizar configuração
                string x = RealizaConfiguracao(Variaveis.JsonAPI);
                return x;
            }
            // PROCESSA OPERACAÇÃO ADMINISTRATIVA   
            else if (operacao == OPERACAO_CANCELAMENTO_ADM || operacao == OPERACAO_REIMPERSSAO)
            {
                // realizar adm
                string x = RealizaADM(operacao, Variaveis.JsonAPI);
                return x;
            }
            else if (operacao == OPERACAO_CANCELMAENTO)
            {
                // realiza cancelamento
                string x = RealizaADM(operacao, Variaveis.JsonAPI);
                return x;
            }
            // OPERAÇÃO INDEFINIDA
            else
            {
                return "OPERAÇÃO INDEFINIDA";
            }
            
        }

        // =================================================================================
        // FUNÇÃO RESPONDÁVEL POR FINALIZAR A OPERAÇÃO DE TEF, CONFIRMANDO OU NÃO A OPERAÇÃO
        public static string FinalizaOperacao(int confirmacao)
        {
            int result = 0;

            // VALIDA PARAMETRO PASSADO À FUNÇÃO PARA REALIZAR A CONFIRMAÇÃO
            if (confirmacao != CONFIRMAR_OPERACAO && confirmacao != CANCELAR_OPERACAO)
            {
                string alerta = "Parametro Inválido";
                MessageBox.Show(alerta, "Alerta");
                return alerta;
            }

            result = ApiTEF.ElginTEF_ConfirmarOperacaoTEF(confirmacao);
            if (result != 0)
            {
                string alerta = "Erro na confirmação: " + result;
                MessageBox.Show(alerta, "Alerta");
                return alerta;
            }

            result = ApiTEF.ElginTEF_FinalizarOperacaoTEF(FINALIZAR_TRANSACAO);            
            if (result != 0)
            {
                string alerta = "Erro na confirmação: " + result;
                MessageBox.Show(alerta, "Alerta");
                return alerta;
            }

            return "SUCESSO";
        }
    }
}