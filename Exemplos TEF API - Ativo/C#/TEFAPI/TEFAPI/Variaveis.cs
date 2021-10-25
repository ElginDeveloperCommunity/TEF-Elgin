using Newtonsoft.Json;
using System.Collections.Generic;

namespace TEFAPI
{
    // Classe para guardar os valores globais a serem acessados por diferentes threads
    class Variaveis
    {
        // propriedade string que sempre está atualizada com uma string do json atual, 
        // seja o que será enviado para api, seja o de retorno da api
        public static string JsonAPI { get; set; }

        // propriedade Dictionary que sempre está atualizada com o Dictionary com as informações atuais, 
        // seja as que serão enviadas para api, seja o de retorno da api
        public static IDictionary<string, object> Dic { get; set; } = new Dictionary<string, object>();

        // construtor vazio para que o C# não crie o construtor default da classe
        public Variaveis()
        {
            ;
        }

        /// <summary>
        /// Função que pega a string de retorno da API, e atualiza tanto a propriedade "JsonAPI" como o Dictionary "Dic"
        /// </summary>
        /// <param name="text">string retorno API</param>
        public static void AtualizarDicEJsonAPI(string text)
        {
            Dic.Clear();
            JsonAPI = text;
            Dic = JsonConvert.DeserializeObject<Dictionary<string, object>>(text);
        }

        /// <summary>
        /// Função atualiza a string JsonAPI
        /// </summary>
        public static void AtualizarJsonAPI()
        {
            JsonAPI = JsonConvert.SerializeObject(Dic);
        }

        // FUNÇÃO QUE CRIA O JSON INICIAL A SER ENVIADO À API
        public static string CriaJson(string valor = "")
        {
            // Cria dictionary a ser convertido para json
            Dic.Clear();
            Dic.Add("SequenciaCaptura", 0);
            Dic.Add("TipoFluxoCaptura", 0);
            Dic.Add("InfoCaptura", valor);
            Dic.Add("ComponentesTela", null);
            Dic.Add("AbortarFluxoCaptura", false);
            Dic.Add("FormatoInfoCaptura", 0);

            // converte dictionary para string json
            JsonAPI = JsonConvert.SerializeObject(Dic/*, Formatting.Indented*/);
            return JsonAPI;
        }

        // mesma função que a de cima, porém recebe um int como parâmetro
        public static string CriaJson(int valor)
        {
            // Cria dictionary a ser convertido para json
            Dic.Clear();
            Dic.Add("SequenciaCaptura", 0);
            Dic.Add("TipoFluxoCaptura", 0);
            Dic.Add("InfoCaptura", valor);
            Dic.Add("ComponentesTela", null);
            Dic.Add("AbortarFluxoCaptura", false);
            Dic.Add("FormatoInfoCaptura", 0);

            // converte dictionary para string json
            JsonAPI = JsonConvert.SerializeObject(Dic/*, Formatting.Indented*/);
            return JsonAPI;
        }
    }
}
