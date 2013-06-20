VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "sampletool"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Private Sub CommandButton_createPartsMaster_Click()
    Call createPartsMasterSheet(Sheets("$tool").TextBox_ConfigMasterFolder.Text, _
                                                Sheets("$tool").TextBox_PartsMasterSheet.Text)

End Sub

Private Sub CommandButton_getConfigMasterFolder_Click()
    With Application.FileDialog(msoFileDialogFolderPicker)
        .Title = "�p�[�c�\���f�[�^�̕ۑ��t�H���_��I��"
        .InitialView = msoFileDialogViewLargeIcons
        .InitialFileName = "C:\Users\10007434\Desktop\my prj\excel_vba\"
        
        If .Show = True Then
            Sheets("$tool").TextBox_ConfigMasterFolder.Text = .SelectedItems(1)
        End If
    End With
End Sub

Private Sub CommandButton_getInputSheetList_Click()
    Call collectOriginalFileName(Sheets("$tool").TextBox_PartsMasterSheet.Text)
        
End Sub

Private Sub Worksheet_Activate()

    '�z�z�p�V�[�g�Ɋ܂߂���I�����邽�߂̃��X�g�{�b�N�X�̏����ݒ�
    Dim lstBx As MSForms.ListBox
    Set lstBx = Sheets("$tool").ListBox_addColumn
    With lstBx
        If .ListCount < 1 Then
            .AddItem ("UGL���l")
            .AddItem ("UGL�ύX����")
            .AddItem ("UGL�̔����i")
            .AddItem ("UGL�Ǘ�No")
        End If
    End With



End Sub
