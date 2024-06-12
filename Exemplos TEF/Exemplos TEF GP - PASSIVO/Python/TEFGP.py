# python3 
# -*- coding: utf-8 -*- 
# --------------------------------------------------------------------------------------------
# Created By  : Gabriel Alves Franzeri
# Created Date: 15/09/2021 ..etc
# version ='1.0'
# --------------------------------------------------------------------------------------------
# """Clone de utilitário da Elgin para comunicação por troca de arquivos com TEFPassivo"""
# --------------------------------------------------------------------------------------------
# IMPORTANTE
# Executar código utilizando python 32bits por causa da E1_Impressora01.dll
# --------------------------------------------------------------------------------------------
# imports 

from tkinter import Button, Tk, Label, Frame, Entry, Button, Text, StringVar, NSEW, RIDGE, W, E, FLAT, SUNKEN, END, RAISED
from tkinter import filedialog
from tkinter import messagebox
from os import rename, remove, path
import impressora

# --------------------------------------------------------------------------------------------

LARGE_FONT_STYLE = ("Arial", 12, "bold") # brandon, musc, montserrat, coco goose
SMALL_FONT_STYLE = ("Arial", 11, "bold")
BUTTON_FONT_STYLE = ("Arial", 9)
COLOR_BG_FRAME = "#ecf0f1"
COLOR_BG_LABEL = "#ecf0f1"
COLOR_FG_LABEL = "#2c3e50"
COLOR_BG_ENTRY = "#bdc3c7"
COLOR_BG_BUTTON = "#95a5a6"
COLOR_FG_BUTTON = "#2c3e50"

class TEFIntpos:
    # =========================================
    # | ===========  BEGIN LAYOUT =========== |
    # =========================================
    
    def __init__(self):
        
        # create root window
        self.root = Tk()
        self.root.title('   TEF - INTPOS com Scope')
        self.root.minsize(30,15)
        # self.root.geometry('400x150)
        # self.root.attributes('-toolwindow', True)
        self.root.resizable(0,0)

        # create frames
        self.mainframe = self.create_main_frame()
        self.config_frame = self.create_config_frame()
        self.func_frame = self.create_func_frame()
        self.data_frame = self.create_data_frame()

        # # create labels
        self.config_labels = self.create_config_labels()
        self.func_labels = self.create_func_labels()
        self.data_labels = self.create_data_labels()

        # # create buttons
        self.config_buttons = self.create_config_buttons()
        self.func_buttons = self.create_func_buttons()

        # # create entry
        self.config_entry = self.create_config_entry()
        self.data_entry = self.create_data_entry()

        # CONSTANT FOR FILE NAMES
        self.filename_tmp = '\INTPOS.tmp'
        self.filename_001 = '\INTPOS.001'

    def create_main_frame(self):
        frame = Frame(self.root, bg=COLOR_BG_FRAME)
        frame.grid(column=0, row=0, sticky=NSEW)
        return frame

    def create_config_frame(self):
        frame = Frame(self.mainframe, relief=RIDGE, bg=COLOR_BG_FRAME)
        frame.grid(column=0, row=0, sticky=(NSEW), padx=(20, 10))
        return frame    

    def create_func_frame(self):
        frame = Frame(self.mainframe, bg=COLOR_BG_FRAME)
        frame.grid(column=0, row=1, sticky=(NSEW), padx=(20, 10))
        return frame
    
    def create_data_frame(self):
        frame = Frame(self.mainframe, bg=COLOR_BG_FRAME)
        frame.grid(column=0, row=2, sticky=(NSEW), padx=(20, 10))
        return frame

    def create_config_labels(self):
        titulo = Label(self.config_frame, text='Configurações', relief=FLAT, bg=COLOR_BG_LABEL, fg=COLOR_FG_LABEL, font=LARGE_FONT_STYLE)
        titulo.grid(column=0, row=0, sticky=W, pady=(10, 0))   
             
        textos = ['Caminho da escrita para arquivo', 'Valor para venda e cancelamento']
        r = 1
        for t in textos:
            l = Label(self.config_frame, text=t, relief=FLAT, bg=COLOR_BG_LABEL, fg=COLOR_FG_LABEL, font=SMALL_FONT_STYLE)
            l.grid(column=0, row=r, sticky=W, padx=(20, 0), pady=(5))
            r += 1

    def create_func_labels(self):
        titulo = Label(self.func_frame, text='Funções', relief=FLAT, bg=COLOR_BG_LABEL, fg=COLOR_FG_LABEL, font=LARGE_FONT_STYLE)
        titulo.grid(column=0, row=0, sticky=W, pady=(10, 0))      

    def create_data_labels(self):
        titulo = Label(self.data_frame, text='Dados Escritos', relief=FLAT, bg=COLOR_BG_LABEL, fg=COLOR_FG_LABEL, font=LARGE_FONT_STYLE)
        titulo.grid(column=0, row=0, sticky=W, pady=(10, 0)) 

    def create_config_entry(self):
        self.folder_path = StringVar()
        self.folder_path.set('C:\Cliente\Req')
        caminho_entry = Entry(self.config_frame, textvariable=self.folder_path, relief=SUNKEN, bg=COLOR_BG_ENTRY, font=BUTTON_FONT_STYLE, width=30)
        caminho_entry.grid(column=1, row=1, sticky=(W, E), padx=(30, 0))

        self.valor_venda = StringVar()
        self.valor_venda.set('40')
        valor_venda_entry = Entry(self.config_frame, textvariable=self.valor_venda, relief=SUNKEN, bg=COLOR_BG_ENTRY, font=BUTTON_FONT_STYLE, width=33)
        valor_venda_entry.grid(column=1, columnspan=2, row=2, sticky=(W, E), padx=(30, 0))
        valor_venda_entry.focus()
    
    def create_data_entry(self):
        self.data = StringVar()
        data_entry = Text(self.data_frame, relief=SUNKEN, bg=COLOR_BG_ENTRY, height=10, width=63, yscrollcommand=True)
        data_entry.grid(column=0, columnspan=1, row=1, sticky=(NSEW), padx=(0, 10), pady=(0, 20))
        data_entry.insert(END, '')
        return data_entry

    def create_func_buttons(self):
        check_rowspan = lambda x: 2 if x[0] == 2 and x[1] == 3 else 1
        buttons_text = {
            'ADM':(1,1), 'Venda':(1,2), 'Cancelamento Venda':(1,3),
            'Reimpressão':(2,1), 'Confirmar Venda':(2,2), 'Fechar':(2,3),
            'Não Confirmar Venda':(3,2)}
        for text_btn, grid_value in buttons_text.items():
            button = Button(self.func_frame, text=text_btn, relief=RAISED, bg=COLOR_BG_BUTTON, fg=COLOR_FG_BUTTON, font=SMALL_FONT_STYLE, borderwidth=1, width=17, command= lambda x = text_btn: self.button_functions(x)) #, state=check_enable(grid_value))
            button.grid(row=grid_value[0], column=(grid_value[1]-1), rowspan=check_rowspan(grid_value), padx=5, pady=5, sticky=NSEW)

    def create_config_buttons(self):
        button = Button(self.config_frame, text="...", command=self.browse_button, bg=COLOR_BG_BUTTON, fg=COLOR_FG_BUTTON)
        button.grid(row=1, column=2)

    # =======================================
    # | ===========  END LAYOUT =========== | 
    # =======================================

    # permite usuário escolher um diretório se preferir, avisando-o sobre a necessidade de mudar a configuração do serviço caso deseje mudar
    def browse_button(self):
        directory_name = filedialog.askdirectory()
        self.folder_path.set(directory_name) if len(directory_name) > 0 else None
        messagebox.showwarning('Atenção', 'Antes de Continuar, você tem que mudar o path do serviço no configurador!') if len(directory_name) > 0 else None
        
    def button_functions(self, text_button):
        # valores e chaves a serem enviados para o gp
        keys_venda = ['000-000','001-000','002-000','003-000','004-000','999-999']
        values_venda = ['CRT','1','123456', self.valor_venda.get() + '00','0','0']
        dict_venda = dict(zip(keys_venda, values_venda))

        keys_confirma_venda = ['000-000','001-000','027-000','999-999']
        values_confirma_venda = ['CNF','1','123456','0']
        dict_confirma_venda = dict(zip(keys_confirma_venda, values_confirma_venda))

        keys_nao_confirma_venda = ['000-000','001-000','027-000','999-999']
        values_nao_confirma_venda = ['NCN','1','123456','0']
        dict_nao_confirma_venda = dict(zip(keys_nao_confirma_venda, values_nao_confirma_venda))

        keys_adm = ['000-000','001-000','999-999']
        values_adm = ['ADM','1','0']
        dict_adm = dict(zip(keys_adm, values_adm))

        keys_cn = ['000-000','001-000','999-999']
        values_cn = ['CNC','1','0']
        dict_cn = dict(zip(keys_cn, values_cn))

        # chama as funções para cada botão
        if text_button == 'Venda':
            self.button_envia(dict_venda)
        if text_button == 'Confirmar Venda':
            self.button_envia(dict_confirma_venda)
        if text_button == 'Não Confirmar Venda':
            self.button_envia(dict_nao_confirma_venda)
        if text_button == 'ADM':
            self.button_envia(dict_adm)
        if text_button == 'Cancelamento Venda':
            self.button_envia(dict_cn)
        if text_button == 'Reimpressão':
            self.button_reimpressao()
        if text_button == 'Fechar':
            self.root.destroy()
            
    # funções para escrever os dados necessários no diretório para o gp capturar os dados
    def button_envia(self, mydict):
        self.clear_data_entry()
        self.delete_file()
        for key, value in mydict.items():
            self.append_to_file(key, value)
            self.append_to_data_entry(key, value)
        self.rename_file()

    # adiciona string na entry da janela do programa
    def append_to_data_entry(self, key, value):
        query = f'{key} = {value}\n'
        self.data_entry.insert(END, query)

    # apaga dados da entry na janela do programa
    def clear_data_entry(self):
        self.data_entry.delete('0.0', END)

    # adiciona string em arquivo
    def append_to_file(self, key, value):
        file = open(self.folder_path.get() + self.filename_tmp, 'a+')
        # append text at the end of file
        file.write(f'{key} = {value}\n')
        file.close()

    # renomeia arquivo de intpos.tmp para intpos.001 para que o gp capture os dados
    def rename_file(self):
        rename(self.folder_path.get() + self.filename_tmp, self.folder_path.get() + self.filename_001)

    # deleta arquivo intpos.001 caso já exista no diretório
    def delete_file(self):
        if path.exists(self.folder_path.get() + self.filename_001):
            remove(self.folder_path.get() + self.filename_001)

    # função que chama a dll da impressora, modificar as constantes aqui se utilizar outra impressora
    def button_impressora(self):
        if impressora.abre_conexao_impressora(1, 'i9', 'USB', 0) == 0:
            impressora.impressao_texto(self.busca_txt(), 0, 1, 0)
            impressora.avanca_papel(1)
            impressora.corte(1)
            impressora.fecha_conexao_impressora()
        else:
            messagebox.showinfo("Atenção", "Parece que há algum problema de conexão com a impressora. Por favor, revisar as constantes de conexão!\n\n" + str(impressora.abre_conexao_impressora(1, 'i9', 'USB', 0)))
            
    # busca o comprovante no arquivo que o GP retorna
    def busca_txt(self):
        path = "C:\\Cliente\\Resp\\INTPOS.001"
        file = open(path, 'r', encoding='utf-8')
        list_lines = file.readlines()
        file.close()
        choosen_lines = list(filter(lambda x: '029' in x, list_lines))
        formatted_lines = list(map(lambda x: x[9:], choosen_lines))
        join_lines = ''.join(formatted_lines)
        return join_lines

    # se o arquivo do comprovante existir, imprimir
    def button_reimpressao(self):
        if path.exists("C:\Cliente\Resp\INTPOS.001"):
            self.button_impressora()
        else:
            messagebox.showerror("Arquivo inexistente", 'O arquivo do comprovante "C:\Cliente\Resp\INTPOS.001" não existe!')

    # função do tkinter
    def run(self):
        self.root.mainloop()

if __name__ == "__main__":
    programa = TEFIntpos()
    programa.run()