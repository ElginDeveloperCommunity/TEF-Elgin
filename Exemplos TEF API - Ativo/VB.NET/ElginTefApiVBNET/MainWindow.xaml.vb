Class MainWindow
    Private Sub BtnCarregar_Click(sender As Object, e As RoutedEventArgs) Handles BtnCarregar.Click
        If CBox.Text.Contains("TEF") Then
            ControleApi.ModoOperacao = "vender"
            Dim JanelaP As Pagamento = New Pagamento()
            JanelaP.ShowDialog()
            JanelaP.Focus()
        ElseIf CBox.Text.Contains("Adm") Then
            ControleApi.ModoOperacao = "adm"
            Dim JanelaA As Administrativa = New Administrativa()
            JanelaA.ShowDialog()
            JanelaA.Focus()
        ElseIf CBox.Text.Contains("Coleta") Then
            Dim JanelaColetaPinPad As ColetaPinPad = New ColetaPinPad()
            JanelaColetaPinPad.ShowDialog()
            JanelaColetaPinPad.Focus()
        Else
            MessageBox.Show("Selecione uma operação")
        End If
    End Sub
End Class
