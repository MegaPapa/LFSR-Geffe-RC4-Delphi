object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1055#1086#1090#1086#1082#1086#1074#1086#1077' '#1096#1080#1092#1088#1086#1074#1072#1085#1080#1077
  ClientHeight = 428
  ClientWidth = 941
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object EditLFSR1: TEdit
    Left = 343
    Top = 306
    Width = 194
    Height = 21
    MaxLength = 26
    TabOrder = 0
    OnKeyPress = EditLFSR1KeyPress
  end
  object ButtonGenerateLFSR1: TButton
    Left = 343
    Top = 279
    Width = 75
    Height = 25
    Caption = 'Generate'
    TabOrder = 1
    OnClick = ButtonGenerateLFSR1Click
  end
  object MemoLFSR1: TMemo
    Left = 343
    Top = 333
    Width = 194
    Height = 90
    Lines.Strings = (
      'MemoLFSR1')
    TabOrder = 2
  end
  object ButtonOpen: TButton
    Left = 8
    Top = 348
    Width = 75
    Height = 25
    Caption = 'Open'
    TabOrder = 3
    OnClick = ButtonOpenClick
  end
  object RadioButtonLFSR: TRadioButton
    Left = 8
    Top = 279
    Width = 113
    Height = 17
    Caption = 'RadioButtonLFSR'
    Checked = True
    TabOrder = 4
    TabStop = True
    OnClick = RadioButtonLFSRClick
  end
  object RadioButtonGeffe: TRadioButton
    Left = 8
    Top = 302
    Width = 113
    Height = 17
    Caption = 'RadioButtonGeffe'
    TabOrder = 5
    OnClick = RadioButtonGeffeClick
  end
  object RadioButtonRC4: TRadioButton
    Left = 8
    Top = 325
    Width = 113
    Height = 17
    Caption = 'RadioButtonRC4'
    TabOrder = 6
    OnClick = RadioButtonRC4Click
  end
  object ButtonCiphr: TButton
    Left = 113
    Top = 348
    Width = 75
    Height = 25
    Caption = 'Ciphr'
    TabOrder = 7
    OnClick = ButtonCiphrClick
  end
  object ButtonDeciphr: TButton
    Left = 199
    Top = 348
    Width = 75
    Height = 25
    Caption = 'Deciphr'
    TabOrder = 8
    OnClick = ButtonDeciphrClick
  end
  object MemoLFSR2: TMemo
    Left = 543
    Top = 333
    Width = 194
    Height = 89
    Lines.Strings = (
      'MemoLFSR2')
    TabOrder = 9
  end
  object MemoLFSR3: TMemo
    Left = 743
    Top = 333
    Width = 193
    Height = 89
    Lines.Strings = (
      'MemoLFSR3')
    TabOrder = 10
  end
  object EditLFSR2: TEdit
    Left = 543
    Top = 306
    Width = 194
    Height = 21
    MaxLength = 34
    TabOrder = 11
  end
  object EditLFSR3: TEdit
    Left = 743
    Top = 306
    Width = 193
    Height = 21
    MaxLength = 24
    TabOrder = 12
  end
  object ButtonGenerateLFSR2: TButton
    Left = 543
    Top = 275
    Width = 75
    Height = 25
    Caption = 'Generate'
    Enabled = False
    TabOrder = 13
    OnClick = ButtonGenerateLFSR2Click
  end
  object ButtonGenerateLFSR3: TButton
    Left = 743
    Top = 279
    Width = 75
    Height = 25
    Caption = 'Generate'
    Enabled = False
    TabOrder = 14
    OnClick = ButtonGenerateLFSR3Click
  end
  object EditRC4: TEdit
    Left = 127
    Top = 277
    Width = 187
    Height = 21
    Enabled = False
    TabOrder = 15
    OnKeyPress = EditRC4KeyPress
  end
  object ButtonAddRC4: TButton
    Left = 127
    Top = 304
    Width = 75
    Height = 25
    Caption = 'Add Key'
    Enabled = False
    TabOrder = 16
    OnClick = ButtonAddRC4Click
  end
  object ButtonClearKey: TButton
    Left = 239
    Top = 304
    Width = 75
    Height = 25
    Caption = 'Clear Key'
    Enabled = False
    TabOrder = 17
    OnClick = ButtonClearKeyClick
  end
  object MemoCiphrRC4: TMemo
    Left = 796
    Top = 8
    Width = 137
    Height = 248
    Lines.Strings = (
      'MemoCiphrRC4')
    TabOrder = 18
  end
  object Button1: TButton
    Left = 160
    Top = 395
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 19
    OnClick = Button1Click
  end
  object PanelTexts: TPanel
    Left = 8
    Top = 8
    Width = 257
    Height = 248
    TabOrder = 20
    object LabelMemoText: TLabel
      Left = 105
      Top = 5
      Width = 26
      Height = 13
      Caption = 'Text:'
    end
    object LabelMemoBinText: TLabel
      Left = 89
      Top = 127
      Width = 57
      Height = 13
      Caption = 'Binary text:'
    end
    object MemoBinText: TMemo
      Left = 0
      Top = 144
      Width = 249
      Height = 97
      Lines.Strings = (
        'MemoBinText')
      TabOrder = 0
    end
    object MemoText: TMemo
      Left = 0
      Top = 24
      Width = 249
      Height = 97
      Lines.Strings = (
        'MemoText')
      TabOrder = 1
    end
  end
  object PanelCiphr: TPanel
    Left = 271
    Top = 8
    Width = 273
    Height = 248
    TabOrder = 21
    object LabelCiphrText: TLabel
      Left = 105
      Top = 5
      Width = 49
      Height = 13
      Caption = 'Ciphrtext:'
    end
    object LabelCiphr: TLabel
      Left = 89
      Top = 125
      Width = 83
      Height = 13
      Caption = 'Binary ciphrtext :'
    end
    object MemoCiphrText: TMemo
      Left = 0
      Top = 24
      Width = 265
      Height = 97
      Lines.Strings = (
        'MemoCiphrText')
      TabOrder = 0
    end
    object MemoCiphr: TMemo
      Left = 0
      Top = 144
      Width = 265
      Height = 97
      Lines.Strings = (
        'MemoCiphr')
      TabOrder = 1
    end
  end
  object PanelKey: TPanel
    Left = 550
    Top = 152
    Width = 243
    Height = 104
    TabOrder = 22
    object Label6: TLabel
      Left = 97
      Top = 5
      Width = 45
      Height = 13
      Caption = 'RC4 Key:'
    end
    object MemoKey: TMemo
      Left = 0
      Top = 24
      Width = 240
      Height = 73
      Lines.Strings = (
        'MemoKey')
      TabOrder = 0
    end
  end
  object PanelDeciphr: TPanel
    Left = 550
    Top = 8
    Width = 243
    Height = 138
    TabOrder = 23
    object Label5: TLabel
      Left = 89
      Top = 5
      Width = 63
      Height = 13
      Caption = 'Deciphr text:'
    end
    object MemoDeciphr: TMemo
      Left = 0
      Top = 24
      Width = 240
      Height = 105
      Lines.Strings = (
        'MemoDeciphr')
      TabOrder = 0
    end
  end
  object OpenDialog: TOpenDialog
    Left = 81
    Top = 352
  end
  object SaveDialog: TSaveDialog
    Left = 289
    Top = 344
  end
end
