Attribute VB_Name = "sample"
Option Explicit

Enum confmaster_shCond
    '�f�[�^�̗̈��N3����X�^�[�g
    datRowS = 6
    datColS = 14
    
    '�f�[�^�̗̈��S�i19��j�܂�
    datColE = 19
End Enum

Sub createPartsMaster()
    Dim bRet As Boolean
    Dim fls As New clFiles
    Dim datArr As New clDatArr
    Dim files As New Collection
    Dim shs As New clSheets
    Dim sh As New clSheet
    Dim rootPath As String
    Dim file As Variant
    Dim wb As Workbook
    Dim ignoreNames As New Collection
    Dim targetNames As New Collection
    Dim shName As Variant
    Dim dat As Variant
    Dim row As Long
    Dim col As Long
    Dim retTmpBucket(1 To MAX_ROW, _
                                    1 To confmaster_shCond.datColE - confmaster_shCond.datColS + 1)
    Dim index As Long
    Dim lastIndex As Long
    Dim newDat As Variant
     
    '�w��t�H���_���̃p�[�c�\���}�X�^�[�t�@�C�����擾
    rootPath = ThisWorkbook.path & "\sample_config_master"
    bRet = fls.getAllXlsFilePathCol(rootPath, files)
    If Not bRet Then
        Exit Sub
    End If
    
    '=======================
    'Sheet names to ignore
    ignoreNames.Add ("tool")
    ignoreNames.Add ("$")
    ignoreNames.Add ("ugl-")
    '=======================
    
    'Workbook���J���ăf�[�^���擾
    Application.ScreenUpdating = False
    index = 1
    For Each file In files
        'workbook�I�u�W�F�N�g���擾
        bRet = fls.getWorkbookObj(file, wb)
        If Not bRet Then
            Debug.Print "err ::: cannot get->" & file & " |" & Now
            GoTo GONEXT
        End If
        '�����Ώۂ̃V�[�g�����擾
        Set targetNames = New Collection
        bRet = shs.getTargetSheets(wb, ignoreNames, targetNames)
        If Not bRet Then
            Debug.Print "err ::: cannot get any sheet" & " |" & Now
            GoTo GONEXT
        End If
        '�V�[�g����f�[�^���擾
        For Each shName In targetNames
            bRet = sh.getAllDataAsArray(wb, shName, _
                                                            confmaster_shCond.datRowS, _
                                                            confmaster_shCond.datColS, _
                                                            confmaster_shCond.datColE, _
                                                            dat, row, col)
            '�擾�����f�[�^��bucket�ɓ����
            bRet = datArr.addArray(dat, index, retTmpBucket, lastIndex)
            index = lastIndex + 1
        Next shName
        '�I�u�W�F�N�g�����
        wb.Close savechanges:=False
GONEXT:
    Next file
    Application.ScreenUpdating = True
    
    '�o�P�c�̕s�v�ȃG���A���폜
    bRet = datArr.formatArray(retTmpBucket, lastIndex, _
                                                confmaster_shCond.datColE - confmaster_shCond.datColS + 1, _
                                                newDat)
    If bRet = True Then
        'initialize the sheet to verification
        bRet = sh.initSheet(ThisWorkbook, "$verify")
        'plot all data on the $verify sheet
        With ThisWorkbook.Sheets("$verify")
            .Select
            .Range(Cells(1, 1), Cells(lastIndex, confmaster_shCond.datColE - confmaster_shCond.datColS + 1)) = newDat
            Debug.Print "result ::: done " & " |" & Now
        End With
    Else
        Debug.Print "result ::: no data" & " |" & Now
    End If
End Sub
