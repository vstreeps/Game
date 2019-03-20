uses GraphABC;
const
  N = 2;
  Z = '0';
  K = 'X';
  Size = 200;
  Border = 1;
  Sx = 1200;
  Sy = 70;
  i = 2;
  

var
  Matrix: array [0..N, 0..N] of char;
  Massiv: array [0..i, 0..i] of integer;
  Player1: boolean;
  t1: integer;
  t2: integer;
  t3: integer;
  t4: integer;
  fi1,fi2,fi3,fi4: text;
  strt1,strt2,strt3,s1: string;
  
procedure Draw();
  procedure DrawZ(i, j: integer);
  begin
    SetPenColor(clBlack);
    SetPenWidth(4);
    var size2 := Size div 2;
    DrawCircle((i + 1) * Size - size2, (j + 1) * Size - size2, Round(size2 * 0.7));
  end;
  
  procedure DrawK(i, j: integer);
    procedure RLine(x, y, x1, y1: real):=Line(Round(x), Round(y), Round(x1), Round(y1));

  begin
    SetPenColor(clRed);
    SetPenWidth(4);
    var size2 := Size div 2 * 0.3;
    var cx1 := i * Size + size2;
    var cy1 := j * Size + size2;
    var cx2 := (i + 1) * Size - size2;
    var cy2 := (j + 1) * Size - size2;
    RLine(cx1, cy1, cx2, cy2);
    RLine(cx1, cy2, cx2, cy1);
  end;

  begin
    ClearWindow(clWhite);
    if Player1 then SetWindowCaption('Ходит первый игрок') else SetWindowCaption('Ходит второй игрок');
    for var i := 0 to N do
      for var j := 0 to N do
      begin
        SetPenColor(clBlack);
        SetPenWidth(1);
        DrawRectangle(i * Size + Border, j * Size + Border, (i + 1) * Size - Border, (j + 1) * Size - Border);
        if Matrix[i, j] = Z then DrawZ(i, j)
        else if Matrix[i, j] = K then DrawK(i, j);
      end;
    Redraw();
  end;

function Won(c: char): boolean;
var
  count: byte;
begin
  Result := false;
  for var i := 0 to N do
  begin
    count := 0;
    for var j := 0 to N do
      if Matrix[i, j] = c then Inc(count);
    if count = 3 then Result := true;
  end;
  
  if not Result then
  begin
    for var i := 0 to N do
    begin
      count := 0;
      for var j := 0 to N do
        if Matrix[j, i] = c then Inc(count);
      if count = 3 then Result := true;
    end;
    
    if not Result then
    begin
      count := 0;
      for var i := 0 to N do
        if Matrix[i, i] = c then Inc(count);
      if count = 3 then Result := true;
      
      if not Result then
      begin
        count := 0;
        for var i := 0 to N do
          if Matrix[N - i, i] = c then Inc(count);
        if count = 3 then Result := true;
      end;
    end;
  end;
end;

function IsFull(): boolean;
begin
  Result := true;
  for var i := 0 to N do
    for var j := 0 to N do
      if (Matrix[i, j] <> Z) and (Matrix[i, j] <> K) then
      begin
        Result := false;
        break;
      end;
end;

procedure MouseDown(x, y, mb: integer);
  procedure ShowWinner(s: string;  t: integer; s1:string; s2: string; t4: integer; c: Color);
  begin
    SetWindowCaption('Результат игры');
    Sleep(1500);
    SetWindowSize(Sx, Sy);
    CenterWindow();
    ClearWindow(clWhite);
    
    SetFontSize(16);
    SetFontStyle(fsItalic);
    SetFontColor(c);
    s:=s + inttostr(t);
    s2:=s2 + inttostr(t4);
    DrawTextCentered(0, 0, Sx, Sy, s);
    DrawTextCentered(0, 0, Sx + 320, Sy, s1);
    DrawTextCentered(0, 0, Sx + 600, Sy, s2);
    
    Redraw();
    Sleep(5000);
    Halt();
  end;

begin    
  var i := x div Size;
  var j := y div Size;
  if (Matrix[i, j] <> Z) and (Matrix[i, j] <> K) then
  begin
    if Player1 then Matrix[i, j] := Z else Matrix[i, j] := K;
    t4:=t4 +1;
    Massiv[i, j]:= t4;
    Draw();
    
    var winnerExists := Won(Z) or Won(K);
    if Won(Z) then t1:=t1 + 1;
    if Won(K) then t2:=t2 + 1;
    
    assign(fi1,'result1.txt');
    reset(fi1);readln(fi1,strt1);
    t1 := strtoint(strt1);
    write(t1);
    close(fi1);
    
    assign(fi2,'result2.txt');
    reset(fi2);readln(fi2,strt2);
    t2 := strtoint(strt2);
    write(t2);
    close(fi2);
    
    assign(fi3,'result0.txt');
    reset(fi3);readln(fi3,strt3);
    t3 := strtoint(strt3);
    write(t3);
    close(fi3);
    
    assign(fi4,'result4.txt');
    for i := 0 to 2 do
          for j := 0 to 2 do
              begin 
                rewrite(fi4); 
                writeln(fi4,Massiv[i,j]);
              end;
    close(fi4);
    
    
    if winnerExists then
      if Player1 
      then 
      begin
      t1:=t1+1;
      rewrite(fi1);
      writeln(fi1, t1);
      close(fi1);
      
      if t1 = 1 then s1:='' else s1:='а';
      s1:='раз' + s1 + '!';
      ShowWinner('Игрок первый победил ',t1,s1,'Количество ходов  ',t4, clBlack);
      
      end
      else 
      begin
      t2:=t2+1;
      rewrite(fi2);
      writeln(fi2, t2);
      close(fi2);
      
      if t1 = 1 then s1:='' else s1:='а';
      s1:='раз' + s1 + '!';
      ShowWinner('Игрок второй победил ',t2,s1,'Количество ходов  ',t4, clRed); 
      end;
                 
    if IsFull() and not winnerExists then 
    begin
      t3 := t3 + 1;
      rewrite(fi3);
      writeln(fi3, t3);
      close(fi3);
      
      if t1 = 1 then s1:='' else s1:='а';
      s1:='    раз' + s1 + '!';
      ShowWinner('Игра закончилась ничьей ',t3,s1,'Количество ходов  ',t4, clDarkBlue);
    end;
    
    
    Player1 := not Player1;
    end;    
end;

begin
  var Size2 := Size * 3;
  SetWindowIsFixedSize(true);
  SetWindowSize(Size2, Size2);
  CenterWindow();
  LockDrawing();
  
  Player1 := true;
  Draw();
  
  OnMouseDown := MouseDown;
end.