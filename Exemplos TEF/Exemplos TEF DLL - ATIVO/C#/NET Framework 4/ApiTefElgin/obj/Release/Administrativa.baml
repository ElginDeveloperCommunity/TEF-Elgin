   M S B A M L   `   `   `  ���� F  BApiTefElgin, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null'clr-namespace:WpfTesteVs
WpfTesteVs      WpfTesteVs.Administrativa   \ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     @d2http://schemas.microsoft.com/expression/blend/2008     Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     *localclr-namespace:WpfTesteVs       � Title$  Administrativa��$
��auto��$	��300��$
��auto��$	��850��$
��1200�� � 	Resources    ButtonStyle �� 
TargetType �� Property �� Value �� 
TargetType �� Triggers P� Property P� Value  btnOperador��%]  &	        &	 �    �� " ��.���  � ��$	 5,3q���  � ��$	 3,8q���  � ��$
 15px(���  � ��$
 Bold"���  � �� �#0099ff��  � ��
 �������  � ��$ 32����  � ��$	 110����  � ��$	 160����  � �� �� " ��.R��� #��z��
���   �$��1q�._��� $��Center=�$��Center=� P�  � �� . . ���  � �� �#191919P�  �@J�IsMouseOver . . ���  � �� �#005690�� " ��.���  � ��$ 5,5,5,10q���  � ��$
 15px(���  � ��$ Medium"���  � �� �#0099ff��  � ��$	 3,8q���  � ��
 �������  � ��$ 32����  � �� �� " ��.R��� #��z��
���   �$��1q�._��� $��Center=�$��Center=� P�  � �� . . ���  � �� �#191919P�  �@J�IsMouseOver . . ���  � �� �#005690.��� 	 � ColumnDefinitions	 �� $��* ��� $
��1.5* �.+�� -   
 �Name$
 GridLeft��$��0�� � RowDefinitions �� $
��0.5* �$	��100���� $��* �.+�� -   $
 Valor��$��0��$��	0,0,10,10q�$	��400�� �� $
��auto ��� $
��auto �.+��� $�� ��$��0��$��10q�$��16(�$��Candara)�� -   $
 
GridBotoes��$��1��$��20,0,0,0q� �� $��* �	 �� $��* �.+��� -    ��Name$ btnIniciarOperacao��$��0��$��0��$��1��$��Iniciar Operação��#��[  $	��400��� -   $
 Operador��$��1��$��
10,5,5,-15q� �� $
��auto ��� $
��auto �.+��� $��Operador��$��0��$��10q�$��16(�$��Candara)�� -   $
 OperadorDinamico��$��1��$��20q� �� $��* ��� $��* ��� $��* ��� $��* �	 �� $��* ��� $��* ��� $��* �.+��� -    ��Name$ lblOperador1��$��0��$��0��$��3��$��
AGUARDE...��$y�Hidden=��� -   $ btnCancelar��$��3��$��1��$��Cancelar��$y�Hidden=�#��[ �� -	   $ btnOk��$��3��$��2��$��Ok��$y�Hidden=�#��[  �� 	IsDefault . �� -
    ��Name$ txtOperador��$��2��$��0��$��3��$y�Hidden=��� -    ��Name$ cmbLista��$��2��$��0��$��2��$y�Hidden=�� -   $
 Right��$��1�� �� $
��auto �.+�� -   $

 Logs��$��0�� �� $
��auto ��� $
��auto �.+��� $
��Logs��$��0��$��10q�$��16(�$��Candara)��� -   $ 	LogsEntry��$��1�� �� TextWrapping$
 Wrap=� �� AcceptsReturn . " �� VerticalScrollBarVisibility$ Visible=�$
��auto��$	��270��$	��450��$��10q�