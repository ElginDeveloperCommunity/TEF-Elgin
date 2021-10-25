using System.Runtime.InteropServices;
using System.Text;
using System;

namespace TEFAPI
{
    internal class ApiTEF
    {
        public const string PATH = "C:\\APITEFElgin\\BIN\\APITEFElgin.dll";

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int ElginTEF_Autenticador();

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int ElginTEF_IniciarOperacaoTEF();

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int ElginTEF_RealizarPagamentoTEF(int CodigoOperacao, StringBuilder DadosCaptura, ref int tamDados);

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern StringBuilder ElginTEF_RealizarPagamentoTEF2(int CodigoOperacao, StringBuilder DadosCaptura);

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int ElginTEF_RealizarConfiguracao(StringBuilder DadosCaptura, ref int tamDados);

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int ElginTEF_RealizarAdmTEF(int CodigoOperacao, StringBuilder DadosCaptura, ref int tamDados);

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern StringBuilder ElginTEF_RealizarAdmTEF2(int CodigoOperacao, StringBuilder DadosCaptura);

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int ElginTEF_ConfirmarOperacaoTEF(int Acao);

        [DllImport(PATH, CallingConvention = CallingConvention.StdCall)]
        internal static extern int ElginTEF_FinalizarOperacaoTEF(int Encerramento);

    }
}