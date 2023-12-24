object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 280
  Width = 386
  object conn: TFDConnection
    Params.Strings = (
      'Database=C:\Delphi\99Money\DB\banco.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 48
    Top = 32
  end
end
