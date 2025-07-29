Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$signature = @"
[DllImport("shell32.dll", CharSet = CharSet.Auto)]
public static extern IntPtr ExtractIcon(IntPtr hInst, string lpszExeFileName, int nIconIndex);
"@

Add-Type -MemberDefinition $signature -Name "Shell32" -Namespace "Win32"

$iconPtr = [Win32.Shell32]::ExtractIcon([IntPtr]::Zero, "$env:SystemRoot\System32\shell32.dll", 226)

# Convert the icon handle to a usable Icon object
$icon = [System.Drawing.Icon]::FromHandle($iconPtr)

# Create the form
$PrinterSelection = New-Object System.Windows.Forms.Form
$PrinterSelection.Text = "Select a printer:"
$PrinterSelection.Size = New-Object System.Drawing.Size(300, 250)
$PrinterSelection.StartPosition = "CenterScreen"

# Create the ListBox
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Size = New-Object System.Drawing.Size(260,120)
$listBox.Location = New-Object System.Drawing.Point(10,20)
$listBox.SelectionMode = "One"

# Add items to the ListBox
foreach ($printer in $(Get-Printer)){

$listBox.Items.Add($printer.Name) | Out-Null

}

# Create the OK button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$okButton.Location = New-Object System.Drawing.Point(100, 160)
$okButton.Add_Click({
    $global:CloseWindow = $false
    $PrinterSelection.Tag = $listBox.SelectedItem
    $PrinterSelection.Close()
})

# Add controls to the form
$PrinterSelection.Controls.Add($listBox)
$PrinterSelection.Controls.Add($okButton)

$PrinterSelection.Icon = $icon

# Show the form
$ShowPrinters = $true
while ($ShowPrinters){
$global:CloseWindow = $true
$PrinterSelection.ShowDialog() | Out-Null

# Output the selected item
if ($PrinterSelection.Tag) {
    $ShowPrinters = $false
    rundll32 printui.dll,PrintUIEntry /o /n $PrinterSelection.Tag
    
}

elseif ($CloseWindow) {
    exit 
    }
 
 else {
    
    [System.Windows.Forms.MessageBox]::Show("No Printer was selected.") | Out-Null

}
}