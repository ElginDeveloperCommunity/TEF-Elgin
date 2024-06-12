using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Windows;

namespace TEFGP
{
    class Model
    {
        // declarando variáveis para caminhos de diretórios
        public static string fileTmp = "INTPOS.tmp";
        public static string file001 = "INTPOS.001";
        public static string dir = CheckPath();
        public static string pathTmp = Path.Combine(dir, fileTmp);
        public static string pathInt = Path.Combine(dir, file001);

        // declarando variáveis para conexão de impressora
        public static int tipo = 1;
        public static string modelo = "i9";
        public static string conexao = "USB";
        public static int param = 0;

        public static void CreateFile()
        {
            // This append to text only once
            if (!File.Exists(pathTmp))
            {
                // Create a file to write to
                FileStream sw = File.Create(pathTmp);
                sw.Close();
            }
        }
        // Adicionar argumentos ao texto no formato chave = valor
        public static void AppendToFile(string key, string value)
        {
            CreateFile();
            // This text is always added
            using (StreamWriter sw = File.AppendText(pathTmp))
            {
                sw.WriteLine($"{key} = {value}");
            }
        }
        // ler arquivo
        public static List<string> ReadFromFile()
        {
            using (StreamReader sr = File.OpenText(pathTmp))
            {
                string s = string.Empty;
                List<string> list = new List<string>();
                while ((s = sr.ReadLine()) != null)
                {
                    list.Add(s);
                }
                return list;
            }
        }
        // renomear arquivo
        public static void RenameFile()
        {
            File.Move(pathTmp, pathInt);
        }
        // deletar arquivo
        public static void DeleteFile()
        {
            File.Delete(pathInt);
        }
        // retorna o caminho do arquivo definido pelo usuário
        public static string CheckPath()
        {
            return ((MainWindow)System.Windows.Application.Current.MainWindow).folderPath.Text;
        }
        // tratamento do arquivo intpos.001 para extração do comprovante
        public static void BuscaComprovante()
        {
            string path = "C:\\Cliente\\Resp\\INTPOS.001";
            List<string> list_lines = File.ReadAllLines(path).ToList();
            List<string> choosen_lines = list_lines.Where(x => x.Contains("029")).ToList();
            List<string> formatt_lines = choosen_lines.Select(x => x.Substring(9)).ToList();

            Imprimir(String.Join("\n", formatt_lines));
        }
        
        public static void Imprimir(string dados)
        {
            int retorno_conexao = Impressora.AbreConexaoImpressora(tipo, modelo, conexao, param);

            if (retorno_conexao == 0)
            {
                Impressora.ImpressaoTexto(dados, 0, 1, 0);
                Impressora.AvancaPapel(3);
                Impressora.Corte(1);
                Impressora.FechaConexaoImpressora();
            }
            else if (retorno_conexao == -21)
            {
                MessageBox.Show("Por favor, conectar impressora antes de prosseguir", "Impressora Desconectada");
            }
            else
            {
                MessageBox.Show($"Algo deu errado com a conexão com a impressora, tente revisar as constantes para conexão.\n\n{retorno_conexao}", "Conexão Impressora");
            }
        }
    }
}
