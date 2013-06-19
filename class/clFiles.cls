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

'==================================================
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

'==================================================
'�t���p�X��Collection���󂯁A�t�@�C�����ƕۑ�����Ă���t�H���_����2����Array��Ԃ�
'  [i]fullPaths Excel�̃t���p�X��~�ς���Collection
'  [o]dat       �t�@�C�����ƕۑ�����Ă���t�H���_����2����Array
'--------------------------------------------------
Public Function getFolderAndFileNameArr(ByVal fullPaths As Collection, _
                                        ByRef dat As Variant) As Boolean
    Dim FSO As Object
    Dim retTmp As Variant
    Dim fullPath As String
    Dim file As String
    Dim folder As String
    Dim i As Long
    
    If fullPaths.count < 1 Then
        getFolderAndFileNameArr = False
        Exit Function
    End If
    
    Set FSO = CreateObject("Scripting.FileSystemObject")
    ReDim retTmp(1 To fullPaths.count, 1 To 2)
    For i = 1 To fullPaths.count Step 1
        fullPath = fullPaths(i)
        file = FSO.GetFile(fullPath).name
        folder = FSO.getFolder(FSO.GetFile(fullPath).ParentFolder).name
        retTmp(i, 1) = folder
        retTmp(i, 2) = file
    Next i
    Set FSO = Nothing
    
    dat = retTmp
    getFolderAndFileNameArr = True
End Function

'==================================================
'�w�肵���f�B���N�g���z���ɂ���SExcel�t�@�C���̃t���p�X�擾
'  [i]path      ��������f�B���N�g���̃p�X
'  [o]ret       Excel�̃t���p�X��~�ς���Collection
'--------------------------------------------------
Public Function getAllXlsFilePathCol(ByVal path As String, _
                                    ByRef ret As Collection) As Boolean
    Dim FSO As Object
    Dim folder As Variant
    Dim file As Variant
    
    Set FSO = CreateObject("Scripting.FileSystemObject")
    For Each folder In FSO.getFolder(path).SubFolders
        Call getAllXlsFilePathCol(folder.path, ret)
    Next folder
    For Each file In FSO.getFolder(path).files
        If InStr(file.Type, "Excel") > 0 Then
            ret.Add (file.path)
        End If
    Next file
    Set FSO = Nothing
    
    If ret.count < 1 Then
        getAllXlsFilePathCol = False
    Else
        getAllXlsFilePathCol = True
    End If
End Function


                            