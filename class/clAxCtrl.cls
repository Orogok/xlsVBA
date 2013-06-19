VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clAxCtrl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'==================================================
'ActiveX�R���g���[����checkBox���w���Ɏw�萔�z�u����B
'checkBox�̒l�ƁA�w���̃Z���̒l�ƃ����N��������ԁB
'  [i]wb        �Ώۂ�Workbook
'  [i]shName    checkBox��z�u����V�[�g��
'  [i]rowS      �z�u����ŏ��̍s
'  [i]colVal    �����N����Z���̗�
'  [i]colCtrl   checkBox��z�u�����
'  [i]count     �z�u���鐔
'--------------------------------------------------
Public Function putChkBoxesV(ByVal wb As Workbook, _
                                ByVal shName As String, _
                                ByVal rowS As Long, _
                                ByVal colVal As Long, _
                                ByVal colCtrl As Long, _
                                ByVal count As Long) As Boolean
    Dim objChkBox As OLEObject
    Dim i As Long
    Dim rngCtrl As Range
    Dim rngVal As Range
    Dim chkBoxHeight As Integer
    Dim chkBoxWidth As Integer
    
    'checkBox�̃T�C�Y���w��
    chkBoxHeight = 15
    chkBoxWidth = 15
    
    '��ʍX�V���ꎞ�I��OFF
    Application.ScreenUpdating = False
    
    With wb.Worksheets(shName)
        .Select
    
        For i = 1 To count
            'checkBox��z�u����Z�����擾
            Set rngCtrl = .Range(.Cells(rowS + i - 1, colCtrl), .Cells(rowS + i - 1, colCtrl))
            
            'checkBox�̒l�ƘA��������Z�����擾
            Set rngVal = .Range(.Cells(rowS + i - 1, colVal), .Cells(rowS + i - 1, colVal))
            
            With .OLEObjects.Add(ClassType:="Forms.CheckBox.1")
                .name = "chkBox_" & i
                '�Z���̒����ɔz�u
                .Left = rngCtrl.Left + rngCtrl.Width / 2 - chkBoxWidth / 2
                .Top = rngCtrl.Top + rngCtrl.Height / 2 - chkBoxHeight / 2
                .Height = 16
                .Width = 15
                .LinkedCell = Replace(rngVal.Address, "$", "")
                .Object.Caption = ""
                .Object.Value = False
            End With
        Next
    
    End With

    '��ʍX�V��ON�ɖ߂�
    Application.ScreenUpdating = True
    
    putChkBoxesV = True
End Function
