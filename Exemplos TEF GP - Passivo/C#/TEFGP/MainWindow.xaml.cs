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
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.IO;
using Microsoft.WindowsAPICodePack.Dialogs;

namespace TEFGP
{
    /// <summary>
    /// Interação lógica para MainWindow.xam
    /// </summary>
    public partial class MainWindow : Window
    {
        // caminho para diretório onde será colocado o arquivo intpos.001
        public string FolderPath
        {
            get { return folderPath.Text; }
        }
        public MainWindow()
        {
            InitializeComponent();
        }
        // Lê o arquivo e escreve/imprime dados no textbox na janela principal
        private void ImprimeDataEntry()
        {
            List<string> s = Model.ReadFromFile();
            string entryText = String.Join("\n", s);
            dataEntry.Text = entryText;
        }
        // Apaga dados escritos no textbox da janela principal
        private void ClearDataEntry()
        {
            dataEntry.Text = "";
        }

        // Envia dados (exemplo: valor da compra) para o arquivo intpos.001
        private void EnviarDados(Dictionary<string, string> myDict)
        {
            ClearDataEntry();
            Model.DeleteFile();
            foreach (KeyValuePair<string, string> entry in myDict)
            {
                Model.AppendToFile(entry.Key, entry.Value);
            }
            ImprimeDataEntry();
            Model.RenameFile();
        }
        // Função que chama a caixa de diálogo para escolher o diretório em que o arquivo intpos.001 será criado, se for mudado, deve-se mudar
        // as configurações do GP
        private void FolderPathButton_Click(object sender, RoutedEventArgs e)
        {
            CommonOpenFileDialog dfd = new CommonOpenFileDialog()
            {
                Title = "Escolher caminho de Troca de Arquivos",
                IsFolderPicker = true,
                InitialDirectory = folderPath.Text
            };

            if (dfd.ShowDialog() == CommonFileDialogResult.Ok)
            {
                folderPath.Text = dfd.FileName;
                MessageBox.Show("Ao mudar o diretório para a troca de arquivos, não esqueça de mudar também no json de configurações",
                    "ATENÇÃO", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
            Model.CheckPath();
        }
        // Funções dos botões que enviam os dados para a função "EnviarDados"
        public void VendaButton_Click(object sender, RoutedEventArgs e)
        {
            string[] keys_venda = new string[] { "000-000", "001-000", "002-000", "003-000", "004-000", "999-999" };
            string[] values_venda = new string[] { "CRT", "1", "123456", valor.Text + "00", "0", "0" };
            Dictionary<string, string> dict_venda = keys_venda.Zip(values_venda, (k, v) => new { k, v }).ToDictionary(x => x.k, x => x.v);
            EnviarDados(dict_venda);
        }

        private void VendaConfirmaButton_Click(object sender, RoutedEventArgs e)
        {
            string[] keys_confirma_venda = new string[] { "000-000", "001-000", "027-000", "999-999" };
            string[] values_confirma_venda = new string[] { "CNF", "1", "123456", "0" };
            Dictionary<string, string> dict_confirma_venda = keys_confirma_venda.Zip(values_confirma_venda, (k, v) => new { k, v }).ToDictionary(x => x.k, x => x.v);
            EnviarDados(dict_confirma_venda);
        }

        private void VendaNConfirmaButton_Click(object sender, RoutedEventArgs e)
        {
            string[] keys_nao_confirma_venda = new string[] { "000-000", "001-000", "027-000", "999-999" };
            string[] values_nao_confirma_venda = new string[] { "NCN", "1", "123456", "0" };
            Dictionary<string, string> dict_nao_confirma_venda = keys_nao_confirma_venda.Zip(values_nao_confirma_venda, (k, v) => new { k, v }).ToDictionary(x => x.k, x => x.v);
            EnviarDados(dict_nao_confirma_venda);
        }

        private void VendaCancelaButton_Click(object sender, RoutedEventArgs e)
        {
            string[] keys_cn = new string[] { "000-000", "001-000", "999-999" };
            string[] values_cn = new string[] { "CNC", "1", "0" };
            Dictionary<string, string> dict_cn = keys_cn.Zip(values_cn, (k, v) => new { k, v }).ToDictionary(x => x.k, x => x.v);
            EnviarDados(dict_cn);
        }

        private void ADM_Click(object sender, RoutedEventArgs e)
        {
            string[] keys_adm = new string[] { "000-000", "001-000", "999-999" };
            string[] values_adm = new string[] { "ADM", "1", "0" };
            Dictionary<string, string> dict_adm = keys_adm.Zip(values_adm, (k, v) => new { k, v }).ToDictionary(x => x.k, x => x.v);
            EnviarDados(dict_adm);
        }
        // botão para imprimir comprovante, verifica antes se arquivo do comprovante existe
        private void reImpress_Click(object sender, RoutedEventArgs e)
        {
            string pathFileResp = "C:\\Cliente\\Resp\\INTPOS.001";
            if (File.Exists(pathFileResp))
            {
                Model.BuscaComprovante();
            }
            else
            {
                MessageBox.Show("O arquivo do comprovante \"C:\\Cliente\\Resp\\INTPOS.001\" não existe!");
            }
        }
        // abre janela para conectar impressora
        private void ConexaoImpressora_Click(object sender, RoutedEventArgs e)
        {
            JanelaConectaImpressora j = new JanelaConectaImpressora();
            j.ShowDialog();
            j.Focus();
        }
    }
}
