using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace TEFGP
{
    /// <summary>
    /// Lógica interna para JanelaConectaImpressora.xaml
    /// </summary>
    public partial class JanelaConectaImpressora : Window
    {
        public JanelaConectaImpressora()
        {
            InitializeComponent();
        }
        // define as variáveis de conexão com a impressora e verifica se é possível estabelecer a comunicação
        private void BtnConectar_Click(object sender, RoutedEventArgs e)
        {
            Model.tipo = int.Parse(lblTipo.Text);
            Model.modelo = lblModelo.Text;
            Model.conexao = lblConexao.Text;
            Model.param = int.Parse(lblParam.Text);

            int ret = Impressora.AbreConexaoImpressora(Model.tipo, Model.modelo, Model.conexao, Model.param);
            Impressora.FechaConexaoImpressora();
            if(ret == 0)
            {
                MessageBox.Show("Sua Impressora está conectada!", "Conexão Impressora");
            }
            else
            {
                MessageBox.Show($"A conexão com a impressora não pode ser feita por causa do erro: \n\n{ret}", "Conexão Impressora");
            }
        }
    }
}
