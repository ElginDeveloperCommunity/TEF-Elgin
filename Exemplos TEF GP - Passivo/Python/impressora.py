import ctypes
import platform

if platform.system() == "Windows":
    ffi = ctypes.WinDLL("./E1_Impressora01.dll")
else:
    ffi = ctypes.cdll.LoadLibrary("./libE1_Impressora.so")

def abre_conexao_impressora(tipo, modelo, conexao, param):
    fn = ffi.AbreConexaoImpressora
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_int, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_int]

    modelo = ctypes.c_char_p(bytes(modelo, "utf-8"))
    conexao = ctypes.c_char_p(bytes(conexao, "utf-8"))

    return fn(tipo, modelo, conexao, param)


def fecha_conexao_impressora():
    fn = ffi.FechaConexaoImpressora
    fn.restype = ctypes.c_int
    fn.argtypes = []

    return fn()

def impressao_texto(dados, posicao, stilo, tamanho):
    fn = ffi.ImpressaoTexto
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_int, ctypes.c_int]

    dados = ctypes.c_char_p(bytes(dados, "utf-8"))

    return fn(dados, posicao, stilo, tamanho)

def corte(avanco):
    fn = ffi.Corte
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_int]

    return fn(avanco)

def corte_total(avanco):
    fn = ffi.CorteTotal
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_int]

    return fn(avanco)

def impressao_qrcode(dados, tamanho, nivelCorrecao):
    fn = ffi.ImpressaoQRCode
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_int]

    dados = ctypes.c_char_p(bytes(dados, "utf-8"))

    return fn(dados, tamanho, nivelCorrecao)

def impressao_pdf_417(numCols, numRows, width, heigth, errCorLvl, options, dados):
    fn = ffi.ImpressaoPDF417
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_char_p]

    dados = ctypes.c_char_p(bytes(dados, "utf-8"))

    return fn(numCols, numRows, width, heigth, errCorLvl, options, dados)

def impressao_codigo_barras(tipo, dados, altura, largura, HRI):
    fn = ffi.ImpressaoCodigoBarras
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_int, ctypes.c_char_p, ctypes.c_int, ctypes.c_int, ctypes.c_int]

    dados = ctypes.c_char_p(bytes(dados, "utf-8"))

    return fn(tipo, dados, altura, largura, HRI)

def avanca_papel(linhas):
    fn = ffi.AvancaPapel
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_int]

    return fn(linhas)

def status_impressora(param):
    fn = ffi.StatusImpressora
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_int]

    return fn(param)

def abre_gaveta_elgin():
    fn = ffi.AbreGavetaElgin
    fn.restype = ctypes.c_int
    fn.argtypes = []

    return fn()

def abre_gaveta(pino, ti, tf):
    fn = ffi.AbreGaveta
    fn.restype = ctypes.c_int
    fn.argtypes = [ ctypes.c_int, ctypes.c_int, ctypes.c_int]

    return fn( pino, ti, tf)

def inicializa_impressora():
    fn = ffi.InicializaImpressora
    fn.restype = ctypes.c_int
    fn.argtypes = []

    return fn()

def sinal_sonoro(qtd, tempoinicio, tempofim):
    fn = ffi.SinalSonoro
    fn.restype = ctypes.c_int
    fn.argtypes = [ ctypes.c_int, ctypes.c_int, ctypes.c_int]

    return fn(qtd, tempoinicio, tempofim)

def imprime_imagem_memoria(key, scala):
    fn = ffi.ImprimeImagemMemoria
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_char_p, ctypes.c_int]

    dados = ctypes.c_char_p(bytes(key, "utf-8"))

    return fn(key, scala)

def imprime_xml_sat(dados, param):
    fn = ffi.ImprimeXMLSAT
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_char_p, ctypes.c_int]

    dados = ctypes.c_char_p(bytes(dados, "utf-8"))

    return fn(dados, param)

def imprime_xml_cancelamento_sat(dados, assQRCode, param):
    fn = ffi.ImprimeXMLCancelamentoSAT
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_char_p, ctypes.c_char_p, ctypes.c_int]

    dados = ctypes.c_char_p(bytes(dados, "utf-8"))
    assQRCode = ctypes.c_char_p(bytes(assQRCode, "utf-8"))

    return fn(dados, assQRCode, param)

def imprime_xml_nfce(dados, indexcsc, csc, param):
    fn = ffi.ImprimeXMLNFCe
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_char_p, ctypes.c_int]

    dados = ctypes.c_char_p(bytes(dados, "utf-8"))
    csc = ctypes.c_char_p(bytes(csc, "utf-8"))

    return fn(dados, indexcsc, csc, param)    

def imprime_cupom_tef(dados):
    fn = ffi.ImprimeCupomTEF
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_char_p]

    dados = ctypes.c_char_p(bytes(dados, "utf-8"))

    return fn(dados)    

def imprime_imagem(path):
    fn = ffi.ImprimeImagem
    fn.restype = ctypes.c_int
    fn.argtypes = [ctypes.c_char_p]

    path = ctypes.c_char_p(bytes(path, "utf-8"))

    return fn(path)  
