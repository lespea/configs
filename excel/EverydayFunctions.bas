Attribute VB_Name = "EverydayFunctions"
Option Explicit
'
' Author:  Adam Lesperance
' Version: 1.5
' Date: 2011-07-22
'

Sub FillDown()
Attribute FillDown.VB_ProcData.VB_Invoke_Func = "L\n14"
'
' First promps for a cell in a column that goes all the way to the "bottom" of the report.
' Then, starting from the currently selected cell, it fills in the gaps as it moves down the
' row with whatever the last text was.
'
' a     a
'       a
' b     b
' c     c
'       c
' d     d
'
' Keyboard Shortcut: Ctrl+Shift+L
'
    Dim big_range As range, current As range
    Dim curRow, curCol As Long
    Dim lastCol As Long
   
    ' Save the current cell info
    curRow = ActiveCell.row
    curCol = ActiveCell.Column
   
    ' Prompt the user for the range to use as the "full height" column
    On Error Resume Next
    Application.DisplayAlerts = False
    Set big_range = Application.InputBox(Prompt:= _
        "Select a cell in the column that contains values from the top to the 'bottom' of the worksheet.", _
            Title:="SPECIFY RANGE", Type:=8)
    On Error GoTo 0
    Application.DisplayAlerts = True

    Dim notHidden As Boolean
    notHidden = Application.ScreenUpdating
    
    If notHidden Then
        Application.ScreenUpdating = False
    End If
    
    ' If the user cancelled then exit
    If big_range = Empty Then
        Exit Sub
    ' Else save the end row
    Else
        lastCol = big_range.End(xlDown).row
    End If
   
   
    Dim current_val, last_val As String
    last_val = ""
   
    ' Loop from the current cell to the bottom and do the copying
    Do While (curRow <= lastCol)
        current_val = Cells(curRow, curCol).Value
        If current_val = "" Then
            Cells(curRow, curCol).Value = last_val
        Else
            last_val = current_val
        End If
        curRow = curRow + 1
    Loop
    
    If notHidden Then
        Application.ScreenUpdating = True
    End If
End Sub
Sub RefreshFilters()
Attribute RefreshFilters.VB_ProcData.VB_Invoke_Func = "R\n14"
'
' Refreshes the autofilters (if the contents have changed it will re-filter)
'
' Keyboard Shortcut: Ctrl+Shift+T
'
    ActiveSheet.Autofilter.ApplyFilter
End Sub
Sub MakePercent()
Attribute MakePercent.VB_ProcData.VB_Invoke_Func = "P\n14"
'
' Simply turns the selected cells into percent types
'
' Keyboard Shortcut: Ctrl+Shift+P
'
    Selection.NumberFormat = "0.00%"
End Sub
Sub SetColors()
Attribute SetColors.VB_ProcData.VB_Invoke_Func = "O\n14"
'
' Creates 3 rules (for xls compatability) that transforms cells with color-codes into that
' respective color.  For example, all cells with "R" (red) are filled with red and along
' with the fond color turning red.  The rules are created on the currently selected cells.
'
' Included colors:
'   (G)reen
'   (Y)ellow
'   (R)ed
'
' Keyboard Shortcut: {NONE}
'
    'Removed any existing conditions
    Selection.FormatConditions.Delete
   
    'Green
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlEqual, Formula1:="=""G"""
    Selection.FormatConditions(Selection.FormatConditions.count).SetFirstPriority
    With Selection.FormatConditions(1).Font
        .Color = -11480942
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 5296274
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = True
   
    'Yellow
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlEqual, Formula1:="=""Y"""
    Selection.FormatConditions(Selection.FormatConditions.count).SetFirstPriority
    With Selection.FormatConditions(1).Font
        .Color = -16711681
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 65535
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = True
   
    'Red
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlEqual, Formula1:="=""R"""
    Selection.FormatConditions(Selection.FormatConditions.count).SetFirstPriority
    With Selection.FormatConditions(1).Font
        .Color = -16776961
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 255
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = True
End Sub
Sub SetMoreColors()
Attribute SetMoreColors.VB_ProcData.VB_Invoke_Func = "U\n14"
'
' Includes additional colors besides the "normal" SetColors sub
'   (O)range
'   (B)lue
'   (Gr)ey
'   (Bl)ack
'
' Keyboard Shortcut: Ctrl+Shift+O
'
    'Call the original sub to set those colors first
    EverydayFunctions.SetColors
   
    'Orange
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlEqual, Formula1:="=""O"""
    Selection.FormatConditions(Selection.FormatConditions.count).SetFirstPriority
    With Selection.FormatConditions(1).Font
        .Color = -16727809
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 49407
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = True
   
    'Blue
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlEqual, Formula1:="=""B"""
    Selection.FormatConditions(Selection.FormatConditions.count).SetFirstPriority
    With Selection.FormatConditions(1).Font
        .Color = -4165632
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 12611584
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = True
   
    'Grey
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlEqual, Formula1:="=""Gr"""
    Selection.FormatConditions(Selection.FormatConditions.count).SetFirstPriority
    With Selection.FormatConditions(1).Font
        .Color = -8947849
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 7829367
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = True
   
    'Black
    Selection.FormatConditions.Add Type:=xlCellValue, Operator:=xlEqual, Formula1:="=""Bl"""
    Selection.FormatConditions(Selection.FormatConditions.count).SetFirstPriority
    With Selection.FormatConditions(1).Font
        .Color = -16777216
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 0
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = True
End Sub
Sub Autofilter()
Attribute Autofilter.VB_ProcData.VB_Invoke_Func = "A\n14"
'
' Turns on (or refreshes) autofilter for the header column
'
' Keyboard Shortcut: Ctrl+Shift+A
'
    If ActiveSheet.ListObjects.count > 0 Then
        Dim table As ListObject
        Set table = ActiveSheet.ListObjects(1)
        
        ' If autofilter is not active, then just turn it on
        If Not table.ShowAutoFilter Then
            table.ShowAutoFilter = True
        ' Else refresh
        Else
            table.Autofilter.ShowAllData
        End If
    ElseIf Cells(1, 1).Value <> "" Then
        ' If autofilter is not active, then just turn it on
        If Not ActiveSheet.AutoFilterMode Then
            Cells(1, 1).Autofilter
        ' Otherwise turn it off and then on again to refresh it (otherwise it may miss new columns)
        Else
            Cells(1, 1).Autofilter
            Cells(1, 1).Autofilter
        End If
    End If
End Sub
Function rMarkGood(rng As range)
Attribute rMarkGood.VB_ProcData.VB_Invoke_Func = "C\n14"
'
' Mark range as "Good"
'
    rng.Style = "Good"
End Function
Function rMarkBad(rng As range)
Attribute rMarkBad.VB_ProcData.VB_Invoke_Func = "X\n14"
'
' Mark range as "Bad"
'
    rng.Style = "Bad"
End Function
Function rMarkNeutral(rng As range)
Attribute rMarkNeutral.VB_ProcData.VB_Invoke_Func = "V\n14"
'
' Mark range as "Neutral"
'
    rng.Style = "Neutral"
End Function
Sub MarkGood()
Attribute MarkGood.VB_ProcData.VB_Invoke_Func = "X\n14"
'
' Mark selection as "Good"     (excel 2007 only)
'
' Keyboard Shortcut: Ctrl+Shift+X
'
    rMarkGood Selection
End Sub
Sub MarkBad()
Attribute MarkBad.VB_ProcData.VB_Invoke_Func = "B\n14"
'
' Mark selection as "Bad"      (excel 2007 only)
'
' Keyboard Shortcut: Ctrl+Shift+B
'
    rMarkBad Selection
End Sub
Sub MarkNeutral()
Attribute MarkNeutral.VB_ProcData.VB_Invoke_Func = "C\n14"
'
' Mark selection as "Neutral"  (excel 2007 only)
'
' Keyboard Shortcut: Ctrl+Shift+C
'
    rMarkNeutral Selection
End Sub
Sub ShowHideFieldList()
Attribute ShowHideFieldList.VB_ProcData.VB_Invoke_Func = "Q\n14"
'
' Show/hide pivot table field list
'
' Keyboard Shortcut: Ctrl+Shift+Q
'
    If ActiveWorkbook.ShowPivotTableFieldList = True Then
        ActiveWorkbook.ShowPivotTableFieldList = False
    Else
        ActiveWorkbook.ShowPivotTableFieldList = True
    End If
End Sub
Sub FixedHeight()
'
' Sets the height of every row to 12.75
'
' Keyboard Shortcut: {NONE}
'
    Cells.RowHeight = 12.75
End Sub
Sub ClearFilters()
Attribute ClearFilters.VB_ProcData.VB_Invoke_Func = "Y\n14"
'
' Reset filters
'
' Keyboard Shortcut: Ctrl+Shift+Y
'
    If ActiveSheet.ListObjects.count > 0 Then
        Dim table As ListObject
        Set table = ActiveSheet.ListObjects(1)
        
        ' If autofilter is not active, then just turn it on
        If table.ShowAutoFilter Then
            table.Autofilter.ShowAllData
        End If
    ElseIf ActiveSheet.FilterMode Then
        ActiveSheet.ShowAllData
    End If
End Sub
Sub NoWrap()
Attribute NoWrap.VB_ProcData.VB_Invoke_Func = "N\n14"
'
' Disables "wrap" on all cells
'
' Keyboard Shortcut: Ctrl+Shift+R
'
    Cells.WrapText = False
End Sub
Sub Heightify()
Attribute Heightify.VB_ProcData.VB_Invoke_Func = "H\n14"
'
' Sets the height of each row to "autofit"
'
' Keyboard Shortcut: Ctrl+Shift+H
'
    ' Autofit the cells
    Cells.Rows.AutoFit
End Sub
Sub Freeze()
Attribute Freeze.VB_ProcData.VB_Invoke_Func = "Z\n14"
'
' Freeze the worksheet on the selected range (won't work on cell 1,1)
'
' Keyboard Shortcut: Ctrl+Shift+Z
'
    EverydayFunctions.rFreeze Selection
End Sub
Sub rFreeze(rng As range)
'
' Freeze the worksheet on provided range
'
    Dim notHidden As Boolean
    notHidden = Application.ScreenUpdating
    
    If rng.row = 1 And rng.Column = 1 Then
        ActiveWindow.FreezePanes = False
    Else
        Application.ScreenUpdating = True
        ActiveWindow.FreezePanes = False
        
        rng.Select
        ActiveWindow.FreezePanes = True
    End If
    
    If Not notHidden Then Application.ScreenUpdating = False
End Sub
Sub MergeBooks()
'
' Combines every worksheet from every workbook into a single workbook
'
' Keyboard Shortcut: {NONE}
'
    Dim saveBook As Workbook
    Dim curBook  As Workbook
    Dim curSheet As Worksheet

    Application.ScreenUpdating = False

    For Each curBook In Workbooks
        If EverydayFunctions.NotPersonalWkb(curBook) Then
            If saveBook Is Nothing Then
                Set saveBook = curBook
            Else
                For Each curSheet In curBook.Worksheets
                    curSheet.Move Before:=saveBook.Sheets(1)
                Next curSheet
            End If
        End If
    Next curBook

    Application.ScreenUpdating = True
End Sub
Sub MergeSheets()
'
' Combines the data from all of the worksheets into a single, new worksheet.
' A prompt is displayed asking if there are consistent headers across all of
'   the books to avoid duping the header (otherwise the user will have to
'   manually remove the dupe headers
'
' Keyboard Shortcut: {NONE}
'
    Dim saveSheet As Worksheet
    Dim curSheet As Worksheet
    Dim removeHeader As Integer
    Dim saveRow As Long

    Application.ScreenUpdating = False
   
    Worksheets.Add().name = "Concat"
    Sheets("Concat").Move Before:=Sheets(1)
    Set saveSheet = Sheets("Concat")
    saveRow = 1
   
    removeHeader = MsgBox("Would you like to remove all the header lines except the first one?", vbYesNo)

    For Each curSheet In ActiveWorkbook.Worksheets
        If curSheet.name = "Concat" Then
            GoTo continue
        End If
       
        curSheet.Activate
   
        Dim startCol As Long, endCol As Long, startRow As Long, endRow As Long
        startCol = 1
        startRow = 1
       
        endCol = EverydayFunctions.getRealMaxCol
        endRow = EverydayFunctions.getRealMaxRow
        
        If removeHeader = vbYes Then
            If saveRow = 1 Then
                If Cells(startRow, startCol) = "" Then
                    GoTo continue
                End If
               
                range(Cells(startRow, startCol), Cells(startRow, endCol)).Copy
               
                saveSheet.Activate
                Cells(saveRow, 1).Select
                ActiveSheet.Paste
                curSheet.Activate
               
                saveRow = 2
            End If
           
            startRow = startRow + 1
        End If
       
        If endRow > 1 Then
            range(Cells(startRow, startCol), Cells(endRow, endCol)).Copy
           
            saveSheet.Activate
            Cells(saveRow, 1).Select
            ActiveSheet.Paste
            curSheet.Activate
           
            saveRow = saveRow + (endRow - startRow)
        End If
       
continue:
    Next curSheet
   
    saveSheet.Activate

    Application.ScreenUpdating = True
End Sub
Sub PrettyFormat()
Attribute PrettyFormat.VB_ProcData.VB_Invoke_Func = "S\n14"
'
' Calls myBorder on all of the "active" cells and on the header column, bolds the
' header column, freezes on cell A2, and turns on autofilter.  The active cells
' are the range from (1,1) to the last column with text in the header row down to
' the last row found in the first column.
'
' Keyboard Shortcut: Ctrl+Shift+S
'
    Dim notHidden As Boolean
    notHidden = Application.ScreenUpdating
    
    If notHidden Then
        Application.ScreenUpdating = False
        Application.Calculation = xlCalculationManual
    End If
    
    EverydayFunctions.NoWrap
    
    ' Remove all existing borders and font styles
    With Cells
        .Borders.LineStyle = xlNone
        .Font.FontStyle = ""
    End With
   
    Dim maxCol As Long, maxRow As Long
    Dim myRange As range
    
    maxCol = EverydayFunctions.getRealMaxCol
    maxRow = EverydayFunctions.getRealMaxRow
    Set myRange = range(Cells(1, 1), Cells(maxRow, maxCol))
      
    ' Set the font alignment and row height
    With myRange
        .HorizontalAlignment = xlLeft
        .VerticalAlignment = xlBottom
    End With
   
    ' Make a strong border and fill the intner borders
    EverydayFunctions.rMyBorder myRange

    ' Select the header row, make a strong border, and bold
    Set myRange = range(Cells(1, 1), Cells(1, maxCol))
   
    EverydayFunctions.rMyBorder myRange
    myRange.Font.Bold = True

    ' Set filtering and spacing and freeze above the header row
    EverydayFunctions.Autofilter
   
    EverydayFunctions.rFreeze range("A2")
    
    ActiveWorkbook.DefaultTableStyle = "TableStyleMedium15"
   
    If notHidden Then
        Application.Calculation = xlCalculationAutomatic
        Application.ScreenUpdating = True
    End If
End Sub
Sub PrettyFormatAll()
Attribute PrettyFormatAll.VB_ProcData.VB_Invoke_Func = "G\n14"
'
' Calls PrettyFormat on each worksheet in the current workbook
'
' Keyboard Shortcut: Ctrl+Shift+G
'
    Application.ScreenUpdating = False

    Dim mySheet As Worksheet
    ' Loop through every worksheet and "PrettyFormat" them
    For Each mySheet In Worksheets
        mySheet.Select
        EverydayFunctions.PrettyFormat
        EverydayFunctions.Widify
    Next mySheet
   
    Sheets(1).Select

    Application.ScreenUpdating = True
End Sub
Sub PrettyFormatAllWorkbooks()
'
' Calls PrettyFormatAll on every workbook
'
' Keyboard Shortcut: {NONE}
'
    Dim myBook As Workbook

    Application.ScreenUpdating = False

    For Each myBook In Workbooks
        If EverydayFunctions.NotPersonalWkb(myBook) Then
            myBook.Worksheets(1).Activate
            EverydayFunctions.PrettyFormatAll
        End If
    Next myBook

    Application.ScreenUpdating = True
End Sub
Sub SepRanges()
Attribute SepRanges.VB_ProcData.VB_Invoke_Func = "J\n14"
'
' Looks at the current cell, then moves down and if a different value is found
' changes the border from column 1 to maxColumn (defined by the last column in
' the header row)  to a solid black line
'
' Keyboard Shortcut: Ctrl+Shift+J
'
    Dim notHidden As Boolean
    notHidden = Application.ScreenUpdating
    
    If notHidden Then
        Application.ScreenUpdating = False
    End If
   
    Dim startRow As Double
    Dim startCol As Integer
   
    Dim endRow As Double
    Dim endCol As Integer
   
    Dim curRow As Double
    Dim curText As String
    Dim newText As String

    ' Save the starting cell location and value
    startRow = ActiveCell.row
    startCol = ActiveCell.Column
    curText = ActiveCell.Value

    ' Find the ending row/column
    endCol = EverydayFunctions.getRealMaxCol
    endRow = EverydayFunctions.getRealMaxRow

    ' Set the curRow to the starting row
    curRow = startRow

    ' Loop through all of the remaining rows
    Do While (curRow < endRow)
        ' Get the value out of the next row
        newText = Cells(curRow + 1, startCol).Value

        ' If the text has changed, then insert the heavy line
        If newText <> curText Then
            With range(Cells(curRow, 1), Cells(curRow, endCol)).Borders(xlEdgeBottom)
                .LineStyle = xlContinuous
                .Weight = xlMedium
            End With
            curText = newText
        End If

        ' Increment the row counter
        curRow = curRow + 1
    Loop
   
    ' Place a border at the bottom as well
    With range(Cells(curRow, 1), Cells(curRow, endCol)).Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With

    If notHidden Then
        Application.ScreenUpdating = True
    End If
End Sub
Sub SepRanges2()
Attribute SepRanges2.VB_ProcData.VB_Invoke_Func = "K\n14"
'
' Same as SepRanges but uses a dashed line
'
' Keyboard Shortcut: Ctrl+Shift+K
'
    Dim notHidden As Boolean
    notHidden = Application.ScreenUpdating
    
    If notHidden Then
        Application.ScreenUpdating = False
    End If
   
    Dim startRow As Double
    Dim startCol As Integer
   
    Dim endRow As Double
    Dim endCol As Integer
   
    Dim curRow As Double
    Dim curText As String
    Dim newText As String

    ' Save the starting cell location and value
    startRow = ActiveCell.row
    startCol = ActiveCell.Column
    curText = ActiveCell.Value

    ' Find the ending row/column
    endCol = EverydayFunctions.getRealMaxCol
    endRow = EverydayFunctions.getRealMaxRow

    ' Set the curRow to the starting row
    curRow = startRow

    ' Loop through all of the remaining rows
    Do While (curRow < endRow)
        ' Get the value out of the next row
        newText = Cells(curRow + 1, startCol).Value

        ' If the text has changed, then insert the heavy line
        If newText <> curText Then
            With range(Cells(curRow, 1), Cells(curRow, endCol)).Borders(xlEdgeBottom)
                .LineStyle = xlDashDotDot
                .Weight = xlMedium
            End With
            curText = newText
        End If

        ' Increment the row counter
        curRow = curRow + 1
    Loop

    If notHidden Then
        Application.ScreenUpdating = True
    End If
End Sub
Function fWidify(Optional maxWidth As Integer = 35)
'
' Function that sets the width of each column to "autofit,"  but caps the max width at 35
'
    Dim notHidden As Boolean
    notHidden = Application.ScreenUpdating
    
    If notHidden Then
        Application.ScreenUpdating = False
    End If

    ' Autofit the cells
    Cells.Columns.AutoFit
   
    Dim col As range
    For Each col In ActiveSheet.Columns
        If col.ColumnWidth > maxWidth Then
            col.ColumnWidth = maxWidth
        End If
    Next col

    If notHidden Then
        Application.ScreenUpdating = True
    End If
End Function
Sub Widify()
Attribute Widify.VB_ProcData.VB_Invoke_Func = "W\n14"
'
' Sets the width of each column to "autofit,"  but caps the max width at fWidify's default (35)
'
' Keyboard Shortcut: Ctrl+Shift+W
'
    EverydayFunctions.fWidify
End Sub
Function rMyBorder(myRange As range)
'
' Sets a strong outer border and a normal inner boarder
'
    EverydayFunctions.StrongBorder myRange
    EverydayFunctions.FillInner myRange
End Function
Sub MyBorder()
Attribute MyBorder.VB_ProcData.VB_Invoke_Func = "M\n14"
'
' Sets the inner border to light and a the outer border to strong
'
' Keyboard Shortcut: Ctrl+Shift+M
'
    Dim notHidden As Boolean
    notHidden = Application.ScreenUpdating
    
    If notHidden Then
        Application.ScreenUpdating = False
    End If
    
    EverydayFunctions.StrongBorder
    EverydayFunctions.FillInner
    
    If notHidden Then
        Application.ScreenUpdating = True
    End If
End Sub
Function NoBorder(Optional rng As range)
'
' Clears all of the borders
'
    If rng Is Nothing Then Set rng = Selection
    
    ' If there is more than 1 column, then set the inside line to solid, thin
    If rng.Columns.count > 1 Then
        With rng.Borders(xlInsideVertical)
            .LineStyle = xlNone
        End With
    End If

    ' If there is more than 1 row, then set the inside line to solid, thin
    If rng.Rows.count > 1 Then
        With rng.Borders(xlInsideHorizontal)
            .LineStyle = xlNone
        End With
    End If
End Function
Function FillInner(Optional rng As range)
'
' Changes the inner border for the current range/selection to thin
'
    If rng Is Nothing Then Set rng = Selection
    
    ' If there is more than 1 column, then set the inside line to solid, thin
    If rng.Columns.count > 1 Then
        With rng.Borders(xlInsideVertical)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .ColorIndex = xlAutomatic
        End With
    End If

    ' If there is more than 1 row, then set the inside line to solid, thin
    If rng.Rows.count > 1 Then
        With rng.Borders(xlInsideHorizontal)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .ColorIndex = xlAutomatic
        End With
    End If
End Function
Function StrongBorder(Optional rng As range)
'
' Changes the border for the current selection to "strong"
'
    If rng Is Nothing Then Set rng = Selection
    
    ' Set each side of the selection to solid, heavy
    With rng.Borders
        .LineStyle = xlContinuous
        .Weight = xlMedium
        .ColorIndex = xlAutomatic
    End With
End Function
Function ColLetter(ColNumber As Long) As String
'
' Given a column number, return a column letter
'
    ColLetter = Split(Cells(1, ColNumber).Address, "$")(1)
End Function
Function ColNumber(ColLetter As String) As Long
'
' Given a column letter, return a column number
'
    ColNumber = Columns(ColLetter).Column
End Function
Function CreatePivotCache(range As Variant) As PivotCache
'
' Creates a new pivot cache to work with
'
    Set CreatePivotCache = ActiveWorkbook.PivotCaches.Create( _
        SourceType:=xlDatabase _
      , SourceData:=range _
      , Version:=xlPivotTableVersion12 _
    )
End Function
Function AddPivotWks(sheetName As String, PivotName As String, PTCache As PivotCache, Optional insertRow As Integer = 3) As PivotTable
'
' Creates a new worksheet, rename and format it, and add a pivot table
'
    ' Create the new spreadsheet to hold our pivot table
    ActiveWorkbook.Sheets.Add
    ActiveSheet.name = sheetName
    
    ' Add the pivot table
    Set AddPivotWks = PTCache.CreatePivotTable( _
        TableDestination:=Cells(insertRow, 1) _
      , TableName:=PivotName _
      , DefaultVersion:=xlPivotTableVersion12 _
    )
    
    ' Our prefered style (can be changed afterwards if need be)
    AddPivotWks.TableStyle2 = "PivotStyleDark2"

    ' Change the font
    Cells.Font.name = "Consolas"
End Function
Function AddTmpPivotWks(PTCache As PivotCache, Optional insertRow As Integer = 3) As PivotTable
'
' Creates a new worksheet, rename and format it, and add a pivot table
'
    ' Create the new spreadsheet to hold our pivot table
    ActiveWorkbook.Sheets.Add
    
    ' Add the pivot table
    Set AddTmpPivotWks = PTCache.CreatePivotTable( _
        TableDestination:=Cells(insertRow, 1) _
      , TableName:="tmp_pivot_name" _
      , DefaultVersion:=xlPivotTableVersion12 _
    )
End Function
Function CreateTable(range As range, name As String, Optional hasHeader As Boolean = True) As ListObject
'
' Set the table value depending on whether we have a header or not
'
    Dim headerTrigger As XlYesNoGuess
    If hasHeader Then
        headerTrigger = xlYes
    Else
        headerTrigger = xlNo
    End If
    
    ' Create the table using the provided info
    Set CreateTable = ActiveSheet.ListObjects.Add( _
        SourceType:=xlSrcRange _
      , Source:=range _
    )

    ' And set the defaults
    With CreateTable
        .name = name
        .TableStyle = "TableStyleMedium15"
    End With
End Function
Function getUsefulRange() As range
'
' Returns the largest unbroken range of cells that have text from 1,1 to the maximum row/columns
'
    Set getUsefulRange = range(Cells(1, 1), Cells(EverydayFunctions.getRealMaxRow, EverydayFunctions.getRealMaxCol))
End Function
Function getRealMaxRow() As Long
'
' Get the max row based of a provided row number
'
    getRealMaxRow = Cells.Find("*", After:=[A1], SearchOrder:=xlByRows, SearchDirection:=xlPrevious).row
End Function
Function getRealMaxCol() As Long
'
' Get the max column based of a provided column number
'
    getRealMaxCol = Cells.Find("*", After:=[A1], SearchOrder:=xlByColumns, SearchDirection:=xlPrevious).Column
End Function
Function getMaxRow(Optional col As Long = 1) As Long
'
' Get the max row based of a provided row number
'
    If Cells(2, col).Value <> "" Then
        getMaxRow = Cells(1, col).End(xlDown).row
    Else
        getMaxRow = 1
    End If
End Function
Function getMaxCol(Optional row As Long = 1) As Long
'
' Get the max column based of a provided column number
'
    If Cells(row, 2).Value <> "" Then
        getMaxCol = Cells(row, 1).End(xlToRight).Column
    Else
        getMaxCol = 1
    End If
End Function
Function SheetExists(sheetName As String, Optional wkb As Workbook) As Boolean
'
' Determine if a sheet exists witht he provided name for the provided workbook
'
    Dim ws As Worksheet
    
    If wkb Is Nothing Then Set wkb = ActiveWorkbook
    
    ' Can't check if a worksheet exists normally so supress any errors that we get
    On Error Resume Next
    Set ws = wkb.Worksheets(sheetName)
    On Error GoTo 0
    
    If Not ws Is Nothing Then
        SheetExists = True
    Else
        SheetExists = False
    End If
End Function
Function ListObjectExists(LOName As String, Optional ws As Worksheet) As Boolean
'
' Determine if a list object exists witht he provided name for the provided worksheet
'
    Dim lo As ListObject
    
    If ws Is Nothing Then Set ws = ActiveSheet
    
    ' Can't check if a worksheet exists normally so supress any errors that we get
    On Error Resume Next
    Set lo = ws.ListObjects(LOName)
    On Error GoTo 0
    
    If Not lo Is Nothing Then
        ListObjectExists = True
    Else
        ListObjectExists = False
    End If
End Function
Function NotPersonalWkbName(name As String) As Boolean
'
' Check to see if the provided string looks like the "personal" workbook (could be personal .xls, .xlsm, .xlsx, etc)
'
    If Left(LCase(name), 12) <> "personal.xls" Then
        NotPersonalWkbName = True
    Else
        NotPersonalWkbName = False
    End If
End Function
Function NotPersonalWkb(wkb As Workbook) As Boolean
'
' Check to see if the provided workbook's name looks like the "personal" workbook
'
    NotPersonalWkb = EverydayFunctions.NotPersonalWkbName(wkb.name)
End Function
Function delSheet(wks As Worksheet)
'
' Force deletion of a worksheet (ignore all errors)
'
    Application.DisplayAlerts = False
        wks.Delete
    Application.DisplayAlerts = True
End Function
Function delSheetsAfter(sheetNum As Integer, Optional wkb As Workbook)
'
' Delete all worksheets that appear after the given index
'
    Dim notHidden As Boolean
    notHidden = Application.ScreenUpdating
    
    If notHidden Then
        Application.ScreenUpdating = False
    End If
    
    If wkb Is Nothing Then Set wkb = ActiveWorkbook
    
    Dim max As Integer
    max = wkb.Sheets.count - sheetNum
    
    ' Turn off error messages and delete all of the sheets after the given int
    Application.DisplayAlerts = False
    Do While max > 0
        wkb.Sheets(sheetNum + 1).Delete
        max = max - 1
    Loop
    Application.DisplayAlerts = True
    
    
    If notHidden Then
        Application.ScreenUpdating = True
    End If
End Function
Function getRandomLetter() As String
'
' Returns a random small letter
'
    Randomize ' Shouldn't be reseeding every time but vb is a pos
    getRandomLetter = Chr(Int((Asc("z") - Asc("a") + 1) * Rnd + Asc("a")))
End Function
Function getRandomWord(min As Integer, max As Integer) As String
'
' Returns a random word that is between the given min and max in length
'
    Dim length As Integer, i As Integer, word As String
    length = Int((max - min + 1) * Rnd + min)
    
    For i = 1 To length
        getRandomWord = getRandomWord & EverydayFunctions.getRandomLetter
    Next i
End Function
Function getUniqueSheetName(Optional wkb As Workbook) As String
'
' Returns a random sheet name that is guaranteed to be unique to specified workbook
'
    Dim name As String
    
    If wkb Is Nothing Then Set wkb = ActiveWorkbook
    
    Do
        name = "_temp_" & EverydayFunctions.getRandomWord(3, 10)
    Loop While EverydayFunctions.SheetExists(name, wkb)
    
    getUniqueSheetNameW = name
End Function
Function getSorted(PCache As PivotCache, rowField, countField, Optional maxResults = -1) As Variant
'
' Given a PivotCache and 2 different fields, this returns an array of field 1 sorted by occurance of field 2.
' An optional maxResults can be passed which will limit the array size returned
'
    Dim curSheet As Worksheet, tmpSheet As Worksheet
    Set curSheet = ActiveSheet
    
    ' Create a new temp pivot table that we'll use to do the counting
    Dim PT As PivotTable
    Set PT = EverydayFunctions.AddTmpPivotWks(PCache, 1)
    Set tmpSheet = ActiveSheet
    
    ' Add the correct fields
    With PT.PivotFields(rowField)
        .Orientation = xlRowField
        .Position = 1
    End With
    
    PT.AddDataField PT.PivotFields(countField), "Counts", xlCount
    PT.PivotFields(rowField).AutoSort xlDescending, "Counts"
    
    ' Pull out how many results there are
    Dim max As Long, i As Long
    max = EverydayFunctions.getRealMaxRow
    i = 2
    
    ' If a limit is desired and there are more results than that, then lower the limit (don't forget to account for title rows)
    If maxResults > 0 And max > (maxResults + 2) Then
        max = maxResults + 2
    End If
    
    ' Resize the array to hold all of the desired values
    Dim objects As Variant
    ReDim objects(1 To (max - 2))
    
    ' Put the strings into the array
    Do While i < max
        objects(i - 1) = Cells(i, 1).Value
        i = i + 1
    Loop
    
    ' And return the object
    getSorted = objects
    
    ' Remove the tmp sheet before returning
    curSheet.Activate
    EverydayFunctions.delSheet tmpSheet
End Function
Function makeValidSheetName(name As String) As String
'
' Removes any invalid sheet characters and truncates the length to 31
'
    Dim badChars As Variant, char As Variant
    badChars = Array(":", "\", "/", "?", "*", "[", "]")
    
    ' Loop through all of the known bad characters and remove them from the string
    For Each char In badChars
        name = Application.WorksheetFunction.Substitute(name, char, "")
    Next char
    
    ' Truncate the string
    If Len(name) > 31 Then name = Left(name, 31)
    
    makeValidSheetName = name
End Function
