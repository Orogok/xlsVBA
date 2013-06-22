Attribute VB_Name = "sample"
Option Explicit

'====================
'�C���v�b�g�V�[�g����
'====================
Sub inputSh_main(ByVal rootPath As String)
    Dim bRet As Boolean
    Dim dealers As Variant
    Dim dealers2 As Variant
    Dim col As Long
    Dim row As Long
    Dim sh As New clSheet
    Dim da As New clDB
    Dim rootDir As String
    
    '�f�B�[�������擾���ADB�V�[�g�֕ۑ�
    bRet = sh.getDataAsArray(ThisWorkbook, TOOL, 21, 21, 5, 11, dealers, row, col)
    
    '2�����z��̍s������ւ�
    dealers2 = Application.WorksheetFunction.Transpose(dealers)
    bRet = da.setDataArr(dbnum.dealer_name, dealers2)
    
    '�K�v�ȃf�B���N�g�����쐬
    bRet = inputSh_makeDir(rootDir)
    
    '�p�[�c�\���}�X�^�[�t�@�C����z�z�p�ɖ��O��ς��ăC���v�b�g�V�[�g�t�H���_�փR�s�[
    bRet = copyConfmasterFile(rootDir)
    
    '�f�B�[���[���ɃC���v�b�g�V�[�g���R�s�[
    bRet = dealFilesToDealers(rootDir)
End Sub

'�f�B�[���[���ɃC���v�b�g�V�[�g���R�s�[
Private Function dealFilesToDealers(ByVal parentDir As String)
    
    '�ǂ̃t�@�C�����ǂ̃f�B�[���ɔz�z���邩�̕\(�z�z�}�g���N�X)�̏�Ԃ��擾
    Dim dealMatrix As Variant
    Dim row As Long
    Dim col As Long
    Dim sh As New clSheet
    Dim bRet As Boolean
    bRet = sh.getDataAsArray(ThisWorkbook, TOOL, 22, 26, 5, 11, dealMatrix, row, col)
    
    'DB�V�[�g���̔z�z�p�C���v�b�g�V�[�g���̈ꗗ�ƃf�B�[�������擾
    Dim newNames As Collection
    Dim dealers As Collection
    Dim db As New clDB
    bRet = db.getDataColl(dbnum.confmaster_newName, newNames)
    bRet = db.getDataColl(dbnum.dealer_name, dealers)
    
    '�z�z�p�C���v�b�g�V�[�g�̕ۑ���̃��X�g��DB�V�[�g�ɍ쐬
    Dim bVal As Boolean
    Dim i As Long
    Dim j As Long
    Dim inpShPath As String
    Dim FSO As Object
    Dim fromFiles As New Collection
    Dim toFiles As New Collection
    Dim fromFolder As String
    Set FSO = CreateObject("Scripting.FileSystemObject")
    fromFolder = FSO.BuildPath(parentDir, inpSh)

    For i = 1 To UBound(dealMatrix, 1) Step 1
        For j = 1 To UBound(dealMatrix, 2) Step 1
            bVal = dealMatrix(i, j)
            If bVal Then
                inpShPath = FSO.BuildPath(parentDir, dealers(j))
                inpShPath = inpShPath & "\" & newNames(i)
                toFiles.Add (inpShPath)
                fromFiles.Add (fromFolder & "\" & newNames(i))
            End If
        Next j
    Next i
    
    bRet = db.setDataColl(dbnum.inpSh_fromPath, fromFiles)
    bRet = db.setDataColl(dbnum.inpSh_toPath, toFiles)

    For i = 1 To fromFiles.count Step 1
            FSO.copyFile fromFiles(i), toFiles(i), True
    Next i
    Set FSO = Nothing

End Function

'�p�[�c�\���}�X�^�[�t�@�C����z�z�p�ɖ��O��ς��ăC���v�b�g�V�[�g�t�H���_�փR�s�[
Private Function copyConfmasterFile(ByVal parentDir As String) As Boolean
    Dim bRet As Boolean
    Dim db As New clDB
    Dim sh As New clSheet
    Dim confmasterColl As Collection
    Dim newNames As Variant
    Dim lastRow As Long
    Dim da As New clDatArr
    '$tool�V�[�g��̔z�z���t�@�C�������擾
    bRet = sh.getColDataAsArray(ThisWorkbook, TOOL, _
                                                toolSh.rowUL, toolSh.colUL + 1, _
                                                True, newNames, lastRow)
    bRet = da.removeEmptyRecord(newNames, newNames)
    'DB�V�[�g�փy�[�X�g
    bRet = db.setDataArr(dbnum.confmaster_newName, newNames)
    '�I���W�i���̃p�[�c�\���}�X�^�[�̃��X�g���擾
    Dim orgFiles As New Collection
    Dim newFileNames As New Collection
    bRet = db.getDataColl(dbnum.confmaster_orgPath, orgFiles)
    bRet = db.getDataColl(dbnum.confmaster_newName, newFileNames)
    '�S�V�[�g�����Ă������߂̃t�H���_���쐬
    Dim newFolderPath As String
    Dim di As New clDir
    bRet = di.createFolder(parentDir, inpSh, newFolderPath)
    '�R�s�[
    Dim item As Variant
    Dim FSO As Object
    Dim newPath As String
    Dim i As Long
    Set FSO = CreateObject("Scripting.FileSystemObject")
    For i = 1 To orgFiles.count Step 1
            newPath = FSO.BuildPath(newFolderPath, newFileNames(i))
            FSO.copyFile orgFiles(i), newPath, True
    Next i
    Set FSO = Nothing
End Function

'�f�X�N�g�b�v�ɃC���v�b�g�V�[�g�ۑ��p�̃t�H���_���쐬
'���̒��Ƀf�B�[���[���Ƃ̃t�H���_�𐶐�����
Function inputSh_makeDir(ByRef rootDir As String) As Boolean
    Dim bRet As Boolean
    Dim di As New clDir
    Dim parentDir As String
    Dim i As Long
    Dim newPath As String
    '�f�X�N�g�b�v�ɐe�t�H���_(�t�H���_���FInputSheets)�����
    Dim WSH As Variant
    Dim dtp As String
    Set WSH = CreateObject("Wscript.Shell")
    dtp = WSH.SpecialFolders("Desktop")
    Set WSH = Nothing
    bRet = di.createFolder(dtp, ROOT, parentDir)
    '�V�[�g�FTOOL���̃f�B�[���[����ǂݎ���āA�f�B�[�����Ƃ̃t�H���_��e�t�H���_(�t�H���_���FInputSheets)���ɍ쐬
    Dim dealers As New Collection
    Dim da As New clDB
    bRet = da.getDataColl(dbnum.dealer_name, dealers)
    For i = 1 To dealers.count Step 1
        bRet = di.createFolder(parentDir, dealers(i), newPath)
    Next i
    rootDir = parentDir
End Function

'====================
'�p�[�c�}�X�^�[�V�[�g���������@���C���֐�
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
    Call setPartsListData(sheetName, retTmpBucket)
    Application.ScreenUpdating = True
End Sub

'�p�[�c���X�g���e���p�[�c���X�g�V�[�g�ɏ�������
Private Sub setPartsListData(ByVal sheetName As String, _
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

'�p�[�c���X�g�̃w�b�_�[���p�[�c���X�g�ɏ�������
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
'�p�[�c�\���}�X�^�[�t�@�C�������񂵁A�f�[�^���擾��Array�ɐݒ肷��B
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
            bRet = sh.getDataAsArray(wb, shName, confmasterSh.datRowS, 0, _
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
'�p�[�c�}�X�^�[�V�[�g�𐶐�����ہA�p�[�c�\���}�X�^�[�t�@�C�������񂷂�B���̍ۂ�
'DB�V�[�g�փp�[�c�\���}�X�^�[�t�@�C���̃t���p�X�̃��X�g���쐬����Ɠ����ɁA
'�z�z�p�C���v�b�g�V�[�g�̕\�́u�p�[�c�\���}�X�^�[�I���W�i���t�@�C���v�̃��X�g���X�V����B
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
