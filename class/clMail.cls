VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clMail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'=============================
'�A�h���X�A�^�C�g���A�{����ݒ肵���[�����N������B�i�Y�t�t�@�C���Ȃ��j
'  [i]wb          ThisWorkbook
'  [i]toAddr    ���惁�[���A�h���X
'  [i]subj        ���[���̃^�C�g��
'  [i]bdy         ���[���̖{��
'--------------------------------------------------
Public Function openMailer(ByVal wb As Workbook, _
                                        ByVal toAddr As String, _
                                        ByVal subj As String, _
                                        ByVal bdy As String _
                                        ) As Boolean
    Dim strLink As String
    strLink = "mailto:" & toAddr & "?subject=" & subj & "&body=" & bdy
    wb.FollowHyperlink strLink
    openMailer = True
End Function

'=============================
'�A�h���X�A�^�C�g���A�{���A�Y�t�t�@�C����ݒ肵outlook���N������
'  [i]toAddr          ���惁�[���A�h���X
'  [i]subj              ���[���̃^�C�g��
'  [i]bdy               ���[���̖{��
'  [i]attachPath    �Y�t�t�@�C���̃t���p�X
'--------------------------------------------------
Public Function openOutlook(ByVal toAddr As String, _
                                        ByVal subj As String, _
                                        Optional ByVal bdy As String = "", _
                                        Optional ByVal attachPath As String = "" _
                                        ) As Boolean
    Dim OLK As Outlook.Application
    Dim mailItem As Outlook.mailItem
    
    Set OLK = CreateObject("Outlook.Application")
    Set mailItem = OLK.CreateItem(olMailItem)

    mailItem.To = toAddr
    mailItem.CC = ""
    mailItem.BCC = ""
    mailItem.subject = subj
    mailItem.Importance = olImportanceNormal
    If attachPath <> "" Then
        mailItem.Attachments.Add attachPath
    End If
    mailItem.body = bdy

    mailItem.Display
    Set mailItem = Nothing
    Set OLK = Nothing
    openOutlook = True
End Function
