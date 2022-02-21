using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace TEFGP
{
    class Impressora
    {
        // declaração dos métodos da dll
        public const string PATH = "./E1_Impressora01.dll";
        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int AbreConexaoImpressora(int tipo, string modelo, string conexao, int param);

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int FechaConexaoImpressora();

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int ImpressaoTexto(string dados, int posicao, int estilo, int tamanho);

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int Corte(int avanco);

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int AvancaPapel(int linhas);
    }
}
