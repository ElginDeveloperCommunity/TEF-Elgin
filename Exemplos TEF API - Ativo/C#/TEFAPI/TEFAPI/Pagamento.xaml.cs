using Newtonsoft.Json;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace TEFAPI
{
    /// <summary>
    /// Lógica interna para Pagamento.xaml
    /// </summary>
    public partial class Pagamento : Window
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

        public bool btnOkProsPressed = false;
        public bool btnCancelPressed = false;
        public bool btnVoltarPressed = false;

        const string espaco = "\n============================\n";
        bool seguirFluxo;

        public static string ValorVenda { get; set; }
        public static int Operacao { get; set; }
        
        public Pagamento()
        {
            InitializeComponent();
        }

        // Escreve na área de logs no formato {chave: valor}
        public void EscreveLog(string chave, string valor, string espaco_inicial = "")
        {
            Dispatcher.Invoke(() => {
                LogsEntry.Text += espaco_inicial + chave + ": " + valor + espaco;
                LogsEntry.ScrollToEnd();
            });
        }

        // Escreve uma string na área de logs
        public void EscreveLog(string texto)
        {
            Dispatcher.Invoke(() => {
                LogsEntry.Text += texto + espaco;
                LogsEntry.ScrollToEnd();
            });
        }

        // evento dos botões do teclado numérico, escrevendo seus números no label do valor da venda
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Button b = (Button)sender;
            if (LblValor.Text == "0") { LblValor.Text = b.Content.ToString(); }
            else { LblValor.Text += b.Content.ToString(); }
        }

        // apaga valor da venda
        private void BtnClear_Click(object sender, RoutedEventArgs e)
        {
            LblValor.Text = "";
        }

        // apaga último número escrito no label de venda
        private void BtnBS_Click(object sender, RoutedEventArgs e)
        {
            if (LblValor.Text != "")
            {
                LblValor.Text = LblValor.Text.Remove(LblValor.Text.Length - 1);
            }
        }
        
        // evento botão de débito, inicializa processo e entra no loop principal
        private async void BtnDebito_Click(object sender, RoutedEventArgs e)
        {
            Operacao = PAGAMENTO_DEBITO;
            ValorVenda = LblValor.Text;
            Variaveis.CriaJson(ValorVenda);

            await Task.Factory.StartNew(() => {
                EscreveLog("Operação Iniciada", "Aguarde...", espaco);
                EscreveLog("ElginTEF_Autenticador", Controle.Autenticador());
                EscreveLog("ElginTEF_IniciarOperacaoTEF", Controle.IniciaOperacao().ToString());
                TefLoop();
            });
        }

        // evento botão de crédito, inicializa processo e entra no loop principal
        public async void BtnCredito_Click(object sender, RoutedEventArgs e)
        {
            Operacao = PAGAMENTO_CREDITO;
            ValorVenda = LblValor.Text;
            Variaveis.CriaJson(ValorVenda);
            
            await Task.Factory.StartNew(() => {
                EscreveLog("Operação Iniciada", "Aguarde...", espaco);
                EscreveLog("ElginTEF_Autenticador", Controle.Autenticador());
                EscreveLog("ElginTEF_IniciarOperacaoTEF", Controle.IniciaOperacao().ToString());
                TefLoop();
            });            
        }

        /// <summary>
        /// Função que recebe o json tratado pela API. Json vem no formato "ComponentesTela":[ {Dictionary}, {Dictionary}, ...]
        /// Esta Função separa os dicionários com os elementos da tela em uma List 
        /// </summary>
        /// <param name="json_retorno">JSON de retorno / tratado por uma das funções da api</param>
        /// <returns></returns>
        public List<Dictionary<string, object>> GetComponentesTela(string json_retorno)
        {
            Dictionary<string, object> _Dic = new Dictionary<string, object>();
            _Dic = JsonConvert.DeserializeObject<Dictionary<string, object>>(json_retorno);

            if (_Dic.TryGetValue("ComponentesTela", out object value))
            {
                List<Dictionary<string, object>> _ListComponentes = JsonConvert.DeserializeObject<List<Dictionary<string, object>>>(value.ToString());
                return _ListComponentes;
            }
            else
            {
                MessageBox.Show("Deu ruim");
                return null;
            }
        }

        /// <summary>
        /// Pega a List com os Dictionary com a descrição dos elementos da tela, e os torna visíveis para o usuário.
        /// </summary>
        /// <param name="ListComponentes">List criada pela Função GetComponentesTela</param>
        public void AtualizarTela(List<Dictionary<string, object>> ListComponentes)
        {
            string tipo_fluxo = Variaveis.Dic["TipoFluxo"].ToString();

            object cod_componente_tela = "";
            object componente = "";
            object tipo_visor = "";
            object conteudo = "";

            // Desabilitar componentes tela
            Dispatcher.Invoke(() =>
            {
                EscreveLog("JSON RECEBIDO DA API ----------------");
                EscreveLog(Variaveis.JsonAPI);
                lblOperador1.Visibility = Visibility.Hidden;
                lblOperador2.Visibility = Visibility.Hidden;
                txtOperador.Visibility = Visibility.Hidden;
                btnOk.Visibility = Visibility.Hidden;
                btnCancelar.Visibility = Visibility.Hidden;
                btnVoltar.Visibility = Visibility.Hidden;
            });

            seguirFluxo = false;

            // Processa os componentes da Tela
            // itera pela List com os Dictionary
            foreach(Dictionary<string, object> DicTemp in ListComponentes)
            {
                DicTemp.TryGetValue("CodigoComponenteTela", out cod_componente_tela);
                DicTemp.TryGetValue("NomeComponenteTela", out componente);
                DicTemp.TryGetValue("TipoVisor", out tipo_visor);
                DicTemp.TryGetValue("ConteudoComponenteTela", out conteudo);

                switch (componente.ToString().ToUpper())
                {
                    case "LABEL":
                        if (tipo_visor.ToString().ToUpper() == "OPERADOR")
                        {
                            if (cod_componente_tela.ToString() == "1")
                            {
                                Dispatcher.Invoke(() =>
                                {
                                    lblOperador1.Content = conteudo;
                                    lblOperador1.Visibility = Visibility.Visible;
                                });
                            }
                            else
                            {
                                Dispatcher.Invoke(() =>
                                {
                                    lblOperador2.Content = conteudo;
                                    lblOperador2.Visibility = Visibility.Visible;
                                });
                            }
                        }
                        else
                        {
                            Dispatcher.Invoke(() =>
                            {
                                lblCliente.Content = conteudo;
                                lblCliente.Visibility = Visibility.Visible;
                            });
                        }
                        break;
                    case "BUTTON":
                        if (conteudo.ToString().ToLower() == "ok" || conteudo.ToString().ToLower() == "prosseguir")
                        {
                            Dispatcher.Invoke(() =>
                            {
                                btnOk.Content = conteudo;
                                btnOk.Visibility = Visibility.Visible;
                            });
                        }
                        else if(conteudo.ToString().ToLower() == "cancelar")
                        {
                            Dispatcher.Invoke(() =>
                            {
                                btnCancelar.Content = conteudo;
                                btnCancelar.Visibility = Visibility.Visible;
                            });
                        }
                        else
                        {
                            Dispatcher.Invoke(() =>
                            {
                                btnVoltar.Content = conteudo;
                                btnVoltar.Visibility = Visibility.Visible;
                            });
                        }
                        break;
                    case "TEXTBOX":
                        Dispatcher.Invoke(() =>
                        {
                            txtOperador.Text = conteudo.ToString();
                            txtOperador.Visibility = Visibility.Visible;
                            txtOperador.Focus();
                        });
                        break;
                    case "COMPROVANTELOJA":
                        MessageBox.Show(conteudo.ToString(), "Comprovante Loja");
                        break;
                    case "COMPROVANTECLIENTE":
                        MessageBox.Show(conteudo.ToString(), "Comprovante Cliente");
                        break;
                    case "DADOSTRANSACAO":
                        MessageBox.Show(conteudo.ToString(), "Comprovante Cliente");
                        break;
                    case "SEGUIRFLUXO":
                        seguirFluxo = true;
                        break;
                    default:
                        break;
                }
            }
        }

        // LOOP PRINCIPAL
        public void TefLoop()
        {
            string retorno;
            int i = 0;
            // LOOP
            do
            {
                // Se o botão dinâmico "Cancela" for clicado modifica o Dictionary que está sendo enviado para a API durante o while.
                if (btnCancelPressed)
                {
                    Variaveis.Dic.Remove("TipoFluxo");
                    Variaveis.Dic.Remove("ComponentesTela");
                    Variaveis.Dic.Add("TipoFluxo", TIPO_FLUXO_CANCELAR_CAPTURA);
                    Variaveis.Dic.Add("ComponentesTela", null);
                    Variaveis.AtualizarJsonAPI();
                    btnCancelPressed = false;
                }
                // Se o botão dinâmico "Voltar" for clicado modifica o Dictionary que está sendo enviado para a API durante o while.
                if (btnVoltarPressed)
                {
                    Variaveis.Dic.Remove("TipoFluxo");
                    Variaveis.Dic.Remove("ComponentesTela");
                    Variaveis.Dic.Add("TipoFluxo", TIPO_FLUXO_RETORNAR_CAPTURA);
                    Variaveis.Dic.Add("ComponentesTela", null);
                    Variaveis.AtualizarJsonAPI();
                    btnVoltarPressed = false;
                }
                // Se o botão dinâmico "Prosseguir" for clicado modifica o Dictionary que está sendo enviado para a API durante o while.
                if (btnOkProsPressed)
                {
                    if (txtOperador.Visibility == Visibility.Visible)
                    {
                        if (txtOperador.Text == "")
                        {
                            MessageBox.Show("Preencha o campo:", "Lembrete");
                        }
                        else
                        {
                            // alterar tipo fluxo e info captura
                            Variaveis.Dic.Remove("TipoFluxo");
                            Variaveis.Dic.Remove("InfoCaptura");
                            Variaveis.Dic.Remove("ComponentesTela");
                            Variaveis.Dic.Add("TipoFluxo", TIPO_FLUXO_PROSSEGUIR_CAPTURA);
                            Variaveis.Dic.Add("InfoCaptura", txtOperador.Text);
                            Variaveis.Dic.Add("ComponentesTela", null);
                            Variaveis.AtualizarJsonAPI();
                        }
                    }
                    else
                    {
                        Variaveis.Dic["TipoFluxo"] = TIPO_FLUXO_PROSSEGUIR_CAPTURA;
                        Variaveis.AtualizarJsonAPI();
                    }
                    btnOkProsPressed = false;
                }

                // Escreve na área de logs o json que está sendo enviado para a API a cada while
                EscreveLog("JSON ENVIADO PARA API ------------------");
                EscreveLog(Variaveis.JsonAPI);
                EscreveLog(i++.ToString());

                retorno = Controle.FluxoColeta(Operacao); // faz o fluxo de coleta de dados da api, parâmetro operação definido no click de cada botão

                AtualizarTela(GetComponentesTela(retorno)); // atualiza os elementos na tela
            } while (Variaveis.Dic["SequenciaCaptura"].ToString() != "99" && seguirFluxo == true);

            // FINALIZAR
            if (Variaveis.Dic["SequenciaCaptura"].ToString() == "99" && Operacao != OPERACAO_CONFIGURACAO)
            {
                retorno = Controle.FinalizaOperacao(CONFIRMAR_OPERACAO);
                if (retorno != "SUCESSO")
                {
                    MessageBox.Show(retorno);
                }
                MessageBox.Show("SUCESSO");
            }
        }

        // evento do botão dinâmico prosseguir
        private void btnOk_Click(object sender, RoutedEventArgs e)
        {
            if (txtOperador.Visibility == Visibility.Visible)
            {
                if (txtOperador.Text == "")
                {
                    MessageBox.Show("Preencha o campo:", "Lembrete");
                }
                else
                {
                    // alterar tipo fluxo e info captura
                    Variaveis.Dic.Remove("TipoFluxo");
                    Variaveis.Dic.Remove("InfoCaptura");
                    Variaveis.Dic.Remove("ComponentesTela");
                    Variaveis.Dic.Add("TipoFluxo", TIPO_FLUXO_PROSSEGUIR_CAPTURA);
                    Variaveis.Dic.Add("InfoCaptura", txtOperador.Text);
                    Variaveis.Dic.Add("ComponentesTela", null);
                    Variaveis.AtualizarJsonAPI();
                    Task.Factory.StartNew(() => { TefLoop(); });
                }
            }
            else
            {
                Variaveis.Dic.Remove("TipoFluxo");
                Variaveis.Dic.Remove("ComponentesTela");
                Variaveis.Dic.Add("TipoFluxo", TIPO_FLUXO_SEGUIR_FLUXO);
                Variaveis.Dic.Add("ComponentesTela", null); Variaveis.AtualizarJsonAPI();
                Task.Factory.StartNew(() => { TefLoop(); });
            }

        }

        // evento do botão dinâmico "Cancelar" 
        private void btnCancelar_Click(object sender, RoutedEventArgs e)
        {
            btnCancelPressed = true; // para quando o processo do while não estiver parado, usar essa variável como gatilho
                                     // para modificar o Dictionary principal para de fato alnvear 

            Variaveis.Dic.Remove("TipoFluxo");
            Variaveis.Dic.Remove("ComponentesTela");
            Variaveis.Dic.Add("TipoFluxo", TIPO_FLUXO_CANCELAR_CAPTURA);
            Variaveis.Dic.Add("ComponentesTela", null);
            Variaveis.AtualizarJsonAPI();
        }

        public void btnVoltar_Click(object sender, RoutedEventArgs e)
        {
            btnVoltarPressed = true;
        }

        // evento botão de cancelamento, inicializa processo e entra no loop principal
        // essa função cancela a última venda
        private async void BtnCancelamento_Click(object sender, RoutedEventArgs e)
        {
            Operacao = OPERACAO_CANCELAMENTO_ADM;
            ValorVenda = LblValor.Text;
            Variaveis.CriaJson(ValorVenda);

            if (LblValor.Text != "")
            {
                await Task.Factory.StartNew(() => {
                    EscreveLog("Operação Iniciada", "Aguarde...", espaco);
                    EscreveLog("ElginTEF_Autenticador", Controle.Autenticador());
                    EscreveLog("ElginTEF_IniciarOperacaoTEF", Controle.IniciaOperacao().ToString());
                    TefLoop();
                });
            }
            else { MessageBox.Show("Informe um valor!", "Erro"); }            
        }

        // evento botão de reimpressão, inicializa processo e entra no loop principal
        // essa função retorna os dados da última vendasso e entra no loop principal
        private async void BtnReimpressao_Click(object sender, RoutedEventArgs e)
        {
            Operacao = OPERACAO_REIMPERSSAO;
            Variaveis.CriaJson();

            await Task.Factory.StartNew(() => {
                EscreveLog("Operação Iniciada", "Aguarde...", espaco);
                EscreveLog("ElginTEF_Autenticador", Controle.Autenticador());
                EscreveLog("ElginTEF_IniciarOperacaoTEF", Controle.IniciaOperacao().ToString());
                TefLoop();
            });
        }

        // evento botão de configuração, não precisa de inicilização, já entra direto no loop principal
        // essa função permite mudar algumas configurações do pinpad e
        private async void BtnConfig_Click(object sender, RoutedEventArgs e)
        {
            Operacao = OPERACAO_CONFIGURACAO;
            Variaveis.CriaJson(0);

            await Task.Factory.StartNew(() => {
                EscreveLog("Operação Iniciada", "Aguarde...", espaco);
                TefLoop();
            });
        }
    }
}
