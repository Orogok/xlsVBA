Attribute VB_Name = "sample"
Option Explicit

Sub createPartsMaster()
    
    Dim bRet As Boolean
    Dim fls As New clFiles
    
    '�w��t�H���_���̃p�[�c�\���}�X�^�[�t�@�C�����擾
    Dim rootPath As String
    Dim files As New Collection
    rootPath = ThisWorkbook.path & "\sample_config_master"
    bRet = fls.getAllXlsFilePathCol(rootPath, files)
    If Not bRet Then
        Exit Sub
    End If
    
    '���J���ăf�[�^���擾
    Dim shs As New clSheets
    Dim file As Variant
    Dim wb As Workbook
    Dim ignoreNames As New Collection
    Dim targetNames As New Collection
    Dim shName As Variant
    '=======================
    'Sheet names to ignore
    ignoreNames.Add ("tool")
    ignoreNames.Add ("$")
    ignoreNames.Add ("ugl-")
    '=======================
    
    Application.ScreenUpdating = False
    
    For Each file In files
        'workbook�I�u�W�F�N�g���擾
        bRet = fls.getWorkbookObj(file, wb)
        
        '�����Ώۂ̃V�[�g�����擾
        Set targetNames = New Collection
        bRet = shs.getTargetSheets(wb, ignoreNames, targetNames)
        
        
        If bRet Then
        
        
        
            '�I�u�W�F�N�g�����
            wb.Close savechanges:=False
        End If
    Next
    
    Application.ScreenUpdating = True
End Sub
