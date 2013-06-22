Attribute VB_Name = "sample"
Option Explicit



'====================
'�C���v�b�g�V�[�g����
'====================
Sub inputSh_main(ByVal rootPath As String)
    Dim bRet As Boolean
    Dim inputShDir As String
    
    '�K�v�ȃf�B���N�g�����쐬
    bRet = inputSh_makeDir(inputShDir)



'
'    '�S�p�[�c�\���}�X�^�[�t�@�C�����擾
'    Dim files As New Collection
'    Dim fls As New clFiles
'    bRet = fls.getAllXlsFilePathCol(rootPath, files)
'
'    '�S�p�[�c�\���}�X�^�[�t�@�C����$InputSheets�t�H���_���ɕۑ�
'    Dim FSO As Object
'    Dim folder As String
'    Dim orgfile As String
'    Dim newFilePath As String
'    Dim obj As Variant
'    Set FSO = CreateObject("Scripting.FileSystemObject")
'    bRet = di.createFolder(parentDir, "$InputSheets", newPath)
'    For Each obj In files
'        bRet = fls.getFolderAndFileName(obj, True, folder, orgfile)
'        newFilePath = FSO.BuildPath(newPath, orgfile)
'        FSO.copyFile obj, newFilePath, True
'    Next obj
'    Set FSO = Nothing
'
'    '�p�[�c�\���}�X�^�[�t�@�C���̃R�s�[�ɍۂ��A�R�s�[�O��̃t�@�C�����̃n�b�V���e�[�u�����쐬����
'    Dim rngOrg As Range
'    Dim rngNew As Range
'    Dim dicFileName As Variant
'    Set dicFileName = CreateObject("Scripting.Dictionary")
'    For i = toolSh.rowUL To toolSh.rowLR Step 1
'            Set rngOrg = ThisWorkbook.Sheets(TOOL). _
'                                    Range(Cells(i, toolSh.colUL), _
'                                    Cells(i, toolSh.colUL))
'            Set rngNew = ThisWorkbook.Sheets(TOOL). _
'                                    Range(Cells(i, toolSh.colUL + 1), _
'                                    Cells(i, toolSh.colUL + 1))
'            '�t�@�C�����̐ݒ肪�Ȃ��Ȃ�܂Ń��[�v���āA�n�b�V���e�[�u�����쐬����
'            If rngOrg.Value = "" Then
'                Exit For
'            Else
'                '�V���̂��Ȃ���΁A���t�@�C������ݒ肷��
'                If rngNew.Value = "" Then
'                    dicFileName.Add rngOrg.Value, rngOrg.Value
'                Else
'                    dicFileName.Add rngOrg.Value, rngNew.Value
'                End If
'            End If
'    Next i
'
'    '�p�[�c�\���}�X�^�[�t�@�C�����x���_�[�t�H���_�փR�s�[����
'     bRet = fls.copyFiles(fromPath, toPath, dicFileName)
'
'
'
'    '=======================
'    'arguments
'    fromPath = "C:\Users\10007434\Desktop\InputSheets\$InputSheets"
'    toPath = "C:\Users\10007434\Desktop\InputSheets\�f�B�[��A"
'    dicFileName.Add "BC-10 ver1.00.xls", "BC10.xls"
'    dicFileName.Add "F-45N ver2.00.xlsx", "F45N.xls"
'
'
'    ' FSO�ɂ��t�@�C���R�s�[
'
'
'
    
    
    
End Sub



'�K�v�ȃf�B���N�g�����쐬
Function inputSh_makeDir(ByRef inputShDir As String)
    Dim bRet As Boolean
    Dim di As New clDir
    Dim parentDir As String
    Dim i As Long
    Dim newPath As String

    '�f�X�N�g�b�v�ɐe�t�H���_(�t�H���_���FInputSheets)�����
    bRet = di.createFolder(g_desktop, "InputSheets", parentDir)

    '�V�[�g�FTOOL���̃f�B�[���[����ǂݎ���āA�f�B�[�����Ƃ̃t�H���_��e�t�H���_(�t�H���_���FInputSheets)���ɍ쐬
    For i = 1 To g_dealers.count Step 1
        bRet = di.createFolder(parentDir, g_dealers(i), newPath)
    Next i
    
    '�S�V�[�g�����Ă������߂̃t�H���_���쐬
    bRet = di.createFolder(parentDir, INPSH, newPath)
    
    inputShDir = parentDir
End Function

'====================
'�p�[�c�}�X�^�[�V�[�g�𐶐�
'====================
Sub createPartsMasterSheet(ByVal rootPath As String, _
                                            ByVal sheetName As String)

    Application.ScreenUpdating = False
                                                
    '�p�[�c�\���}�X�^�[�t�@�C���̈ꗗ���X�V
    Call updateConfMasterList(rootPath)
    
    '�p�[�c�\���}�X�^�[�t�@�C������f�[�^���擾
    Dim retTmpBucket As Variant
    Call getDataInConfMaster(retTmpBucket)
    
    '�p�[�c�}�X�^�[�V�[�g�̏�����
    Dim sh As New clSheet
    Dim bRet As Boolean
    bRet = sh.initSheet(ThisWorkbook, PMASTER)
    
    '�w�b�_�[��������������
    Call setHeader(sheetName)
    
    '�f�[�^����
    Dim dat As Variant
    Call setData(sheetName, retTmpBucket)
    
    Application.ScreenUpdating = True
    
End Sub

'�f�[�^��ݒ�
Private Sub setData(ByVal sheetName As String, _
                                ByVal dat As Variant)
    Dim bRet As Boolean
    Dim sh As New clSheet
    Dim row As Long
    Dim col As Long
    
    row = UBound(dat, 1)
    col = UBound(dat, 2)
                                   
    With ThisWorkbook.Sheets(sheetName)
            '�f�[�^�ݒ�
            .Range(Cells(2, 1), Cells(row + 1, col)) = dat
            'UGL�ݒ蕔���̐F�ύX
            .Range(Cells(2, col + 1), Cells(row + 1, col + 4)).Interior.Color = RGB(153, 255, 153)
            '�r��
            With .Range(Cells(2, 1), Cells(row + 1, col + 4))
               With .Borders(xlInsideHorizontal)
                   .LineStyle = xlDash
                   .Weight = xlThin
                   .ColorIndex = xlAutomatic
               End With
               With .Borders(xlEdgeBottom)
                   .LineStyle = xlContinuous
                   .Weight = xlThin
                   .ColorIndex = xlAutomatic
               End With
            End With
    End With
End Sub

'�w�b�_�[��ݒ�
Private Sub setHeader(ByVal sheetName As String)
    Dim header As Variant
     With ThisWorkbook.Sheets(sheetName)
         .Select
         header = Array("���[�J�[", "�p�[�cNo", "�p�[�c����", _
                                         "�K�pRegion", "�K�p�K�i", "Remarks", _
                                         "UGL���l", "UGL�ύX����", _
                                         "UGL�̔����i", "UGL�Ǘ�No")
         With .Range("A1:J1")
             .Value = header
             .Font.Color = RGB(255, 255, 255)
             .Font.Bold = True
             .HorizontalAlignment = xlCenter
         End With
         .Range("A1:F1").Interior.Color = RGB(128, 128, 128)
         .Range("G1:J1").Interior.Color = RGB(0, 102, 0)
     End With
End Sub

'�p�[�c�\���}�X�^�[�t�@�C������f�[�^���擾
Private Sub getDataInConfMaster(ByRef dat As Variant)
    Dim bRet As Boolean
    Dim filesColl As Collection
    Dim foldersColl As Collection
    Dim db As New clDB
    Dim i As Long
    Dim index As Long
    Dim lastIndex As Long
    Dim ignoreNames As New Collection
    Dim targetNames As New Collection
    Dim wb As Workbook
    Dim fls As New clFiles
    Dim shs As New clSheets
    Dim sh As New clSheet
    Dim shName
    Dim row As Long
    Dim col As Long
    Dim da As New clDatArr
    Dim retTmpBucket As Variant
    ReDim retTmpBucket(1 To MAX_ROW, 1 To MAX_COL)
    
    'DB�V�[�g����p�[�c�\���t�@�C�����擾
    bRet = db.getDataColl(dbnum.confmaster_orgPath, filesColl)
    'DB�V�[�g����p�[�c�\���t�@�C���̃t�H���_�����擾
    bRet = db.getDataColl(dbnum.confmaster_foldername, foldersColl)
    
    '=======================
    'Sheet names to ignore
    ignoreNames.Add ("tool")
    ignoreNames.Add ("$")
    ignoreNames.Add ("ugl-")
    '=======================
    
    index = 1
    For i = 1 To filesColl.count Step 1
        'workbook�I�u�W�F�N�g���擾
        bRet = fls.getWorkbookObj(filesColl(i), wb)
        
        '�����Ώۂ̃V�[�g�����擾
        Set targetNames = New Collection
        bRet = shs.getTargetSheets(wb, ignoreNames, targetNames)
        
        '�V�[�g����f�[�^���擾
        For Each shName In targetNames
            '�f�[�^�擾
            bRet = sh.getAllDataAsArray(wb, shName, confmasterSh.datRowS, 0, _
                                                            confmasterSh.datColS, confmasterSh.datColE, _
                                                            dat, row, col)
            '1�s��(Ref.No�j���폜
            bRet = da.removeColFromArray(dat, 1, dat)
            'Empty�����̃��R�[�h���폜
            bRet = da.removeEmptyRecord(dat, dat)
            '�܂������������R�[�h������΍폜�B
            bRet = da.removeDuplication(dat, dat)
            '1��ڂɃt�H���_����}��
            bRet = da.insertColIntoArray(dat, 1, foldersColl(i), dat)
            '�擾�����f�[�^��bucket�ɓ����
            bRet = da.addArray(dat, index, retTmpBucket, lastIndex)
            index = lastIndex + 1
        Next shName
        '�I�u�W�F�N�g�����
        wb.Close savechanges:=False
    Next i

    '�o�P�c�̕s�v�ȃG���A���폜
    bRet = da.formatArray(retTmpBucket, lastIndex, UBound(dat, 2), retTmpBucket)
    dat = retTmpBucket
End Sub


'�p�[�c�\���}�X�^�[�t�@�C���̈ꗗ���X�V
Private Sub updateConfMasterList(ByVal rootPath As String)
    Dim filesColl As New Collection
    Dim foldersColl As New Collection
    Dim filenamesColl As New Collection
    Dim bRet As Boolean
    Dim fls As New clFiles
    Dim filenamesArr As Variant
    Dim filenamesCount As Long
    Dim db As New clDB
    Dim wb As Workbook
    Dim sh As New clSheet
    Dim lastRow As Long
    Dim ax As New clAxCtrl
    
    '�p�[�c�\���}�X�^�t�@�C���̃t���p�X���擾
    bRet = fls.getAllXlsFilePathCol(rootPath, filesColl)
    '�t���p�X����t�H���_���ƁA�t�@�C�������擾
    bRet = fls.getFolderAndFileNameColl(filesColl, foldersColl, filenamesColl)
    '���ꂼ���DB�V�[�g�֏o��(�ォ��g�����߁ADB�V�[�g�֕ۑ�)
    bRet = db.setDataColl(dbnum.confmaster_orgPath, filesColl)
    bRet = db.setDataColl(dbnum.confmaster_foldername, foldersColl)
    bRet = db.setDataColl(dbnum.confmaster_filename, filenamesColl)

    '���X�g�����S�̂̏�����
    Set wb = ThisWorkbook
    With wb.Sheets(TOOL).Range(Cells(toolSh.rowUL, toolSh.colUL), _
                    Cells(toolSh.rowLR, toolSh.colLR))
        .Clear
        .Interior.Color = RGB(0, 32, 96)
    End With
    '���ɔz�u����Ă���`�F�b�N�{�b�N�X���폜
    bRet = sh.deleteObjectInRange(ThisWorkbook, TOOL, _
                                                    toolSh.rowUL, toolSh.colUL, _
                                                    toolSh.rowLR, toolSh.colLR)
    '�p�[�c�\���}�X�^�[�I���W�i���t�@�C�����X�g�\��
    bRet = db.getDataArr(dbnum.confmaster_filename, filenamesArr)
    lastRow = UBound(filenamesArr)
    With wb.Sheets(TOOL).Range(Cells(toolSh.rowUL, toolSh.colUL), _
                           Cells(toolSh.rowUL + lastRow - 1, toolSh.colUL))
        .Value = filenamesArr
        .Interior.Color = RGB(255, 255, 255)
        .Font.Size = 12
    End With
    '�z�z���t�@�C���������̐ݒ�
    With wb.Sheets(TOOL).Range(Cells(toolSh.rowUL, toolSh.colUL + 1), _
                           Cells(toolSh.rowUL + lastRow - 1, toolSh.colUL + 1))
        .Interior.Color = RGB(255, 255, 153)
        .Font.Size = 12
    End With
    '�f�B�[�����̈�̐ݒ�
    Dim i As Long
    For i = 0 To 6 Step 1
        bRet = ax.putChkBoxesV(ThisWorkbook, TOOL, _
                                            toolSh.rowUL, toolSh.colUL + 2 + i, _
                                            toolSh.colUL + 2 + i, lastRow)
    Next i
    With wb.Sheets(TOOL).Range(Cells(toolSh.rowUL, toolSh.colUL + 2), _
                    Cells(toolSh.rowUL + lastRow - 1, toolSh.colLR))
        '�t�H���g�̐F��w�i�F�ɍ��킹��
        .Font.Color = RGB(0, 32, 96)
        '�����t��������ݒ�@�Z���̒l��True�������物�F���h��Ԃ�
        .FormatConditions.Add(Type:=xlCellValue, _
                Operator:=xlGreaterEqual, Formula1:=True).Interior.Color = vbYellow
    End With
    '�r������}
     With wb.Sheets(TOOL).Range(Cells(toolSh.rowUL, toolSh.colUL), _
                    Cells(toolSh.rowUL + lastRow - 1, toolSh.colLR - 1))
            With .Borders(xlEdgeTop)
                .LineStyle = xlDash
                .Weight = xlThin
                .ColorIndex = xlAutomatic
            End With
            With .Borders(xlInsideHorizontal)
                .LineStyle = xlDash
                .Weight = xlThin
                .ColorIndex = xlAutomatic
            End With
            With .Borders(xlEdgeBottom)
                .LineStyle = xlDash
                .Weight = xlThin
                .ColorIndex = xlAutomatic
            End With
    End With
End Sub

