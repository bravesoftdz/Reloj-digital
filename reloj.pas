unit Reloj;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, ComCtrls, StdCtrls, TplLCDLineUnit, DateUtils, {Windows,} MMSystem;

type

  { TFPrinc }

  TFPrinc = class(TForm)
    CBSonido: TCheckBox;
    LCDFecha: TplLCDLine;
    LCDHora: TplLCDLine;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SBar: TStatusBar;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    function FormatoAMPM(ConSonido: boolean): string;
    function GenerarHora: string;
  public
    { public declarations }
  end;

var
  FPrinc: TFPrinc;

implementation

{$R *.lfm}

const
  HoraX: array [1..12] of string=(
    'La una ','Las dos ','Las tres ','Las cuatro ',
    'Las cinco ','Las seis ','Las siete ','Las ocho ',
    'Las nueve ','Las diez ','Las once ','Las doce ');
  MinDec: array [1..5] of string=(
    'y diez ','y veinte ','y treinta ','y cuarenta ','y cincuenta ');
  MinUnid: array [0..9] of string=(
    'y cero','y un','y dos','y tres','y cuatro',
    'y cinco','y seis','y siete','y ocho','y nueve');
  MinMenor20: array [1..9] of string=(
    'y once','y doce','y trece','y catorce','y quince',
    'y dieciseis','y diecisiete','y dieciocho','y diecinueve');
  Min=' minutos';

{ TFPrinc }

function TFPrinc.FormatoAMPM(ConSonido: boolean): string;
var
  HoraTotal: TTime;
  HoraCompleta,EsAMPM: string;
  Tiempo,Seg: byte;
begin
  HoraTotal:=Time;
  //se determina la hora:
  Tiempo:=HourOf(HoraTotal);
  if IsPM(HoraTotal) then
  begin
    if Tiempo>12 then
      if Tiempo-12<10 then HoraCompleta:='0'+IntToStr(Tiempo-12)+':'
      else HoraCompleta:=IntToStr(Tiempo-12)+':'
    else HoraCompleta:=IntToStr(12)+':';
    EsAMPM:=' PM';
  end
  else
  begin
    if Tiempo>9 then HoraCompleta:=IntToStr(Tiempo)+':'
    else
      if Tiempo=0 then HoraCompleta:=IntToStr(12)+':'
      else HoraCompleta:='0'+IntToStr(Tiempo)+':';
    EsAMPM:=' AM';
  end;
  //se determina los minutos:
  Tiempo:=MinuteOf(HoraTotal);
  if Tiempo>9 then HoraCompleta:=HoraCompleta+IntToStr(Tiempo)+':'
  else HoraCompleta:=HoraCompleta+'0'+IntToStr(Tiempo)+':';
  //se determina los segundos:
  Seg:=SecondOf(HoraTotal);
  if Seg>9 then HoraCompleta:=HoraCompleta+IntToStr(Seg)
  else HoraCompleta:=HoraCompleta+'0'+IntToStr(Seg);
  //se activa o no el sonido a una hora en punto:
  if ConSonido then
    if (Tiempo=0) and (Seg=0) then sndPlaySound('Speech On.wav',SND_SYNC);
  Result:=HoraCompleta+EsAMPM;
end;

function TFPrinc.GenerarHora: string;
var
  HoraTotal: TTime;  HoraCompleta: string;
  Hora,Minutos,MinDc,MinUn: word;
begin
  HoraTotal:=Time;
  //se determina la hora:
  if IsPM(HoraTotal) then Hora:=HourOf(HoraTotal)-12
                     else Hora:=HourOf(HoraTotal);
  if Hora=0 then HoraCompleta:=HoraX[12]
            else HoraCompleta:=HoraX[Hora];
  //se determinan los minutos:
  Minutos:=MinuteOf(HoraTotal);
  if Minutos<10 then HoraCompleta:=HoraCompleta+MinUnid[Minutos]
  else
    if Minutos in [11..19] then
      HoraCompleta:=HoraCompleta+MinMenor20[Minutos-10]
    else
    begin
      MinDc:=Minutos div 10;
      MinUn:=Minutos mod 10;
      HoraCompleta:=HoraCompleta+MinDec[MinDc];
      if Minutos in [21..29,31..39,41..49,51..59] then
        HoraCompleta:=HoraCompleta+MinUnid[MinUn];
    end;
  Result:=HoraCompleta+Min;
end;

procedure TFPrinc.Timer1Timer(Sender: TObject);
begin
  LCDFecha.Text:=DateToStr(Date);
  SBar.Panels[0].Text:=TimeToStr(Time)+': '+GenerarHora;
  LCDHora.Text:=' '+FormatoAMPM(CBSonido.Checked);
end;

procedure TFPrinc.FormShow(Sender: TObject);
begin
  LCDFecha.Text:=DateToStr(Date);
  LCDHora.Text:=' '+FormatoAMPM(CBSonido.Checked);
end;

procedure TFPrinc.SpeedButton1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFPrinc.SpeedButton2Click(Sender: TObject);
begin
  ShowMessage('Reloj NASA v1.0'+#13+#13+'Autor: Ing. Francisco J. Sáez S.'+#13+
              'Hecho con Lazarus v1.0.8'+#13+'Calabozo, Noviembre de 2.013');
end;

end.
