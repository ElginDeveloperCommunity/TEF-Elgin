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

namespace TEFAPI
{
    /// <summary>
    /// Interação lógica para MainWindow.xam
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void BtnCarregar_Click(object sender, RoutedEventArgs e)
        {
            if (CBox.Text.Contains("TEF"))
            {
                Pagamento JanelaP = new Pagamento();
                JanelaP.ShowDialog();
                JanelaP.Focus();
            }
            else if (CBox.Text.Contains("Adm"))
            {
                Administrativa JanelaA = new Administrativa();
                JanelaA.ShowDialog();
                JanelaA.Focus();
            }
            else
            {
                MessageBox.Show("Selecione uma operação");
            }
        }
    }
}
