Attribute VB_Name = "g_list"
Option Explicit

'�O���[�o���ϐ��A�萔�̐ݒ�p���W���[��
'�C�j�V�����C�Y���K�v�ȃO���[�o���ϐ��A�萔�Ɋւ��Ă�ThisWorkbook�N���X�ɂăC�j�V�����C�Y����

Public Const MAX_ROW As Long = 65536     '�ő�s�ԍ�
Public Const MAX_COL As Long = 100          '�ő��ԍ�
Public Const TOOL As String = "$tool"           '�c�[���V�[�g��
Public Const INPSH As String = "$allInptSheets" '�S�C���v�b�g�V�[�g��ۑ�����t�H���_�̖��O
Public Const PMASTER As String = "$PartsMaster" '�p�[�c�}�X�^�[�V�[�g��
Public g_dealers As New Collection                      '�f�B�[���[����Collection
Public g_desktop As String                          '�f�X�N�g�b�v�p�X

'DB�V�[�g�̃t�H�[�}�b�g���
Public Const TOOLDB As String = "$$$db"
Enum dbnum
    confmaster_orgPath = 1
    confmaster_foldername = 2
    confmaster_filename = 3
End Enum

'�p�[�c�\���}�X�^�[�V�[�g�̃t�H�[�}�b�g���
Enum confmasterSh
    '�f�[�^�̗̈��N3����X�^�[�g
    datRowS = 6
    datColS = 14
    '�f�[�^�̗̈��S�i19��j�܂�
    datColE = 19
End Enum

'$tool�V�[�g�̃t�H�[�}�b�g���
 Enum toolSh
 '$tool�V�[�g���̃C���v�b�g�V�[�g���X�g�͈̔�
    rowUL = 22
    colUL = 3
    rowLR = 36
    colLR = 12
End Enum

Public Sub init()
    Dim sh As New clSheet
    Dim da As New clDatArr
    Dim bRet As Boolean
    
    '�f�B�[�������擾
    Dim dealers As Variant
    Dim col As Long
    Dim row As Long
    bRet = sh.getAllDataAsArray(ThisWorkbook, TOOL, 21, 21, 5, 11, dealers, row, col)
    bRet = da.cnvArrToColl(dealers, g_dealers)
    
    '�z�z�p�V�[�g�Ɋ܂߂���I�����邽�߂̃��X�g�{�b�N�X�̏����ݒ�
    Dim lstBx As MSForms.ListBox
    Set lstBx = ThisWorkbook.Sheets(TOOL).ListBox_addColumn
    With lstBx
        If .ListCount < 1 Then
            .AddItem ("UGL���l")
            .AddItem ("UGL�ύX����")
            .AddItem ("UGL�̔����i")
            .AddItem ("UGL�Ǘ�No")
        End If
    End With
    
    '�f�X�N�g�b�v�ɐe�t�H���_(�t�H���_���FInputSheets)�����
    Dim WSH As Variant
    Set WSH = CreateObject("Wscript.Shell")
    g_desktop = WSH.SpecialFolders("Desktop")
    Set WSH = Nothing
End Sub


