VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clFiles"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Option Base 1

'=============================
' Export some specified modules into the specified directory.
' �w�肳�ꂽ���W���[�����w�肵���f�B���N�g���փG�N�X�|�[�g����B
'  [i]wb                   �G�N�X�|�[�g����Excel�u�b�N�I�u�W�F�N�g
'  [i]tgtModules       �G�N�X�|�[�g�Ώۂ̃��W���[�����̔z��
'  [i]toPath             �G�N�X�|�[�g���Excel�u�b�N�I�u�W�F�N�g
' Return : True : one or more were successfully exported
' �֐��̕Ԃ�l�F��ȏ�G�N�X�|�[�g�ɐ���������True
'--------------------------------------------------
Public Function exportModules( _
                                        ByVal wb As Workbook, _
                                        ByVal tgtModules As Variant, _
                                        ByVal toPath As String _
                                        ) As Boolean
    Dim tgtMo As String, prg As String
    Dim i As Long
    Dim sh As New clSheet
    Dim ext As String
    Dim bRet As Boolean
    
    bRet = False
    For i = 1 To UBound(tgtModules) Step 1
        tgtMo = tgtModules(i)
        If sh.existModule(wb, tgtMo) Then
        
            With wb.VBProject.VBComponents(tgtMo)
                    'Get extention for the module.
                    Select Case .Type
                    Case vbext_ct_StdModule
                        ext = "bas"
                    Case vbext_ct_ClassModule, vbext_ct_Document
                        ext = "cls"
                    Case vbext_ct_MSForm
                        ext = "frm"
                    End Select
                    
                    'Export the module.
                    Dim objFso As Object
                    Dim exportFilePath As String
                    Set objFso = CreateObject("Scripting.FileSystemObject")
                         exportFilePath = objFso.BuildPath(toPath, tgtMo & "." & ext)
                    Set objFso = Nothing
                    .Export exportFilePath
                    
                    bRet = True
            End With
        End If
    Next i
    exportModules = bRet
End Function

'=============================
' Get the full path of all Excel files under the specified directory.
' �w�肵���f�B���N�g���z���ɂ���SExcel�t�@�C���̃t���p�X�擾
'  [i]path      ��������f�B���N�g���̃p�X
'  [o]ret       Excel�̃t���p�X��~�ς���Collection
' Return : True : one or more file paths were successfully collected.
' �֐��̕Ԃ�l�F��ȏ�R�s�[�ɐ���������True
'--------------------------------------------------
Public Function getAllXlsFilePathCol(ByVal Path As String, _
                                    ByRef ret As Collection) As Boolean
    Dim FSO As Object
    Dim folder As Variant
    Dim file As Variant
    
    Set FSO = CreateObject("Scripting.FileSystemObject")
    For Each folder In FSO.getFolder(Path).SubFolders
        Call getAllXlsFilePathCol(folder.Path, ret)
    Next folder
    For Each file In FSO.getFolder(Path).files
        If InStr(file.Type, "Excel") > 0 Then
            ret.Add (file.Path)
        End If
    Next file
    Set FSO = Nothing
    
    If ret.count < 1 Then
        getAllXlsFilePathCol = False
    Else
        getAllXlsFilePathCol = True
    End If
End Function

'=============================
' Copy some specified sheets and modules from one excel book into another.
' �w�肳�ꂽ�V�[�g�A���W���[�����A�V�����u�b�N�̒��ɃR�s�[����B
' �}�N�����܂܂��ꍇxlsm�ŕۑ�����B
'  [i]wbFrom             �R�s�[����Excel�u�b�N�I�u�W�F�N�g
'  [i]wbTo                  �R�s�[���Excel�u�b�N�I�u�W�F�N�g
'  [i]tgtSheets           �R�s�[�Ώۂ̃V�[�g���̔z��
'  [i]tgtStdModules           �R�s�[�Ώۂ̕W�����W���[�����̔z��
'  [i]tgtClsModules           �R�s�[�Ώۂ̃N���X���W���[�����̔z��
' Return : True : one or more were successfully copied
' �֐��̕Ԃ�l�FTrue : ��ȏ�R�s�[�ɐ�������
'--------------------------------------------------
Public Function copySheetsAndModules( _
                                        ByVal wbFrom As Workbook, _
                                        ByVal wbTo As Workbook, _
                                        ByVal tgtSheets As Variant, _
                                        ByVal tgtStdModules As Variant, _
                                        ByVal tgtClsModules As Variant _
                                        ) As Boolean
    
    Dim bRet1 As Boolean, bRet2 As Boolean, bRet3 As Boolean
    Dim copiedSheets As New Collection, copiedStdModules As New Collection, copiedClsModules As New Collection
    bRet1 = copySheets(wbFrom, tgtSheets, wbTo, copiedSheets)
    bRet2 = copyModules(wbFrom, tgtStdModules, vbext_ct_StdModule, wbTo, copiedStdModules)
    bRet3 = copyModules(wbFrom, tgtClsModules, vbext_ct_ClassModule, wbTo, copiedClsModules)
    
    copySheetsAndModulesIntoNewFileThenSave = bRet1 Or bRet2 Or bRet3
End Function


'=============================
' Copy some specified modules from one excel book into another.
' �w�肳�ꂽ���W���[�����A�ʂ̃u�b�N�̒��ɃR�s�[����B
'  [i]wbFrom                �R�s�[����Excel�u�b�N�I�u�W�F�N�g
'  [i]tgtModules           �R�s�[�Ώۂ̃��W���[�����̔z��
'  [i]wbTo                   �R�s�[���Excel�u�b�N�I�u�W�F�N�g
'  [o]copiedModules      �R�s�[�������������W���[�����O�Q
' Return : True : one or more were successfully copied
' �֐��̕Ԃ�l�F��ȏ�R�s�[�ɐ���������True
'--------------------------------------------------
Public Function copyModules(ByVal wbFrom As Workbook, _
                                            ByVal tgtModules As Variant, _
                                            ByVal cmpKind As Integer, _
                                            ByRef wbTo As Workbook, _
                                            ByRef copiedModules As Collection _
                                           ) As Boolean
    Dim tgtMo As String, prg As String
    Dim i As Long
    Dim sh As New clSheet
    Dim cntLines As Long
    
    For i = 1 To UBound(tgtModules) Step 1
        tgtMo = tgtModules(i)
        If sh.existModule(wbFrom, tgtMo) Then
            With wbFrom.VBProject.VBComponents(tgtMo).CodeModule
                prg = .Lines(1, .CountOfLines)
            End With
            
            With wbTo.VBProject.VBComponents.Add(cmpKind)
                '�u�ϐ��̐錾����������v�I�v�V�������L���̏ꍇ�AOption Explicit�̍s�������I�ɂł��邽�߁A��������폜�B
                cntLines = .CodeModule.CountOfLines
                If cntLines > 0 Then
                    .CodeModule.DeleteLines 1, cntLines
                End If
                .CodeModule.AddFromString prg
                .name = tgtMo
            End With
            copiedModules.Add (tgtMo)
        End If
    Next i

    If copiedModules.count > 0 Then
        copyModules = True
    Else
        copyModules = False
    End If

End Function

'=============================
' Copy some specified sheets from one book into another book.
' �u�b�N���̎w�肳�ꂽ�V�[�g���A�ʂ̃u�b�N�̒��ɃR�s�[����B
'  [i]wbFrom                �R�s�[����Excel�u�b�N�I�u�W�F�N�g
'  [i]tgtSheets             �R�s�[�Ώۂ̃V�[�g���̔z��
'  [i]wbTo                   �R�s�[���Excel�u�b�N�I�u�W�F�N�g
'  [o]copiedSheets      �R�s�[�����������V�[�g�̖��O�Q
' Return : True : one or more were successfully copied
' �֐��̕Ԃ�l�F��ȏ�R�s�[�ɐ���������True
'--------------------------------------------------
Public Function copySheets(ByVal wbFrom As Workbook, _
                                                ByVal tgtSheets As Variant, _
                                                ByVal wbTo As Workbook, _
                                                ByRef copiedSheets As Collection _
                                                ) As Boolean
    Dim i As Long
    Dim tgtSh As String
    Dim sh As clSheet
    Set sh = New clSheet
    
    For i = 1 To UBound(tgtSheets) Step 1
        tgtSh = tgtSheets(i)
        If sh.existSheet(wbFrom, tgtSh) Then
            wbFrom.sheets(tgtSh).Copy After:=wbTo.sheets(wbTo.sheets.count)
            copiedSheets.Add (tgtSh)
        End If
    Next i
    
    If copiedSheets.count > 0 Then
        copySheets = True
    Else
        copySheets = False
    End If
End Function


'----------------------------------------------------------------------------------
'�������� ��������

'=============================
'�w��t�H���_���̃t�@�C�����A�ʂ̃t�H���_�ɐV�����t�@�C�����ŃR�s�[����B
'  [i]fromPath            �R�s�[���̃t�@�C��������t�H���_�̃p�X
'  [i]toPath                �R�s�[��̃t�H���_�̃p�X
'  [i]dicFileNames      �R�s�[�̑O��̃t�@�C�������ݒ肳�ꂽ�n�b�V���e�[�u��CreateObject("Scripting.Dictionary")�Ő���
'--------------------------------------------------
Public Function copyFiles(ByVal fromPath As String, _
                                        ByVal toPath As String, _
                                        ByVal dicFileNames As Variant _
                                        ) As Boolean
    Dim sRet As String
    Dim i As Long
    Dim FSO As Object
    Dim fromFile As String
    Dim toFile As String
    Dim keys As Variant
    
    '�f�B���N�g�������݂��邩�`�F�b�N
    sRet = Dir(fromPath, vbDirectory)
    If sRet = "" Then
        Debug.Print "err ::: directory does not exist.(" & fromPath & ")  [func:copyFiles()]" & Now
        copyFiles = False
        Exit Function
    End If
    sRet = Dir(toPath, vbDirectory)
    If sRet = "" Then
        Debug.Print "err ::: directory does not exist.(" & toPath & ")  [func:copyFiles()]" & Now
        copyFiles = False
        Exit Function
    End If
        
    Set FSO = CreateObject("Scripting.FileSystemObject")
    
    'dicFileNames��key����(�R�s�[���̃t�@�C����)��z��Ƃ��Ď擾
    keys = dicFileNames.keys()
    
    'key�̐������[�v���ĐV�t�@�C�����ŏ㏑���R�s�[����
    For i = 0 To UBound(keys) Step 1
        fromFile = FSO.BuildPath(fromPath, keys(i))
        toFile = FSO.BuildPath(toPath, dicFileNames(keys(i)))
        FSO.copyFile fromFile, toFile, True
    Next i
    
    Set FSO = Nothing
    copyFiles = True
End Function

'=============================
'�t�@�C�������󂯂�workbook�I�u�W�F�N�g���擾
'  [i]file  Excel�̃t���p�X
'  [o]wb    workbook�I�u�W�F�N�g
'  *** �擾����wb�I�u�W�F�N�g�͖{�֐��̊O��wb.close����
'--------------------------------------------------
Public Function getWorkbookObj(ByVal file As String, _
                        ByRef wb As Workbook) As Boolean
    Dim ret As Workbook
    Dim wbTmp As Workbook
    Dim buf As String
    
    '�t�@�C���̑��݊m�F
    buf = Dir(file)
    If buf = "" Then
        getWorkbookObj = False
        Exit Function
    End If
    
    '���ɊJ���Ă����ꍇ
    For Each wbTmp In Workbooks
        If wbTmp.name = buf Then
            Set wb = wbTmp
            getWorkbookObj = True
            Exit Function
        End If
    Next wbTmp
    
    Set wb = GetObject(file)
    getWorkbookObj = True
    
End Function

'=============================
'�t���p�X��Collection���󂯁A�t�@�C�����ƕۑ�����Ă���t�H���_����Collection��Ԃ�
'  [i]fullPaths Excel�̃t���p�X��~�ς���Collection
'  [o]folders       �t�@�C�����ƕۑ�����Ă���t�H���_����2����Array
'  [o]filenames       �t�@�C�����ƕۑ�����Ă���t�H���_����2����Array
'--------------------------------------------------
Public Function getFolderAndFileNameColl(ByVal fullPaths As Collection, _
                                                                ByRef folders As Collection, _
                                                                ByRef filenames As Collection _
                                                                ) As Boolean
    If fullPaths.count < 1 Then
        getFolderAndFileNameColl = False
        Exit Function
    End If
    
    Dim retFolders As New Collection
    Dim retFiles As New Collection
    Dim item As Variant
    Dim file As String
    Dim folder As String
    Dim bRet As Boolean
  
    For Each item In fullPaths
        bRet = getFolderAndFileName(item, True, folder, file)
        If bRet Then
            retFolders.Add (folder)
            retFiles.Add (file)
        End If
    Next item
    
    Set folders = retFolders
    Set filenames = retFiles
    getFolderAndFileNameColl = True
End Function

'=============================
'�t���p�X��Collection���󂯁A�t�@�C�����ƕۑ�����Ă���t�H���_����2����Array��Ԃ�
'  [i]fullPaths Excel�̃t���p�X��~�ς���Collection
'  [o]dat       �t�@�C�����ƕۑ�����Ă���t�H���_����2����Array
'--------------------------------------------------
Public Function getFolderAndFileNameArr(ByVal fullPaths As Collection, _
                                        ByRef dat As Variant) As Boolean
    Dim retTmp As Variant
    Dim fullPath As String
    Dim file As String
    Dim folder As String
    Dim i As Long
    Dim bRet As Boolean
    
    If fullPaths.count < 1 Then
        getFolderAndFileNameArr = False
        Exit Function
    End If
    
    ReDim retTmp(1 To fullPaths.count, 1 To 2)
    For i = 1 To fullPaths.count Step 1
        fullPath = fullPaths(i)
        bRet = getFolderAndFileName(fullPath, True, folder, file)
        If bRet Then
            retTmp(i, 1) = folder
            retTmp(i, 2) = file
        End If
    Next i
    
    dat = retTmp
    getFolderAndFileNameArr = True
End Function

'=============================
'�t�@�C���̃t���p�X���󂯁A�t�@�C�����ƕۑ�����Ă���t�H���_����Ԃ�
'  [i]fullPaths     Excel�̃t���p�X��~�ς���Collection
'  [i]extflg        �g���q�̗v�� true=�g���q���� false=�g���q�Ȃ�
'  [o]folder        �t�H���_��
'  [o]file            �t�@�C���� �g���q����
'--------------------------------------------------
Public Function getFolderAndFileName(ByVal fullPath As String, _
                                                            ByVal extFlg As Boolean, _
                                                                ByRef folder As String, _
                                                                ByRef file As String _
                                                                ) As Boolean
    Dim FSO As Object
    Dim bRet As Boolean
    Dim dot As Long
    Set FSO = CreateObject("Scripting.FileSystemObject")
    
    '�t�@�C�����Ȃ��ꍇ�G���[
    bRet = FSO.FileExists(fullPath)
    If Not bRet Then
        Debug.Print "err ::: file does not exist.(" & fullPath & ")  [func:insertColIntoArray()]" & Now
        getFolderAndFileName = False
        Exit Function
    End If
    
    file = FSO.GetFile(fullPath).name
    '�g���q���������t�@�C�����̎擾
    If extFlg = False Then
        dot = InStrRev(file, ".")
        file = Left(file, dot - 1)
    End If
    
    folder = FSO.getFolder(FSO.GetFile(fullPath).ParentFolder).name
    
    Set FSO = Nothing
    getFolderAndFileName = True
End Function

'=============================
'Workbook�Ɠ��f�B���N�g���ɂ���w�肵���g���q�̃t�@�C���̃t�@�C�����擾
'  [o]ret       �t�@�C������~�ς���Collection
'--------------------------------------------------
Public Function getAllFileNameCol(ByVal ext As String, _
                                    ByRef ret As Collection) As Boolean
    Dim FSO As Object
    Dim folder As Variant
    Dim file As Variant
    
    Dim Path As String
    Path = ThisWorkbook.Path
    
    
    Set FSO = CreateObject("Scripting.FileSystemObject")
    For Each folder In FSO.getFolder(Path).SubFolders
        Call getAllXlsFilePathCol(folder.Path, ret)
    Next folder
    For Each file In FSO.getFolder(Path).files
        If InStr(1, file.name, ext, vbTextCompare) > 0 Then
            ret.Add (file.name)
        End If
    Next file
    Set FSO = Nothing
    
    If ret.count < 1 Then
        getAllFileNameCol = False
    Else
        getAllFileNameCol = True
    End If
End Function
                            