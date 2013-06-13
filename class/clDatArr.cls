VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clDatArr"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'==================================================
'2�����z��(arr)���A(newRow, newCol)��2�����z��ɐ��`���ĕԂ��B
'�l������Ȃ��v�f��Empty�ɂȂ�B
'  [i]arr       ���`����z��
'  [i]newRow    ���`��̍s���i���R�[�h���j
'  [i]newCol    ���`��̗�i�t�B�[���h���j
'  [o]dat       ���`��̔z��
'--------------------------------------------------
Public Function formatArray(ByVal arr As Variant, _
                            ByVal newRow As Long, _
                            ByVal newCol As Long, _
                            ByRef dat As Variant _
                            ) As Boolean
                            
    '�l��ݒ肷��ׂ́A���ۂ̃��[�v���������擾
    Dim loopRow As Long
    Dim loopCol As Long
    If UBound(arr, 1) > newRow Then
        loopRow = newRow
    Else
        loopRow = UBound(arr, 1)
    End If
    If UBound(arr, 2) > newCol Then
        loopCol = newCol
    Else
        loopCol = UBound(arr, 2)
    End If
    
    '2�����z��𐮌`
    Dim retTmpBucket As Variant
    ReDim retTmpBucket(1 To newRow, 1 To newCol)
    Dim i As Long
    Dim j As Long
    For i = 1 To loopRow Step 1
        For j = 1 To loopCol Step 1
            retTmpBucket(i, j) = arr(i, j)
        Next j
    Next i

    dat = retTmpBucket
    formatArray = True
                            
End Function


'==================================================
'2�����z��(arr)���A2�����z��(dat)�ɒǉ����ĕԂ�
'dat�ɑ΂��āAindexRow�Ŏw�肳�ꂽ�������ŏ��̃��R�[�h�̓Y�����Ƃ���arr��ǉ�����B
'  [i]arr        �ǉ�����z��
'  [i]indexRow    �ǉ�����ۂ̐擪���R�[�h�̓Y����
'  [i/o]dat       �ǉ������e�z��
'  [o]row         �ǉ���̍ŏI���R�[�h�̓Y����
'--------------------------------------------------
Public Function addArray(ByVal arr As Variant, _
                            ByVal indexRow As Long, _
                            ByRef dat As Variant, _
                            ByRef row As Long) As Boolean
    '���ڐ��i�񐔁j���������`�F�b�N
    Dim col As Long
    col = UBound(dat, 2)
    If col <> UBound(arr, 2) Then
        Debug.Print "err ::: no much columns. [func:combineArray()]" & Now
        addArray = False
        Exit Function
    End If
    
    'dat��arr�����Ă��I�[�o�[�t���[���Ȃ����`�F�b�N
    Dim rowDat As Long
    Dim rowA As Long
    rowDat = UBound(dat, 1)
    rowA = UBound(arr, 1)
    If rowDat < rowA + indexRow - 1 Then
        Debug.Print "err ::: not enough size. [func:combineArray()]" & Now
        addArray = False
        Exit Function
    End If
    
    'arr�̒��g��dat�ɓ����
    Dim i As Long
    Dim j As Long
    For i = 1 To rowA Step 1
        For j = 1 To col
            dat(indexRow + i - 1, j) = arr(i, j)
        Next j
    Next i
    row = indexRow + rowA - 1
    addArray = True
End Function
