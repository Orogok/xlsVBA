Attribute VB_Name = "ctrls"
Option Explicit

'==================================================
'ActiveX�R���g���[����checkBox���w���Ɏw�萔�z�u����B
'checkBox�̒l�ƁA�w���̃Z���̒l�ƃ����N��������ԁB
'  [i]shName    checkBox��z�u����V�[�g��
'  [i]rowS      �z�u����ŏ��̍s
'  [i]colVal    �����N����Z���̗�
'  [i]colCtrl   checkBox��z�u�����
'  [i]count     �z�u���鐔
'--------------------------------------------------
Sub putChkBoxes(ByVal shName As String, _
                ByVal rowS As Long, _
                ByVal colVal As Long, _
                ByVal colCtrl As Long, _
                ByVal count As Long)
                
    Dim objChkBox As OLEObject
    Dim i As Long
    Dim rngCtrl As Range
    Dim rngVal As Range
    
    '��ʍX�V���ꎞ�I��OFF
    Application.ScreenUpdating = False
    
    With Worksheets(shName)
        .Select
    
        For i = 1 To count
            'checkBox��z�u����Z�����擾
            Set rngCtrl = .Range(.Cells(rowS + i - 1, colCtrl), .Cells(rowS + i - 1, colCtrl))
            
            'checkBox�̒l�ƘA��������Z�����擾
            Set rngVal = .Range(.Cells(rowS + i - 1, colVal), .Cells(rowS + i - 1, colVal))
            
            With .OLEObjects.Add(ClassType:="Forms.CheckBox.1")
                .name = "chk_" & i
                .Left = rngCtrl.Left
                .Top = rngCtrl.Top
                .LinkedCell = Replace(rngVal.Address, "$", "")
                .Object.Caption = "chk_" & i
                .Object.Value = False
            End With
        Next
    
    End With

    '��ʍX�V��ON�ɖ߂�
    Application.ScreenUpdating = True

End Sub
