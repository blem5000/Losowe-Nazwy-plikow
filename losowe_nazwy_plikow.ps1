function WybierzFolder{
    Add-Type -AssemblyName System.Windows.Forms
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $null = $browser.ShowDialog()
    $folder = $browser.SelectedPath

    return $folder
}

function ZmienNazwy{
    Clear-Variable -Name "browser" -ErrorAction SilentlyContinue
    Clear-Variable -Name "folder" -ErrorAction SilentlyContinue
    Clear-Variable -Name "null" -ErrorAction SilentlyContinue
    Clear-Variable -Name "listaPlikow" -ErrorAction SilentlyContinue

    $folder = WybierzFolder
    do{
        $msgBoxInput =  [System.Windows.MessageBox]::Show("Czy na pewno chcesz zmienić nazwy plików w folderze $folder" + "?",'Losowe nazwy plikow','YesNoCancel','Warning')

        switch  ($msgBoxInput) {

            'Yes' {

            $a = 1 

        }

            'No' {
            $a = 0
            $folder = WybierzFolder

        }

            'Cancel' {
            exit
        }

        }
    } while ($a -ne 1)
    $listaPlikow = Get-ChildItem -Path $folder
    $ZrandomizowanaListaPlikow = $listaPlikow | Get-Random -Count $listaPlikow.Count


    for($i=0; $i -le $listaPlikow.Count - 1;$i++){
    $sciezka = $folder + "\" + $listaPlikow[$i]
    $nowaNazwa = New-Guid
    $tekst = $listaPlikow[$i].ToString()
    $pozycja = $tekst.IndexOf(".")
    $rozszerzenie = $tekst.Substring($pozycja)

    $nowaNazwa = $nowaNazwa.ToString() + $rozszerzenie
    Rename-Item -Path $sciezka -NewName $nowaNazwa

    }

    $msgBoxInput =  [System.Windows.MessageBox]::Show('Zmieniono nazwy plikow w folderze','Losowe nazwy plikow','OK','Information')
    switch  ($msgBoxInput) {
      'OK' {
        Invoke-Item $folder
        }
    }
}

ZmienNazwy