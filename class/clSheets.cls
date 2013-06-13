VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clSheets"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit






'==================================================
'�����V�[�g�̒��̃f�[�^���������āAArray�Ɋi�[
'  [i]shNames   �����Ώۂ̃V�[�g����������Collection
'  [i]datRowS   �f�[�^�̈�̃X�^�[�g�s
'  [i]datColS   �f�[�^�̈�̍ŏ��̗�i��ԍ��̗�)
'  [i]datColE   �f�[�^�̈�̍Ō�̗�i��ԉE�̗�)
'  [o]dat       ���������f�[�^
'  [o]row       �ŏI�s��
'--------------------------------------------------
Public Function combineSheets(ByVal shNames As Collection, _
                                ByVal datRowS As Long, _
                                ByVal datColS As Long, _
                                ByVal datColE As Long, _
                                    ByRef dat As Variant, _
                                    ByRef row As Long) As Boolean
    Dim sh As New clSheet
    Dim datArr As New clDatArr
    Dim retTmpBucket As Variant
    ReDim retTmpBucket(1 To MAX_ROW, 1 To datColE - datColS + 1)
    Dim datBySheet As Variant
    Dim rowBySheet As Long
    Dim colBySheet As Long
    Dim bRet  As Boolean
    Dim shName As Variant
    Dim indexRow As Long
    Dim lastRow As Long
    
    
    indexRow = 1
    For Each shName In shNames
        '�V�[�g�̗L�����`�F�b�N
        If sh.existSheet(shName) Then
            '�V�[�g����Data���擾
            bRet = sh.getAllDataAsArray(shName, datRowS, datColS, datColE, datBySheet, rowBySheet, colBySheet)
            If bRet Then
                '�擾����Data��bucket�ɒǉ�
                bRet = datArr.addArray(datBySheet, indexRow, retTmpBucket, lastRow)
                If Not bRet Then
                    '�I�[�o�[�t���[����\��������̂ŏ������~
                    Exit Function
                End If
                indexRow = lastRow + 1
            End If
        End If
    Next
    
    '�Ԃ�l���쐬
    bRet = datArr.formatArray(retTmpBucket, lastRow, colBySheet, dat)
    row = lastRow
    combineSheets = True
End Function